link_config_files node-version

node_version=`cat ~/.node-version`
if [ ! -d ~/.nodenv/versions/$node_version ]; then
  nodenv install $node_version
  nodenv rehash

  # Get the current version of npm.
  npm install npm -g

  # I do this here rather than in the Brewfile, coz we need node installed
  # first, and I can't figure out how to get the --ignore-dependencies to work
  # in the Brewfile.
  if [ ! -f /usr/local/bin/yarn ]; then
    brew install yarn --ignore-dependencies
  fi

  # I'd love to use yarn for these, but yarn global installs don't play nice
  # with nodenv.
  npm install standard -g
  npm install babel-eslint -g
  npm install create-react-app -g

  nodenv rehash
else
  echo "Node $node_version is already installed, skipping."
fi