mkdir -p ~/.config/nvim
link_file ~/.dotfiles/nvim/init.lua ~/.config/nvim/init.lua

# Our neovim plugins are in submodules, so make sure we've got them.
git submodule update --init

mkdir -p ~/.local/share/nvim/site/pack
link_file ~/.dotfiles/nvim/plugins ~/.local/share/nvim/site/pack/plugins

echo Installed.
