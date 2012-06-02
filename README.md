# Ryan Bates Dot Files

These are config files to set up a system the way I like it. It now uses [Oh My ZSH](https://github.com/robbyrussell/oh-my-zsh). If you would like to see my old, custom Bash and ZSH config, check out [this branch](https://github.com/ryanb/dotfiles/tree/custom-bash-zsh)


## Installation

Run the following commands in your terminal. It will prompt you before it does anything destructive. Check out the [Rakefile](https://github.com/ryanb/dotfiles/blob/custom-bash-zsh/Rakefile) to see exactly what it does.

```terminal
git clone git://github.com/ryanb/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```

After installing, open a new terminal window to see the effects.


## Environment

I am running on Mac OS X, but it will likely work on Linux as well.


## Features

I normally place all of my coding projects in ~/code, so this directory can easily be accessed (and tab completed) with the "c" command.

  c railsca<tab>

There is also an "h" command which behaves similar, but acts on the home path.

  h doc<tab>

Tab completion is also added to rake and cap commands:

  rake db:mi<tab>
  cap de<tab>

To speed things up, the results are cached in local .rake_tasks~ and .cap_tasks~. It is smart enough to expire the cache automatically in most cases, but you can simply remove the files to flush the cache.

If you're using git, you'll notice the current branch name shows up in the prompt while in a git repository.

If there are some shell configuration settings which you want secure or specific to one system, place it into a ~/.localrc file. This will be loaded automatically if it exists.

There are several features enabled in Ruby's irb including history and completion. Many convenience methods are added as well such as "ri" which can be used to get inline documentation in IRB. See irbrc file for details.


## Uninstall

To remove the dotfile configs, run the following commands. Be certain to double check the contents of the files before removing so you don't lose custom settings.

```
unlink ~/.bin
unlink ~/.gitignore
unlink ~/.gemrc
unlink ~/.gvimrc
unlink ~/.irbrc
unlink ~/.vim
unlink ~/.vimrc
unlink ~/.zshrc
rm ~/.gitconfig # careful here
rm -rf ~/.dotfiles
rm -rf ~/.oh-my-zsh
chsh -s `which bash` # change back to Bash if you want
```

Then open a new terminal window to see the effects.
