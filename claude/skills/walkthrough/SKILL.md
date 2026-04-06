---
name: walkthrough
description: Walk through PR changes from the user's perspective. Traces each UI change through its full vertical slice — what the user sees, what it triggers, and how the server handles it. Use when asked to walk through what changed, review a PR, or summarize branch changes.
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep, Agent
argument-hint: [base-branch]
---

# Walkthrough

Generate a walkthrough of the current branch's changes, organized from the user's perspective.

## Step 1: Get the diff

Determine the base branch in this order:
1. Use `$ARGUMENTS` if the user specifies a branch
2. Use `bin/base-branch` if the script exists and is executable
3. Fall back to `develop`

```bash
git diff origin/<base-branch>...HEAD --stat
git diff origin/<base-branch>...HEAD -- <non-test files>
```

Exclude test files, spec files, and doc files from the diff. Focus only on implementation.

## Step 2: Identify user-facing entry points

Entry points are the highest-level changes to the existing system — the places where the diff first touches code that was already there. Trace from these points downward.

Look for:
- New or changed UI components, buttons, forms, modals, pages
- New routes or changed routes
- Changes to Liquid templates, translations
- New action handlers or event registrations

A component that hasn't changed in the diff is never an entry point, even if it renders the result of changed code. The entry point is the changed code that feeds it.

## Step 3: Write the walkthrough

Organize the output as **user flows**, not by file or layer. Each flow starts with what the user sees and traces downward through the code.

### Structure for each flow

1. **Start with the UI change** — what does the user see? A new button, a changed form, a new page? Describe the visible change and reference the file + line.

2. **Trace what happens on interaction** — when the user clicks/submits, what code runs? Follow the chain: event handler → action/service → API call → controller → model. Show each hop as a step.

3. **At each step, only highlight**:
   - New behavior or changed behavior (not just moved code)
   - Complex logic (conditionals, amount calculations, state management)
   - Side effects (jobs enqueued, orders finalized, state mutations)
   - Where data flows between systems (POS → server, server → gateway → redirect back)

4. **Skip entirely**:
   - Import reordering
   - Pure code extraction/refactoring that preserves identical behavior (but DO mention if an extracted function adds new conditions)
   - Boilerplate registration (unless it's the entry point itself)
   - Test files
   - Styling-only changes (unless they change UX behavior)

### Formatting

- Use `##` headers for each flow, named from the user's perspective (e.g., "Flow 1: POS Operator generates a pay-by-link")
- Use `###` headers for each step within a flow
- Use numbered steps within each flow section
- Reference files as **`filename.ext:line`** or **`filename.ext`** (bold backtick)
- Include short code snippets only when they clarify logic that's hard to describe in prose
- Keep descriptions concise — one or two sentences per point

## Step 4: Add an "Areas of concern" section

End with a numbered list of concerns, edge cases, or questions. Focus on:
- Logic that affects more than its intended scope (e.g., a condition that runs for all orders, not just the new feature)
- Fragile patterns (e.g., relying on a single-letter query param)
- Silent failure modes (e.g., swallowed errors)
- Security considerations (e.g., user-controlled amounts, trust boundaries)
- Missing guards or validation gaps
