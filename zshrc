# defaults loaded from /etc/zsh/zshrc. You can clobber this file with your own
# from a dotfiles repo to override.
source /etc/zsh/zshrc.default.inc.zsh

alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias vimclean="find . -iname '*.swp' | xargs rm"
alias weather="curl http://v2.wttr.in"
alias vim="vim.basic"

export FZF_DEFAULT_COMMAND="rg --files -g '"\!"sorbet' -g '"\!"*.graphql'"
export EDITOR='vim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
