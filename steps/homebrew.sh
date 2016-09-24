if [ ! -f /usr/local/bin/brew ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo 'brew is already installed, skipping.'
fi

link_config_files Brewfile
brew bundle --global
