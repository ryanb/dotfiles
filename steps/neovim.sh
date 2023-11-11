mkdir -p ~/.config
link_file config/nvim ~/.config/nvim

# Rebuild the help index for all the plugins.
nvim --headless -c "helptags ALL" -c "quitall"
