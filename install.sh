#!/bin/bash

# TODO install fish?
# TODO make script agnostic of folder it is run in 
# TODO curl ... to github to README.md to run instruction
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

  # Change home to the home directory of the original user
  export HOME=`sudo -u $SUDO_USER /bin/bash -c "echo ~"`
  export XDG_CONFIG_HOME=~/.config
fi

apt update
# TODO maybe just make it so we just need one of wget and curl
apt install -y wget
apt install -y curl
apt install -y git
# install nodejs for CoC
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# install neovim
# TODO currently neovim files extracted to squashfs-root, maybe change to install them in /usr
# TODO if neovim already installed exit
NVIM_INSTALL_PATH=/usr/local/bin
if test -e $NVIM_INSTALL_PATH && test -z $FORCE; then
  echo "Error: file already exists at $NVIM_INSTALL_PATH"
  exit 1
fi

# TODO package not available, need to get this some other way
# TODO also it seems to cause issues if ccls looks for the standard headers depending on the version of clang it was built with
# apt install ccls # needed for CoC C++ support

# install llvm+clang for ccls
# TODO check signature
# TODO set as default compiler

# It seems like you can set this as the default with `update-alternatives`. Currently I am running into a
# where it seems like clang++ is trying to use the standard library from c++ but it isn't installed correctly
# or something. Maybe that was my original problem with the packaged version of `ccls`? I though that it wasn't
# working since there was no compatible version of clang++ on my machine, but maybe not...
# I tried to use libc++ instead of libstdc++ (clang implementation of std lib) but I am still running into issues.
# I am possibly not installing the pre-compiled clang files properly (I just did a recursive copy to /usr/local).
# Seems to have trouble finding the shared libraries when runing the binary.
# Seems like you mainly need to set LD_LIBRARY_PATH
#
# TODO fix g++ installation or figure out how to use libstdc++ by default
#

LLVM_CLANG_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
LLVM_CLANG_PATH=$(pwd)/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04 # TODO extract this from URL
wget $LLVM_CLANG_URL

git clone --depth=1 --recursive https://github.com/MaskRay/ccls.git # TODO pin to release?
pushd ccls

cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$LLVM_CLANG_PATH  # TODO add build parallelism?
cmake --build Release
ln -s $FORCE $(pwd)/Release/ccls /usr/local/bin/ccls
 
popd

sudo -u $SUDO_USER wget -O nvim.appimage https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
sudo -u $SUDO_USER chmod a+x nvim.appimage
sudo -u $SUDO_USER ./nvim.appimage --appimage-extract
mkdir -p /usr/local/bin # organize this line to somewhere else, doesn't fit with nvim code
sudo -u $SUDO_USER mkdir -p $XDG_CONFIG_HOME/nvim
ln -s $FORCE $(pwd)/vimrc $XDG_CONFIG_HOME/nvim/init.vim
ln -s $FORCE $(pwd)/squashfs-root/usr/bin/nvim $NVIM_INSTALL_PATH # TODO is it safe to hardcode `squashfs-root`
ln -s $FORCE $(pwd)/coc-settings.json $XDG_CONFIG_HOME/nvim/coc-settings.json
rm nvim.appimage

git config --global core.editor "nvim"
export EDITOR=nvim # TODO need to actually add this to bash_profile or whatever

sudo -u $SUDO_USER ln -s $FORCE $(pwd)/vimrc ~/.vimrc
sudo -u $SUDO_USER ln -s $FORCE $(pwd)/tmux.conf ~/.tmux.conf
sudo -u $SUDO_USER ln -s $FORCE $(pwd)/emacs.d ~/.emacs.d


