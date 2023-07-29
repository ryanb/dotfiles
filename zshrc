# Environment ==================================================================

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

export CLICOLOR=1  # Make ls colour its output.
export LESS=-R     # Make less support ANSI colour sequences.

# Prompt =======================================================================

PATH_PROMPT_INFO='%F{blue}%~%f'

autoload -U vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vsc_info:*' check-for-staged-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' formats '%F{green}[%b%u%c]%f'
precmd () { vcs_info }

NEWLINE=$'\n'

setopt prompt_subst
PROMPT='${NEWLINE}${PATH_PROMPT_INFO} ${vcs_info_msg_0_} %# '

# vi mode ======================================================================

bindkey -v
KEYTIMEOUT=1

bar_cursor() { echo -ne "\e[6 q" }
block_cursor() { echo -ne "\e[2 q" }

zle -N zle-line-init bar_cursor

zle-keymap-select () {
  if [[ $KEYMAP = vicmd ]]; then
    block_cursor
  else
    bar_cursor
  fi
}
zle -N zle-keymap-select

# History ======================================================================

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

# Aliases ======================================================================

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

alias zed='/usr/local/bin/zed'

function autoruby {
  echo $1 | entr -c ruby $1
}

function autonode {
  echo $1 | entr -c node $1
}

# Homebrew =====================================================================

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH

  export HOMEBREW_NO_ENV_HINTS=true
  export EDITOR=$HOMEBREW_PREFIX/bin/nvim
fi

# asdf =========================================================================

if [[ -f $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh ]]; then
  source $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh
fi

# Completion and syntax highlighting ===========================================

autoload -U compinit && compinit

ZSH_AUTOSUGGEST_STRATEGY=(completion)

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-yarn-completions/zsh-yarn-completions.plugin.zsh
