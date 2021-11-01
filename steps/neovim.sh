mkdir -p ~/.config/nvim
link_file ~/.dotfiles/nvim/init.lua ~/.config/nvim/init.lua

if [ ! -d ~/.local/share/nvim/site/pack/paqs/start/paq-nvim ]; then
git clone --depth=1 https://github.com/savq/paq-nvim.git ~/.local/share/nvim/site/pack/paqs/start/paq-nvim
fi

echo
echo "You'll need to do a manual :PaqSync to finish the job."
