#!/bin/bash
input=$(cat)
context=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')
dir=$(echo "$input" | jq -r '.workspace.current_dir' | xargs basename)

five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0 | floor')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0 | floor')
usage=$(( five_hour > seven_day ? five_hour : seven_day ))

if [ "$usage" -ge 50 ]; then
  echo "Context: ${context}% | Usage: ${usage}% | $dir"
else
  echo "Context: ${context}% | $dir"
fi
