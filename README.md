# Pete's Dotfiles

This does 80% of the work of setting up a Mac the way I like it.

Setup scripts only work if you maintain them. The only way to maintain them is
to use them frequently.

To that end, the install script is idempotent, and can be edited and re-run on
a machine that's already set up. Individual setup steps can be run separately.

Simpler is better. I like to be as close to a stock system as possible.
Anything I'm not using gets removed.

## Usage

### Installation

On a new system:

    xcode-select --install
    git clone git://github.com/notahat/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    ./bin/install home

Run `./bin/install -h` to see other options.

### Managing Plugins

Plugins for neovim and zsh are managed as git submodules.

Run `./bin/upgrade-plugins` to fetch new versions of all plugins.

## Modifying

Scripts for each step live in the `steps` directory. They're all run by
`bin/install`, which also provides some helpful functions for the steps to
use.

All the config files live under `config`. Most of these get soft-linked into
place by the steps.

The `environments` directory contains Brewfiles and `.tool-versions` files
specific to home and work.

## Tools Used

### [Homebrew](https://brew.sh)

Homebrew installs anything where I always want the latest version, including
apps from the Mac App Store. I configure it to run `brew upgrade`
automatically.

### [asdf](https://asdf-vm.com)

Asdf manages things like languages, where I want particular versions (and
possibly multiple versions) installed.
