## Installation

To set up a new system:

    git clone git://github.com/notahat/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    ./install.sh

The install script is idempotent; it is safe to run multiple times.

## Steps

The installation is divided into steps.

Run `./install.sh -h` to see all the available steps.

Run `./install.sh [step name]` to run a single step.

The script for each step is in the `steps` directory.

## Plugins

Plugins for neovim and zsh are managed as git submodules.

Run `./update-plugins.sh` to fetch new versions of all plugins.
