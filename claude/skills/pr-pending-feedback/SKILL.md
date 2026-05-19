---
name: pr-pending-feedback
description: Evaluate pending (unsubmitted) review comments on the current branch's PR and, after user confirmation, address each in a separate sub-agent and separate commit.
user-invocable-only: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Agent
---

# pr-pending-feedback — Triage and address pending PR review comments

The goal: look at every comment on the **pending (unsubmitted) review** the current user has drafted on the PR for the current branch, evaluate each one independently, recommend which to address (and which to skip), and — only after the user confirms — dispatch a sub-agent per comment to fix it, one commit per comment.

Pending reviews are private to their author until submitted, so this skill only sees comments authored by the currently authenticated `gh` user.

## Step 1: Find the PR for the current branch

```bash
pr_number=$(gh pr view --json number --jq .number)
pr_url=$(gh pr view --json url --jq .url)
repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
me=$(gh api user --jq .login)
```

If `gh pr view` fails, stop and tell the user there is no open PR for the current branch.

## Step 2: Find the pending review

List reviews on the PR and find one in `PENDING` state authored by the current user:

```bash
gh api "repos/$repo/pulls/$pr_number/reviews" --jq \
  ".[] | select(.state==\"PENDING\" and .user.login==\"$me\") | {id, body, submitted_at, html_url}"
```

If there is no pending review, stop and tell the user there is no pending review on this PR for them. If there are multiple pending reviews (rare), list them and ask which to use.

Capture the `id` as `review_id`.

## Step 3: Fetch the pending review's comments

```bash
gh api "repos/$repo/pulls/$pr_number/reviews/$review_id/comments"
```

Each comment includes `path`, `line` (or `original_line`), `body`, `diff_hunk`, and `html_url`. Also note the pending review's top-level `body` from Step 2 — it may contain general feedback worth addressing too.

## Step 4: Evaluate each comment independently

For each pending comment, read the referenced file(s) at the relevant lines to understand the current code. Then form an independent judgment on:

- **What the comment is asking for** (summarize in one line).
- **Whether it's still applicable** (the code may have changed since the comment was drafted).
- **Recommendation**: `address`, `skip`, or `discuss`.
  - `address` — clearly actionable and worth doing.
  - `skip` — stale, already done, out of scope, or you disagree on reflection (explain briefly).
  - `discuss` — needs user input before acting (ambiguous, subjective, or a design call).
- **One-sentence rationale.**

Since these are the user's own comments, frame skip/discuss recommendations as "you may want to reconsider this" rather than disagreeing with a third party.

Evaluate each comment on its own merits; do not let one comment's recommendation influence another's.

## Step 5: Present triage to the user

Output a compact markdown table or list. For each comment include:

- A short label (e.g. `#1`, `#2`) used for confirmation.
- The file:line (or "general" for the review body).
- A 1-line summary of the ask.
- Your recommendation and rationale.
- A clickable link to the comment.

End with a prompt like:

> Reply with which to address (e.g. "all", "1,3,4", "all except 2"). I'll run one sub-agent per comment and commit each fix separately.

**Stop and wait for the user's reply.** Do not proceed to Step 6 without explicit confirmation.

## Step 6: Address each confirmed comment

For each confirmed comment, dispatch a **separate sub-agent** via the Agent tool. Run them **sequentially**, not in parallel — each creates a commit on the same branch, and parallel edits would conflict.

Prompt for each sub-agent should include:

- The current working directory (per project convention).
- The PR URL and comment URL.
- The file path and line.
- The comment body.
- The diff hunk showing the code in question.
- A clear instruction: "Make the smallest change that addresses this comment. Run the relevant tests. Then create a single git commit with a message summarizing the fix. Do not push. Do not address other feedback."

Example skeleton:

```
Agent({
  subagent_type: "general-purpose",
  description: "Address pending comment #<n>",
  prompt: "Working directory: <cwd>.\n\nAddress this pending PR review comment (drafted by the user themself, not yet submitted):\n\n<comment body>\n\nFile: <path>:<line>\nComment URL: <url>\nPR: <pr_url>\n\nDiff hunk for context:\n<diffHunk>\n\nMake the smallest change that resolves the feedback. Run the relevant tests for the changed file. Create exactly one git commit with a concise message (no ticket prefix — this isn't the first commit of the branch, per the repo's git conventions). Do not push. Do not address any other feedback. Report back with the commit SHA and a one-line summary."
})
```

After each sub-agent returns, verify with `git log --oneline -1` that a new commit landed, then proceed to the next.

If a sub-agent reports it could not address the comment (e.g. tests failed, unclear intent), **stop** and surface the problem to the user before continuing with remaining comments.

## Step 7: Final report

After all sub-agents finish, output a summary:

- List of commits created (SHA + subject), one per addressed comment.
- Any comments skipped per the user's instructions.
- Any comments that failed and need the user's attention.
- A reminder that the pending review is **still pending** on GitHub — addressing the comments locally does not submit or delete the draft.
- Reminder to push commits when ready (do **not** push automatically).

## Step 8: Offer to delete the pending comments

Ask the user whether to delete the addressed pending comments (and/or the pending review itself) now that they've been addressed locally. Phrase it explicitly, e.g.:

> Want me to delete the pending comments I just addressed? I can delete them individually, or delete the whole pending review if nothing's left worth keeping.

**Wait for explicit confirmation.** Do not delete anything without the user saying so.

If the user confirms, delete only the comments they confirmed:

- Delete an individual pending comment:
  ```bash
  gh api -X DELETE "repos/$repo/pulls/comments/<comment_id>"
  ```
- Delete the entire pending review (only if the user asks for this, or if all comments were addressed and the user confirms):
  ```bash
  gh api -X DELETE "repos/$repo/pulls/$pr_number/reviews/$review_id"
  ```

Skip any comments the user chose **not** to address — those should remain pending. If deleting the whole review would discard un-addressed comments, warn the user and confirm again before doing so.

After deletion, report which comments/reviews were deleted.

## Notes

- This skill only operates on pending reviews authored by the current `gh`-authenticated user. Pending reviews by others are not visible via the API.
- Never submit the pending review from this skill — leave submission to the user.
- Only delete pending comments or the pending review after explicit user confirmation in Step 8.
- Never push or force-push.
- Respect the project's git conventions from `CLAUDE.md` (e.g. `Chore:` prefix for non-user-facing changes, no ticket code on subsequent commits, one thing per commit).
