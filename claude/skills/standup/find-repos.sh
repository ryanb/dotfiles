#!/usr/bin/env bash
# Find git repos under <base_path> with any commits since the given date.
# Usage: find-repos.sh <base_path> [since]
# Outputs one absolute repo path per line.
set -euo pipefail

base="${1:?base path required}"
since="${2:-yesterday}"

# Expand a leading ~ in base
base="${base/#\~/$HOME}"

for dir in "$base"/*/; do
  [ -d "$dir/.git" ] || continue
  if [ -n "$(git -C "$dir" log --all --since="$since" --oneline -1 2>/dev/null)" ]; then
    echo "${dir%/}"
  fi
done
