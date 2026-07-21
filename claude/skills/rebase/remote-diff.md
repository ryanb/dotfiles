# Remote diff comparison

Procedure for comparing the rebased branch against its remote to detect rebase/merge
mistakes (lost additions, reverted deletions, accidental duplications). Referenced by the
rebase skill's final step. `<base-branch>` below is the branch you just rebased onto — use
the freshly fetched `origin/<base-branch>` ref for both sides.

## Step 1: Fast-path — compare net changes with patch-id

Reduce each branch's net change (relative to the base) to a single normalized hash and compare:

```bash
local_id=$(git diff -b --unified=0 origin/<base-branch>...HEAD | git patch-id --stable | awk '{print $1}')
remote_id=$(git diff -b --unified=0 origin/<base-branch>...@{u} | git patch-id --stable | awk '{print $1}')
```

If `local_id` equals `remote_id` (including both being empty, meaning neither branch changed
anything), the local and remote branches make identical net changes relative to the base.
Report **Clean rebase — no issues detected.** and stop — no tmp files are created, so no
cleanup is needed.

`patch-id --stable` ignores line numbers, hunk headers, and file ordering, and `-b` ignores
whitespace changes — so a rebase that adapted your change to overlapping base edits can still
match here. A rebase that changed only whitespace also reports clean; this matches the diff's
`-b` behavior.

If the hashes differ, continue to Step 2 for the detailed comparison that localizes what changed.

## Step 2: Detailed comparison (only when hashes differ)

Generate both diffs with zero context lines and ignoring whitespace changes, strip metadata
lines, then compare:

```bash
mkdir -p tmp

git diff -b --unified=0 origin/<base-branch>...HEAD > tmp/local_branch_diff.patch
git diff -b --unified=0 origin/<base-branch>...@{u} > tmp/remote_branch_diff.patch

grep -v -E '^(index |@@ |diff --git)' tmp/local_branch_diff.patch > tmp/local_stripped.patch
grep -v -E '^(index |@@ |diff --git)' tmp/remote_branch_diff.patch > tmp/remote_stripped.patch

diff tmp/local_stripped.patch tmp/remote_stripped.patch > tmp/diff_comparison.patch || true
```

## Step 3: Analyze results

Read `tmp/diff_comparison.patch`, then read the relevant source files for context and report.

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

## Step 4: Clean up

```bash
rm -f tmp/local_branch_diff.patch tmp/remote_branch_diff.patch tmp/local_stripped.patch tmp/remote_stripped.patch tmp/diff_comparison.patch
```
