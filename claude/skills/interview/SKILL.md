---
disable-model-invocation: true
name: interview
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Like grill-me, but asks one structured, numbered question at a time with multiple-choice options. Use when the user wants a disciplined interview to stress-test a plan or design, or mentions "interview me".
---

# Interview

Interview the user relentlessly about every aspect of this plan or design until you reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one at a time.

## Rules for questions

- **One question at a time.** Never bundle multiple questions into a single turn. Ask, wait for the answer, then ask the next.
- **Don't move on until the current question is answered.** If the user asks for clarification, adds to an earlier answer, or replies without choosing, answer them and re-ask the same question under the same number, revised if needed. A reply doesn't have to contain a new question.
- **Number questions in strict sequence.** A question keeps its number until it's answered; the next question takes the next integer.
- **Always present a numbered list of multiple-choice answers.** Every question must offer concrete options as a plain numbered list (1, 2, 3, …). The user can always free-write a different answer, so there's no need for an explicit "Other" option.
- **Always give a recommendation.** After the options, state which option you recommend and why, in one line.
- **Explore before asking.** If a question can be answered by exploring the codebase, do that instead of asking.

Format every question like this:

```
<The single question>

1. <Option one>
2. <Option two>
3. <Option three>

Recommendation: <option number and a one-line reason>
```

Keep going until the design tree is resolved — scope, behavior, edge cases, data model, UI/UX, integrations, permissions, and any open questions are all settled.
