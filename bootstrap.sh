#!/bin/bash

# TODO install nvim from source..
# TODO CoC needs node installed...
# TODO make script agnostic of folder
# TODO auto install updated version of nvim / vim (nvim 4.3)
# TODO maybe load plugs as on-demand instead of all at once
# TODO maybe provide Makefile with `install` and `clean` targets

set -e

if [ -z $XDG_CONFIG_HOME ]
then
  echo 'Error: need to set $XDG_CONFIG_HOME'
  exit 1
fi

ln -s $(pwd)/vimrc ~/.vimrc
ln -s $(pwd)/tmux.conf ~/.tmux.conf
ln -s $(pwd)/emacs.d ~/.emacs.d
ln -s $(pwd)/vimrc $XDG_CONFIG_HOME/nvim/init.vim

