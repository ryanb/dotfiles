# Dot Files

These are config files to set up a system the way I like it.
I am running on Mac OS X, but it will likely work on Linux as well.

## Installation

Run the following commands in your terminal. It will prompt you before it does anything destructive. Check out the [Rakefile](https://github.com/ryanb/dotfiles/blob/custom-bash-zsh/Rakefile) to see exactly what it does.

```terminal
git clone git://github.com/dbldots/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```
after installing, open a new terminal window to see the effects.

## Quick File Usage

```
curl https://raw.githubusercontent.com/dbldots/dotfiles/master/files/_tmux.conf > ~/.tmux.conf
```

## Features

* oh-my-zsh
* vundle
* some more useful vim plugins
* my favourite vim mappings (mac & linux friendly)
* additional 'pure' zsh theme from (https://github.com/sindresorhus/pure)

## Uninstall

```terminal
rake uninstall
```
