#!/usr/bin/env bash

# Set color variables for some nice-er output
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

REPO_URL=https://github.com/darkdoc/devenv.git
REPO_PATH="$HOME/.devenv"

DEVENV_DISTRO_TYPE=debian
DEVENV_WITH_GUI=false

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

function install_debian {
    command -v apt >/dev/null 2>&1 || error "apt not found"
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
    ansible-playbook ansible/dev-env.yml
}


function install_rhel {
    command -v yum >/dev/null 2>&1 || error "yum not found"
    info "Hello from rhel"
    info "gui     = ${DEVENV_WITH_GUI}"
}

VALID_ARGS=$(getopt -o gd:u: --long gui,distro:,user: -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -g | --gui)
        if [[ $(grep -i Microsoft /proc/version) ]]; then
            error "Bash is running on WSL, GUI install not supported"
        fi
        DEVENV_WITH_GUI=true
        shift
        ;;
    -d | --distro)
        if [[ $2 == "apt" || $2 == "deb" ]]; then
            DEVENV_DISTRO_TYPE="debian"
        elif [[ $2 == "yum" || $2 == "dnf" ]]; then
            DEVENV_DISTRO_TYPE="rhel"
        else
            error "Disto not supported: $2"
            exit 1
        fi
        shift 2
        ;;
    -u | --user)
        export DEVENV_USER=$2 
        shift 2
        ;;
    --) shift; 
        break 
        ;;
  esac
done


info "User to setup devenv: ${DEVENV_USER:-Not set with arg, will use ansible default value}"
install_${DEVENV_DISTRO_TYPE}
