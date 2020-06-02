#!/bin/bash

# TODO install fish?
# TODO CoC needs node installed...
# TODO make script agnostic of folder it is run in 
# TODO curl ... to github to README.md to run instruction
# TODO make neovim the default editor
# TODO link vim to nvim
# TODO maybe load plugs as on-demand instead of all at once
# TODO maybe provide Makefile with `install` and `clean` targets
# TODO cmake would be useful
# TODO macOS?
# TODO maybe put everything that doesn't need sudo together

set -e
set -v

# this is set to -f if -f is passed to the script
FORCE=""
# TODO need to document this and maybe make it easier
if [[ $* == *-f* ]]; then
  FORCE="-f"
fi

if [ -z $XDG_CONFIG_HOME ]
then
  # read -p '$XDG_CONFIG_HOME is not set. Would you like to continue by proceeding with the default XDG_CONFIG_HOME=~/.config? ' yn
  echo '$XDG_CONFIG_HOME is not set. Would you like to proceed with the default XDG_CONFIG_HOME=~/.config?'
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) break;;
      No ) exit 1;;
    esac
  done  

  # This script is designed to be run with sudo but I need to expand ~ as the original user. This was the
  # first way I could figure out to do this. There is probably a better solution (maybe running separating
  # superuser commands from non-superuser commands into two separate scripts)
  export XDG_CONFIG_HOME=`sudo -u $SUDO_USER /bin/bash -c "echo ~/.config"`
  echo $XDG_CONFIG_HOME
fi

apt update
# TODO maybe just make it so we just need one of wget and curl
apt install -y wget
apt install -y curl
apt install -y git
apt install -y nodejs # need this for CoC

# install neovim
# TODO currently neovim files extracted to squashfs-root, maybe change to install them in /usr
# TODO if neovim already installed exit
NVIM_INSTALL_PATH=/usr/local/bin
if test -e $NVIM_INSTALL_PATH && test -z $FORCE; then
  echo "Error: file already exists at $NVIM_INSTALL_PATH"
  exit 1
fi

sudo -u $SUDO_USER wget -O nvim.appimage https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
sudo -u $SUDO_USER chmod a+x nvim.appimage
sudo -u $SUDO_USER ./nvim.appimage --appimage-extract
mkdir -p /usr/local/bin # organize this line to somewhere else, doesn't fit with nvim code
sudo -u $SUDO_USER mkdir -p $XDG_CONFIG_HOME/nvim
ln -s $FORCE $(pwd)/vimrc $XDG_CONFIG_HOME/nvim/init.vim
ln -s $FORCE $(pwd)/squashfs-root/usr/bin/nvim $NVIM_INSTALL_PATH # TODO is it safe to hardcode `squashfs-root`
rm nvim.appimage

ln -s $FORCE $(pwd)/vimrc ~/.vimrc
ln -s $FORCE $(pwd)/tmux.conf ~/.tmux.conf
ln -s $FORCE $(pwd)/emacs.d ~/.emacs.d


