#!/bin/bash

# This is only tested on Ubuntu 20.04
# TODO i3 conf
# TODO install fish?
# TODO make script agnostic of folder it is run in 
# TODO maybe provide Makefile with `install` and `clean` targets

# this is set to -f if -f is passed to the script
FORCE=""
# TODO need to document this and maybe make it easier
if [[ $* == *-f* ]]; then
  FORCE="-f"
fi

set -e
set -v

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

  export XDG_CONFIG_HOME=~/.config
fi

git config --global core.editor "nvim"
# TODO update-alternatives?
export EDITOR=nvim

ln -s $FORCE $(pwd)/vimrc ~/.vimrc
ln -s $FORCE $(pwd)/tmux.conf ~/.tmux.conf
ln -s $FORCE $(pwd)/emacs.d ~/.emacs.d
ln -s $FORCE $(pwd)/coc-settings.json $XDG_CONFIG_HOME/nvim/coc-settings.json
ln -s $FORCE $(pwd)/vimrc $XDG_CONFIG_HOME/nvim/init.vim

