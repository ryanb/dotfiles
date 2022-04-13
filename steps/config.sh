# We use submodules for neovim and zsh plugins, so make sure we've got 'em.
git submodule update --init --depth 1

link_config_files finicky.js tool-versions zshrc zsh

defaults write com.apple.dock show-recents -boolean FALSE
killall Dock
