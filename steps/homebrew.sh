if [ ! -f /usr/local/bin/brew ]; then
  arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo 'x86_64 brew is already installed, skipping.'
fi

if [ ! -f /opt/homebrew/bin/brew ]; then
  arch -arm64e /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo 'arm64e brew is already installed, skipping.'
fi

arch -x86_64 /usr/local/bin/brew bundle --no-lock --file Brewfile-x86_64

arch -arm64e /opt/homebrew/bin/brew bundle --no-lock --file Brewfile-arm64e
