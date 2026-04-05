---
name: prd-to-issues
description: Break a PRD into dependency-ordered vertical slice GitHub issues. Activate when the user says "break down PRD", "create issues from PRD", or "slice the PRD". Not for writing PRDs, triaging bugs, or creating non-implementation issues.
---

# PRD to Issues

Convert a PRD into independently-grabbable GitHub issues using thin end-to-end vertical slices (tracer bullets).

> **Activation guard:** Only run when the user explicitly asks to decompose a PRD into issues. Do not activate on general issue creation or bug triage requests.

## Step 1: Load the PRD and Explore

Locate the PRD. Ask the user for the GitHub issue number or read from `/tmp/prd-{name}/prd-draft.md`.

If the PRD is a GitHub issue, fetch it:

```bash
gh issue view <number>
```

Explore the codebase if not already familiar. Identify affected modules, integration layers, and existing patterns.

## Step 2: Draft and Validate Slices

Break the PRD into tracer bullet issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end.

**Slicing rules:**
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
- Mark each slice **AFK** (can be merged without human input) or **HITL** (requires a decision). Prefer AFK.

Present the proposed breakdown to the user as a numbered list:

| # | Title | Type | Blocked By | User Stories |
|---|-------|------|------------|-------------|
| 1 | {name} | AFK | — | US-1, US-3 |
| 2 | {name} | AFK | #1 | US-2 |
| 3 | {name} | HITL | #1 | US-4 |

Ask the user:
- Does the granularity feel right?
- Are the dependency relationships correct?
- Should any slices be merged or split?
- Are the HITL/AFK labels correct?

Iterate until the user approves.

## Step 3: Create GitHub Issues

For each approved slice, create a GitHub issue in dependency order (blockers first) so real issue numbers can be referenced.

Copy the template from [assets/issue-template.md](assets/issue-template.md) and fill it for each slice.

```bash
gh issue create --title "{Slice Title}" --body-file /tmp/prd-{name}/slice-{n}.md
```

Do NOT close or modify the parent PRD issue.

## Non-Negotiable Acceptance Criteria

The issue breakdown is NOT complete unless ALL of these are true:

- [ ] Every slice cuts end-to-end through all integration layers — no horizontal slices
- [ ] Every slice is independently demoable or verifiable
- [ ] Every slice has acceptance criteria traceable to the parent PRD
- [ ] Dependency order is explicit — no circular dependencies
- [ ] Every HITL slice names the decision and who makes it
- [ ] User has approved the breakdown before any issues are created
- [ ] Parent PRD issue is NOT modified or closed

## Output

- **Artifacts:** GitHub issues (one per slice)
- **Pipeline:** `prd-discover` → `prd-interview` → `prd-draft` → **this skill**
