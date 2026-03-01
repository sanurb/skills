---
name: interviewing-plans
description: Conduct dependency-aware plan interviews that interrogate every design branch until assumptions are resolved and shared understanding is explicit. Use when scoping features, refactors, architecture, migrations, or any plan with interdependent decisions.
references:
  - references/decision-branches.md
---

# Interviewing Plans

Run a relentless, dependency-ordered interview until every decision in the plan is explicit, consistent, and acknowledged by both sides.

## Activation Triggers

Use this skill when user asks for any of:
- Deep planning interviews
- Design-tree walkthroughs
- Decision dependency resolution
- “Challenge every assumption” style planning
- Shared-understanding checkpoints before implementation

## Non-Negotiable Rules

1. **Interrogate before drafting** — do not propose implementation plan before core branches are resolved.
2. **Dependency-first traversal** — never ask a child-branch question while parent dependency is unresolved.
3. **One decision at a time** — ask exactly one active decision question per turn unless user explicitly asks for batching.
4. **Structured questioning first** — use the `ask` tool by default for branch decisions.
5. **No silent assumptions** — if user says “doesn’t matter,” convert into explicit default + risk.
6. **No ambiguous closure** — every branch ends as `decided`, `deferred-with-owner`, or `out-of-scope`.

## Operating Loop

```
MAP -> INTERVIEW -> RECONCILE -> COMPLETE
        ^              |
        |--------------|
```

### Phase 1: MAP

1. Extract plan seed from user input.
2. Build branch list using [decision-branches.md](./references/decision-branches.md).
3. Mark each branch status:
   - `open`
   - `blocked` (waiting on dependency)
   - `decided`
   - `deferred`
   - `out-of-scope`
4. Show branch map before first deep question.

### Phase 2: INTERVIEW

For next eligible branch (`open` + dependencies resolved):

1. Ask one high-leverage question with 2-5 options via `ask`.
2. If answer is vague, follow with a narrowing question.
3. Capture result as explicit decision statement:
   - decision
   - rationale
   - rejected alternative
   - risk introduced
4. Confirm wording with user before moving on.

### Phase 3: RECONCILE

After each branch decision, run consistency checks against prior decisions:

- Scope vs timeline
- Data model vs interface contract
- Reliability target vs budget/effort
- Security/privacy requirements vs UX
- Rollout strategy vs operational capability

If conflict exists, stop traversal and resolve conflict first.

### Phase 4: COMPLETE

Only finish when:

- No `open` branches remain
- No `blocked` branches remain
- Every `deferred` branch has owner + trigger to revisit
- Acceptance criteria are measurable
- User confirms: “Yes, this reflects shared understanding”

## Branch Traversal Policy

Selection order:
1. Lowest-depth open branch with all dependencies resolved
2. Highest-risk branch among ties
3. Oldest unresolved branch among ties

When discovery reveals a missing branch:
- Add branch
- Declare dependency edges
- Re-run selection order

## Interview Tactics (Relentless Mode)

For each decision, probe at least 3 dimensions:

1. **Intent** — Why this choice?
2. **Failure mode** — What breaks first?
3. **Operability** — How is this tested, monitored, and rolled back?

Escalate when needed:
- If user is uncertain: reduce to binary trade-off.
- If user is overconfident: request disconfirming case.
- If user skips details: force explicit assumption with risk label.

## Response Contract (Every Turn)

Always end each response with:

```
---
Phase: <MAP|INTERVIEW|RECONCILE|COMPLETE>
Current branch: <id + name>
Resolved this turn: <decision ids or none>
Blocked by: <dependencies or none>
Next branch: <id + name>
Shared understanding: <0-100%>
```

## Minimal Branch Ledger Format

Use this compact ledger internally and expose when useful:

```markdown
| Branch | Status | Depends On | Decision |
|--------|--------|------------|----------|
| B0 Goal | decided | - | ... |
| B1 Constraints | decided | B0 | ... |
| B4 Architecture | open | B0,B1,B2,B3 | - |
```

## Exit Conditions

Do not exit interview mode early unless user explicitly requests to stop.
If user requests summary midstream, summarize and continue at next unresolved dependency.

## In This Reference

| File | Purpose |
|------|---------|
| [decision-branches.md](./references/decision-branches.md) | Canonical branch tree, dependency order, and branch-specific probe questions |
