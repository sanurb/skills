---
name: prd-draft
description: "Continuation skill: assemble a PRD from validated artifacts, run quality gates, and publish. Runs after prd-interview when both problem-brief.md and decision-ledger.md exist. Not for writing PRDs from scratch."
user-invocable: false
---

# PRD Draft

Assemble the PRD from validated artifacts, gate it for quality, and ship it. Every section is filled from the problem brief and decision ledger — if a section is empty, the upstream interview missed something.

> **Activation guard:** This is a continuation skill. Only run when both `/tmp/prd-{name}/problem-brief.md` and `/tmp/prd-{name}/decision-ledger.md` exist from prior pipeline runs. Do not activate independently.

## Step 1: Assemble the PRD

Read both artifacts:
- `/tmp/prd-{name}/problem-brief.md`
- `/tmp/prd-{name}/decision-ledger.md`

If either is missing, stop. Tell the user which upstream skill to run first.

Fill the template from [references/prd-template.md](references/prd-template.md) by mapping:

| Template Section | Source |
|-----------------|--------|
| Problem Statement | Problem brief → Pain + Current State + Impact |
| Success Metrics | Decision ledger → B1 |
| User Stories | Synthesize from problem brief + B2 + B3 |
| Solution Approach + Key Decisions | Decision ledger → B3 |
| Modules | Decision ledger → B7 |
| Acceptance Criteria | Decision ledger → B5 + B1 |
| Non-Functional Requirements | Decision ledger → B6 |
| Scope / Non-Goals | Decision ledger → B2 |
| Assumptions & Risks | Decision ledger → Assumptions + Deferred |
| Open Questions | Decision ledger → Deferred Decisions |
| Testing Strategy | Decision ledger → B7 |
| Rollout & Measurement | Decision ledger → B8 |

**Context adaptation** — adjust weight based on the project:

| Context | Action |
|---------|--------|
| Startup / early-stage | Keep only: Problem, Metrics, User Stories, Approach, Scope, Open Questions |
| Scale-up | Full template |
| Enterprise / regulated | Full + add compliance traceability |
| API / platform | Full + add Interface Contract section |
| AI / agent product | Full + add Eval Framework, Guardrails sections |

## Step 2: Run Quality Gates

Execute every check from [references/quality-gates.md](references/quality-gates.md) against the draft.

Present the draft to the user with gate results. Ask: *"Does this capture our shared understanding? Anything missing, wrong, or over-specified?"*

Iterate until the user approves.

## Step 3: Publish

Write the draft to `/tmp/prd-{name}/prd-draft.md`.

If the user wants a GitHub issue, execute:

```bash
gh issue create --title "{Feature Name} — PRD" --body-file /tmp/prd-{name}/prd-draft.md
```

After creation, tell the user the issue URL and suggest: "Run `prd-to-issues` to break this into vertical slice implementation issues."

## Non-Negotiable Acceptance Criteria

The PRD is NOT ready to publish unless ALL of these are true:

- [ ] First section is the problem statement — not a feature description
- [ ] Every requirement traces to a user problem from the problem brief
- [ ] Every success metric is falsifiable — a post-launch data pull determines pass/fail
- [ ] At least 2 non-goals stated explicitly
- [ ] At least 3 edge cases or failure scenarios with acceptance criteria
- [ ] Zero NFRs use adjectives without numbers
- [ ] Zero solutions disguised as requirements — every requirement states WHAT, not HOW
- [ ] Every assumption labeled as an assumption, not stated as fact
- [ ] Every open question has an owner and a deadline
- [ ] User has said "yes, publish it"

## Output

- **Artifact:** `/tmp/prd-{name}/prd-draft.md` + optional GitHub issue
- **Pipeline:** `prd-discover` → `prd-interview` → **this skill** → `prd-to-issues`
