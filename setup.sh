#!/usr/bin/env bash

# Set color variables for some nice-er output
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

REPO_URL=https://github.com/darkdoc/devenv.git
REPO_PATH="$HOME/.devenv"

function info {
  echo -e "Info: ${1}"
}

function success {
  echo -e "${GREEN}Success: ${RESET}${1}"
}

function warning {
  echo -e "${YELLOW}Warning: ${RESET}${1}"
}

function error {
  echo -e "${RED}Error: ${RESET}${1}"
  exit 1
}

if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root, but it will need sudo for installing" 
   exit 1
fi

function install_deb {
    info "Installing python3,pip,git..."
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update
    sudo apt-get install python3-full python3-pip git -y\
            --no-install-suggests\
            --no-install-recommends
    
    info "Cloning devenv repo ... (this will override any prev devenv cloned)"
    if [ -d $REPO_PATH ]; then 
        warning "Directory $REPO_PATH exists. Fetching there anyways..."
        rm -rf $REPO_PATH
        #git init --initial-branch=main
        #git remote add origin $REPO_URL
        #git pull -f   || error "Git pull failed"
    #else
    fi
    
    git clone "$REPO_URL" "$REPO_PATH" || error "Git clone failed"
    cd $REPO_PATH
    info "Installing venv for user..."

    python3 -m venv venv
    . venv/bin/activate

    info "Installing ansible"
    pip install ansible
    info "$dist_type"
    ansible-playbook ansible/dev-env.yml
}

#function install_rpm {
#    info "Installing pip..."
#    python3 -m ensurepip --upgrade
#}

case "${1}" in
  (--apt|--deb)
    command -v apt >/dev/null 2>&1 || error "apt not found"
    export dist_type="Debian"
    echo "$dist_type"
    install_deb
  ;;
  (--dnf|--rpm|--yum)
    command -v yum >/dev/null 2>&1 || error "yum not found"
    dist_type=RedHat
    #install_rpm #TODO implement
  ;;
  (''|*)
      info "No option given, defaulting to ubuntu/deb"
      command -v apt >/dev/null 2>&1 || error "apt not found"
      install_deb
  ;;
esac
