#!/bin/bash -x

sudo apt-get install -y curl git ctags zsh autojump htop
sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
sudo apt-get install -y golang

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim

wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
cd chruby-0.3.9/
sudo make install

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
