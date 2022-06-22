#!/bin/sh

git submodule update --remote

# Rebuild the neovim help index for all the plugins.
nvim --headless -c "helptags ALL" -c "quitall"
