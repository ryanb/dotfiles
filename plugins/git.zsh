# This is based on https://github.com/ohmyzsh/ohmyzsh

# ALIASES

alias ga='git add'
alias gaa='git add --all'

alias gb='git branch --sort=committerdate'

alias gco='git checkout'

alias gc='git commit --verbose'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gc!='git commit --verbose --amend'
alias gcn!='git commit --verbose --no-edit --amend'

alias gd='git diff'
alias gdh='git diff HEAD'
alias gdca='git diff --cached'
alias gds='git diff --staged'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'

alias grst='git restore --staged'

alias gpristine='git reset --hard && git clean --force -dfx'
alias groh='git reset origin/$(git_current_branch) --hard'

alias gsh='git show'

alias gst='git status'

alias gstl='git stash list'
alias gsta='git stash push'
alias gstp='git stash pop'

alias gsw='git switch'
alias gswc='git switch --create'


# FUNCTIONS

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(git --no-optional-locks symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(git --no-optional-locks rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# Pass the prefix and suffix as first and second argument
# Example: git_prompt_info [ ]
function git_prompt_info() {
  # If we are on a folder not tracked by git, get out.
  if !git --no-optional-locks rev-parse --git-dir &> /dev/null; then
    return 0
  fi

  local ref
  ref=$(git --no-optional-locks symbolic-ref --short HEAD 2> /dev/null) \
  || ref=$(git --no-optional-locks describe --tags --exact-match HEAD 2> /dev/null) \
  || ref=$(git --no-optional-locks rev-parse --short HEAD 2> /dev/null) \
  || return 0

  echo "$1${ref:gs/%/%%}$(git_dirty_info "*")$2"
}

# Checks if working tree is dirty
# The argument passed in is printed when dirty
# Example: git_dirty_info "*"
function git_dirty_info() {
  local STATUS
  STATUS=$(git --no-optional-locks status --porcelain 2> /dev/null | tail -n 1)
  if [[ -n $STATUS ]]; then
    echo $1
  fi
}
