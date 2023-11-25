# shellcheck shell=bash

link_file "environments/$DOTFILES_ENV/tool-versions" ~/.tool-versions
link_file config/asdf/default-npm-packages ~/.default-npm-packages
link_file config/asdf/default-gems ~/.default-gems

/opt/homebrew/bin/asdf plugin add nodejs || true
/opt/homebrew/bin/asdf install nodejs

/opt/homebrew/bin/asdf plugin add ruby || true
/opt/homebrew/bin/asdf install ruby
