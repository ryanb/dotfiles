link_config_files node-version

node_version=`cat ~/.node-version`
if [ ! -d ~/.nodenv/versions/$node_version ]; then
  nodenv install $node_version
  npm install npm -g
  npm install standard -g
  npm install babel-eslint -g
  nodenv rehash
else
  echo "Node $node_version is already installed, skipping."
fi
