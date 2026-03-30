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
    wezterm cli spawn --new-window --workspace "$name" --cwd "$PWD" -- zsh -ic 'worktree '"$name"'; exec zsh'
    printf '\033]1337;SetUserVar=switch-workspace=%s\007' "$(echo -n "$name" | base64)"
  fi
}
