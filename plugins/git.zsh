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

gdb() {
  local base_branch
  base_branch=$(detect_base_branch)
  echo "Base branch: $base_branch"
  git diff --shortstat "$base_branch"...HEAD
  git diff "$base_branch"...HEAD "$@"
}

gl() {
  if [[ -n "$1" ]]; then
    git log "$@"
    return
  fi
  local commit
  commit=$(git log --color -n 100 | fzf --ansi --no-sort | awk '{print $1}')
  [[ -z "$commit" ]] && return
  git show --format=medium $commit
}
compdef _git gl=git-log

alias glp='git log -p'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
grbi() {
  local commit
  if [[ -z "$1" ]]; then
    commit=$(git log --color -n 100 | fzf --ansi --no-sort | awk '{print $1}')
    [[ -z "$commit" ]] && return
    git rebase --interactive $commit^
  else
    git rebase --interactive "$@"
  fi
}
compdef _git grbi=git-rebase

grbb() {
  local branch
  if [[ -z "$1" ]]; then
    branch=$(git branch --sort=-committerdate | fzf --no-sort | tr -d ' +')
    [[ -z "$branch" ]] && return
    git rebase --interactive $branch
  else
    git rebase --interactive "$@"
  fi
}
compdef _git grbb=git-rebase

alias grst='git restore --staged'

alias gpristine='git reset --hard && git clean --force -dfx'
alias grhr='git reset --hard @{u}'

alias gsh='git show --format=medium'

gshw() {
  local commit
  if [[ -z "$1" ]]; then
    commit=$(git log --color -n 100 | fzf --ansi --no-sort | awk '{print $1}')
    [[ -z "$commit" ]] && return
  else
    commit=$1
  fi
  local commits=("${(@f)$(git log --reverse --oneline $commit^..HEAD)}")
  local total=${#commits}
  local i=1
  while [[ $i -ge 1 && $i -le $total ]]; do
    local entry=${commits[$i]}
    local sha=${entry%% *}
    echo "\n\n[$i/$total] $entry"
    git -c core.pager='less -R' --paginate show --format=medium $sha
    while true; do
      echo ""
      read -sk "?[n]ext [p]rev [q]uit: "
      case $REPLY in
        n) i=$((i + 1)); break ;;
        p) [[ $i -gt 1 ]] && i=$((i - 1)); break ;;
        q) echo ""; return ;;
        *) echo "\nUnknown key '$REPLY'. Use n/p/q." ;;
      esac
    done
  done
}

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

# Designed to work in a project that has a bin/worktree script
worktree() {
  local output
  output=$(bin/worktree --no-cd "$@" 2>&1)
  local exit_code=$?

  echo "$output"

  if [ $exit_code -ne 0 ]; then
    return $exit_code
  fi

  # Extract worktree directory from "cd <path>" line in output
  local worktree_dir
  worktree_dir=$(echo "$output" | grep "^cd " | tail -1 | sed 's/^cd //')

  if [ -n "$worktree_dir" ] && [ -d "$worktree_dir" ]; then
    cd "$worktree_dir" || return 1
    if command -v direnv >/dev/null 2>&1; then
      direnv allow
    fi
  fi
}

gfix() {
  local git_dir="$(git rev-parse --git-dir 2>/dev/null)" || return 1
  for state in rebase-merge rebase-apply MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD BISECT_LOG; do
    if [[ -e "$git_dir/$state" ]]; then
      echo "Git operation in progress, aborting gfix"
      return 1
    fi
  done
  local commit
  local stashed=0
  if [[ -z "$1" ]]; then
    commit=$(git log --color -n 100 | fzf --ansi --no-sort | awk '{print $1}')
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
compdef _git gfix=git-rebase

grbr() {
  local commit
  if [[ -z "$1" ]]; then
    commit=$(git log --color -n 100 | fzf --ansi --no-sort | awk '{print $1}')
    [[ -z "$commit" ]] && return
  else
    commit=$1
  fi
  GIT_SEQUENCE_EDITOR="sed -i '' '1s/^pick/reword/'" git rebase -i $commit^
}
compdef _git grbr=git-rebase

grbe() {
  local commit
  if [[ -z "$1" ]]; then
    commit=$(git log --color -n 100 | fzf --ansi --no-sort | awk '{print $1}')
    [[ -z "$commit" ]] && return
  else
    commit=$1
  fi
  GIT_SEQUENCE_EDITOR="sed -i '' '1s/^pick/edit/'" git rebase -i $commit^
}
compdef _git grbe=git-rebase

# FUNCTIONS

# Detects the base branch for the current branch by walking commits
# and finding the first one that exists on an origin branch
detect_base_branch() {
  local CURRENT_BRANCH=$(git_current_branch)
  # Start from HEAD~1 to ensure at least one commit between base and current branch
  for commit in $(git rev-list HEAD~1 2>/dev/null); do
    for branch in $(git branch --contains "$commit" 2>/dev/null | sed 's/^[* +]//' | grep -v "^$CURRENT_BRANCH$"); do
      # Skip branches that are ahead of HEAD (i.e., branches created from this one)
      if git merge-base --is-ancestor HEAD "$branch" 2>/dev/null; then
        continue
      fi
      echo "$branch"
      return
    done
  done
  # Fallback to repo's default branch
  git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|^refs/remotes/origin/||'
}

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
