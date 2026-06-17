---
name: pr-pending-feedback
description: Evaluate pending (unsubmitted) review comments on the current branch's PR and, after user confirmation, address each in a separate sub-agent and separate commit.
user-invocable-only: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Agent
---

# pr-pending-feedback — Triage and address pending PR review comments

The goal: look at every comment on the **pending (unsubmitted) review** the current user has drafted on the PR for the current branch, evaluate each one independently, split them into ones that can simply be addressed and ones that need discussion, work through the discussion comments one at a time, and — only after all discussions are resolved and the user confirms — dispatch a sub-agent per comment to fix it, one commit per comment.

These comments are the user's own. **Never recommend skipping a comment.** Every comment either gets addressed directly, or — if there's any ambiguity, subjectivity, design call, or doubt about applicability — gets opened up for discussion so the user can decide. "Skip" is only ever an outcome the user explicitly chooses during discussion, never something this skill proposes on its own.

Pending reviews are private to their author until submitted, so this skill only sees comments authored by the currently authenticated `gh` user.

## Step 1: Find the PR for the current branch

```bash
pr_number=$(gh pr view --json number --jq .number)
pr_url=$(gh pr view --json url --jq .url)
repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
base_branch=$(gh pr view --json baseRefName --jq .baseRefName)
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

For each pending comment, read the referenced file(s) at the relevant lines to understand the current code. Then classify it as exactly one of:

- **`address`** — clearly actionable, unambiguous, and you're confident how to do it. It can be handed straight to a sub-agent without further input.
- **`discuss`** — anything else. If the comment is ambiguous, subjective, a design call, possibly stale/already-done, out of scope, or you have any doubt about whether or how to act on it, it needs the user's input first.

**Never classify a comment as `skip`.** These are the user's own comments — if you think one might not be worth doing, that is itself a reason to `discuss` it, not to skip it. Skipping is only ever a decision the user makes during the discussion in Step 5.

Evaluate each comment on its own merits; do not let one comment's classification influence another's.

**Do not present any triage table or list at this stage.** Do not show the user the full set of comments yet. Move straight on to working through the discussion comments.

## Step 5: Work through discussion comments one at a time

For each comment classified as `discuss`, ask the user about it **one question at a time** — present a single comment, wait for the reply, then move to the next. Do not batch them.

For each discussion comment, present:

- The comment body (quoted) and a clickable link to it.
- The file:line and the **relevant code snippet** for context (the lines the comment refers to — pull from the actual file, falling back to the `diff_hunk` if needed). Always include this so the user has the context in front of them.
- A short framing of what needs deciding.
- A **numbered list of plain-text options** for how to proceed (e.g. `1.` address it a particular way, `2.` address it a different way, `3.` skip it, etc.). Always include skipping as one of the numbered options when it's a sensible choice.
- **Explicitly state which option you recommend** and why, in one sentence.

Per the user's global preference, present the options as a numbered plain-text list. Do **not** use the AskUserQuestion tool — print the question as normal output and end your turn so the user can reply in their own words.

**Stop and wait for the user's reply after each discussion comment** before moving to the next one. Record the resolution for each (address in a specific way, or skip).

If there are no discussion comments, skip straight to Step 6.

## Step 6: Present the consolidated plan

Only **after every discussion comment has been resolved**, present a single consolidated list/table of **all** comments and how each will be handled:

- A short label (e.g. `#1`, `#2`).
- The file:line (or "general" for the review body).
- A 1-line summary of the ask.
- How it will be handled: **address** (with any specifics decided during discussion) or **skip** (per the user's decision in Step 5).
- A clickable link to the comment.

End with a plain-text prompt like:

> This is the plan. Reply to confirm and I'll run one sub-agent per comment to address, committing each fix separately. Let me know if you want to change anything.

**Stop and wait for the user's reply.** Do not proceed to Step 7 without explicit confirmation. Do **not** use the AskUserQuestion tool for this — just print the prompt as normal output and end your turn so the user can reply in their own words.

## Step 7: Address each confirmed comment

For each comment the user confirmed to address (skipped comments are left alone), dispatch a **separate sub-agent** via the Agent tool. Run them **sequentially**, not in parallel — each creates a commit on the same branch, and parallel edits would conflict.

Prompt for each sub-agent should include:

- The current working directory (per project convention).
- The PR URL and comment URL.
- The file path and line.
- The comment body.
- The diff hunk showing the code in question.
- A clear instruction: "Make the smallest change that addresses this comment. Run the relevant tests. Then create a single git commit with a message summarizing the fix. Do not push. Do not address other feedback."
- An instruction to apply the feedback **branch-wide**, not only at the commented location: if the comment articulates a general rule or pattern (e.g. "always use `order.sc_id` instead of `order.id`", "prefer `Foo.bar` over `Foo.baz`", "rename X to Y"), search the entire diff on the current branch for other instances of the same pattern and apply the same change there too. Pass the PR's actual base branch (`$base_branch` from Step 1 — may not be `main`, e.g. for stacked PRs) and tell the sub-agent to use `git diff <base_branch>...HEAD` to scope the search to lines this branch introduced or touched. Do not modify code outside the branch's diff.
- An instruction on **comment discipline**: do not add code comments that explain the change itself or why it was made in response to this review. Only add a comment if it clarifies confusing code, a non-obvious edge case, or genuinely complex behavior for a future reader who has no knowledge of this PR. Do not comment obvious code.

Example skeleton:

```
Agent({
  subagent_type: "general-purpose",
  description: "Address pending comment #<n>",
  prompt: "Working directory: <cwd>.\n\nAddress this pending PR review comment (drafted by the user themself, not yet submitted):\n\n<comment body>\n\nFile: <path>:<line>\nComment URL: <url>\nPR: <pr_url>\n\nDiff hunk for context:\n<diffHunk>\n\nMake the smallest change that resolves the feedback. If the comment expresses a general rule or pattern (not just a one-off fix at this line), also apply it to any other matching instances within this branch's diff against its base branch (use `git diff <base_branch>...HEAD` with the PR's actual base branch substituted in to find the touched code). Do not modify code outside this branch's diff. Do not add code comments that explain this change or why it was made in response to the review. Only add a comment if it clarifies confusing code, a non-obvious edge case, or complex behavior for a reader unaware of this PR; never comment obvious code. Run the relevant tests for the changed files. Create exactly one git commit with a concise message (no ticket prefix — this isn't the first commit of the branch, per the repo's git conventions). Do not push. Do not address any other feedback. Report back with the commit SHA and a one-line summary."
})
```

After each sub-agent returns, verify with `git log --oneline -1` that a new commit landed, then proceed to the next.

If a sub-agent reports it could not address the comment (e.g. tests failed, unclear intent), **stop** and surface the problem to the user before continuing with remaining comments.

## Step 8: Final report

After all sub-agents finish, output a summary:

- List of commits created (SHA + subject), one per addressed comment.
- Any comments skipped per the user's decisions during discussion.
- Any comments that failed and need the user's attention.
- A reminder that the pending review is **still pending** on GitHub — addressing the comments locally does not submit or delete the draft.
- Reminder to push commits when ready (do **not** push automatically).

## Step 9: Offer to delete the pending comments

Ask the user whether to delete the addressed pending comments (and/or the pending review itself) now that they've been addressed locally. Phrase it explicitly as plain-text output, e.g.:

> Want me to delete the pending comments I just addressed? I can delete them individually, or delete the whole pending review if nothing's left worth keeping.

**Wait for explicit confirmation.** Do not delete anything without the user saying so. Do **not** use the AskUserQuestion tool for this — print the prompt as normal output and end your turn so the user can reply in their own words.

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
- Only delete pending comments or the pending review after explicit user confirmation in Step 9.
- Never push or force-push.
- Respect the project's git conventions from `CLAUDE.md` (e.g. `Chore:` prefix for non-user-facing changes, no ticket code on subsequent commits, one thing per commit).
