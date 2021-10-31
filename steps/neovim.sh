mkdir -p ~/.config/nvim
link_file ~/.dotfiles/nvim/init.lua ~/.config/nvim/init.lua

if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

echo
echo "You'll need to do a manual :PackerSync to finish the job."
