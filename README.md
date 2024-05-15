## Requirement

user with passwordless sudo (#TODO: fix this so script can take sudo password)

## Quick usage
WIP!

Ubuntu/Debian/apt based:  
(tested with vagrant: ubuntu 23.10, 22.04)
```bash
curl https://raw.githubusercontent.com/darkdoc/devenv/main/setup.sh | bash
```
(This is not yet implemented, but it should give some nice error if you try on ubuntu)  
Fedora/Redhat/yum based  
```bash
curl https://raw.githubusercontent.com/darkdoc/devenv/main/setup.sh | bash -s -- -d yum
```

```bash
The setup script currently supports the following options:  
-d | --distro distro_name #(supports deb/apt and yum/dnf) if not given defaults to deb/apt
-u | --user username #if not given will use the default set in ansible vars
-g | --gui #defaults to false if not used, this is set to fail in WSL (no gui) and plans to set up i3, window manager/desktop env
```

Currently done: 
- ansible setup, running in tmp dir with venv (#TODO make this tmp dir overrideable arg)
- user setup (pwless sudo), zsh, oh-my-zsh install to user
- docker-ce install, config for user
- stow, dotfiles folder, tmux, tpm, and tmux config (#TODO fix font)

