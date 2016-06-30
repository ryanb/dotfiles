#!/bin/bash

set -o errexit

function link_config_files {
  for filename in $*; do
    if [ ! -e ~/.$filename ]; then
      ln -s ~/.$filename ~/.dotfiles/$filename
      echo "Linked .$filename"
    else
      echo ".$filename is already linked, skipping."
    fi
  done
}


echo '*** Config files ***'

link_config_files agignore gitignore tmate.conf tmux.conf zshrc


echo
echo '*** Fonts ***'

cp ~/.dotfiles/fonts/Inconsolata.otf $HOME/Library/Fonts
echo Installed.


echo
echo '*** Homebrew *** '

if which brew > /dev/null; then
  echo 'brew is already installed, skipping.'
else
  echo 'Installing brew...'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

link_config_files Brewfile
brew bundle --global --verbose


echo
echo '*** Ruby *** '

link_config_files ruby-version

ruby_version=`cat ~/.ruby-version`
if [ ! -d ~/.rubies/ruby-$ruby_version ]; then
  ruby-install ruby $ruby_version
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  gem install bundler
else
  echo "Ruby $ruby_version is already installed, skipping."
fi


echo
echo '*** Node ***'

link_config_files node-version

node_version=`cat ~/.node-version`
if [ ! -d ~/.nodenv/versions/$node_version ]; then
  nodenv install $node_version
  npm install npm -g
  npm install standard -g
  npm install babel-eslint -g
  nodenv rehash
else
  echo "Node $node_version is already installed, skipping."
fi


echo
echo '*** Pow ***'

if [ ! -d ~/Library/Application\ Support/Pow ]; then
  curl get.pow.cx | sh
else
  echo 'Pow is already installed, skipping.'
fi


echo
echo '*** Vim config *** '

link_config_files vimrc vundle

mkdir -p ~/.vim/bundle
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim -u ~/.vundle +PluginInstall +qall

echo Installed.


echo
echo '*** Git config *** '

git config --global user.name "Pete Yandell"
git config --global user.email "pete@notahat.com"
git config --global github.user notahat
git config --global difftool.prompt false
git config --global color.ui true
git config --global core.excludesfile '~/.gitignore'

# Make git push only push the current branch.
git config --global push.default current

# Make new branches do a rebase on git pull.
git config --global branch.autosetuprebase always
git config --global merge.defaultToUpstream true

# Helpful aliases.
git config --global alias.root '!pwd'

echo Installed.


echo
echo '*** OS X config *** '

# Disable the dashboard.
defaults write com.apple.dashboard mcx-disabled -boolean YES

# Clear out the dock.
defaults write com.apple.dock checked-for-launchpad -boolean YES
defaults write com.apple.dock persistent-apps "()"
defaults write com.apple.dock orientation left
killall Dock

# Set up menu bar extras.
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu"
killall SystemUIServer

# Hide the desktop.
defaults write com.apple.finder CreateDesktop false
killall Finder

echo Installed.
