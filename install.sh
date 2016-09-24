#!/bin/bash

set -o errexit

green=`tput setaf 2`
reset=`tput sgr0`

function echo_green {
  echo -e "${green}${1}${reset}"
}

function link_file {
  if [ ! -e $2 ]; then
    ln -s $1 $2
    echo "Linked $2"
  else
    echo "$2 is already linked, skipping."
  fi
}

function link_config_files {
  for filename in $*; do
    link_file ~/.dotfiles/$filename ~/.$filename
  done
}


echo_green '*** Firewall ***'

sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on


echo
echo_green '*** Filevault ***'

if ! fdesetup status | grep -E "FileVault is (On|Off, but will be enabled after the next restart)."; then
  sudo fdesetup enable -user "$USER" | tee ~/Desktop/"FileVault Recovery Key.txt"
fi


echo
echo_green '*** Config files ***'

link_config_files agignore gitignore tmate.conf tmux.conf zshrc


echo
echo_green '*** Fonts ***'

cp ~/.dotfiles/fonts/*.otf $HOME/Library/Fonts
echo Installed.


echo
echo_green '*** Homebrew ***'

if [ ! -f /usr/local/bin/brew ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo 'brew is already installed, skipping.'
fi

link_config_files Brewfile
brew bundle --global


echo
echo_green '*** Ruby ***'

link_config_files ruby-version

ruby_version=`cat ~/.ruby-version`
if [ ! -d ~/.rubies/ruby-$ruby_version ]; then
  ruby-install ruby $ruby_version
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  chruby $ruby_version
  gem install bundler
else
  echo "Ruby $ruby_version is already installed, skipping."
fi


echo
echo_green '*** Node ***'

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
echo_green '*** Pow ***'

if [ ! -d ~/Library/Application\ Support/Pow ]; then
  curl get.pow.cx | sh
else
  echo 'Pow is already installed, skipping.'
fi


echo
echo_green '*** Vim config ***'

link_config_files vimrc vimplug

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
vim -u ~/.vimplug +PlugInstall +qall


echo
echo_green '*** NeoVim config ***'

mkdir -p ~/.config/nvim
link_file ~/.dotfiles/nvim/init.vim ~/.config/nvim/init.vim
link_file ~/.dotfiles/nvim/vimplug.vim ~/.config/nvim/vimplug.vim

if [ ! -f ~/.config/nvim/autoload/plug.vim ]; then
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# This won't work, because neovim exits before the install finishes:
#   nvim -u ~/.config/nvim/vimplug.vim +PlugInstall +qall
# I'll have to do it by hand for now.


echo
echo_green '*** Git config ***'

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
echo_green '*** OS X config ***'

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
