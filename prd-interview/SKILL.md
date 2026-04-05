---
name: prd-interview
description: "Continuation skill: walk the design tree branch-by-branch until every decision is explicit. Runs after prd-discover when problem-brief.md exists. Not for standalone use, brainstorming, or solution design."
user-invocable: false
effort: high
---

# PRD Interview

Resolve every design decision through a dependency-ordered interview. One branch at a time. No child question asked while the parent is unresolved.

> **Activation guard:** This is a continuation skill. Only run when `/tmp/prd-{name}/problem-brief.md` exists from a prior `prd-discover` run. Do not activate independently.

## Step 1: Build the Branch Map

Read `/tmp/prd-{name}/problem-brief.md`. If missing, stop and tell the user to run `prd-discover` first.

From the problem brief, map decision branches in this fixed order:

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

For each branch (lowest unblocked first), ask the probe questions from [references/interview-branches.md](references/interview-branches.md).

**Per-decision protocol (every decision, no exceptions):**

1. Ask ONE question. Wait for the answer.
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

Copy the template from [assets/decision-ledger-template.md](assets/decision-ledger-template.md) and fill every section from the interview.

## Non-Negotiable Acceptance Criteria

The decision ledger is NOT complete unless ALL of these are true:

- [ ] Every branch is `decided` or `deferred-with-owner` — no branch left `open`
- [ ] Every `deferred` decision has an owner, a revisit trigger, and what it blocks
- [ ] B1 has at least one primary metric that passes the vanity test
- [ ] B2 has at least 2 explicit non-goals
- [ ] B3 describes outcomes, not implementation — zero UI prescriptions
- [ ] B5 has at least 3 failure/degradation scenarios
- [ ] B6 has no adjectives without numbers
- [ ] Every assumption is labeled as an assumption, never encoded as a decided fact
- [ ] User has confirmed: "This reflects our shared understanding"

## Output

- **Artifact:** `/tmp/prd-{name}/decision-ledger.md`
- **Next skill:** `prd-draft`
