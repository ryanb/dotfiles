#!/bin/bash
# Claude Code statusline script. Receives JSON via stdin.
# Shows context window usage and a rate limit warning when usage is
# outpacing the time remaining in the window (and >= 20% consumed).
input=$(cat)
context=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')
dir=$(echo "$input" | jq -r '.workspace.current_dir' | xargs basename)

now=$(date +%s)
hourly_usage=""
hourly_expected=""
weekly_usage=""
weekly_expected=""

# Check both rate limit windows; warn if usage% is within 5% of (or above)
# the time-elapsed% (expected usage)
for window in five_hour seven_day; do
  case $window in
    five_hour) seconds=18000 ;;
    seven_day) seconds=604800 ;;
  esac
  used=$(echo "$input" | jq -r ".rate_limits.${window}.used_percentage // 0 | floor")
  resets_at=$(echo "$input" | jq -r ".rate_limits.${window}.resets_at // 0")
  case $window in
    five_hour) threshold=20 ;;
    seven_day) threshold=70 ;;
  esac
  if [ "$used" -ge "$threshold" ] && [ "$resets_at" -gt 0 ]; then
    remaining=$(( resets_at - now ))
    [ "$remaining" -lt 0 ] && remaining=0
    elapsed=$(( 100 - (remaining * 100 / seconds) ))
    if [ "$used" -gt $(( elapsed - 5 )) ]; then
      case $window in
        five_hour) hourly_usage=$used; hourly_expected=$elapsed ;;
        seven_day) weekly_usage=$used; weekly_expected=$elapsed ;;
      esac
    fi
  fi
done

YELLOW='\033[33m'
RESET='\033[0m'

fmt_delta() { local d=$(( $1 - $2 )); [ "$d" -ge 0 ] && echo "+$d" || echo "$d"; }
delta_color() { [ "$(( $1 - $2 ))" -ge 0 ] && echo "$YELLOW"; }

warnings=""
[ -n "$hourly_usage" ] && warnings="$(delta_color "$hourly_usage" "$hourly_expected")Usage: ${hourly_usage}% $(fmt_delta "$hourly_usage" "$hourly_expected")${RESET}"
[ -n "$weekly_usage" ] && warnings="${warnings:+$warnings | }7d Usage: ${weekly_usage}% $(fmt_delta "$weekly_usage" "$weekly_expected")"

stamp=$(date "+%b %d %I:%M %p")

if [ -n "$warnings" ]; then
  echo -e "Context: ${context}% | $warnings | $stamp | $dir"
else
  echo -e "Context: ${context}% | $stamp | $dir"
fi
