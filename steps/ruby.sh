link_config_files ruby-version

ruby_version=`cat ~/.ruby-version`
if [ ! -d ~/.rubies/ruby-$ruby_version ]; then
  ruby-install ruby $ruby_version
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  chruby $ruby_version
  gem install bundler
else
  echo "Ruby $ruby_version is already installed, skipping."
fi
