#!/bin/sh

git submodule update --remote --depth 1

# Rebuild the neovim help index for all the plugins.
nvim --headless -c "helptags ALL" -c "quitall"
