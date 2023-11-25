# shellcheck shell=bash

mkdir -p ~/.ssh
chmod 700 ~/.ssh
link_file config/ssh/ssh-config ~/.ssh/config
