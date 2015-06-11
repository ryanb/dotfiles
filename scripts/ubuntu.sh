#!/bin/bash -x

sudo apt-get install -y curl git ctags silversearcher-ag zsh autojump htop

# neovim
if [ ! -e "/usr/bin/nvim" ]; then
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt-get update
  sudo apt-get install -y neovim
fi

# set shell to zsh
sudo chsh -s `which zsh` $USER
