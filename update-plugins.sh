#!/bin/sh

git submodule foreach git pull

# Rebuild the neovim help index for all the plugins.
nvim --headless -c "helptags ALL" -c "quitall"
