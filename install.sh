#!/bin/bash

set -o errexit

green=`tput setaf 2`
reset=`tput sgr0`

function echo_green {
  echo -e "${green}${1}${reset}"
}

function link_file {
  if [ -L "$2" ]; then
    echo "$2 is already linked, skipping."
  elif [ -e "$2" ]; then
    echo "$2 already exists, skipping. (You might not want this, so check the file.)"
  else
    ln -s "$1" "$2"
    echo "Linked $2"
  fi
}

function link_config_files {
  for filename in $*; do
    link_file ~/.dotfiles/$filename ~/.$filename
  done
}

function run_step {
  echo
  echo_green "*** $1 ***"
  source ~/.dotfiles/steps/$1.sh
}

steps=(firewall filevault config homebrew iterm2 ruby node pow neovim vscode git)

if [ -z $1 ]; then
  for step in ${steps[@]}; do
    run_step $step
  done
elif [ $1 = -h ]; then
  echo "Available steps: ${steps[@]}"
else
  run_step $1
fi

