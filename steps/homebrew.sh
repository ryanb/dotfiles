if [ ! -f /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

/opt/homebrew/bin/brew bundle --no-lock --file environments/${DOTFILES_ENV}/Brewfile

if ! /opt/homebrew/bin/brew autoupdate status | grep "installed and running"; then
  /opt/homebrew/bin/brew autoupdate start --upgrade
fi
