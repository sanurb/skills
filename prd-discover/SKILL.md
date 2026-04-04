---
name: prd-discover
description: Extract a validated problem brief through user interview and codebase exploration. Use when starting a PRD, scoping a feature, or when user says "new PRD", "plan a feature", "write a PRD". Produces the artifact that prd-interview consumes.
---

# PRD Discover

Extract the real problem before anyone starts talking about solutions. This skill produces one artifact: a problem brief that grounds every downstream decision. If the problem is wrong, everything built on top is waste.

## Step 1: Interview the User About the Problem

Ask these five questions. Do NOT proceed until all five have answers.

1. **Who is struggling?** — Name the user or persona.
2. **What is the pain?** — Describe from the user's perspective, not the team's.
3. **What happens today?** — Current workaround, manual process, or nothing.
4. **Why now?** — What changed that makes this urgent.
5. **Any solution ideas?** — Capture verbatim, but tag as `[SOLUTION IDEA]` — these are NOT requirements.

If the user leads with a solution ("build feature X"), redirect:

> "Before we go there — what user problem does X solve? Who experiences it? What do they do today without it?"

Do not accept "users want X" as a problem statement. That is a request. Probe: *"What evidence do we have that this solves a real problem?"*

## Step 2: Explore the Codebase

Scan the repository for current state relevant to the problem:

1. Architecture: modules, data models, API surface affected
2. Existing patterns: how similar features are built today
3. Constraints: technical debt, dependencies, or limitations the user may not know about
4. Prior art: has something like this been attempted before?

Report findings to the user: "Here's what I found that's relevant to this problem..."

If this is a greenfield project with no codebase, skip to Step 3.

## Step 3: Produce the Problem Brief

Write the artifact to `/tmp/prd-{name}/problem-brief.md` where `{name}` is a kebab-case identifier derived from the feature name (confirm with user).

Execute: `mkdir -p /tmp/prd-{name}`

Use this exact format:

```markdown
# Problem Brief: {Feature Name}

**Date:** {YYYY-MM-DD}
**Author:** {user name or "user"}

## Who
{The user/persona experiencing the pain}

## Pain
{The problem from the user's perspective. Grounded in evidence, not opinion.}

## Current State
{What users do today — workaround, manual process, or absence}

## Why Now
{What changed that makes this worth solving}

## Impact
{Quantified if possible: time lost, error rate, churn signal, revenue at risk}

## Solution Ideas (Unvalidated)
{Captured verbatim from user. These are hypotheses, NOT requirements.}
- [SOLUTION IDEA] {idea 1}
- [SOLUTION IDEA] {idea 2}

## Codebase Context
{Summary of relevant findings from Step 2}
- **Affected areas:** {modules, files, APIs}
- **Existing patterns:** {how similar things are built}
- **Constraints discovered:** {tech debt, dependencies, limitations}
- **Prior art:** {previous attempts, if any}

## Stakeholders
{Who else has a stake in this that we should talk to}
```

## Non-Negotiable Acceptance Criteria

The problem brief is NOT complete unless ALL of these are true:

- [ ] Problem is stated from the user's perspective — not the team's, not a stakeholder's
- [ ] No solution is presented as a requirement — solution ideas are explicitly tagged `[SOLUTION IDEA]`
- [ ] "Who" names a specific user or persona — not "users" generically
- [ ] "Why Now" has a concrete trigger — not "it would be nice"
- [ ] Codebase context section exists (or explicitly marked "greenfield — no codebase")
- [ ] The brief fits on one page — if it doesn't, the problem isn't focused enough

## Output

- **Artifact:** `/tmp/prd-{name}/problem-brief.md`
- **Next skill:** `prd-interview` (reads this artifact)
