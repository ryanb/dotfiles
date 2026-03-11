alias ad="agent-deck"

adg() {
  local name=$(basename "$PWD")
  agent-deck group create "$name"
  agent-deck add -t "$name-claude" -g "$name" -c claude .
  agent-deck add -t "$name-term" -g "$name" -c "$SHELL" .
  agent-deck session start "$name-claude"
  agent-deck session start "$name-term"
  agent-deck
}
