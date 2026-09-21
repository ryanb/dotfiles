wt() {
  local name="$1"
  if [[ -z "$name" ]]; then
    name=$(git branch -a --sort=-committerdate --format='%(refname:short)' \
      | sed 's|^origin/||' | awk '!seen[$0]++' \
      | fzf --no-sort)
    [[ -z "$name" ]] && return
  fi
  if wezterm cli list --format json | jq -e --arg ws "$name" 'any(.[]; .workspace == $ws)' > /dev/null 2>&1; then
    printf '\033]1337;SetUserVar=switch-workspace=%s\007' "$(echo -n "$name" | base64)"
  else
    track_branch_parent "$name"
    wezterm cli spawn --new-window --workspace "$name" --cwd "$PWD" -- zsh -ic 'worktree '"$name"'; exec zsh'
    printf '\033]1337;SetUserVar=switch-workspace=%s\007' "$(echo -n "$name" | base64)"
  fi
}

wtc() {
  local code_path="${CODE_PATH:-$HOME/code}"
  local base_path="${code_path%%:*}"
  local name="$1"
  if [[ -z "$name" ]]; then
    name=$(echo "$code_path" | tr ':' '\n' | while read -r dir; do
      for d in "$dir"/*/; do
        [[ -d "$d" ]] && echo "$(stat -f %m "$d") $d"
      done
    done | sort -n | cut -d' ' -f2- | sed "s|$base_path/||;s|/$||" | fzf --tac)
    [[ -z "$name" ]] && return
  fi
  local dir="$base_path/$name"
  local ws="${name:t}"
  if ! wezterm cli list --format json | jq -e --arg ws "$ws" 'any(.[]; .workspace == $ws)' > /dev/null 2>&1; then
    wezterm cli spawn --new-window --workspace "$ws" --cwd "$dir" > /dev/null
  fi
  printf '\033]1337;SetUserVar=switch-workspace=%s\007' "$(echo -n "$ws" | base64)"
}

wtn() {
  local current=$(git symbolic-ref --short -q HEAD) || return 1
  if [[ -z "$current" ]]; then
    echo "wtn: not on a branch" >&2
    return 1
  fi
  local -a children
  local line key parent branch
  while IFS= read -r line; do
    key=${line%% *}
    parent=${line#* }
    [[ "$parent" == "$current" ]] || continue
    branch=${${key#branch.}%.parent}
    git show-ref --verify --quiet "refs/heads/$branch" || continue
    children+=("$branch")
  done < <(git config --get-regexp '^branch\..*\.parent$')
  case ${#children[@]} in
    0) echo "wtn: no branch has $current as its parent" >&2; return 1 ;;
    1) wt "${children[1]}" ;;
    *) echo "wtn: multiple branches have $current as their parent:" >&2
       printf '  %s\n' "${children[@]}" >&2
       return 1 ;;
  esac
}

wtp() {
  local current=$(git symbolic-ref --short -q HEAD)
  if [[ -z "$current" ]]; then
    echo "wtp: not on a branch" >&2
    return 1
  fi
  local parent=$(git config --get "branch.$current.parent")
  if [[ -z "$parent" ]]; then
    echo "wtp: no parent tracked for $current" >&2
    return 1
  fi
  wt "$parent"
}
