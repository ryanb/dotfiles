# ==============================================================================
# Shell basics

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -U compinit
compinit -i

bindkey -v

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin


# ==============================================================================
# Tools

if [ -f /usr/local/opt/chruby/share/chruby/chruby.sh ]; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh
fi

if which nodenv > /dev/null; then
  eval "$(nodenv init -)"
fi


# ==============================================================================
# Prompt

autoload colors; colors;

PATH_PROMPT_INFO="%{$fg[blue]%}%~%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%b%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"  # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""   # Text to display if the branch is clean

function git_prompt_info() {
  branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${branch}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function parse_git_dirty() {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

JOB_PROMPT_INFO="%{$fg[red]%}%(1j.&.)%{$reset_color%}"

setopt prompt_subst
PROMPT='${PATH_PROMPT_INFO}$(git_prompt_info)${JOB_PROMPT_INFO} '


# ==============================================================================
# Tab title

autoload add-zsh-hook

function set_tab_title() {
  echo -n "\033];${PWD##*/}\007"
}

# Set the tab title before each prompt
add-zsh-hook precmd set_tab_title


# ==============================================================================
# Environment

export EDITOR=/usr/local/bin/nvim

export CLICOLOR=1  # Make ls colour its output.
export LESS=-R     # Make less support ANSI colour sequences.

export RAILS_CACHE_CLASSES=true
export DISABLE_SPRING=true

export GOPATH=$HOME/src/go
export PATH=$GOPATH/bin:$PATH


# ==============================================================================
# Aliases

alias be='bundle exec'
alias br='./bin/rails'

alias cdr='cd $(git root)'

alias ga='git add'
alias gb='hub browse'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gff='git merge --ff-only'
alias gl='git log'
alias gm='git merge --no-ff'
alias gp='git push'
alias gpr='git push -u && hub compare'
alias gs='git status'

source .zshrc-envato
