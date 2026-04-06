# Ryan Bates Dot Files

These are config files to set up Mac OS X command line the way I like it using [Zsh](https://www.zsh.org).

For an older version that uses [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh), check out [this branch](https://github.com/ryanb/dotfiles/tree/oh-my-zsh).


## Installation

Run the `bin/install` command to copy files over. It will prompt you before replacing if the files already exist.

```sh
git clone git@github.com/ryanb/dotfiles ~/.dotfiles
cd ~/.dotfiles
./bin/install
```

After installing, open a new terminal window to see the effects.

Feel free to customize the .zshrc file to match your preference.


## Features

I normally place all of my coding projects in ~/code, so this directory can easily be accessed (and tab completed) with the "c" command.

```sh
c railsca<tab>
```

If you don't specify an argument it will open `fzf` allowing you to fuzzy-find code directories. You can add directories to this with CODE_PATH. Just ensure the first one is the base one.

```sh
# in .zshrc
export CODE_PATH="$HOME/code:$HOME/code/railscasts-episodes"
```

There is also an "h" command which behaves similar, but acts on the home path.

```sh
h doc<tab>
```

If you're using git, you'll notice the current branch name shows up in the prompt while in a git repository.

Use `gw` to switch branches with `fzf`. If the branch is checked out in a worktree, it will `cd` there instead.


## Claude Code

The `claude/` directory is a [Claude Code plugin](https://code.claude.com/docs/en/plugins.md) with the following skills:

- **gfix** — Amend a commit further back in history with fixup + auto-rebase
- **rebase** — Interactive rebase workflow
- **remote-diff** — Compare local vs remote branch to detect rebase/merge mistakes
- **review-queue** — Ranked PR review list with dependency trees and filtered line counts
- **walkthrough** — Walk through PR changes from the user's perspective

### Installing as a plugin

```sh
/plugin install --path claude ryanb/dotfiles
```

### review-queue preferences

Create `~/.claude/review-queue.json` to customize which PRs are prioritized per repo:

```json
{
  "owner/repo": "Prioritize POS PRs. Exclude my PRs (author: username) that are not yet approved."
}
```


## Uninstall

To remove the dotfile configs, run the following commands. Be certain to double check the contents of the files before removing so you don't lose custom settings.

```
unlink ~/.bin
unlink ~/.gitignore
unlink ~/.gitconfig
unlink ~/.gemrc
unlink ~/.gvimrc
unlink ~/.irbrc
unlink ~/.vim
unlink ~/.vimrc
rm ~/.zshrc # careful here
rm -rf ~/.dotfiles
```

Then open a new terminal window to see the effects.
