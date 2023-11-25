# Pete's dotfiles

This does 80% of the work of setting up a Mac the way I like it:

```sh
xcode-select --install
git clone git://github.com/notahat/dotfiles ~/.dotfiles
cd ~/.dotfiles
./bin/install home
```

Setup scripts only work if you maintain them. The only way to maintain them is to use them frequently.

To that end, the install script is idempotent. It can be edited and re-run on a machine that's already set up. It's broken up into small steps that can be edited and run individually. (See `./bin/install -h` for usage.)

Simpler is better. I like to be as close to a stock system as possible. Anything I'm not using gets removed.

## How It Works

`bin/install` runs a series of steps that live in the `steps` directory.

All the config files live under `config`. Most of these get soft-linked into place by the steps.

The `environments` directory contains `Brewfile`s and `.tool-versions`s files for home and work.

Plugins for zsh are installed as git submodules. Run `./bin/upgrade-plugins` to fetch new versions of all plugins.

## Tools Used

[Homebrew](https://brew.sh) installs anything where I always want the latest version, including apps from the Mac App Store. I configure it to run `brew upgrade` automatically.

[Asdf](https://asdf-vm.com) manages things like languages, where I want particular versions (and possibly multiple versions) installed.
