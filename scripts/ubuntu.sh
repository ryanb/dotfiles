#!/bin/bash -x

sudo apt-get install -y curl git ctags zsh autojump htop
sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
sudo apt-get install -y golang

sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim

export GOPATH=$HOME/dev/dbldots/go
go get github.com/dbldots/goclip
sudo ln -s $GOPATH/bin/goclip /usr/local/bin/xsel

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

# emacs
sudo apt-get -y build-dep emacs24
mkdir ~/emacs-install
cd ~/emacs-install
wget http://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz
tar -xf emacs-24.5.tar.* && cd emacs-24.5
./configure
make
sudo make install
