#!/bin/bash

# TODO CoC needs node installed...
# TODO make script agnostic of folder it is run in 
# TODO make neovim the default editor
# TODO link vim to nvim
# TODO maybe load plugs as on-demand instead of all at once
# TODO maybe provide Makefile with `install` and `clean` targets

set -e

if [ -z $XDG_CONFIG_HOME ]
then
  # read -p '$XDG_CONFIG_HOME is not set. Would you like to continue by proceeding with the default XDG_CONFIG_HOME=~/.config? ' yn
  echo '$XDG_CONFIG_HOME is not set. Would you like to proceed with the default XDG_CONFIG=~/.config?'
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) break;;
      No ) exit 1;;
    esac
  done  

  export XDG_CONFIG_HOME=~/.config
fi

apt update
# TODO maybe just make it so we just need one of wget and curl
apt install -y wget
apt install -y curl
apt install -y git

# install neovim
# TODO currently neovim files extracted to squashfs-root, maybe change to install them in /usr
# TODO if neovim already installed exit
wget -O nvim.appimage https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract
mkdir -p /usr/local/bin
ln -s $(pwd)/squashfs-root/usr/bin/nvim /usr/local/bin/nvim

ln -s $(pwd)/vimrc ~/.vimrc
ln -s $(pwd)/tmux.conf ~/.tmux.conf
ln -s $(pwd)/emacs.d ~/.emacs.d

mkdir -p $XDG_CONFIG_HOME/nvim
ln -s $(pwd)/vimrc $XDG_CONFIG_HOME/nvim/init.vim

