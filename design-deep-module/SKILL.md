---
name: design-deep-module
description: Design multiple radically different interfaces for a module-deepening candidate and create a refactor RFC as a GitHub issue. Use after explore-architecture surfaces candidates and the user picks one. Do NOT use without a specific candidate chosen, for simple extract-function refactors, or without prior coupling evidence from explore-architecture.
---

# Design Deep Module

Given a deepening candidate (from explore-architecture), frame the problem space, spawn parallel sub-agents to produce radically different interface designs, and create a GitHub issue RFC.

## Instructions

### Step 1. Frame the problem space

Write a brief explanation of the chosen candidate covering:

1. **Constraints** any new interface must satisfy.
2. **Dependencies** classified by category — read [dependency-categories.md](references/dependency-categories.md).
3. **Illustrative code sketch** grounding the constraints — this is NOT a proposal, just context.

Present this to the user. Then immediately proceed to Step 2 while the user reads.

### Step 2. Design and compare interfaces

Spawn 3-4 sub-agents in parallel via the Task tool (`subagent_type="generalPurpose"`). Give each a self-contained technical brief (file paths, coupling details, dependency category, what to hide). Assign different constraints:

| Agent | Constraint |
|-------|-----------|
| 1 | Minimize interface — 1-3 entry points max |
| 2 | Maximize flexibility — support extension and many callers |
| 3 | Optimize for most common caller — default case trivial |
| 4 | Ports & adapters — inject transport (only if cross-boundary deps) |

Each sub-agent returns: interface signature, usage example, what it hides, dependency strategy (per [dependency-categories.md](references/dependency-categories.md)), trade-offs.

Present designs sequentially. Compare on: interface simplicity, depth, ease of correct use vs misuse, testability at boundary. Conclude with an opinionated recommendation — propose a hybrid if elements combine well.

### Step 3. Create the RFC issue

After the user picks (or accepts the recommendation), read [issue-template.md](references/issue-template.md). Fill it. Create immediately via `gh issue create` — do NOT ask the user to review first. Share the URL.

If `gh` is not authenticated, instruct the user to run `gh auth login` first.

## Non-Negotiable

- Sub-agent designs must be radically different. If two are similar, reject and re-prompt with a divergent constraint (e.g., "functional pipeline instead of OOP").
- Must include dependency strategy from [dependency-categories.md](references/dependency-categories.md) for each design.
- Must give an opinionated recommendation, not a menu.
- GitHub issue must be created immediately — never ask the user to review before creating.
- Issue must follow the template in [issue-template.md](references/issue-template.md) exactly.

## Output

```
GitHub issue created: <URL>
```

## References

| File | When to read |
|------|-------------|
| [dependency-categories.md](references/dependency-categories.md) | Step 1 (classify deps) and Step 2 (dependency strategy per design) |
| [issue-template.md](references/issue-template.md) | Step 3 (fill and create the issue) |
