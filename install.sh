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

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "macOS"
else
  echo "Error: $OSTYPE not supported"
fi

# this is set to -f if -f is passed to the script
FORCE=""
# TODO need to document this and maybe make it easier
if [[ $* == *-f* ]]; then
  FORCE="-f"
fi

function package_install {
  if [[ "OSTYPE" == "linux-gnu"* ]]; then
    apt install -y $@
  elif [[ "OSTYPE" == "darwin"* ]]; then
    brew install -y $@
  fi
}

function package_update {
  if [[ "OSTYPE" == "linux-gnu"* ]]; then
    apt update
  elif [[ "OSTYPE" == "darwin"* ]]; then
    brew update
  fi
}

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

  # Change home to the home directory of the original user
  export HOME=`sudo -u $SUDO_USER /bin/bash -c "echo ~"`
  export XDG_CONFIG_HOME=~/.config
fi

package_update
# TODO maybe just make it so we just need one of wget and curl
package_install -y wget
package_install -y curl
package_install -y git
# install nodejs for CoC
# TODO these are different versions of node
if [[ "OSTYPE" == "linux-gnu"* ]]; then
  curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  apt install -y nodejs
elif [[ "OSTYPE" == "darwin"* ]]; then
  package-install -y node
fi

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
ln -s $FORCE $(pwd)/coc-settings.json $XDG_CONFIG_HOME/nvim/coc-settings.json
rm nvim.appimage

git config --global core.editor "nvim"
export EDITOR=nvim # TODO need to actually add this to bash_profile or whatever

sudo -u $SUDO_USER ln -s $FORCE $(pwd)/vimrc ~/.vimrc
sudo -u $SUDO_USER ln -s $FORCE $(pwd)/tmux.conf ~/.tmux.conf
sudo -u $SUDO_USER ln -s $FORCE $(pwd)/emacs.d ~/.emacs.d


