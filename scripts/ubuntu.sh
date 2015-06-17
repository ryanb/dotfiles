#!/bin/bash -x

sudo apt-get install -y curl git ctags zsh autojump htop
sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev

# neovim
if [ ! -d "$HOME/the_silver_searcher" ]; then
  cd
  git clone git@github.com:ggreer/the_silver_searcher.git
  cd the_silver_searcher
  ./build.sh
  sudo make install
fi

# set shell to zsh
sudo chsh -s `which zsh` $USER
