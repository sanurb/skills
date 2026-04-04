---
name: prd-draft
description: Assemble a PRD from the problem brief and decision ledger, run quality gates, and publish as a GitHub issue. Use when drafting or publishing a PRD, or when user says "draft the PRD", "write it up", "publish the PRD". Use after prd-interview. Reads artifacts from prd-discover and prd-interview.
---

# PRD Draft

Assemble the PRD from validated artifacts, gate it for quality, and ship it. No creative writing. Every section is filled from the problem brief and decision ledger — if a section is empty, the upstream interview missed something.

## Step 1: Assemble the PRD

Read both artifacts:
- `/tmp/prd-{name}/problem-brief.md`
- `/tmp/prd-{name}/decision-ledger.md`

If either is missing, stop. Tell the user which upstream skill to run first.

Fill the template from [prd-template.md](./references/prd-template.md) by mapping:

| Template Section | Source |
|-----------------|--------|
| Problem Statement | Problem brief → Pain + Current State + Impact |
| Success Metrics | Decision ledger → B1 |
| User Stories | Synthesize from problem brief + B2 + B3 |
| Solution Approach + Key Decisions | Decision ledger → B3 |
| Modules | Decision ledger → B7 |
| Acceptance Criteria | Decision ledger → B5 (edge cases) + B1 (metrics) |
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
| API / platform | Full + add Interface Contract section (endpoints, schemas, versioning) |
| AI / agent product | Full + add Eval Framework, Guardrails, Model Dependency sections |

## Step 2: Run Quality Gates

Execute every check from [quality-gates.md](./references/quality-gates.md) against the draft.

**Blockers (must fix before publish):**
- Opens with features instead of problem → rewrite opening
- Success metric fails vanity test → revise with user
- Zero non-goals → go back and ask user
- Solution prescribed as requirement → rewrite as outcome
- Unresolved open question that blocks implementation → assign owner + deadline
- NFR uses adjective without number → quantify or remove

**Warnings (flag to user, publish if accepted):**
- Fewer than 3 edge cases
- Assumptions not explicitly labeled
- No rollout plan
- No considered-but-rejected alternatives

Present the draft to the user with gate results. Ask: *"Does this capture our shared understanding? Anything missing, wrong, or over-specified?"*

Iterate until user approves.

## Step 3: Publish as GitHub Issue

Execute: `gh issue create --title "{Feature Name} — PRD" --body-file /tmp/prd-{name}/prd-draft.md`

After creation, tell the user:
- The issue URL
- "Run `prd-to-issues` to break this into vertical slice implementation issues"

## Non-Negotiable Acceptance Criteria

The PRD is NOT ready to publish unless ALL of these are true:

- [ ] First section is the problem statement — not a feature description
- [ ] Every requirement traces to a user problem from the problem brief
- [ ] Every success metric is falsifiable — a post-launch data pull determines pass/fail
- [ ] At least 2 non-goals are stated explicitly
- [ ] At least 3 edge cases or failure scenarios have acceptance criteria
- [ ] Zero NFRs use adjectives without numbers
- [ ] Zero solutions disguised as requirements — every requirement states WHAT, not HOW
- [ ] Every assumption is labeled as an assumption, not stated as a fact
- [ ] Every open question has an owner and a deadline
- [ ] User has said "yes, publish it"

## Output

- **Artifact:** `/tmp/prd-{name}/prd-draft.md` + GitHub issue
- **Upstream:** `prd-discover` → `prd-interview` → **this skill**
- **Downstream:** `prd-to-issues` (breaks the PRD into implementation issues)
