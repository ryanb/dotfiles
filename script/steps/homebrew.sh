if [ ! -f /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

/opt/homebrew/bin/brew bundle --no-lock --file Brewfile-${DOTFILES_ENV:-home}

if ! brew autoupdate status | grep "installed and running"; then
  brew autoupdate start --upgrade
fi
