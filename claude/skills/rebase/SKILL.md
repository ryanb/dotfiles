---
name: rebase
description: Interactive rebase onto a base branch, resolving conflicts along the way and verifying tests pass. Compares against remote when done.
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep, Agent, Skill, AskUserQuestion
argument-hint: [base-branch]
---

# Rebase

Rebase the current branch onto a base branch, resolving conflicts and verifying tests along the way.

## Step 1: Determine base branch

Determine the base branch in this order:
1. Use `$ARGUMENTS` if the user specifies a branch
2. Use `bin/base-branch` if the script exists and is executable
3. Ask the user which branch to rebase onto

## Step 2: Start the rebase

Fetch latest and begin the rebase:

```bash
git fetch origin
git rebase origin/<base-branch>
```

If the rebase completes with no conflicts, skip to Step 6.

## Step 3: Resolve conflicts

1. Identify the conflicting files with `git diff --name-only --diff-filter=U`
2. Read each conflicting file and understand both sides of the conflict
3. Resolve the conflict by taking both sides into account — don't blindly pick one side. Understand the intent of each change and produce a result that incorporates both correctly.
4. Stage the resolved files with `git add`

If a conflict is ambiguous and you can't confidently determine the correct resolution, ask the user.

## Step 4: Run related tests

Run the tests related to the files that had conflicts. If tests fail due to the conflict resolution, fix them before proceeding.

If tests fail but seem **unrelated** to the rebase, verify by stashing and testing:

```bash
git stash
# run tests again
git stash pop
```

- If tests also fail without your changes, the failures are pre-existing. Note this for the user and continue.
- If tests only fail with your changes, the rebase introduced the problem. Investigate and fix.

If you are unable to resolve test failures, let the user know what's broken and what you tried.

## Step 5: Continue the rebase

```bash
git rebase --continue
```

If there are more conflicts, go back to Step 3. Repeat until the rebase is complete.

## Step 6: Check remote and compare

Check if a remote tracking branch exists:

```bash
git rev-parse --verify @{u} 2>/dev/null
```

If a remote branch exists, run the `/remote-diff` skill to compare the rebase result against the remote and flag any potential issues.

If no remote branch exists, skip this step and report that the rebase is complete.
