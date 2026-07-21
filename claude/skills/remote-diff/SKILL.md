---
name: remote-diff
description: Compare local branch changes against the remote branch to detect rebase/merge mistakes.
user-invocable-only: true
allowed-tools: Bash, Read, Glob, Grep, Agent
argument-hint: [base-branch]
---

# Remote Diff

Compare local branch changes against the remote branch to detect rebase/merge mistakes.

## Step 1: Determine base branch

Determine the base branch in this order:
1. Use `$ARGUMENTS` if the user specifies a branch
2. Use the tracked parent from `git config branch.$(git branch --show-current).parent`, if set and it still resolves to a commit
3. Use `bin/base-branch` if the script exists and is executable
4. Fall back to `develop`

## Step 2: Check prerequisites

Verify the upstream tracking branch exists:
```bash
git rev-parse --verify @{u}
```

If this fails, report that there's no remote branch to compare against and stop. The user needs to push their branch first.

## Step 3: Fast-path — compare net changes with patch-id

Fetch the latest remote refs, then reduce each branch's net change (relative to its base) to a single normalized hash and compare:

```bash
git fetch origin

local_id=$(git diff -b --unified=0 <base-branch>...HEAD | git patch-id --stable | awk '{print $1}')
remote_id=$(git diff -b --unified=0 origin/<base-branch>...@{u} | git patch-id --stable | awk '{print $1}')
```

If `local_id` equals `remote_id` (including both being empty, meaning neither branch changed anything), the local and remote branches make identical net changes relative to the base. Report: **Clean rebase — no issues detected.** and stop — no tmp files are created, so no cleanup is needed.

`patch-id --stable` ignores line numbers, hunk headers, and file ordering, and `-b` ignores whitespace changes — so a rebase that adapted your change to overlapping base edits can still match here. A rebase that changed only whitespace would also report clean; this matches the original diff's `-b` behavior.

If the hashes differ, fall through to Step 4 for the detailed comparison that localizes what changed.

## Step 4: Generate and compare full diffs

Generate both diffs with zero context lines and ignoring whitespace changes, strip metadata lines, then compare:

```bash
mkdir -p tmp

git diff -b --unified=0 <base-branch>...HEAD > tmp/local_branch_diff.patch
git diff -b --unified=0 origin/<base-branch>...@{u} > tmp/remote_branch_diff.patch

grep -v -E '^(index |@@ |diff --git)' tmp/local_branch_diff.patch > tmp/local_stripped.patch
grep -v -E '^(index |@@ |diff --git)' tmp/remote_branch_diff.patch > tmp/remote_stripped.patch

diff tmp/local_stripped.patch tmp/remote_stripped.patch > tmp/diff_comparison.patch || true
```

## Step 5: Analyze results

Read `tmp/diff_comparison.patch`.

If it's empty, report: **Clean rebase — no issues detected.** The local and remote branches make identical code changes relative to the base branch.

If there are differences, read the relevant source files for context and report:

### Interpreting differences

Any difference warrants review. Read the source files to assess each one.

Signs of trouble:
- A `+` line present in the remote diff but missing from local → an **addition was lost** during rebase
- A `-` line present in the remote diff but missing from local → a **deletion was lost**, meaning removed code came back
- Lines present only in the local diff could be conflict resolution or accidental — verify by reading the code

### Report format

For each difference:
- **What changed** — which file and what code differs
- **Remote version** — what the remote branch had
- **Local version** — what the local branch has
- **Assessment** — whether this looks intentional (e.g., correct conflict resolution adapting to renamed code) or suspicious (e.g., lost code, accidental reversion, duplicated changes)

### Summary
- Overall assessment: clean rebase or needs attention
- Any lost or accidentally reverted changes
- Any suspicious conflict resolutions

## Step 6: Clean up

```bash
rm -f tmp/local_branch_diff.patch tmp/remote_branch_diff.patch tmp/local_stripped.patch tmp/remote_stripped.patch tmp/diff_comparison.patch
```
