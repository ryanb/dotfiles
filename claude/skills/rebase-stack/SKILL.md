---
name: rebase-stack
description: Rebase or reorder a stack of dependent PR branches — first onto the base branch, each subsequent branch onto the previous (rebased) one — dropping any commits already in the parent. The list may reorder the existing chain. Force-pushes with lease, handles merged-base PRs, and handles branches without remotes. Each branch must already be checked out in a worktree.
disable-model-invocation: true
user-invocable-only: true
allowed-tools: Bash, Read, Glob, Grep, Skill, Agent
argument-hint: [--base <branch>] <branch1> <branch2> [branch3 ...]
---

# Rebase Stack

Rebase a chain of dependent branches in order. The first branch is rebased onto the base branch; each subsequent branch is rebased onto the previous (now-rebased) branch, keeping only that branch's own commits so nothing is duplicated.

The list you pass **defines the target order** and does not have to match the current chain — reordering is supported. Each branch's exclusion boundary is derived from its own current ancestry, so moving a branch up or down the stack replays only its own commits. See [Reordering](#reordering-changing-the-order-of-the-stack) for the extra steps a reorder needs.

Two shell scripts shipped with this skill do the mechanical work: `rebase-stack.sh` rewrites the local branches, and `relink-stack.sh` reconciles the GitHub stack and PR bases afterwards when the order changed. This skill calls them and, when the rebase pauses on a conflict, delegates the resolution to a sub-agent so the main context stays small.

## Step 1: Determine the stack

Get the ordered branch list from `$ARGUMENTS`. The first branch is the bottom of the stack (closest to the base branch); each subsequent branch builds on the previous one. This is the **target** order — if it differs from the current chain, that's a reorder and the run will rewrite the stack's shape.

If no branches are supplied in `$ARGUMENTS`, infer the stack from the current branch.

### Base branch

Determine the base branch in this order:
1. Use `--base <branch>` if the user specifies one (it goes before the branch list)
2. Use the bottom branch's tracked parent from `git config branch.<bottom>.parent`, if set, still resolving to a commit, and not itself one of the stack branches
3. Use `bin/base-branch` if the script exists and is executable
4. Ask the user which branch the stack sits on

Pass the result to both scripts as `--base <branch>` so they don't have to re-derive it.

### Preferred: ask `gh stack`

The repo may already track the chain as a GitHub stack (the `gh stack` extension). Ask it first:

```bash
gh stack view --json
```

- **Success** — the current branch belongs to a stack. The JSON lists the stack's branches; read it and take the branches in order **bottom → top** (bottom = closest to the trunk/base branch). Field names vary by `gh-stack` version, so inspect the JSON rather than assuming keys — expect a branch name, a PR number, and a merged/open status per entry. If the output includes the trunk/base branch itself as an entry, drop it: it's the rebase base, not part of the stack.
- **`current branch "X" is not part of a stack`** — fall back to the PR-walk below.
- **`gh: unknown command "stack"`** (extension not installed) — fall back to the PR-walk below.

If `gh stack view` reports the trunk and the user passed `--base`, prefer the user's `--base`.

### Fallback: walk GitHub PR base/head refs

1. Get the current branch: `git rev-parse --abbrev-ref HEAD`.
2. Fetch all open PRs in one call:

   ```bash
   gh pr list --state open --json number,headRefName,baseRefName --limit 200
   ```

3. **Walk down to the bottom of the stack.** Starting from the current branch, look up the PR whose `headRefName` matches it. If that PR's `baseRefName` is not the base branch, set current = `baseRefName` and repeat. Stop when `baseRefName` == base — that branch is the bottom.

   If the current branch has no open PR, or no PR chain leads back to the base, ask the user for the stack rather than guessing.

4. **Walk up from the bottom.** Find the PR whose `baseRefName` equals the bottom branch — its `headRefName` is the next branch up. Repeat from each new branch until no PR has it as a base. That ordered list (bottom → top) is the stack.

   If a branch is the base of more than one open PR, the stack forks. Stop, show the user the candidate branches, and ask which one to follow.

### Confirm

Show the inferred stack to the user with PR numbers — and note whether it came from `gh stack` or the PR walk — before running the rebase, so they can confirm or correct it.

If the requested order differs from the current chain, say so explicitly: list which branches move and what their new parents will be, and confirm before running. A reorder force-pushes a rewritten history to open PRs.

## Step 2: Pre-flight — ensure each branch is fetched and in a worktree

For each branch in the stack, in order:

1. **Fetch from origin** so we have the latest ref:

   ```bash
   git fetch origin <branch>
   ```

   If the fetch fails (no such ref on origin) and there's no local branch either, ask the user — the branch may be misspelled or only exist on a fork.

2. **Ensure a local branch exists.** If `git rev-parse --verify refs/heads/<branch>` fails, create one tracking the remote:

   ```bash
   git branch <branch> origin/<branch>
   ```

3. **Ensure the branch is checked out in a worktree.** Check `git worktree list --porcelain` for `branch refs/heads/<branch>`.

   After all branches have been fetched and have local refs, collect the list of branches that still need a worktree. If the list is non-empty, ask the user directly (in a plain message — do not use `AskUserQuestion`) before creating them. Wait for the user to confirm before proceeding.

   How to create them depends on the project:

   - **`bin/worktree` exists and is executable** — use it, one branch at a time. If the project provides it, it likely sets up an isolated environment (DB, ports, env) and can take a few minutes per branch, so say that when asking, and don't run several in parallel against the same source data. Prefer it over `git worktree add` so tests can run with the full setup.
   - **Otherwise** — fall back to `git worktree add <path> <branch>`, and tell the user the worktrees have no project environment set up, so tests may not be runnable in them.

Once every branch has both a local ref and a worktree, proceed.

## Step 3: Run the script

```bash
~/.claude/skills/rebase-stack/rebase-stack.sh --base <base-branch> <branch1> <branch2> [...]
```

The script will:

- Fetch `origin`.
- Record each branch's pre-rebase tip (so we can correctly exclude old parent commits).
- For each branch in order: locate its worktree, compute `git rebase --onto <new-base> <old-base> <branch>`, and run it via `git -C <worktree>` (no `cd` required). `<old-base>` is the branch's **deepest current ancestor** among the other branches' pre-rebase tips, falling back to its fork point from `origin/<base>` — derived from ancestry, not from list position, which is what makes a reordered list safe.
- Print `↻ <branch> moves: <old parent> → <new parent>` for any branch whose parent changes.
- Stop before pushing if a branch ends up with **no commits of its own** (exit `3`) — the symptom of its commits having been absorbed into another branch.
- Skip a branch entirely if its PR is already merged (detected via `gh pr view --json state`, falling back to `git merge-base --is-ancestor`). The next branch in the stack is then rebased onto `origin/<base>` directly while still excluding the merged branch's old commits.
- Set parent tracking after each branch rebase, matching Step 6 of the `rebase` skill: set `branch.<branch>.parent` to the branch it was rebased onto (the base branch for the bottom branch, the previous stack branch otherwise) and point `refs/parent/<branch>` at that commit. The config and ref are created if they don't already exist.
- Force-push with `--force-with-lease` after each branch rebase, but only if the branch has an upstream. Branches without an upstream are rebased but left unpushed.
- Persist progress in `$(git rev-parse --git-common-dir)/rebase-stack-state` so it survives conflict pauses.

Exit codes:
- `0` — done.
- `1` — fatal error (e.g. a branch isn't in any worktree).
- `2` — conflicts. State saved; resume after resolving.
- `3` — a branch has no commits of its own. Nothing pushed; state saved. See [Empty branches](#empty-branches-exit-3).

## Step 4: Resolve conflicts (loop)

If the script exited with code `2`, read its output to find the conflicting branch and worktree path. **Delegate the resolution to a sub-agent** (via the `Agent` tool) so the main context stays small — don't read the conflicting files yourself. Spawn one sub-agent per conflicting branch with a prompt like the template below, filling in the branch name and worktree path:

> Resolve the git rebase conflicts in the worktree at `<worktree>` (branch `<branch>`), then drive the rebase to completion. Do **not** force-push and do **not** run any `rebase-stack.sh` command — stop once the rebase is clean.
>
> Loop until `git -C <worktree> status` shows no rebase in progress:
> 1. List conflicting files: `git -C <worktree> diff --name-only --diff-filter=U`.
> 2. Read each file and resolve the conflict, taking both sides into account — don't blindly pick one side. Understand the intent of each change and produce a result that incorporates both correctly.
> 3. Stage resolved files: `git -C <worktree> add <file>`.
> 4. Run tests related to the resolved files inside the worktree using a subshell so the parent shell's cwd never changes: `(cd <worktree> && <test command>)`. If tests fail due to your resolution, fix it. If failures look unrelated, verify by stashing: `(cd <worktree> && git stash && <test command>; status=$?; git stash pop; exit $status)` — failures present without your changes are pre-existing (note them and continue); failures only with your changes mean your resolution introduced the problem (investigate and fix).
> 5. Continue the rebase: `git -C <worktree> rebase --continue`. If more conflicts surface, repeat from step 1.
>
> When the rebase is complete, report back a concise summary: each file you resolved with a one-line note on how, any test results, and anything ambiguous you had to make a judgement call on.

When the sub-agent reports back, **retain its summary** — you'll need it for the Step 5 report. If it flagged an ambiguous conflict it had to guess at, surface that to the user now. Otherwise, resume the script:

```bash
~/.claude/skills/rebase-stack/rebase-stack.sh --continue
```

`--continue` force-pushes the just-finished branch (if it has an upstream), then proceeds to the next branch in the stack. If that branch also conflicts, the script exits `2` again — spawn a fresh sub-agent for it and repeat.

Repeat until the script prints `✅ Stacked rebase complete`. If the script exits `3` instead, don't resolve anything — go to [Empty branches](#empty-branches-exit-3).

## Step 5: Reconcile GitHub stack metadata (reorders only)

`rebase-stack.sh` rewrites local branches only. If the run changed the stack's **order**, the PR bases and the GitHub stack are now stale and must be reconciled — otherwise the PRs show wrong bases and wrong diffs. If the order didn't change, skip this step.

`relink-stack.sh` (shipped with this skill) does it. Pass the same branch list, bottom → top:

```bash
~/.claude/skills/rebase-stack/relink-stack.sh --base <base-branch> <branch-bottom> ... <branch-top>
```

It is a **dry run by default**: it prints each PR, the base it should have, and whether that's a change, then exits without touching anything. Show that plan to the user and confirm the `CHANGE` lines are the branches they expect to move. Then execute:

```bash
~/.claude/skills/rebase-stack/relink-stack.sh --base <base-branch> --yes <branch-bottom> ... <branch-top>
```

It unstacks the affected stack(s), runs `gh stack link --base <base> <branches>`, then re-reads `gh pr list` and verifies every base matches the target order, exiting non-zero if any don't.

### How unstack and link actually behave

Measured against a real 12-PR stack, not inferred from the help text:

- **`gh stack link` does reorder.** Its help says *"existing PRs are never removed,"* which reads as additive-only, but in practice it created a **new stack** containing all 12 PRs in the given order, migrated them off the old stack, and updated the one PR whose base needed changing. The old stack number disappeared. So `link` alone is usually enough.
- **`gh stack unstack` can no-op while exiting 0.** It printed `⚠ Some pull requests are queued for merge or have auto-merge enabled and remain stacked on GitHub` / `The stack was left in place`, and returned success. Never assume the stack was dissolved because the command "worked" — a merged PR still sitting in the stack is enough to trigger this.
- **Always trust the script's verification output**, not the intermediate command output. It re-reads `gh pr list` at the end and checks every base.

`gh pr edit <pr> --base <branch>` is not an alternative for a stacked PR: it fails with `Cannot change the base branch because the pull request is part of a stack`.

### Finding the stack number for `--unstack`

There is no `gh stack list`, and **the stack number appears only in `gh stack view --short` (`Stack #8899`) — `--json` omits it**, exposing only `trunk`, `currentBranch`, and `branches`. The script parses `--short` for this. It still can't see a stack that isn't tracked locally, so when the plan says `Stacks to dissolve first: none detected` but the PRs *are* stacked, import and read it:

```bash
(cd <worktree> && gh stack checkout <pr-number> && gh stack view --short)
```

Run that from the branch's **own** worktree. It prints `failed to checkout ... already used by worktree` for a branch checked out elsewhere; the import still succeeds and the view works. Then re-run with `--unstack <stack-number>` (comma-separate several). `gh stack checkout` also reveals the true membership — a stack that looks like 10 PRs from one worktree can be 12 once imported.

If `link` fails *after* an unstack succeeded, the PRs are left unstacked on GitHub. Bases are still set, so re-running the script rebuilds the stack; the script says so in that error path.

Don't plan around `gh stack modify` — an interactive TUI, not drivable by an agent. `gh stack init` creates a *new* stack rather than adjusting one, so it's also wrong here.

## Step 6: Report

Summarize what happened:
- Branches that were rebased and force-pushed.
- Branches whose parent changed, with old → new parent.
- Branches that were skipped because their PR was already merged.
- Branches that were rebased but not pushed (no upstream).
- Any conflicts that were resolved, with a one-line note on the resolution (drawn from the sub-agents' reported summaries in Step 4).
- Whether GitHub stack metadata was reconciled (Step 5), and any PR whose base still looks wrong.

## Reordering: changing the order of the stack

To move a branch within the stack, pass the branches in the order you want. Nothing else changes — the exclusion boundaries come from ancestry, so the script replays each branch's own commits onto its new parent.

> **A reorder can destroy the moved branch's PR. Warn the user before starting.**
>
> When a branch moves *down* the stack, the branches that used to be below it end up
> containing it. Force-pushing one of those branches while the moved PR's base still points
> at it makes GitHub see "base contains head" and **auto-close the PR as merged, then delete
> its remote branch** — even though nothing reached the base branch.
>
> Observed: moving branch `A` below four integration branches closed **A's PR** as MERGED the
> instant branch `B` (one of those four) was force-pushed, and deleted `origin/A`. A PR in that state
> **cannot be reopened** (`can't be reopened because it was already merged`), so its number,
> comments, and review history are gone; the only fix is a fresh PR.
>
> To avoid it, repoint the moved PR's base **before** any force-push. That needs the stack
> dissolved first (`gh pr edit --base` is refused for a stacked PR), and GitHub may refuse to
> unstack — see below. When it does, the loss is unavoidable: tell the user up front, then
> recreate the PR afterwards (`gh pr create --base <new parent> --head <branch>`, reusing the
> old title and body, and re-adding labels). No commits are ever at risk — only PR metadata.

Extra care for a reorder:

- **Confirm the new order with the user first** (Step 1). Every moved branch is force-pushed with a rewritten history.
- **Expect conflicts.** A branch moving down the stack loses the context of the branches that used to be below it. Step 4's sub-agent loop handles these; there may be several.
- **Watch the `↻ moves:` lines.** They are the check that the script agrees with your intent. A branch you didn't expect to move signals the list is wrong — abort and re-derive it.
- **Do Step 5.** GitHub stack metadata and PR bases do not follow a reorder on their own; run `relink-stack.sh`.

### Empty branches (exit 3)

Exit `3` means a branch's commits were all already present in its new parent, so it has nothing of its own and its PR would show an empty diff. Nothing was pushed. Almost always this means the branch list was wrong — usually a branch further down absorbed commits that weren't its own.

Stop and investigate rather than pushing through:

1. Inspect the branch: `git -C <worktree> log --oneline <new-parent>..<branch>` (empty) and compare against its pre-rebase tip from `--status`.
2. If it's wrong, restore the branch (`git -C <worktree> checkout -B <branch> <old-tip>` — the script prints the exact command), fix the order, and start over. Any branch already force-pushed in this run needs restoring and re-pushing too.
3. Only if the branch is genuinely subsumed (its work really did land elsewhere) run `--continue`, which pushes it and moves on.

## Limitations

- **`rebase-stack.sh` never updates GitHub stack metadata or PR bases** — `relink-stack.sh` (Step 5) is a separate command, not part of the rebase run.
- **`relink-stack.sh` can't reliably discover stack numbers** on its own (no `gh stack list`), so a reorder often needs `--unstack <n>` supplied by hand.
- **`gh stack unstack` is refused by GitHub** for PRs queued for merge or with auto-merge enabled (a merged PR still in the stack counts), and then leaves the whole stack in place while exiting 0.
- **Neither script can prevent the moved PR being auto-closed as merged** on a downward reorder — see the warning under [Reordering](#reordering-changing-the-order-of-the-stack). Plan to recreate that PR.
- **Every branch must be checked out in its own worktree.** There is no single-worktree mode.
- **No dry run.** The first branch is force-pushed before the last is rebased, so a bad run leaves the stack half-rewritten. Recover with the pre-rebase tips in the state file.
- **`--abort` discards state but undoes no rebases**, and it drops the `OLD_TIPS` you'd need to recover. Read `--status` before aborting.
- **`--continue` always force-pushes `BRANCHES[INDEX]`** before advancing. That's also how you resume mid-stack: point `INDEX` at an already-correct branch so the push is a no-op.
- **A merge in the stack isn't handled.** Branches are assumed to be linear chains of their own commits.

## Recovery

- `~/.claude/skills/rebase-stack/rebase-stack.sh --status` — show saved state, including `OLD_TIPS` (each branch's pre-rebase tip) and `INDEX` (the branch being worked on).
- `~/.claude/skills/rebase-stack/rebase-stack.sh --abort` — discard saved state. Does not undo any rebases already performed.
- To undo a branch: `git -C <worktree> checkout -B <branch> <old-tip>`, taking `<old-tip>` from `OLD_TIPS` or `git -C <worktree> reflog`. Then force-push it if it was already pushed. Prefer `checkout -B` over `reset --hard` — it's equivalent here and survives sandboxes that block `reset --hard`.
- To resume mid-stack after a manual fix, edit `$(git rev-parse --git-common-dir)/rebase-stack-state` so `BRANCHES` and `OLD_TIPS` describe the real current state, set `INDEX` to the last already-correct branch, set `PARENT_NAME`/`PARENT_SHA` for that branch, then run `--continue`.
