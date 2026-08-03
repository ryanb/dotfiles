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
