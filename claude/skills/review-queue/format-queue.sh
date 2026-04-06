#!/usr/bin/env bash
# Reads PR JSON from stdin (output of pr-data.sh).
# Filters WIP, scores, builds dependency trees, and outputs a formatted ranked list.
# If preferences are present, outputs them as a PREFERENCES: header for Claude to apply.
set -euo pipefail

jq -r '
.preferences as $prefs
| .prs

# 1. Filter out WIP-labeled PRs
| [.[] | select([.labels[] | select(. == "WIP")] | length == 0)]

# 2. Compute review-ease scores (lower = easier to review)
| [.[] | . + {
    score: (
      (.filteredAdditions + .filteredDeletions)
      - (if (.approvedBy | length) > 0 then 50 else 0 end)
      - (if ([.labels[] | select(. == "ai-review: 5/5")] | length) > 0 then 40 else 0 end)
      - (if ([.labels[] | select(. == "risk: Low")] | length) > 0 then 30 else 0 end)
      - (if .reviewDecision == "APPROVED" then 50 else 0 end)
    )
  }]

# 3. Identify parent for each PR
| . as $scored
| [.[] | . + {
    parentNumber: (
      .baseRefName as $base
      | [$scored[] | select(.headRefName == $base) | .number] | first // null
    )
  }]
| . as $all

# Helper: get children of a node sorted by score
| def get_children($head):
    [$all[] | select(.baseRefName == $head and .parentNumber != null)] | sort_by(.score);

  # Helper: format label/approval/status badges
  def format_extras:
    ([.labels[] | select(startswith("ai-review:") or startswith("risk:"))]
      | map("`" + . + "`")) as $badges
    | (if (.approvedBy | length) > 0
       then ["Approved by " + ([.approvedBy[] | "@" + .] | join(", "))]
       else [] end) as $approvals
    | (if .reviewDecision == "CHANGES_REQUESTED"
       then ["Changes requested"]
       else [] end) as $status
    | ($badges + $approvals + $status) | join(" ");

  # Helper: format one PR line
  def format_pr($prefix):
    "\($prefix)[\(.title)](\(.url)) (\(.author)) [+\(.filteredAdditions), -\(.filteredDeletions)]"
    + (format_extras as $e | if $e != "" then " " + $e else "" end);

  # Recursive tree renderer
  # $line_prefix:     the prefix for THIS node'"'"'s line  (e.g. "    └─ ")
  # $children_prefix: the prefix base for this node'"'"'s children (e.g. "       ")
  def render_node($line_prefix; $children_prefix):
    [format_pr($line_prefix)]
    + (
      get_children(.headRefName) as $ch
      | if ($ch | length) == 0 then []
        else
          [range($ch | length)] | map(
            . as $i
            | (($ch | length) - 1) as $last_idx
            | (if $i == $last_idx then $children_prefix + "└─ " else $children_prefix + "├─ " end) as $clp
            | (if $i == $last_idx then $children_prefix + "   " else $children_prefix + "│  " end) as $ccp
            | $ch[$i] | render_node($clp; $ccp)
          ) | add
        end
    );

# 4. Build preferences header (if any)
(if $prefs then ["PREFERENCES: " + $prefs, ""] else [] end)

# 5. Get roots (PRs with no parent in the set), sorted by score
+ ([.[] | select(.parentNumber == null)] | sort_by(.score)

  # 6. Render each root and its dependency tree
  | to_entries | map(
      (.key + 1) as $num
      | .value | render_node("\($num)\\. "; "    ")
    )
  | add // ["No PRs to review."]
)
| join("\n")
'
