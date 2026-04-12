---
name: review-queue
description: Show pull requests that need review, ranked by ease of review. Displays PRs as clickable links with line counts, grouped as a dependency tree when PRs build on each other.
user-invocable-only: true
allowed-tools: Bash, Read
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

The line counts exclude test files, spec files, docs, and lock files.
