#!/bin/bash

set -o errexit

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

function echo_red {
  echo -e "${red}${1}${reset}"
}

function echo_green {
  echo -e "${green}${1}${reset}"
}

function link_file {
  if [ -L "$2" ]; then
    echo "$2 is already linked, skipping."
  elif [ -e "$2" ]; then
    echo_red "$2 already exists, skipping. (You might not want this, so check the file.)"
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
  source ~/.dotfiles/script/steps/$1.sh
}

function usage {
  echo "Usage:"
  echo "  ./install.sh [step]"
  echo
  echo "Available steps: ${steps[@]}"
}

steps=(plugins macos homebrew asdf zsh ssh git iterm2 neovim vscode zed)

if [ -z $DOTFILES_ENV ]; then
  echo_red "No DOTFILES_ENV set! It should be either work or home."
  exit 1
fi

if [ -z $1 ]; then
  for step in ${steps[@]}; do
    run_step $step
  done
elif [ $1 = -h ]; then
  usage
else
  run_step $1
fi
