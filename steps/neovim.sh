mkdir -p ~/.config/nvim
link_file ~/.dotfiles/nvim/init.lua ~/.config/nvim/init.lua

# Our neovim plugins are in submodules, so make sure we've got them.
git submodule update --init --depth 1

mkdir -p ~/.config/nvim/pack
link_file ~/.dotfiles/nvim/plugins ~/.config/nvim/pack/plugins

# Rebuild the help index for all the plugins.
nvim --headless -c "helptags ALL" -c "quitall"
