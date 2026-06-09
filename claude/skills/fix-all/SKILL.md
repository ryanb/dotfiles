---
name: fix-all
description: Run bin/claude-review --print and automatically fix all reported issues, committing each fix individually.
disable-model-invocation: true
user-invocable-only: true
---

# Fix All Review Issues

Automatically find and fix all issues reported by `bin/claude-review --print`.

## Step 1: Run the review

Run `bin/claude-review --print` to get the list of issues. If the command doesn't exist or fails, report back to the user and stop.

## Step 2: Print the full review output verbatim

**This is a required, non-optional step. Do not skip it.**

Before reading any file, spawning any sub-agent, or making any edit, emit a plain-text message to the user containing the **entire, unmodified** stdout from `bin/claude-review --print`.

Rules for this step:
- Paste the output verbatim. Do not summarize, truncate, paraphrase, reorder, or omit any issue — including issues surfaced in "prior review runs" or notes.
- Do not collapse multiple issues into a "note" or parenthetical. Every issue the review reported must appear in full, with its severity, file:line, and description.
- Do not wrap it in commentary beyond a one-line header like `=== Code Review ===`.
- Do **not** stop or end the turn after printing. Immediately continue to Step 3 in the same turn — the printed output is informational for the user, not a checkpoint.

## Step 3: Parse the issues

Parse the review output into individual issues. Each issue is separated by a line of dashes (`--------------------------------------------------`) and follows this format:

```
Issue N (Severity): file_path:line_number

Description...
```

Severity is one of: Critical, Warning, Suggestion.

If the output says "No issues found." then report that to the user and stop.

## Step 4: Fix issues sequentially

For each issue, spawn a sub-agent to fix it. Process issues **one at a time, sequentially** (not in parallel) to avoid conflicts between fixes. The current working directory is the project root.

Each sub-agent should:
1. Read the relevant file and understand the issue
2. If the issue is a bug fix, first write or update a test that fails due to the bug
3. Apply the fix and verify the test now passes
4. Run any related tests if applicable to verify the fix doesn't break anything
5. Create a git commit for the fix with a descriptive message that includes **why** the change was made (e.g., the issue description or the problem it solves), not just what was changed. The reader should be able to evaluate whether the fix was appropriate from the commit message alone. Prefix the commit message with "Chore:" only for pure refactoring — bug fixes, external changes, and configuration changes are not chores.

**Use your judgment on each issue:**
- **Critical** and **Warning** issues should generally be fixed.
- **Suggestion** issues: fix these too, including small stylistic improvements. Only skip suggestions that are not beneficial or would require a large change.
- Skip any issue that seems like a false positive or doesn't make sense in context.
- If a fix would be a significant or risky change (large refactor, architectural change, behavior change that could break things), confirm with the user before applying it.

**Defer issues that go against the grain of the branch:**

Some fixes would push against the direction or intent of the changes in this branch — for example, reverting a deliberate design decision the branch is making, undoing a pattern the branch is intentionally introducing, or "fixing" something to match the old approach the branch is moving away from. To judge this, compare against what the branch is actually doing (e.g. `git diff main...HEAD` or the equivalent base branch) to understand its intent.

For these issues:
- **Do not fix them inline.** Collect them into a deferred list that persists across all review rounds.
- Continue processing the remaining issues normally.
- **Do not ask the user about deferred issues between rounds.** They are all handled together at the very end in Step 6.

## Step 5: Re-run the review

After all fixes are applied, run `bin/claude-review --print` again to check for remaining issues.

If new issues are found:
- Apply fixes for legitimate new issues following the same process as Step 4 (including deferring any that go against the grain of the branch — add them to the same deferred list; do not confirm them with the user yet).
- If the same issues keep appearing (repeating between rounds), stop fixing them.
- If only minor suggestions remain that aren't worth fixing, stop.
- Do at most 5 rounds of review-and-fix to avoid infinite loops.

## Step 6: Confirm and apply deferred issues

Once all review rounds are complete, handle the accumulated deferred list (the against-the-grain issues collected across every round):
- Present the full deferred list to the user. For each, explain what the fix would do and why it appears to conflict with the branch's intent.
- Ask the user, as a numbered list of plain-text options, which deferred issues (if any) they want applied.
- Apply only the deferred fixes the user confirms, following the same sub-agent + individual-commit process as Step 4.

If no issues were deferred, skip this step.

## Step 7: Summary

When done, provide a summary that includes:
- **Issues fixed**: List each issue that was fixed with a brief description
- **Issues skipped**: List any issues that were intentionally skipped and why
- **Potential concerns**: Flag any fixes that might need user review (e.g., behavior changes, edge cases, or anything you're not fully confident about)
- **Remaining issues**: Any issues still reported after the final review round
