#!/usr/bin/env bash
# Reconcile GitHub stack metadata and PR base branches with a stack's real order.
#
# `rebase-stack.sh` rewrites local branches; it does not touch GitHub. After a
# run that changed the stack's *shape*, this brings the PR bases and the GitHub
# stack into line with the new order.
#
# Why unstack-then-link: `gh stack link` is additive — "existing PRs are never
# removed" — so it cannot reorder a stack whose PRs are already all in it.
# Reordering means dissolving the affected stack(s) first, then relinking in the
# target order.
#
# Dry run by default: prints the plan and exits. Pass --yes to execute.

set -euo pipefail

# Newline-delimited rather than arrays: this has to run under the bash 3.2 that
# ships with macOS, where `set -u` rejects empty-array expansion and there is no
# `mapfile`.
BASE_BRANCH=
ASSUME_YES=false
UNSTACK_OVERRIDE=
BRANCHES=()

usage() {
  cat <<EOF
Usage:
  $(basename "$0") [--base <branch>] [--yes] [--unstack <n>[,<n>...]] \\
      <branch-bottom> [branch2 ...] <branch-top>

  Branches are given bottom → top, the same order passed to rebase-stack.sh.

Flags:
  --base <branch>     Base of the bottom PR. Defaults to the bottom branch's
                      tracked parent, else bin/base-branch.
  --yes               Execute. Without it, print the plan and exit 0.
  --unstack <n>,<n>   Stack numbers to dissolve first, when auto-detection
                      can't find them (it needs local stack tracking).
EOF
}

die() {
  echo "✗ $*" >&2
  exit 1
}

while (( $# )); do
  case "$1" in
    --base)     BASE_BRANCH=${2:?--base requires a value}; shift 2 ;;
    --yes)      ASSUME_YES=true; shift ;;
    --unstack)  UNSTACK_OVERRIDE=$(tr ',' '\n' <<< "${2:?--unstack requires a value}"); shift 2 ;;
    -h|--help)  usage; exit 0 ;;
    --*)        usage >&2; die "Unknown flag: $1" ;;
    *)          BRANCHES+=("$1"); shift ;;
  esac
done

(( ${#BRANCHES[@]} >= 2 )) || { usage >&2; die "Need at least two branches."; }

in_stack() {
  local b
  for b in "${BRANCHES[@]}"; do [[ "$b" == "$1" ]] && return 0; done
  return 1
}

if [[ -z "$BASE_BRANCH" ]]; then
  candidate=$(git config "branch.${BRANCHES[0]}.parent" 2>/dev/null || true)
  if [[ -n "$candidate" ]] && ! in_stack "$candidate" \
     && git rev-parse --verify "$candidate^{commit}" >/dev/null 2>&1; then
    BASE_BRANCH=$candidate
  else
    root=$(git rev-parse --show-toplevel)
    if [[ -x "$root/bin/base-branch" ]] && candidate=$("$root/bin/base-branch" 2>/dev/null) \
       && [[ -n "$candidate" ]]; then
      BASE_BRANCH=$candidate
    else
      die "Could not determine the base branch. Pass --base <branch>."
    fi
  fi
fi
command -v gh >/dev/null 2>&1 || die "gh is not installed."
command -v jq >/dev/null 2>&1 || die "jq is not installed."
gh stack --version >/dev/null 2>&1 || die "The gh-stack extension is not installed."

worktree_for_branch() {
  git worktree list --porcelain | awk -v b="$1" '
    $1 == "worktree" { wt = $2 }
    $1 == "branch"   { if ($2 == "refs/heads/" b && !found) { print wt; found = 1 } }
  '
}

# --- Resolve each branch to its open PR -------------------------------------

PR_JSON=$(gh pr list --state open --limit 200 --json number,headRefName,baseRefName)

pr_number_for() {
  jq -r --arg b "$1" '.[] | select(.headRefName == $b) | .number' <<< "$PR_JSON" | head -1
}

pr_base_for() {
  jq -r --arg b "$1" '.[] | select(.headRefName == $b) | .baseRefName' <<< "$PR_JSON" | head -1
}

PR_NUMBERS=()
MISSING_PRS=
for branch in "${BRANCHES[@]}"; do
  pr=$(pr_number_for "$branch")
  PR_NUMBERS+=("$pr")
  [[ -n "$pr" ]] || MISSING_PRS="$MISSING_PRS $branch"
done

# --- Discover which stacks those PRs currently belong to --------------------
#
# There is no `gh stack list`. `gh stack view --json` only reports the stack
# containing the checked-out branch, and only once that stack is tracked
# locally, so this is best-effort — hence --unstack as an escape hatch.

# The stack number is printed only by `gh stack view --short` ("Stack #8899");
# `--json` omits it entirely, exposing just trunk/currentBranch/branches.
discover_stacks() {
  local branch wt num
  for branch in "${BRANCHES[@]}"; do
    wt=$(worktree_for_branch "$branch")
    [[ -n "$wt" ]] || continue
    num=$( (cd "$wt" && gh stack view --short 2>/dev/null) | sed -n 's/^Stack #\([0-9]\{1,\}\).*/\1/p' | head -1 )
    [[ -n "$num" ]] && echo "$num"
  done | sort -u
}

if [[ -n "$UNSTACK_OVERRIDE" ]]; then
  STACKS=$UNSTACK_OVERRIDE
else
  STACKS=$(discover_stacks)
fi

# --- Plan -------------------------------------------------------------------

echo "Target order (bottom → top), base $BASE_BRANCH:"
for (( i = 0; i < ${#BRANCHES[@]}; i++ )); do
  branch="${BRANCHES[$i]}"
  pr="${PR_NUMBERS[$i]}"
  want=$([[ $i -eq 0 ]] && echo "$BASE_BRANCH" || echo "${BRANCHES[$((i - 1))]}")
  if [[ -z "$pr" ]]; then
    printf '  %-2d %-55s (no open PR — link will create one) base → %s\n' "$((i + 1))" "$branch" "$want"
  else
    have=$(pr_base_for "$branch")
    mark=$([[ "$have" == "$want" ]] && echo "ok" || echo "CHANGE from $have")
    printf '  %-2d %-55s #%-6s base → %-45s [%s]\n' "$((i + 1))" "$branch" "$pr" "$want" "$mark"
  fi
done

echo
if [[ -n "$STACKS" ]]; then
  echo "Stacks to dissolve first: $(tr '\n' ' ' <<< "$STACKS")"
else
  echo "Stacks to dissolve first: none detected."
  echo "  If these PRs ARE already in a stack, auto-detection failed (it needs local"
  echo "  stack tracking). 'link' is additive and will NOT reorder an existing stack,"
  echo "  so re-run with --unstack <stack-number>. Find it in the GitHub stack UI, or:"
  echo "    (cd <worktree> && gh stack checkout ${PR_NUMBERS[0]:-<pr>} && gh stack view --json)"
fi

if [[ -n "$MISSING_PRS" ]]; then
  echo
  echo "⚠ No open PR for:$MISSING_PRS"
  echo "  'gh stack link' will push these branches and open PRs for them."
fi

LINK_CMD=(gh stack link --base "$BASE_BRANCH" "${BRANCHES[@]}")
echo
echo "Commands:"
while read -r n; do [[ -n "$n" ]] && echo "  gh stack unstack $n"; done <<< "$STACKS"
echo "  ${LINK_CMD[*]}"

if [[ "$ASSUME_YES" != true ]]; then
  echo
  echo "Dry run — nothing changed. Re-run with --yes to execute."
  exit 0
fi

# --- Execute ----------------------------------------------------------------

while read -r n; do
  [[ -n "$n" ]] || continue
  echo
  echo "→ gh stack unstack $n"
  # Exits 0 even when it does nothing ("⚠ Some pull requests are queued for merge or have
  # auto-merge enabled and remain stacked" / "The stack was left in place"), so the output
  # is the only signal. Not fatal: `link` reorders by creating a new stack anyway, and the
  # verification pass at the end is what actually decides.
  out=$(gh stack unstack "$n" 2>&1) || true
  printf '%s\n' "$out"
  if grep -qE 'left in place|remain stacked' <<< "$out"; then
    echo "  ⚠ stack $n was NOT dissolved. Continuing — 'link' can still reorder, and bases"
    echo "    are verified at the end."
  fi
done <<< "$STACKS"

echo
echo "→ ${LINK_CMD[*]}"
if ! "${LINK_CMD[@]}"; then
  echo >&2
  echo "✗ link failed." >&2
  if [[ -n "$STACKS" ]]; then
    echo "  Stacks $(tr '\n' ' ' <<< "$STACKS") were already dissolved — these PRs are now UNSTACKED on" >&2
    echo "  GitHub. Re-run this script (bases are still set) to rebuild the stack." >&2
  fi
  echo "  If the error mentions multiple stacks, re-run with --unstack listing every" >&2
  echo "  stack number it named." >&2
  exit 1
fi

# --- Verify -----------------------------------------------------------------

echo
echo "→ Verifying PR bases..."
AFTER=$(gh pr list --state open --limit 200 --json number,headRefName,baseRefName)
failed=false
for (( i = 0; i < ${#BRANCHES[@]}; i++ )); do
  branch="${BRANCHES[$i]}"
  want=$([[ $i -eq 0 ]] && echo "$BASE_BRANCH" || echo "${BRANCHES[$((i - 1))]}")
  have=$(jq -r --arg b "$branch" '.[] | select(.headRefName == $b) | .baseRefName' <<< "$AFTER" | head -1)
  if [[ "$have" == "$want" ]]; then
    echo "  ✓ $branch → $have"
  else
    echo "  ✗ $branch → ${have:-<no open PR>} (expected $want)"
    failed=true
  fi
done

if [[ "$failed" == true ]]; then
  echo >&2
  echo "✗ Some PR bases are still wrong. The usual cause is that the PRs were already" >&2
  echo "  in a stack that wasn't dissolved, so 'link' had nothing to reorder. Re-run" >&2
  echo "  with --unstack <stack-number>." >&2
  exit 1
fi

echo
echo "✅ Stack metadata and PR bases match the new order."
