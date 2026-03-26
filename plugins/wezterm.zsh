wt() {
  if [[ -z "$1" ]]; then
    echo "Usage: wt <name>"
    return 1
  fi
  if wezterm cli list --format json | jq -e --arg ws "$1" 'any(.[]; .workspace == $ws)' > /dev/null 2>&1; then
    printf '\033]1337;SetUserVar=switch-workspace=%s\007' "$(echo -n "$1" | base64)"
  else
    wezterm cli spawn --new-window --workspace "$1" --cwd "$PWD" -- zsh -ic 'worktree '"$1"'; exec zsh'
    printf '\033]1337;SetUserVar=switch-workspace=%s\007' "$(echo -n "$1" | base64)"
  fi
}
