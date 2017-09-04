#!/bin/bash -x
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo add-apt-repository -y ppa:tmate.io/archive
sudo add-apt-repository -y ppa:cpick/hub

sudo apt-get update

sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev software-properties-common
sudo apt-get install -y curl git ctags zsh autojump htop

sudo apt-get install -y neovim
sudo apt-get install -y tmate
sudo apt-get install -y hub
sudo apt-get install -y golang
sudo apt-get install -y tmux

export GOPATH=$HOME/dev/dbldots/go
go get github.com/dbldots/goclip
sudo ln -s $GOPATH/bin/goclip /usr/local/bin/xsel

# neovim
if [ ! -d "$HOME/the_silver_searcher" ]; then
  cd
  git clone https://github.com/ggreer/the_silver_searcher.git
  cd the_silver_searcher
  ./build.sh
  sudo make install
fi

# set shell to zsh
sudo chsh -s `which zsh` $USER
