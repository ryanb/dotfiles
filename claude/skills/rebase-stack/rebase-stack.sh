#!/usr/bin/env bash
# Rebase a stack of dependent branches.
#
# - First branch is rebased onto origin/<base>, resolved from --base, the
#   bottom branch's tracked parent, or bin/base-branch.
# - Each subsequent branch is rebased onto the previous (now-rebased) branch.
# - The commits replayed for a branch are only its own: the `git rebase --onto`
#   exclusion boundary is derived from the branch's *current* ancestry, not from
#   the position it occupies in the given list. That makes reordering safe — the
#   list may be in any order relative to the existing chain.
# - Branches whose PR is already merged are skipped; the stack continues onto
#   origin/<base>.
# - Branches without an upstream are rebased but not pushed.
# - On conflicts, exits with code 2 after printing the worktree path. Resolve
#   there, run `git rebase --continue` until clean, then re-invoke with
#   --continue to force-push and move on to the next branch.
# - If a branch ends up with no commits of its own, exits with code 3 without
#   pushing. Re-invoke with --continue to push it anyway.
#
# Does NOT touch GitHub stack metadata or PR base branches. After a run that
# changes the shape of the stack, reconcile those separately (see SKILL.md).

set -euo pipefail

GIT_COMMON=$(git rev-parse --git-common-dir 2>/dev/null) || {
  echo "Not in a git repository." >&2
  exit 1
}
GIT_COMMON=$(cd "$GIT_COMMON" && pwd)
STATE="$GIT_COMMON/rebase-stack-state"

worktree_for_branch() {
  # Note: do not `exit` early from awk — under `set -o pipefail`, terminating
  # before `git worktree list` finishes writing gives git SIGPIPE and the
  # pipeline exits 141, killing the script. Consume all input and print the
  # first match instead.
  git worktree list --porcelain | awk -v b="$1" '
    $1 == "worktree" { wt = $2 }
    $1 == "branch"   { if ($2 == "refs/heads/" b && !found) { print wt; found = 1 } }
  '
}

is_merged_pr() {
  local branch=$1
  if command -v gh >/dev/null 2>&1; then
    local state
    state=$(gh pr view "$branch" --json state -q .state 2>/dev/null || true)
    if [[ "$state" == "MERGED" ]]; then
      return 0
    fi
  fi
  git merge-base --is-ancestor "$branch" "origin/$BASE_BRANCH" 2>/dev/null
}

is_ancestor() {
  git -C "$1" merge-base --is-ancestor "$2" "$3" 2>/dev/null
}

# The commit after which BRANCHES[$2] holds only its own commits: its deepest
# current ancestor among the other branches' pre-rebase tips, falling back to
# the fork point from origin/<base>. Derived from ancestry rather than list
# position so a reordered list still excludes the right commits.
old_boundary_for() {
  local wt=$1 self=$2 fallback=$3
  local tip="${OLD_TIPS[$self]}" best=$fallback
  local i cand
  for (( i = 0; i < ${#BRANCHES[@]}; i++ )); do
    (( i == self )) && continue
    cand="${OLD_TIPS[$i]}"
    [[ "$cand" == "$tip" ]] && continue
    is_ancestor "$wt" "$cand" "$tip" || continue
    if is_ancestor "$wt" "$best" "$cand"; then
      best=$cand
    fi
  done
  printf '%s' "$best"
}

label_for_tip() {
  local sha=$1 i
  for (( i = 0; i < ${#BRANCHES[@]}; i++ )); do
    if [[ "${OLD_TIPS[$i]}" == "$sha" ]]; then
      printf '%s' "${BRANCHES[$i]}"
      return
    fi
  done
  printf '%s' "${sha:0:8}"
}

own_commit_count() {
  git -C "$1" rev-list --count "$2..$3"
}

remote_branch_exists() {
  git -C "$1" rev-parse --verify '@{u}' >/dev/null 2>&1
}

update_parent_tracking() {
  local wt=$1 branch=$2 parent_name=$3 parent_sha=$4
  [[ -n "$parent_name" && -n "$parent_sha" ]] || return 0
  git -C "$wt" config "branch.$branch.parent" "$parent_name"
  git -C "$wt" update-ref "refs/parent/$branch" "$parent_sha"
  echo "  parent: $branch → $parent_name (${parent_sha:0:8})"
}

save_state() {
  {
    printf 'BASE_BRANCH=%q\n' "$BASE_BRANCH"
    printf 'INDEX=%s\n' "$INDEX"
    printf 'PARENT_NAME=%q\n' "${PARENT_NAME:-}"
    printf 'PARENT_SHA=%q\n' "${PARENT_SHA:-}"
    printf 'BRANCHES=('
    for b in "${BRANCHES[@]}"; do printf ' %q' "$b"; done
    printf ' )\n'
    printf 'OLD_TIPS=('
    for t in "${OLD_TIPS[@]}"; do printf ' %q' "$t"; done
    printf ' )\n'
  } > "$STATE"
}

in_stack() {
  local b
  for b in "${BRANCHES[@]}"; do [[ "$b" == "$1" ]] && return 0; done
  return 1
}

resolve_base_branch() {
  local bottom=$1 candidate root
  candidate=$(git config "branch.$bottom.parent" 2>/dev/null || true)
  if [[ -n "$candidate" ]] && ! in_stack "$candidate" \
     && git rev-parse --verify "$candidate^{commit}" >/dev/null 2>&1; then
    echo "$candidate"
    return 0
  fi
  root=$(git rev-parse --show-toplevel)
  if [[ -x "$root/bin/base-branch" ]]; then
    if candidate=$("$root/bin/base-branch" 2>/dev/null) && [[ -n "$candidate" ]]; then
      echo "$candidate"
      return 0
    fi
  fi
  echo "Could not determine the base branch. Pass --base <branch>." >&2
  return 1
}

usage() {
  cat <<EOF
Usage:
  $(basename "$0") [--base <branch>] <branch1> [branch2 ...]
                              Start a stacked rebase
                              (any order — reordering is supported)
  $(basename "$0") --continue  Resume after a conflict or an empty-branch stop
  $(basename "$0") --abort     Discard saved state
  $(basename "$0") --status    Show current state
EOF
}

BASE_BRANCH=

# Parse leading --base option for the start command.
if [[ ${1:-} == "--base" ]]; then
  shift
  BASE_BRANCH=${1:?--base requires a value}
  shift
fi

cmd=${1:-}
case "$cmd" in
  ""|-h|--help)
    usage
    exit 0
    ;;
  --abort)
    rm -f "$STATE"
    echo "State cleared."
    exit 0
    ;;
  --status)
    if [[ -f "$STATE" ]]; then cat "$STATE"; else echo "No stacked rebase in progress."; fi
    exit 0
    ;;
  --continue)
    [[ -f "$STATE" ]] || { echo "No stacked rebase in progress." >&2; exit 1; }
    BRANCHES=()
    OLD_TIPS=()
    INDEX=0
    PARENT_NAME=
    PARENT_SHA=
    # shellcheck disable=SC1090
    source "$STATE"
    cur="${BRANCHES[$INDEX]}"
    cur_wt=$(worktree_for_branch "$cur")
    if [[ -n "$cur_wt" ]] && { [[ -d "$cur_wt/.git/rebase-merge" ]] || [[ -d "$cur_wt/.git/rebase-apply" ]]; }; then
      echo "Rebase still in progress in $cur_wt." >&2
      echo "Resolve conflicts and finish (git rebase --continue) before re-running --continue." >&2
      exit 2
    fi
    if [[ -n "$cur_wt" ]]; then
      update_parent_tracking "$cur_wt" "$cur" "$PARENT_NAME" "$PARENT_SHA"
    fi
    if [[ -n "$cur_wt" ]] && remote_branch_exists "$cur_wt"; then
      echo "→ Force-pushing $cur..."
      git -C "$cur_wt" push --force-with-lease
    fi
    INDEX=$((INDEX + 1))
    save_state
    ;;
  --*)
    echo "Unknown flag: $cmd" >&2
    usage >&2
    exit 1
    ;;
  *)
    BRANCHES=("$@")
    OLD_TIPS=()
    INDEX=0
    PARENT_NAME=
    PARENT_SHA=
    if [[ -z "$BASE_BRANCH" ]]; then
      BASE_BRANCH=$(resolve_base_branch "${BRANCHES[0]}") || exit 1
    fi
    git fetch origin
    for b in "${BRANCHES[@]}"; do
      if ! git rev-parse --verify "refs/heads/$b" >/dev/null 2>&1; then
        echo "Branch not found locally: $b" >&2
        exit 1
      fi
      OLD_TIPS+=("$(git rev-parse "$b")")
    done
    save_state
    ;;
esac

while (( INDEX < ${#BRANCHES[@]} )); do
  branch="${BRANCHES[$INDEX]}"
  wt=$(worktree_for_branch "$branch")
  if [[ -z "$wt" ]]; then
    echo "Branch '$branch' is not checked out in any worktree." >&2
    echo "Create a worktree for it and re-run --continue." >&2
    save_state
    exit 1
  fi

  base_fork=$(git -C "$wt" merge-base "${OLD_TIPS[$INDEX]}" "origin/$BASE_BRANCH")
  old_base=$(old_boundary_for "$wt" "$INDEX" "$base_fork")

  if (( INDEX == 0 )); then
    new_base_ref="origin/$BASE_BRANCH"
    PARENT_NAME="$BASE_BRANCH"
  else
    prev="${BRANCHES[$((INDEX - 1))]}"
    if is_merged_pr "$prev"; then
      new_base_ref="origin/$BASE_BRANCH"
      PARENT_NAME="$BASE_BRANCH"
    else
      PARENT_NAME="$prev"
      prev_wt=$(worktree_for_branch "$prev")
      if [[ -z "$prev_wt" ]]; then
        echo "Previous branch '$prev' has no worktree; cannot resolve its rebased tip." >&2
        save_state
        exit 1
      fi
      new_base_ref=$(git -C "$prev_wt" rev-parse "$prev")
    fi
  fi

  if is_merged_pr "$branch"; then
    echo "✓ $branch is already merged — skipping."
    INDEX=$((INDEX + 1))
    save_state
    continue
  fi

  new_base_sha=$(git -C "$wt" rev-parse "$new_base_ref")
  PARENT_SHA="$new_base_sha"
  branch_base=$(git -C "$wt" merge-base "$branch" "$new_base_sha")
  if [[ "$old_base" == "$base_fork" ]]; then
    old_parent_label="$BASE_BRANCH"
  else
    old_parent_label=$(label_for_tip "$old_base")
  fi
  before_count=$(own_commit_count "$wt" "$old_base" "${OLD_TIPS[$INDEX]}")

  if [[ "$old_parent_label" != "$PARENT_NAME" ]]; then
    echo "↻ $branch moves: $old_parent_label → $PARENT_NAME ($before_count own commit(s))"
  fi

  if [[ "$branch_base" == "$new_base_sha" && "$old_base" == "$new_base_sha" ]]; then
    echo "✓ $branch is already up to date with $new_base_ref."
  else
    echo "→ Rebasing $branch onto $new_base_ref (excluding ${old_base:0:8}..) in $wt"
    if ! git -C "$wt" rebase --onto "$new_base_sha" "$old_base" "$branch"; then
      echo
      echo "✗ Conflicts in $branch"
      echo "  Worktree: $wt"
      echo "  1. Resolve conflicts and 'git rebase --continue' until done."
      echo "  2. Run: $(basename "$0") --continue"
      save_state
      exit 2
    fi
  fi

  after_count=$(own_commit_count "$wt" "$new_base_sha" "$branch")
  if (( before_count > 0 && after_count == 0 )); then
    echo
    echo "✗ $branch has no commits of its own after rebasing — all $before_count were"
    echo "  already present in $PARENT_NAME. Its PR would have an empty diff."
    echo "  Nothing has been pushed. Pre-rebase tip: ${OLD_TIPS[$INDEX]}"
    echo "  Worktree: $wt"
    echo "  If this is wrong, restore with:"
    echo "    git -C $wt checkout -B $branch ${OLD_TIPS[$INDEX]}"
    echo "  If it is expected (the branch is genuinely subsumed), run:"
    echo "    $(basename "$0") --continue"
    save_state
    exit 3
  fi

  update_parent_tracking "$wt" "$branch" "$PARENT_NAME" "$PARENT_SHA"

  if remote_branch_exists "$wt"; then
    echo "→ Force-pushing $branch..."
    git -C "$wt" push --force-with-lease
  else
    echo "  (no upstream for $branch — skipping push)"
  fi

  INDEX=$((INDEX + 1))
  save_state
done

rm -f "$STATE"
echo
echo "✅ Stacked rebase complete."
