---
name: prd-interview
description: Walk the design tree branch-by-branch until every decision is explicit. Reads the problem brief from prd-discover, produces a decision ledger that prd-draft consumes. Use when running the PRD interview phase, or when user says "interview me about the design", "resolve the decisions", "walk the design tree". Use after prd-discover.
---

# PRD Interview

Resolve every design decision through a dependency-ordered interview. One branch at a time. No child question asked while the parent is unresolved. No ambiguity left standing.

## Step 1: Build the Branch Map

Read `/tmp/prd-{name}/problem-brief.md`. If it doesn't exist, run `prd-discover` first.

From the problem brief, identify decision branches in this fixed order:

| # | Branch | Depends On | Status |
|---|--------|-----------|--------|
| B1 | Success Criteria | — | open |
| B2 | Scope Boundaries & Non-Goals | — | open |
| B3 | Solution Approach | B1, B2 | blocked |
| B4 | Data Model & State | B3 | blocked |
| B5 | Edge Cases & Failure Modes | B3 | blocked |
| B6 | Non-Functional Requirements | B2 | blocked |
| B7 | Module Design & Testing | B3, B5 | blocked |
| B8 | Rollout & Measurement | B1, B3 | blocked |

Show this map to the user before asking the first question.

## Step 2: Interview Branch-by-Branch

For each branch (lowest unblocked first), ask the probe questions from [interview-branches.md](./references/interview-branches.md).

**Per-decision protocol (every decision, no exceptions):**

1. Ask ONE question. Wait for answer.
2. Apply the relevant distinction check:
   - User states a solution → *"Is this what to achieve, or how to achieve it?"*
   - User states an assumption → *"What evidence supports this?"*
   - User gives a vague NFR → *"What number, at what percentile, under what load?"*
   - User gives a vanity metric → *"Would a bad implementation still hit this?"*
   - User adds scope → Name it, park it, cost it.
3. Record the decision as: **decision + rationale + rejected alternative + risk introduced**.
4. Confirm wording with user before moving to the next question.

After resolving a branch, update its status to `decided` and unblock dependents.

## Step 3: Produce the Decision Ledger

When all branches are `decided` or `deferred-with-owner`, write to `/tmp/prd-{name}/decision-ledger.md`.

Use this exact format:

```markdown
# Decision Ledger: {Feature Name}

**Date:** {YYYY-MM-DD}
**Branches resolved:** {N}/8

## B1: Success Criteria
**Status:** decided

| Metric | Target | Timeframe | Type |
|--------|--------|-----------|------|
| {metric} | {threshold} | {window} | Primary |
| {metric} | {threshold} | {window} | Secondary |
| {metric} | {must not regress} | {window} | Guardrail |

## B2: Scope Boundaries & Non-Goals
**Status:** decided

**In scope:**
- {item}

**Non-goals (explicit exclusions):**
- {exclusion + why excluded}

## B3: Solution Approach
**Status:** decided

**Approach:** {outcome-level description — what, not how}

**Key decisions:**
- **Decision:** {what}
  - Rationale: {why}
  - Rejected: {alternative + why rejected}
  - Risk: {what could go wrong}

## B4: Data Model & State
**Status:** decided | deferred

{Source of truth, migrations, cross-system dependencies}

## B5: Edge Cases & Failure Modes
**Status:** decided

- Given {failure condition}, then {expected behavior}
- Given {empty/malformed input}, then {handling}
- Given {concurrent access}, then {resolution}

## B6: Non-Functional Requirements
**Status:** decided

| Attribute | Specification | Measurement |
|-----------|--------------|-------------|
| {e.g., Performance} | {p95 < 200ms at 1K users} | {how measured} |

## B7: Module Design & Testing
**Status:** decided

| Module | Change | Interface | Test in Isolation? |
|--------|--------|-----------|-------------------|
| {name} | {what changes} | {how others interact} | Yes/No |

**Testing approach:** {unit/integration/e2e}
**Prior art:** {existing similar tests in codebase}

## B8: Rollout & Measurement
**Status:** decided | deferred

- Strategy: {feature flag / A/B / phased / full}
- Instrumentation: {events to track}
- Rollback: {plan}
- Review: {who, when}

## Deferred Decisions

| Decision | Owner | Revisit When | Blocks |
|----------|-------|-------------|--------|
| {question} | {who} | {trigger} | {what} |

## Assumptions (Unvalidated)

| Assumption | Risk if Wrong | Validation Plan |
|------------|--------------|-----------------|
| {belief} | {consequence} | {how to test} |
```

## Non-Negotiable Acceptance Criteria

The decision ledger is NOT complete unless ALL of these are true:

- [ ] Every branch is `decided` or `deferred-with-owner` — no branch left `open`
- [ ] Every `deferred` decision has an owner, a trigger to revisit, and what it blocks
- [ ] B1 (Success Criteria) has at least one primary metric that passes the vanity test
- [ ] B2 (Scope) has at least 2 explicit non-goals
- [ ] B3 (Solution) describes outcomes, not implementation — zero UI prescriptions
- [ ] B5 (Edge Cases) has at least 3 failure/degradation scenarios
- [ ] B6 (NFRs) has no adjectives without numbers — every "fast/reliable/secure" is quantified
- [ ] Every assumption is labeled as an assumption, never encoded as a decided fact
- [ ] User has confirmed: "This reflects our shared understanding"

## Output

- **Artifact:** `/tmp/prd-{name}/decision-ledger.md`
- **Next skill:** `prd-draft` (reads both problem brief and decision ledger)
