---
name: triage-issue
description: Investigate a bug by searching the codebase for root cause, then create a GitHub issue with a TDD fix plan. Use when the user reports a bug, mentions "triage", wants to investigate a problem, or needs a fix plan filed as an issue. Do NOT use for feature requests, architecture improvements, problems without observable symptoms, or when the user already knows the root cause and just wants to fix it.
---

# Triage Issue

Investigate a reported problem, find its root cause via code search, and create a GitHub issue with a TDD fix plan. Mostly hands-off — minimize questions to the user.

## Instructions

### Step 1. Investigate

Get the problem description from the user. If not provided, ask ONE question: "What's the problem you're seeing?" Then investigate immediately — do NOT ask follow-ups.

Search the codebase with codemogger for the relevant code paths:

```bash
npx codemogger search "<error message or symptom keywords>"
npx codemogger search "<feature or module name>" --mode keyword
```

For each result, trace the code path to find:

- **Where** the bug manifests (entry point, API, UI)
- **Why** the current code fails (root cause, not symptom)
- **What** related code works correctly (similar patterns elsewhere)

Cross-reference with recent changes to affected areas:

```bash
git log --oneline --since="2 weeks ago" -- <files from codemogger results>
```

If codemogger is not indexed, fall back to the Task tool (`subagent_type="explore"`, thoroughness `"very thorough"`).

### Step 2. Design TDD fix plan

Based on the root cause, create an ordered list of RED-GREEN cycles. Each cycle is one vertical slice:

- **RED**: A specific test that captures the broken/missing behavior
- **GREEN**: The minimal code change to make that test pass

End with a REFACTOR step if cleanup is needed after all tests pass.

Rules for the plan:
- Tests verify behavior through public interfaces, not implementation details
- One test at a time (vertical slices, never all tests first then all code)
- Each test must survive internal refactors
- Describe behaviors and contracts, not file paths or internal structure

### Step 3. Create the GitHub issue

Read [issue-template.md](references/issue-template.md). Fill it with the root cause analysis and TDD plan. Create immediately via `gh issue create` — do NOT ask the user to review first.

If `gh` is not authenticated, instruct the user to run `gh auth login` first.

## Non-Negotiable

- Must search the codebase before declaring root cause — no guessing from intuition alone.
- Root cause must identify a specific behavior that fails, not just "this file looks wrong."
- TDD plan must use vertical slices (one RED→GREEN at a time), never horizontal.
- Issue must NOT contain file paths or line numbers — describe modules, behaviors, and contracts. The issue must remain useful after major refactors.
- Issue must be created immediately without asking the user to review.

## Output

```
Issue created: <URL>
Root cause: <one-line summary>
```

## References

| File | When to read |
|------|-------------|
| [issue-template.md](references/issue-template.md) | Step 3 (fill and create the issue) |
