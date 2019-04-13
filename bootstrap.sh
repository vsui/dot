#!/bin/bash

ln -s $(pwd)/vimrc ~/.vimrc
ln -s $(pwd)/tmux.conf ~/.tmux.conf
ln -s $(pwd)/emacs.d ~/.emacs.d
ln -s $(pwd)/vimrc $XDG_CONFIG_HOME/nvim/init.vim

