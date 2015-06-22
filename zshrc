
# Completion

autoload -U compinit
compinit -i

# History

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# Path

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:~/.bin

# Boxen

if [[ -f /opt/boxen/env.sh ]]; then
  source /opt/boxen/env.sh
fi

# chruby or rbenv

if [[ -f /usr/local/opt/chruby/share/chruby/chruby.sh ]]; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh

  function ruby_version() {
    basename "$RUBY_ROOT"
  }
else
  # If we're using boxen, it'll have set up rbenv for us already.
  function ruby_version() {
    rbenv version | sed "s/^\([^ ]*\).*$/\1/"
  }
fi

# Colors for the prompt

autoload colors; colors;

# Git prompt magic

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%b%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"              # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""               # Text to display if the branch is clean

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function parse_git_dirty () {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Prompts

setopt prompt_subst
PROMPT='%{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info) '
# RPROMPT='%{$fg[yellow]%}$(ruby_version)%{$reset_color%}'

# Aliases

alias be="bundle exec"
alias ga="git add"
alias gs="git status"
alias gf="git fetch"
alias gco="git checkout"
alias gm="git merge --no-ff"
alias gff="git merge --ff-only"
alias gp="git push"
alias gb="gh browse"
alias cdr='cd $(git rev-parse --show-cdup)'

alias moment=~/src/moment/bin/moment

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
# See http://www.leancrew.com/all-this/2013/02/getting-rid-of-open-with-duplicates/
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user; killall Finder'

# We use the full path here to work around this nasty bug: http://www.tpope.net/node/108
# In particular, calling "filetype indent off" in my vimrc was causing vim to
# always exit with a non-zero status. Very annoying for git commit.
export EDITOR=/usr/bin/vim

export CLICOLOR=1                                         # Make ls colour its output.
export LESS=-R                                            # Make less support ANSI colour sequences.

export RAILS_CACHE_CLASSES=true

export NODENV_VERSION=v0.12.1

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Set environment variables for Docker, if it's up.
if [ `boot2docker status` = running ]; then
    `boot2docker shellinit 2> /dev/null`
fi
