alias reload='source ~/.zshrc'

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
alias gb='gh pr view --web'
alias gs='git status'

alias zed='/usr/local/bin/zed'

alias lvim='NVIM_APPNAME=lazyvim nvim'

function autoruby {
  echo $1 | entr -c ruby $1
}

function autonode {
  echo $1 | entr -c node $1
}

function autorspec {
  echo $1 | entr -c ./up rspec $1
}
