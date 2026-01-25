# This is based on https://github.com/ohmyzsh/ohmyzsh

# ALIASES

alias ga='git add'
alias gaa='git add --all'
alias gaap='git add -N . && git add -p'

alias gb='git branch --sort=committerdate'

alias gco='git checkout'

alias gc='git commit --verbose'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gc!='git commit --verbose --amend'
alias gcn!='git commit --verbose --no-edit --amend'

alias gcp='git cherry-pick'

alias gd='git diff'
alias gdh='git diff HEAD'
alias gdca='git diff --cached'
alias gds='git diff --staged'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
grbi() {
  local commit
  if [[ -z "$1" ]]; then
    commit=$(git log --oneline -n 100 | fzf --no-sort | awk '{print $1}')
    [[ -z "$commit" ]] && return
    git rebase --interactive $commit^
  else
    git rebase --interactive "$@"
  fi
}

alias grst='git restore --staged'

alias gpristine='git reset --hard && git clean --force -dfx'
alias groh='git reset origin/$(git_current_branch) --hard'

alias gsh='git show'

alias gst='git status'

alias gstl='git stash list'
alias gsta='git stash push'
alias gstas='git stash push --staged'
alias gstau='git stash push --keep-index'
alias gstp='git stash pop'

alias gsw='git switch'
alias gswc='git switch --create'

gbm() {
  if [[ -z "$1" ]]; then
    echo "Usage: gbm <new-branch-name>"
    return 1
  fi

  local new_branch=$1
  local old_branch=$(git_current_branch)

  # Convert branch names to directory names (replace / with _)
  local old_dir_name=${old_branch//\//_}
  local new_dir_name=${new_branch//\//_}

  # Check if we're in a worktree whose directory matches the branch name
  local current_root=$(git rev-parse --show-toplevel)
  local current_dir_name=${current_root:t}

  if [[ "$current_dir_name" == "$old_dir_name" ]]; then
    local parent_dir=${current_root:h}
    local new_worktree_path="$parent_dir/$new_dir_name"

    # Rename the branch first
    git branch -m "$new_branch" || return 1

    # Move the worktree directory
    cd "$parent_dir"
    mv "$old_dir_name" "$new_dir_name" || return 1

    # Repair the worktree
    git -C "$new_worktree_path" worktree repair

    # Change to the new directory
    cd "$new_worktree_path"
  else
    # Just rename the branch
    git branch -m "$new_branch"
  fi
}

gw() {
  local branch
  if [[ -z "$1" ]]; then
    branch=$(git branch --sort=-committerdate | fzf --no-sort | tr -d ' +')
    [[ -z "$branch" ]] && return
  else
    branch=$1
    shift
  fi

  local worktree_path
  worktree_path=$(git worktree list | grep "\[$branch\]" | awk '{print $1}')
  if [[ -n "$worktree_path" ]]; then
    cd "$worktree_path"
  else
    # If we're in a linked worktree, cd to main repo first
    local main_worktree current_root
    main_worktree=$(git worktree list | head -1 | awk '{print $1}')
    current_root=$(git rev-parse --show-toplevel)
    if [[ "$current_root" != "$main_worktree" ]]; then
      cd "$main_worktree"
    fi
    git switch "$branch" "$@"
  fi
}
_gw() {
  local branches=("${(@f)$(git branch --format='%(refname:short)' 2>/dev/null)}")
  _describe 'branch' branches
}
compdef _gw gw

gfix() {
  local commit
  local stashed=0
  if [[ -z "$1" ]]; then
    commit=$(git log --oneline -n 100 | fzf --no-sort | awk '{print $1}')
    [[ -z "$commit" ]] && return
  else
    commit=$1
  fi
  # Stash unstaged changes if there are any
  if ! git diff --quiet; then
    git stash push --keep-index -m "gfix: unstaged changes"
    stashed=1
  fi
  git commit --fixup $commit && GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash $commit^
  # Restore unstaged changes if we stashed them
  if [[ $stashed -eq 1 ]]; then
    git stash pop
  fi
}

grbr() {
  local commit
  if [[ -z "$1" ]]; then
    commit=$(git log --oneline -n 100 | fzf --no-sort | awk '{print $1}')
    [[ -z "$commit" ]] && return
  else
    commit=$1
  fi
  GIT_SEQUENCE_EDITOR="sed -i '' '1s/^pick/reword/'" git rebase -i $commit^
}

grbe() {
  local commit
  if [[ -z "$1" ]]; then
    commit=$(git log --oneline -n 100 | fzf --no-sort | awk '{print $1}')
    [[ -z "$commit" ]] && return
  else
    commit=$1
  fi
  GIT_SEQUENCE_EDITOR="sed -i '' '1s/^pick/edit/'" git rebase -i $commit^
}

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

  # If branch matches directory name, only show [*] when dirty
  if [[ "${ref//\//_}" == "${PWD:t}" ]]; then
    local dirty=$(git_dirty_info "*")
    if [[ -n $dirty ]]; then
      echo "$1$dirty$2"
    fi
    return 0
  fi

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
