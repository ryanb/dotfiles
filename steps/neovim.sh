link_file ~/.dotfiles/nvim ~/.config/nvim

# Our neovim plugins are in submodules, so make sure we've got them.
git submodule update --init --depth 1

# Rebuild the help index for all the plugins.
nvim --headless -c "helptags ALL" -c "quitall"
