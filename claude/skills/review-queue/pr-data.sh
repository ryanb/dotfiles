#!/usr/bin/env bash
# Gathers PR data for the current repo, outputting JSON.
# Excludes test/doc/lock files from line counts.
set -euo pipefail

EXCLUDE_PATTERNS='(\.(md|lock)$|package-lock\.json|yarn\.lock|Gemfile\.lock|\.test\.(js|ts|jsx|tsx)$|\.spec\.(js|ts|jsx|tsx)$|_test\.go$|_spec\.rb$|(^|/)spec/|(^|/)test/|(^|/)tests/|(^|/)__tests__/)'

repo=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null)
me=$(gh api user -q '.login' 2>/dev/null)

# Load user preferences for this repo (if any)
config_file="$HOME/.claude/review-queue.json"
preferences=""
if [ -f "$config_file" ]; then
  preferences=$(jq -r --arg repo "$repo" '.[$repo] // empty' "$config_file" 2>/dev/null || true)
fi

# Get all open PRs with the fields we need
prs_json=$(gh pr list \
  --json number,title,url,baseRefName,headRefName,labels,reviewDecision,latestReviews,files,isDraft,author \
  --limit 100)

# Process with jq: filter out drafts, compute filtered line counts, emit structured data
echo "$prs_json" | jq --arg me "$me" --arg pat "$EXCLUDE_PATTERNS" --arg prefs "$preferences" '
  {
    preferences: (if $prefs != "" then $prefs else null end),
    prs: [ .[]
      | select(.isDraft == false)
      | {
          number,
          title,
          url,
          baseRefName,
          headRefName,
          author: .author.login,
          labels: [.labels[].name],
          reviewDecision,
          approvedBy: [.latestReviews[] | select(.state == "APPROVED") | .author.login],
          totalAdditions: ([.files[].additions] | add // 0),
          totalDeletions: ([.files[].deletions] | add // 0),
          filteredAdditions: ([.files[] | select(.path | test($pat) | not) | .additions] | add // 0),
          filteredDeletions: ([.files[] | select(.path | test($pat) | not) | .deletions] | add // 0),
          fileCount: ([.files[] | select(.path | test($pat) | not)] | length)
        }
    ]
  }
'
