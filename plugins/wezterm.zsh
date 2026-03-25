wt() {
  if [[ -z "$1" ]]; then
    echo "Usage: wt <name>"
    return 1
  fi
  wezterm cli spawn --new-window --workspace "$1" --cwd "$PWD" -- zsh -ic 'worktree '"$1"'; exec zsh'
}
