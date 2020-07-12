#!/bin/bash

set -e
set -v

apt-get update

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

apt-get install -y git \
                   cmake \
                   nodejs \ # needed for CoC.vim
                   neovim \
                   ccls \
                   i3

