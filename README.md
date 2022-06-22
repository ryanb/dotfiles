This is what I use to set up a Mac for myself.
It gets me 80% of the way there, including:

* Installing most of the apps I use
* Setting up my dev environment

I'm sure you want different things on your system, but feel free to copy this approach.

## Philosophy

Setup scripts only work if you maintain them.
The only way to maintain them is to use them frequently.

To that end, these scripts are:

* idempotent
* divided into steps that can be run individually

That makes it very easy to modify and re-run a step on a sytem that's already set up.

## Installation

On a new system:

    xcode-select --install
    git clone git://github.com/notahat/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    ./install.sh

## Steps

Run `./install.sh -h` to see all the available steps.

Run `./install.sh [step name]` to run a single step.

The scripts for the steps are in the `steps` directory.

## Plugins

Plugins for neovim and zsh are managed as git submodules.

Run `./update-plugins.sh` to fetch new versions of all plugins.
