---
name: gfix
description: Amend a commit further back in the history by staging changes and using gfix to create a fixup commit and auto-rebase.
allowed-tools: Bash, Read, Glob, Grep, Edit, Write, Agent, AskUserQuestion
argument-hint: <instructions>
---

# gfix — Amend a Past Commit

Use the `gfix` shell command to fold staged changes into a commit that is not the most recent. This is the preferred way to amend historical commits in this repo.

## How gfix works

Source: `~/code/dotfiles/plugins/git.zsh` (the `gfix` function)

`gfix <commit-sha>` does the following:
1. Guards against running during an in-progress git operation (rebase, merge, cherry-pick, etc.)
2. Stashes any unstaged changes (preserving the index)
3. Creates a `git commit --fixup <commit-sha>` from whatever is currently staged
4. Runs `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <commit-sha>^` to automatically squash the fixup into the target commit
5. Restores any stashed unstaged changes

## When to use gfix

Use gfix when you need to amend a commit that is **not** the HEAD commit. For example:
- A review comment asks for a change to code introduced 3 commits ago
- You notice a typo or bug in an earlier commit while working on something else
- You want to keep a clean, logical commit history where each commit is self-contained

If you only need to amend the most recent commit, use `git commit --amend` instead.

## Steps

1. **Determine the safe range** — The target commit must be within the current branch's own commits, not on or before the base branch. Use `detect_base_branch` to find the base branch. As a last resort, ask the user.

   The target commit **must** appear in `git log --oneline <base-branch>..HEAD`. If it does not, **stop and tell the user** — rewriting shared history would cause problems.

2. **Identify the target commit** — Use `$ARGUMENTS` to understand what the user wants fixed. List the safe commits with `git log --oneline <base-branch>..HEAD` and examine their diffs to find the commit that introduced the code the user wants changed.

3. **Make and stage the changes** — Edit the files, then `git add` only the files that belong to the target commit.

4. **Run gfix** — Pass the target commit SHA:
   ```bash
   gfix <commit-sha>
   ```

5. **Handle rebase conflicts** — If the rebase hits conflicts:
   - Read the conflicting files and resolve them
   - `git add` the resolved files
   - `git rebase --continue`
   - Repeat until the rebase finishes

6. **Verify** — Run `git log --oneline -10` to confirm the history looks correct. If relevant tests exist, run them.
