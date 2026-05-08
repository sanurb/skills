---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

# Grill With Docs

## Purpose

Stress-test a plan by interviewing the user one question at a time, with their own `CONTEXT.md` and ADRs as the yardstick. Every fuzzy term gets sharpened, every conflict with the glossary gets surfaced, and every resolved decision gets written back to the docs in the same turn — so the conversation produces durable artifacts instead of vapor.

## Instructions

### 1. Read the docs before asking anything

Locate and read the project's existing documentation BEFORE the first question:

- Read `CONTEXT.md` at the repo root if it exists. If `CONTEXT-MAP.md` exists at the root, read it and follow its pointers to the per-context `CONTEXT.md` files relevant to the plan.
- Read every ADR in `docs/adr/` (or the per-context `docs/adr/` for multi-context repos) that touches the area being planned.

If neither file exists, do nothing yet — they get created lazily when the first term resolves or the first ADR is needed.

### 2. Grill one question at a time

Walk down each branch of the design tree. For every question:

- Ask exactly ONE question, then wait for the user's answer before asking the next. No compound questions.
- Provide your own recommended answer with the question.
- If a question can be answered by reading the codebase, read the codebase instead of asking.
- Challenge any term the user uses that conflicts with `CONTEXT.md`: _"Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"_
- Sharpen vague or overloaded terms by proposing a precise canonical name: _"You're saying 'account' — do you mean Customer or User?"_
- Cross-reference user claims against the actual code. If they contradict, surface it: _"Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"_
- Stress-test relationships with concrete invented scenarios that probe the boundary between concepts.

### 3. Capture decisions inline as they crystallise

Update documentation in the same turn as the resolution — never batched at the end:

- When a term resolves, update `CONTEXT.md` immediately. Read: `references/context-format.md` for the exact format. Create `CONTEXT.md` lazily on the first resolved term if it doesn't exist.
- When a decision passes ALL THREE ADR gates (hard to reverse, surprising without context, real trade-off), offer to record an ADR. Read: `references/adr-format.md` for the exact format. Create `docs/adr/` lazily on the first accepted offer; number sequentially by scanning existing files.
- If a decision fails any of the three gates, do NOT offer an ADR. No exceptions.

## Non-Negotiable Acceptance Criteria

The session delivers nothing if any of these fails:

- [ ] Existing `CONTEXT.md` (or each relevant context per `CONTEXT-MAP.md`) was read in full before the first question was asked.
- [ ] Existing ADRs in the touched area were read in full before the first question was asked.
- [ ] Questions were asked one at a time. No compound questions, no batched lists.
- [ ] Every question included a recommended answer from the agent.
- [ ] Every term collision with `CONTEXT.md` was called out the moment it appeared, not later.
- [ ] Every code/claim contradiction surfaced was backed by an actual file reference (path + concept).
- [ ] Updates to `CONTEXT.md` happened in the same turn as the resolution. Never batched.
- [ ] No ADR was offered for any decision that fails any of the three gates.
- [ ] `CONTEXT.md` and `docs/adr/` were created lazily — never speculatively.
- [ ] `CONTEXT.md` contains zero implementation details (only domain-meaningful terms).

## Output

Two artifact streams are produced:

**Stream 1 — conversation:** numbered question/recommendation pairs, one at a time. Format per turn:

```
Q{N}: {one precise question}
Recommendation: {your proposed answer with reasoning}
```

**Stream 2 — file artifacts written inline:**

- `CONTEXT.md` (or the relevant per-context glossary): updated terms appended/edited per `references/context-format.md`. Each update happens in the turn the term resolved.
- `docs/adr/NNNN-slug.md`: one new file per accepted ADR offer, numbered sequentially, formatted per `references/adr-format.md`.

No summary, no recap, no end-of-session report. The artifacts ARE the deliverable.
