---
name: pr-feedback
description: Evaluate unresolved review comments on the current branch's PR and, after user confirmation, address each in a separate sub-agent and separate commit.
user-invocable-only: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Agent
---

# pr-feedback — Triage and address unresolved PR review comments

The goal: look at every **unresolved** review comment on the PR for the current branch, evaluate each one independently, recommend which to address (and which to skip), and — only after the user confirms — dispatch a sub-agent per comment to fix it, one commit per comment.

## Step 1: Find the PR for the current branch

```bash
pr_number=$(gh pr view --json number --jq .number)
pr_url=$(gh pr view --json url --jq .url)
repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
base_branch=$(gh pr view --json baseRefName --jq .baseRefName)
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

Skip reviews by the current user (`gh api user --jq .login`) — don't triage the user's own comments.

## Step 3: Evaluate each comment independently

For each unresolved thread / review body, read the referenced file(s) at the relevant lines to understand the current code. Then form an independent judgment on:

- **What the reviewer is asking for** (summarize in one line).
- **Whether it's still applicable** (code may have moved on, especially for outdated threads).
- **Recommendation**: `address`, `skip`, or `discuss`.
  - `address` — clearly actionable and worth doing.
  - `skip` — stale, already done, out of scope, or you disagree with the reviewer (explain briefly).
  - `discuss` — needs user input before acting (ambiguous, subjective, or a design call).
- **One-sentence rationale.**

Evaluate each comment on its own merits; do not let one comment's recommendation influence another's.

## Step 4: Present triage to the user

Output a compact markdown table or list. For each comment include:

- A short label (e.g. `#1`, `#2`) used for confirmation.
- The file:line (or "general" for review-body comments).
- The reviewer's login.
- A 1-line summary of the ask.
- Your recommendation and rationale.
- A clickable link to the comment.

End with a prompt like:

> Reply with which to address (e.g. "all addresses", "1,3,4", "all except 2"). I'll run one sub-agent per comment and commit each fix separately.

**Stop and wait for the user's reply.** Do not proceed to Step 5 without explicit confirmation.

## Step 5: Address each confirmed comment

For each confirmed comment, dispatch a **separate sub-agent** via the Agent tool. Run them **sequentially**, not in parallel — each creates a commit on the same branch, and parallel edits would conflict.

Prompt for each sub-agent should include:

- The current working directory (per project convention).
- The PR URL and comment URL.
- The file path and line.
- The reviewer's exact comment body.
- The diff hunk showing the code in question.
- A clear instruction: "Make the smallest change that addresses this comment. Run the relevant tests. Then create a single git commit with a message summarizing the fix. Do not push. Do not address other feedback."
- An instruction to apply the feedback **branch-wide**, not only at the commented location: if the comment articulates a general rule or pattern (e.g. "always use `order.sc_id` instead of `order.id`", "prefer `Foo.bar` over `Foo.baz`", "rename X to Y"), search the entire diff on the current branch for other instances of the same pattern and apply the same change there too. Pass the PR's actual base branch (`$base_branch` from Step 1 — may not be `main`, e.g. for stacked PRs) and tell the sub-agent to use `git diff <base_branch>...HEAD` to scope the search to lines this branch introduced or touched. Do not modify code outside the branch's diff.

Example skeleton:

```
Agent({
  subagent_type: "general-purpose",
  description: "Address PR comment #<n>",
  prompt: "Working directory: <cwd>.\n\nAddress this PR review comment:\n\n<comment body>\n\nFile: <path>:<line>\nComment URL: <url>\nPR: <pr_url>\n\nDiff hunk for context:\n<diffHunk>\n\nMake the smallest change that resolves the feedback. If the comment expresses a general rule or pattern (not just a one-off fix at this line), also apply it to any other matching instances within this branch's diff against its base branch (use `git diff <base_branch>...HEAD` with the PR's actual base branch substituted in to find the touched code). Do not modify code outside this branch's diff. Run the relevant tests for the changed files. Create exactly one git commit with a concise message (no ticket prefix — this isn't the first commit of the branch, per the repo's git conventions). Do not push. Do not address any other feedback. Report back with the commit SHA and a one-line summary."
})
```

After each sub-agent returns, verify with `git log --oneline -1` that a new commit landed, then proceed to the next.

If a sub-agent reports it could not address the comment (e.g. tests failed, unclear intent), **stop** and surface the problem to the user before continuing with remaining comments.

## Step 6: Final report

After all sub-agents finish, output a summary:

- List of commits created (SHA + subject), one per addressed comment.
- Any comments skipped per the user's instructions.
- Any comments that failed and need the user's attention.
- Reminder to push when ready (do **not** push automatically).

## Step 7: Reply to comments

Draft a reply for each triaged thread first, then show **all** drafts to the user in a single message and ask whether to post them. **Stop and wait for confirmation.** If they decline, end here.

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

## Notes

- Never push or force-push.
- Respect the project's git conventions from `CLAUDE.md` (e.g. `Chore:` prefix for non-user-facing changes, no ticket code on subsequent commits, one thing per commit).
- After everything is done, remind the user to push the changes when they're ready.
