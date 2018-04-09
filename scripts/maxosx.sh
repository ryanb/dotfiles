#!/bin/bash -x

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap neovim/neovim
brew install --HEAD neovim

brew install tmate
brew install tmux
brew install autojump
brew install hub
brew install ctags
brew install ripgrep

# fix terminfo
# https://github.com/neovim/neovim/issues/2048#issuecomment-78045837
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > ~/$TERM.ti
tic ~/$TERM.ti

# to fix the proper ruby to be picked inside of nvim
sudo mv /etc/{zshenv,zprofile}
