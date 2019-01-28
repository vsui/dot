#!/bin/bash

ln -s $(pwd)/vimrc ~/.vimrc
if [ -d ~/.config/neovim ]; then
	ln -s $(pwd)/vimrc ~/.config/neovim/init.vim
fi
ln -s $(pwd)/tmux.conf ~/.tmux.conf

