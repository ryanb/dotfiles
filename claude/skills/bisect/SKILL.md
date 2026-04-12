---
name: bisect
description: Git bisect to find the first bad commit by running a test command.
user-invocable-only: true
allowed-tools: Bash, Read, Glob, Grep, AskUserQuestion
argument-hint: <instructions on what command to run to test each commit>
---

# bisect — Find the First Bad Commit

Use `git bisect` to binary-search through commit history and find the first commit that introduced a failure.

## Step 1: Ensure clean working tree

Check that there are no staged or unstaged changes. If there are, **stop and tell the user** they need a clean working tree before bisecting, since git bisect checks out older commits.

```bash
git status --porcelain
```

If the output is non-empty, stop and ask the user to commit or stash their changes first.

## Step 2: Determine the test command

Use `$ARGUMENTS` to understand what the user wants to test. This should describe a command or check that fails on the current commit. Determine the exact shell command to run.

## Step 3: Verify the current commit is bad

Run the test command on the current commit (HEAD). If it **passes** (exits 0), stop and tell the user — the current commit doesn't exhibit the failure, so there's nothing to bisect.

## Step 4: Find a good commit

Start searching backwards from HEAD in steps of 10 commits to find a commit where the test passes.

```bash
git stash --include-untracked -q 2>/dev/null; true
git checkout HEAD~10 --quiet
```

Run the test command. If it still fails, go back another 10 commits (`HEAD~10` from the current position). Repeat until either:
- A passing commit is found, or
- You've gone back 100+ commits without finding a passing one — stop and ask the user for guidance (maybe a known-good commit SHA).

Once a good commit is found, note its SHA.

## Step 5: Run git bisect

Return to the original branch first, then start bisecting:

```bash
git checkout - --quiet
git bisect start
git bisect bad
git bisect good <good-commit-sha>
```

Git will check out a middle commit. Run the test command on it:
- If the test **fails** → `git bisect bad`
- If the test **passes** → `git bisect good`

Repeat until git reports the first bad commit.

## Step 6: Record the result and clean up

Save the first bad commit SHA and message. Then reset:

```bash
git bisect reset
```

## Step 7: Report

Tell the user the first bad commit, including:
- The commit SHA
- The commit message
- The commit author and date
- A brief `git show --stat` of the commit so they can see which files changed
