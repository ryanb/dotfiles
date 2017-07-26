#!/usr/bin/env bash

cd ~
curl -fLO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/dbldots/dotfiles/master/files/_config/nvim/init.vim
chmod +x nvim.appimage
sudo ln -s ~/nvim.appimage /usr/local/bin/nvim
nvim
