# shellcheck shell=bash

mkdir -p ~/.config/mise
link_file "environments/$DOTFILES_ENV/mise.toml" ~/.config/mise/config.toml

# Make sure we've got homebrew loaded, coz mise is installed with it.
eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(mise activate bash)"

mise install
