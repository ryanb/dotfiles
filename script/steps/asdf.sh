link_file ~/.dotfiles/tool-versions-${DOTFILES_ENV:-home} ~/.tool-versions
link_config_files default-npm-packages default-gems

asdf plugin add nodejs || true
asdf install nodejs

asdf plugin add ruby || true
asdf install ruby

asdf plugin add rust || true
asdf install rust
