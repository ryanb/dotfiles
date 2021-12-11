# ==============================================================================
# Plugins

export ZPLUG_HOME=/usr/local/opt/zplug
if [[ -f $ZPLUG_HOME/init.zsh ]]; then
  source $ZPLUG_HOME/init.zsh

  zplug "mafredri/zsh-async", from:github
  zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

  zplug "zsh-users/zsh-syntax-highlighting", defer:2
  zplug "zsh-users/zsh-autosuggestions", defer:2

  if ! zplug check; then
    zplug install
  fi

  zplug load
fi

ZSH_AUTOSUGGEST_STRATEGY=(completion)


# ==============================================================================
# Basics

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -U compinit
compinit -i

bindkey -v
KEYTIMEOUT=1

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin


# ==============================================================================
# History

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# Make arrows and command mode j and k search the history.

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search


# ==============================================================================
# Cursor

bar_cursor() { echo -ne "\e[6 q" }
block_cursor() { echo -ne "\e[2 q" }

zle -N zle-line-init bar_cursor

zle-keymap-select () {
  if [ $KEYMAP = vicmd ]; then
    block_cursor
  else
    bar_cursor
  fi
}
zle -N zle-keymap-select


# ==============================================================================
# Tools

if [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
  source /usr/local/opt/asdf/libexec/asdf.sh
fi


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
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gff='git merge --ff-only'
alias gl='git log'
alias gm='git merge --no-ff'
alias gp='git push'
alias gpr='git push -u && gh pr create --web'
alias gs='git status'

source ~/.zshrc-envato
