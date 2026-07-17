#!/bin/bash
# Claude Code statusline script. Receives JSON via stdin.
# Shows context window usage. The five-hour Usage section always shows (default
# color below the warning threshold, yellow when usage is outpacing the time
# remaining). The weekly section shows only when warning.
input=$(cat)
context=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')
dir=$(echo "$input" | jq -r '.workspace.current_dir' | xargs basename)

now=$(date +%s)
hourly_usage=""
hourly_expected=""
hourly_warn=""
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
  [ "$resets_at" -le 0 ] && continue
  remaining=$(( resets_at - now ))
  [ "$remaining" -lt 0 ] && remaining=0
  elapsed=$(( 100 - (remaining * 100 / seconds) ))
  case $window in
    five_hour)
      hourly_usage=$used; hourly_expected=$elapsed
      [ "$used" -gt "$elapsed" ] && hourly_warn=1 || hourly_warn=""
      ;;
    seven_day)
      [ "$used" -ge 70 ] && [ "$used" -gt $(( elapsed - 5 )) ] \
        && weekly_usage=$used && weekly_expected=$elapsed
      ;;
  esac
done

YELLOW='\033[33m'
RESET='\033[0m'

fmt_delta() { local d=$(( $1 - $2 )); [ "$d" -ge 0 ] && echo "+$d" || echo "$d"; }

warnings=""
if [ -n "$hourly_usage" ]; then
  color=""; [ -n "$hourly_warn" ] && color=$YELLOW
  warnings="${color}Usage: ${hourly_usage}% $(fmt_delta "$hourly_usage" "$hourly_expected")${RESET}"
fi
[ -n "$weekly_usage" ] && warnings="${warnings:+$warnings | }7d Usage: ${weekly_usage}% $(fmt_delta "$weekly_usage" "$weekly_expected")"

stamp=$(date "+%b %d %I:%M %p")

if [ -n "$warnings" ]; then
  echo -e "Context: ${context}% | $warnings | $stamp | $dir"
else
  echo -e "Context: ${context}% | $stamp | $dir"
fi
