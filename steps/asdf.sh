link_file environments/${DOTFILES_ENV}/tool-versions ~/.tool-versions
link_file config/asdf/default-npm-packages ~/.default-npm-packages
link_file config/asdf/default-gems ~/.default-gems

asdf plugin add nodejs || true
asdf install nodejs

asdf plugin add ruby || true
asdf install ruby
