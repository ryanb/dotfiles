This does 80% of the work of setting up a Mac the way I like it.

I'm sure you want different things on your system, but feel free to copy this
approach.

## Philosophy

### Idempotence

Setup scripts only work if you maintain them. The only way to maintain them is
to use them frequently.

To that end, the install script is idempotent, and can be edited and re-run on
a machine that's already set up. Individual setup steps can be run separately.

### Simplicity

Simpler is better. I like to be as close to a stock system as possible.
Anything I'm not using gets removed.

## Usage

### Installation

On a new system:

    xcode-select --install
    git clone git://github.com/notahat/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    ./script/install.sh home

Run `./script/install.sh -h` to see other options.

### Managing Plugins

Plugins for neovim and zsh are managed as git submodules.

Run `./script/update-plugins.sh` to fetch new versions of all plugins.

## Modifying

Scripts for each step live in the `script/steps` directory. They're all
run by `scripts/install.h`, which also provides some helpful functions
for the steps to use.

## Tools Used

### [Homebrew](https://brew.sh)

Homebrew installs anything where I always want the latest version, including
apps from the Mac App Store. I run `brew upgrade` pretty regularly to keep
everything up to date.

### [asdf](https://asdf-vm.com)

Asdf manages things like languages, where I want particular versions (and
possibly multiple versions) installed.

### [Neovim](https://neovim.io)

I learnt to use vi on terminals where it was the only option. Neovim gives
me a modern vim with Lua scripting.

### [Visual Studio Code](https://code.visualstudio.com)

I use VSCode for working on JavaScript and TypeScript. Its language server
integration is hard to beat.

### [Z shell](https://zsh.sourceforge.io)

I started using zsh because it was much less resource-hungry than bash, back in
the days when that mattered. I've stuck with it, and it's now the default on
MacOS.

I *don't* use Oh My Zsh. It ruins zsh's responsiveness.
