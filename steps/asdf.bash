# shellcheck shell=bash

link_file "environments/$DOTFILES_ENV/tool-versions" ~/.tool-versions

# Make sure we've got homebrew loaded, coz asdf is installed with it.
eval "$(/opt/homebrew/bin/brew shellenv)"

# shellcheck disable=1091
source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"

asdf plugin add nodejs || true
asdf plugin add ruby || true
asdf install
