---
name: prd-discover
description: Extract a validated problem brief through user interview and codebase exploration. Activate ONLY when the user says "new PRD", "plan a feature", or "write a PRD". Not for implementation specs, bug triage, or general feature discussion.
---

# PRD Discover

Extract the real problem before anyone talks about solutions. This skill produces one artifact: a problem brief that grounds every downstream decision.

> **Activation guard:** Only run this skill when the user explicitly requests a PRD. Do not activate on general feature discussions, bug reports, or implementation questions.

## Step 1: Interview the User About the Problem

Ask these five questions. Do NOT proceed until all five have answers.

1. **Who is struggling?** — Name the specific user or persona.
2. **What is the pain?** — Describe from the user's perspective, not the team's.
3. **What happens today?** — Current workaround, manual process, or nothing.
4. **Why now?** — What changed that makes this urgent.
5. **Any solution ideas?** — Capture verbatim, but tag as `[SOLUTION IDEA]`.

If the user leads with a solution ("build feature X"), redirect:

> "Before we go there — what user problem does X solve? Who experiences it? What do they do today without it?"

Do not accept "users want X" as a problem statement. Probe: *"What evidence do we have that this solves a real problem?"*

## Step 2: Explore the Codebase

Scan the repository for context relevant to the problem:

1. **Architecture:** modules, data models, API surface affected
2. **Existing patterns:** how similar features are built today
3. **Constraints:** technical debt, dependencies, or limitations
4. **Prior art:** has something like this been attempted before?

Report findings to the user. If greenfield with no codebase, skip to Step 3.

## Step 3: Produce the Problem Brief

Create the output directory and write the artifact:

```bash
mkdir -p /tmp/prd-{name}
```

Copy the template from [assets/problem-brief-template.md](assets/problem-brief-template.md) and fill every section from the interview and codebase exploration.

## Non-Negotiable Acceptance Criteria

The problem brief is NOT complete unless ALL of these are true:

- [ ] Problem stated from the user's perspective — not the team's or a stakeholder's
- [ ] No solution presented as a requirement — all tagged `[SOLUTION IDEA]`
- [ ] "Who" names a specific user or persona — not "users" generically
- [ ] "Why Now" has a concrete trigger — not "it would be nice"
- [ ] Codebase context section exists (or explicitly marked "greenfield")
- [ ] The brief fits on one page — if it doesn't, the problem is not focused enough

## Output

- **Artifact:** `/tmp/prd-{name}/problem-brief.md`
- **Next skill:** `prd-interview`
