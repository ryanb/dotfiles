---
name: review-queue
description: Show pull requests that need review, ranked by ease of review. Displays PRs as clickable links with line counts, grouped as a dependency tree when PRs build on each other.
user-invocable-only: true
allowed-tools: Bash, Read
model: sonnet
---

# Review Queue

Show open pull requests that need review, ranked by how easy they are to review.

Run the pipeline:

```bash
~/.claude/skills/review-queue/pr-data.sh | ~/.claude/skills/review-queue/format-queue.sh
```

If this fails (e.g. not in a git repo, or `gh` not authenticated), report the error and stop.

The output is a pre-formatted ranked list. If the first line starts with `PREFERENCES:`, apply those instructions to the list — reorder, exclude, group, or highlight PRs as described. Re-number the final list sequentially. Preserve the same line format: `N\. [title](url) (author) [+N, -N]` with backtick-wrapped labels and tree indentation using `└─` / `├─` / `│`.

If there is no `PREFERENCES:` line, output the list as-is with no additional commentary.

A PR labeled `other base` is stacked on top of another branch, not the main branch. Never include an `other base` PR on its own — only show it nested under the PR for its base branch, as part of that stack. If applying preferences would exclude the base PR (or the base PR isn't in the queue), drop the `other base` PR too, since it can't be reviewed in isolation. Never re-parent an `other base` PR to a different branch to keep it in the list.

The line counts exclude test files, spec files, docs, and lock files.
