# shellcheck shell=bash

if [[ ! -f /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle --no-lock --file "environments/$DOTFILES_ENV/Brewfile"

if ! brew autoupdate status | grep "installed and running"; then
  brew autoupdate start --upgrade
fi
