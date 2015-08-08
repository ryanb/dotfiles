# ==============================================================================
# Shell basics

autoload -U compinit
compinit -i

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:~/.bin:/opt/vagrant/bin


# ==============================================================================
# Tools

if [[ -f /opt/boxen/env.sh ]]; then
  source /opt/boxen/env.sh
fi

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

if [ `boot2docker status` = running ]; then
    `boot2docker shellinit 2> /dev/null`
fi


# ==============================================================================
# Prompt

autoload colors; colors;

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%b%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"  # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""   # Text to display if the branch is clean

function git_prompt_info() {
  branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${branch}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function parse_git_dirty () {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

setopt prompt_subst
PROMPT='%{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info) '


# ==============================================================================
# Environment

# We use the full path here to work around this nasty bug: http://www.tpope.net/node/108
# In particular, calling "filetype indent off" in my vimrc was causing vim to
# always exit with a non-zero status. Very annoying for git commit.
export EDITOR=/usr/bin/vim

export CLICOLOR=1  # Make ls colour its output.
export LESS=-R     # Make less support ANSI colour sequences.

export RAILS_CACHE_CLASSES=true


# ==============================================================================
# Aliases

alias be='bundle exec'

alias cdr='cd $(git rev-parse --show-cdup)'

alias ga='git add'
alias gb='gh browse'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gff='git merge --ff-only'
alias gm='git merge --no-ff'
alias gp='git push'
alias gpr='git push -u origin `git rev-parse --abbrev-ref HEAD` && gh compare'
alias gs='git status'

alias tasks='vim ~/Dropbox/routine/tasks.md'

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
# See http://www.leancrew.com/all-this/2013/02/getting-rid-of-open-with-duplicates/
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user; killall Finder'

# Boot2docker plays up for me sometimes. This fixes it.
alias fix-docker='boot2docker ssh sudo /etc/init.d/docker restart'
