if [ ! -f /usr/local/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo 'brew is already installed, skipping.'
fi

link_config_files Brewfile
brew bundle --global
