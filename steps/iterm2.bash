# shellcheck shell=bash

defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.dotfiles/config/iterm2"

defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

echo Installed.
