#!/bin/bash

set -e
set -v

apt-get update

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

# nodejs is needed for CoC.nvim
apt-get install -y git \
                   cmake \
                   nodejs \
                   neovim \
                   ccls \
                   i3

