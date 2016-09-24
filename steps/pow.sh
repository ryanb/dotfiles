if [ ! -d ~/Library/Application\ Support/Pow ]; then
  curl get.pow.cx | sh
else
  echo 'Pow is already installed, skipping.'
fi
