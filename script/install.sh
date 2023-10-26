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
  echo "  ./install.sh home|work [step name]"
  echo
  echo "Run all steps:"
  echo "  ./script/install.sh home|work"
  echo
  echo "Run a single step:"
  echo "  ./script/install.sh home|work [step name]"
  echo
  echo "Available steps: ${steps[@]}"
  exit 1
}

steps=(plugins macos homebrew asdf zsh ssh git iterm2 neovim zed)

if [[ -z $1 || $1 == -h ]]; then usage; fi

if [[ $1 != "home" && $1 != "work" ]]; then usage; fi
DOTFILES_ENV=$1

if [[ -e $2 ]]; then
  run_step $2
else
  for step in ${steps[@]}; do
    run_step $step
  done
fi
