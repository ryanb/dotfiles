# shellcheck shell=bash

link_file config/zsh/zshrc ~/.zshrc
link_file config/zsh/zshenv ~/.zshenv
mkdir -p ~/.config
link_file config/zsh ~/.config/zsh

# We use submodules for zsh plugins, so make sure we've got 'em.
git submodule update --init --depth 1
