
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.vim/colors/deus.vim --create-dirs https://raw.githubusercontent.com/ajmwagar/vim-deus/master/colors/deus.vim

ln -sf ~/dotfiles/vim/vimrc ~/.vimrc
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/zshrc ~/.zshrc

if ! command -v rg &> /dev/null; then
  sudo apt-get install -o DPkg::Lock::Timeout=600 -y ripgrep
fi

if ! command -v fzf &> /dev/null; then
  sudo apt-get install -o DPkg::Lock::Timeout=600 -y fzf
fi

vim.basic +PlugInstall +qall
