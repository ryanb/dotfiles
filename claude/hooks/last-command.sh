#!/bin/sh
# UserPromptSubmit hook. Receives JSON via stdin. Records the slash command a
# prompt starts with, so the statusline can show the most recent one. Scoped
# per session so parallel sessions don't overwrite each other.
set -e

input=$(cat)
session=$(printf '%s' "$input" | jq -r '.session_id // ""')
prompt=$(printf '%s' "$input" | jq -r '.prompt // ""')
[ -n "$session" ] || exit 0

command=$(printf '%s' "$prompt" | sed -n '1s|^[[:space:]]*/\([A-Za-z0-9:_-]\{1,\}\).*|\1|p')
[ -n "$command" ] || exit 0

dir="$HOME/.claude/last-command"
mkdir -p "$dir"
find "$dir" -type f -mtime +7 -delete 2>/dev/null || true
printf '%s' "$command" > "$dir/$session"
