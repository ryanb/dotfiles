link_config_files tool-versions asdfrc

asdf plugin-add ruby || true
link_config_files default-gems

asdf plugin-add nodejs || true
link_config_files default-npm-packages

# This is needed for nodejs installs. I'd love to figure out
# how to not re-run this every time.
~/.asdf/plugins/nodejs/bin/import-release-team-keyring

asdf install
