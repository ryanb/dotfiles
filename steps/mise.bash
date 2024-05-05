# shellcheck shell=bash

if [[ $DOTFILES_ENV == "home" ]]; then
  mkdir -p .copnfig
  link_file "environments/$DOTFILES_ENV/mise.toml" ~/.config/mise.toml

  # Make sure we've got homebrew loaded, coz mise is installed with it.
  eval "$(/opt/homebrew/bin/brew shellenv)"

  eval "$(mise activate bash)"

  mise install
fi
