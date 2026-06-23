---
name: pr-feedback
description: Evaluate unresolved review comments on the current branch's PR and, after user confirmation, address each in a separate sub-agent and separate commit.
user-invocable-only: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Agent
---

# pr-feedback — Triage and address unresolved PR review comments

The goal: look at every **unresolved** review comment on the PR for the current branch, evaluate each one independently, split them into ones that can simply be addressed (or skipped) and ones that need discussion, work through the discussion comments one at a time, and — only after all discussions are resolved and the user confirms — address each, one commit per comment (simple ones inline, involved ones via a sub-agent).

Unlike pending feedback, these comments come from **other reviewers**, so recommending to **skip** a comment (stale, already done, out of scope, or you disagree) is a legitimate outcome — but anything ambiguous, subjective, or a design call should go to **discussion** so the user decides, not be silently skipped.

## Step 1: Find the PR for the current branch

```bash
pr_number=$(gh pr view --json number --jq .number)
pr_url=$(gh pr view --json url --jq .url)
repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
base_branch=$(gh pr view --json baseRefName --jq .baseRefName)
me=$(gh api user --jq .login)
```

If `gh pr view` fails, stop and tell the user there is no open PR for the current branch.

## Step 2: Fetch unresolved review comments

GitHub's REST API exposes review comments but not the `isResolved` flag — that lives on the review **thread** in GraphQL. Use GraphQL to pull threads with their resolution state and comments:

```bash
gh api graphql -f query='
  query($owner:String!, $repo:String!, $number:Int!) {
    repository(owner:$owner, name:$repo) {
      pullRequest(number:$number) {
        reviewThreads(first:100) {
          nodes {
            id
            isResolved
            isOutdated
            path
            line
            comments(first:50) {
              nodes {
                author { login }
                body
                url
                diffHunk
                originalLine
                path
              }
            }
          }
        }
      }
    }
  }' -F owner="$(echo $repo | cut -d/ -f1)" \
     -F repo="$(echo $repo | cut -d/ -f2)" \
     -F number="$pr_number"
```

Filter to threads where `isResolved == false`. Include outdated threads (they may still be valid), but note them as outdated in the triage so the user can weigh that.

Also fetch **top-level PR review bodies** (the "overall" review comments that aren't tied to a line), since they often contain actionable feedback too:

```bash
gh api "repos/$repo/pulls/$pr_number/reviews" --jq \
  '.[] | select(.body != "" and .body != null) | {author: .user.login, body: .body, state: .state, url: .html_url}'
```

Skip reviews by the current user (`$me`, captured in Step 1) — don't triage the user's own comments.

## Step 3: Evaluate each comment independently

For each unresolved thread / review body, read the referenced file(s) at the relevant lines to understand the current code. Then classify it as exactly one of:

- **`address`** — clearly actionable, unambiguous, still applicable, and you're confident how to do it. It can be acted on without further input.
- **`skip`** — stale, already done, out of scope, or you disagree with the reviewer, and you're confident that's the right call. (Code may have moved on, especially for outdated threads.)
- **`discuss`** — anything else. If the comment is ambiguous, subjective, a design call, possibly stale/already-done, or you have any doubt about whether or how to act on it, it needs the user's input first.

When in doubt between `skip` and acting, prefer `discuss` — let the user make the call rather than silently skipping a reviewer's comment.

For every `address` comment (and any `discuss` comment the user resolves into an action in Step 4), also tag **how** it will be handled:

- **`simple`** — a localized, mechanical, single-location change with no branch-wide pattern implications and no test reasoning needed (e.g. a typo, a rename at one site, a small wording tweak, an obvious guard clause). These are handled inline in the main loop with `Edit` (Step 6), no sub-agent.
- **`involved`** — anything that articulates a general rule to apply branch-wide, touches multiple files, needs judgment, or requires running/reasoning about tests. These get a dedicated sub-agent (Step 6).

When in doubt between `simple` and `involved`, treat it as `involved`.

Evaluate each comment on its own merits; do not let one comment's classification influence another's.

**Do not present any triage table or list at this stage.** Do not show the user the full set of comments yet. Move straight on to working through the discussion comments.

## Step 4: Work through discussion comments one at a time

For each comment classified as `discuss`, ask the user about it **one question at a time** — present a single comment, wait for the reply, then move to the next. Do not batch them.

For each discussion comment, present:

- The reviewer's login and the comment body (quoted), and a clickable link to it.
- The file:line and the **relevant code snippet** for context (the lines the comment refers to — pull from the actual file, falling back to the `diffHunk` if needed). Always include this so the user has the context in front of them.
- A short framing of what needs deciding.
- A **numbered list of plain-text options** for how to proceed (e.g. `1.` address it a particular way, `2.` address it a different way, `3.` skip it, etc.). Always include skipping as one of the numbered options when it's a sensible choice.
- **Explicitly state which option you recommend** and why, in one sentence.

Per the user's global preference, present the options as a numbered plain-text list. Do **not** use the AskUserQuestion tool — print the question as normal output and end your turn so the user can reply in their own words.

**Stop and wait for the user's reply after each discussion comment** before moving to the next one. Record the resolution for each (address in a specific way, or skip).

If there are no discussion comments, skip straight to Step 5.

## Step 5: Present the consolidated plan

Only **after every discussion comment has been resolved**, present a single consolidated list/table of **all** comments and how each will be handled:

- A short label (e.g. `#1`, `#2`).
- The file:line (or "general" for review-body comments).
- The reviewer's login.
- A 1-line summary of the ask.
- How it will be handled: **address** (with any specifics decided during discussion) or **skip** (per your recommendation or the user's decision in Step 4). For each **address** comment, note whether it'll be done **inline** (simple) or via a **sub-agent** (involved).
- A clickable link to the comment.

End with a plain-text prompt like:

> This is the plan. Reply to confirm and I'll address each comment — simple ones inline, involved ones via a sub-agent — committing each fix separately. Let me know if you want to change anything.

**Stop and wait for the user's reply.** Do not proceed to Step 6 without explicit confirmation. Do **not** use the AskUserQuestion tool for this — just print the prompt as normal output and end your turn so the user can reply in their own words.

## Step 6: Address each confirmed comment

Work through the comments the user confirmed to address (skipped comments are left alone) **sequentially**, not in parallel — each creates a commit on the same branch, and parallel edits would conflict. Handle each according to its `simple`/`involved` tag from Step 3:

- **Simple comments** — handle **inline in the main loop** with `Edit`. Make the smallest change that addresses the comment, then create **exactly one git commit** for it (same commit discipline as a sub-agent: one commit per comment, concise message, no ticket prefix, do not push). The same comment-discipline rule applies: do not add code comments explaining the change or that it was made in response to the review. If, once you look closely, a "simple" comment turns out to imply a branch-wide pattern or otherwise isn't trivial after all, escalate it to a sub-agent instead.
- **Involved comments** — dispatch a **separate sub-agent** via the Agent tool (see below).

Either way, the result is **one commit per addressed comment**, so the final report (Step 7) is the same regardless of how each was handled.

For involved comments, the prompt for each sub-agent should include:

- The current working directory (per project convention).
- The PR URL and comment URL.
- The file path and line.
- The reviewer's exact comment body.
- The diff hunk showing the code in question.
- A clear instruction: "Make the smallest change that addresses this comment. Run the relevant tests. Then create a single git commit with a message summarizing the fix. Do not push. Do not address other feedback."
- An instruction to apply the feedback **branch-wide**, not only at the commented location: if the comment articulates a general rule or pattern (e.g. "always use `order.sc_id` instead of `order.id`", "prefer `Foo.bar` over `Foo.baz`", "rename X to Y"), search the entire diff on the current branch for other instances of the same pattern and apply the same change there too. Pass the PR's actual base branch (`$base_branch` from Step 1 — may not be `main`, e.g. for stacked PRs) and tell the sub-agent to use `git diff <base_branch>...HEAD` to scope the search to lines this branch introduced or touched. Do not modify code outside the branch's diff.
- An instruction on **comment discipline**: do not add code comments that explain the change itself or why it was made in response to this review. Only add a comment if it clarifies confusing code, a non-obvious edge case, or genuinely complex behavior for a future reader who has no knowledge of this PR. Do not comment obvious code.

Example skeleton:

```
Agent({
  subagent_type: "general-purpose",
  description: "Address PR comment #<n>",
  prompt: "Working directory: <cwd>.\n\nAddress this PR review comment:\n\n<comment body>\n\nFile: <path>:<line>\nComment URL: <url>\nPR: <pr_url>\n\nDiff hunk for context:\n<diffHunk>\n\nMake the smallest change that resolves the feedback. If the comment expresses a general rule or pattern (not just a one-off fix at this line), also apply it to any other matching instances within this branch's diff against its base branch (use `git diff <base_branch>...HEAD` with the PR's actual base branch substituted in to find the touched code). Do not modify code outside this branch's diff. Do not add code comments that explain this change or why it was made in response to the review. Only add a comment if it clarifies confusing code, a non-obvious edge case, or complex behavior for a reader unaware of this PR; never comment obvious code. Run the relevant tests for the changed files. Create exactly one git commit with a concise message (no ticket prefix — this isn't the first commit of the branch, per the repo's git conventions). Do not push. Do not address any other feedback. Report back with the commit SHA and a one-line summary."
})
```

After each comment is addressed — inline or by a sub-agent — verify with `git log --oneline -1` that a new commit landed, then proceed to the next.

If a comment can't be addressed (e.g. tests failed, or a sub-agent reports unclear intent), **stop** and surface the problem to the user before continuing with remaining comments.

## Step 7: Final report

After all comments are addressed, output a summary:

- List of commits created (SHA + subject), one per addressed comment.
- Any comments skipped per your recommendation or the user's decisions during discussion.
- Any comments that failed and need the user's attention.
- Reminder to push when ready (do **not** push automatically).

## Step 8: Reply to comments

Draft a reply for each triaged thread first, then show **all** drafts to the user in a single plain-text message and ask whether to post them. **Stop and wait for confirmation.** Do **not** use the AskUserQuestion tool for this — print the previews and prompt as normal output and end your turn so the user can reply in their own words. If they decline, end here.

Reply rules:

- **Addressed** (a commit landed): body is exactly `Done, thanks.` — post the reply and mark the thread resolved.
- **Skipped** (per user's instruction or your `skip` recommendation they accepted): body is `From Claude:\n\n<one- or two-sentence reason it was skipped>` — post the reply but do **not** resolve the thread.
- **Failed**: do not draft a reply; surface to the user separately.

Format the preview like:

```
Ready to post these replies. Confirm to proceed.

#1 <file:line> — addressed (will resolve)
> Done, thanks.

#2 <file:line> — skipped (will not resolve)
> From Claude:
>
> <reason>

...
```

The user may edit any draft before confirming; honor their edits exactly.

After posting, share each reply's URL (returned by the `addPullRequestReviewThreadReply` mutation as `comment.url`) as a clickable link.

To reply to a review thread, use the GraphQL `addPullRequestReviewThreadReply` mutation with the thread `id` captured in Step 2:

```bash
gh api graphql -f query='
  mutation($threadId:ID!, $body:String!) {
    addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:$threadId, body:$body}) {
      comment { url }
    }
  }' -F threadId="$thread_id" -F body="Done, thanks."
```

To resolve a thread:

```bash
gh api graphql -f query='
  mutation($threadId:ID!) {
    resolveReviewThread(input:{threadId:$threadId}) {
      thread { isResolved }
    }
  }' -F threadId="$thread_id"
```

Top-level review bodies (not tied to a thread) cannot be resolved; for those, post a regular issue comment via `gh pr comment "$pr_number" --body "..."` only if addressing/skipping warrants a reply.

## Step 9: Offer to update the PR description (author only)

Addressing feedback often changes what the PR does, leaving its **description out of date**. Offer to fix that — but **only if both** of these hold:

1. **The current user is the PR author.** Compare the PR author to the authenticated user:
   ```bash
   pr_author=$(gh pr view --json author --jq .author.login)
   ```
   If `$pr_author` != `$me` (captured in Step 1), **skip this step entirely** — do not offer, do not mention it.
2. **The description is actually out of date.** Read the current description (`gh pr view --json body --jq .body`) and compare it against the changes just made in Step 6. If everything the description says still holds and nothing it should mention is now missing, the description is up to date — **skip this step silently.** Only proceed if a confirmed fix made a concrete claim in the description wrong, incomplete, or misleading.

If both hold, propose a **minimal** edit: the smallest set of changes that brings the description back in line with the code — fix the specific sentences/bullets that the addressed comments invalidated, and add anything now missing. Do **not** rewrite, restructure, or restyle the description; leave everything still-accurate untouched.

Show the user the proposed new description (or a diff of just the changed lines) and ask a single plain-text yes/no question, e.g.:

> Addressing the feedback made the PR description out of date. Here's a minimal update — apply it? (yes/no)

**Wait for explicit confirmation.** Do **not** use the AskUserQuestion tool — print the prompt as normal output and end your turn. If the user confirms, apply it:

```bash
gh pr edit "$pr_number" --body "<updated description>"
```

**Screenshots:** if the description embeds screenshots (e.g. `![...](...)` images, or an attachments/screenshots section) and any addressed comment changed UI or other visible output those screenshots likely depict, you **cannot** regenerate them — so just **remind** the user to re-capture and re-upload them, naming the specific screenshots that are probably now stale. Skip this reminder when the addressed comments didn't change anything the screenshots would show.

## Notes

- Never push or force-push.
- Respect the project's git conventions from `CLAUDE.md` (e.g. `Chore:` prefix for non-user-facing changes, no ticket code on subsequent commits, one thing per commit).
- After everything is done, remind the user to push the changes when they're ready.
