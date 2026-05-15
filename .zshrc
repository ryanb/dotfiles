export PATH="$HOME/.local/bin:$PATH:/Applications/WezTerm.app/Contents/MacOS"
export XDG_CONFIG_HOME="$HOME/.config"
export FZF_DEFAULT_COMMAND="rg --files -g '"\!"sorbet' -g '"\!"*.graphql'"
export EDITOR='vim'

# Force emacs keybindings (EDITOR=vim would otherwise put zsh in vi mode
# under login shells, e.g. inside tmux, breaking C-a / C-e / etc.)
bindkey -e

alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias vimclean="find . -iname '*.swp' | xargs rm"
alias weather="curl http://v2.wttr.in"
# Replace ls with eza
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons' # A nice tree view

# --- Antidote Setup ---
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
# Initialize plugins from our text file
antidote load

eval "$(mise activate zsh)"
eval "$(starship init zsh)"

# --- Quick Fixes & Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z confirmation-Z}={A-Z a-z}' # Case-insensitive completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

