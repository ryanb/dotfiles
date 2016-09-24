mkdir -p ~/.config/nvim
link_file ~/.dotfiles/nvim/init.vim ~/.config/nvim/init.vim
link_file ~/.dotfiles/nvim/vimplug.vim ~/.config/nvim/vimplug.vim

if [ ! -f ~/.config/nvim/autoload/plug.vim ]; then
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo
echo "You'll need to do a manual :PlugInstall to finish the job."
