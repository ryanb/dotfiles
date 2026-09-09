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
  local branch=$1 wt
  # Note: do not `exit` early from awk — under `set -o pipefail`, terminating
  # before `git worktree list` finishes writing gives git SIGPIPE and the
  # pipeline exits 141, killing the script. Consume all input and print the
  # first match instead.
  wt=$(git worktree list --porcelain | awk -v b="$branch" '
    $1 == "worktree" { wt = $2 }
    $1 == "branch"   { if ($2 == "refs/heads/" b && !found) { print wt; found = 1 } }
  ')
  if [[ -z "$wt" ]]; then
    # A worktree paused mid-rebase has a detached HEAD, so `git worktree list`
    # never names the branch it is rebasing.
    wt=$(rebasing_worktree_for_branch "$branch")
  fi
  printf '%s' "$wt"
}

rebasing_worktree_for_branch() {
  local branch=$1 wt d
  for wt in $(git worktree list --porcelain | awk '$1 == "worktree" { print $2 }'); do
    [[ -d "$wt" ]] || continue
    for d in rebase-merge rebase-apply; do
      d=$(git -C "$wt" rev-parse --git-path "$d")
      if [[ -f "$d/head-name" ]] && [[ "$(cat "$d/head-name")" == "refs/heads/$branch" ]]; then
        printf '%s' "$wt"
        return 0
      fi
    done
  done
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

# --git-path because a linked worktree's rebase state lives under the common dir.
rebase_in_progress() {
  local wt=$1 d
  for d in rebase-merge rebase-apply; do
    [[ -d "$(git -C "$wt" rev-parse --git-path "$d")" ]] && return 0
  done
  return 1
}

is_ancestor() {
  git -C "$1" merge-base --is-ancestor "$2" "$3" 2>/dev/null
}

# Boundary after which BRANCHES[$2] holds only its own commits (see SKILL.md
# Step 3). Sets globals so the caller doesn't lose the label to a subshell.
old_boundary_for() {
  local wt=$1 self=$2 fallback=$3
  local tip="${OLD_TIPS[$self]}" best=$fallback
  local i cand mb tracked
  OLD_BOUNDARY_BRANCH=
  tracked=$(git -C "$wt" config "branch.${BRANCHES[$self]}.parent" 2>/dev/null || true)
  for (( i = 0; i < ${#BRANCHES[@]}; i++ )); do
    (( i == self )) && continue
    cand="${OLD_TIPS[$i]}"
    [[ "$cand" == "$tip" ]] && continue
    # Merge-base, not $cand itself: a branch usually forked from an older commit
    # of its parent, so the parent's tip is no ancestor of it.
    mb=$(git -C "$wt" merge-base "$cand" "$tip" 2>/dev/null) || continue
    # A branch containing $tip excludes nothing of self's own work.
    [[ "$mb" == "$tip" || "$mb" == "$fallback" ]] && continue
    if [[ "$mb" != "$cand" ]]; then
      # Diverged: ancestry can't tell an advanced parent from an early-forked child.
      [[ "${BRANCHES[$i]}" == "$tracked" ]] || (( i < self )) || continue
    fi
    if is_ancestor "$wt" "$best" "$mb"; then
      best=$mb
      OLD_BOUNDARY_BRANCH="${BRANCHES[$i]}"
    fi
  done
  OLD_BOUNDARY=$best
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
  $(basename "$0") --abort     Abort the paused rebase and discard saved state
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
    if [[ -f "$STATE" ]]; then
      BRANCHES=()
      INDEX=0
      # shellcheck disable=SC1090
      source "$STATE"
      abort_wt=$(worktree_for_branch "${BRANCHES[$INDEX]}")
      if [[ -n "$abort_wt" ]] && rebase_in_progress "$abort_wt"; then
        echo "→ Aborting the in-progress rebase of ${BRANCHES[$INDEX]} in $abort_wt..."
        git -C "$abort_wt" rebase --abort
      fi
    fi
    rm -f "$STATE"
    echo "State cleared. Rebases already completed in this run are not undone."
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
    if [[ -n "$cur_wt" ]] && rebase_in_progress "$cur_wt"; then
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
  old_boundary_for "$wt" "$INDEX" "$base_fork"
  old_base=$OLD_BOUNDARY

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
  old_parent_label=${OLD_BOUNDARY_BRANCH:-$BASE_BRANCH}
  before_count=$(own_commit_count "$wt" "$old_base" "${OLD_TIPS[$INDEX]}")
  shared_count=$(own_commit_count "$wt" "$branch_base" "${OLD_TIPS[$INDEX]}")
  if (( before_count > shared_count )) && [[ "${REBASE_STACK_ALLOW_OVERSIZED:-}" != 1 ]]; then
    echo "✗ $branch would replay more commits than it owns relative to $PARENT_NAME." >&2
    echo "  Boundary ${old_base:0:8} ($old_parent_label) gives $before_count commit(s)," >&2
    echo "  but only $shared_count are missing from $PARENT_NAME (fork point ${branch_base:0:8})." >&2
    echo "  Nothing has been pushed. The boundary or the branch order is probably wrong:" >&2
    echo "    git -C $wt log --oneline ${branch_base:0:8}..$branch" >&2
    echo "  Re-run with REBASE_STACK_ALLOW_OVERSIZED=1 to proceed anyway." >&2
    save_state
    exit 4
  fi

  if [[ "$old_parent_label" != "$PARENT_NAME" ]]; then
    echo "↻ $branch moves: $old_parent_label → $PARENT_NAME ($before_count own commit(s))"
  fi

  if [[ "$branch_base" == "$new_base_sha" && "$old_base" == "$new_base_sha" ]]; then
    echo "✓ $branch is already up to date with $new_base_ref."
  else
    echo "→ Rebasing $branch onto $new_base_ref ($before_count own commit(s), excluding ${old_base:0:8}..) in $wt"
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
