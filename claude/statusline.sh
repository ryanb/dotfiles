#!/bin/bash
# Claude Code statusline script. Receives JSON via stdin.
# Shows context window usage and a rate limit warning when usage is
# outpacing the time remaining in the window (and >= 50% consumed).
input=$(cat)
context=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')
dir=$(echo "$input" | jq -r '.workspace.current_dir' | xargs basename)

now=$(date +%s)
hourly_usage=""
weekly_usage=""

# Check both rate limit windows; warn if usage% exceeds time-elapsed%
for window in five_hour seven_day; do
  case $window in
    five_hour) seconds=18000 ;;
    seven_day) seconds=604800 ;;
  esac
  used=$(echo "$input" | jq -r ".rate_limits.${window}.used_percentage // 0 | floor")
  resets_at=$(echo "$input" | jq -r ".rate_limits.${window}.resets_at // 0")
  if [ "$used" -ge 50 ] && [ "$resets_at" -gt 0 ]; then
    remaining=$(( resets_at - now ))
    [ "$remaining" -lt 0 ] && remaining=0
    elapsed=$(( 100 - (remaining * 100 / seconds) ))
    if [ "$used" -gt "$elapsed" ]; then
      case $window in
        five_hour) hourly_usage=$used ;;
        seven_day) weekly_usage=$used ;;
      esac
    fi
  fi
done

YELLOW='\033[33m'
RESET='\033[0m'

warnings=""
[ -n "$hourly_usage" ] && warnings="${YELLOW}Usage: ${hourly_usage}%${RESET}"
[ -n "$weekly_usage" ] && warnings="${warnings:+$warnings | }7d Usage: ${weekly_usage}%"

if [ -n "$warnings" ]; then
  echo -e "Context: ${context}% | $warnings | $dir"
else
  echo -e "Context: ${context}% | $dir"
fi
