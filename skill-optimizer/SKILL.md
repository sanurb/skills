---
name: skill-optimizer
description: Measure and fix AI skill activation, clarity, and cross-agent reliability. Use when skill uptake is weak, scores regress, or context is bloated. Not for writing new skills from scratch or general prompt engineering.
---

# Skill Optimizer

Restrict what the agent can do so what it does, it does well. This skill tightens the harness on any AI skill — measure, diagnose, fix.

## Target Skill

Identify the skill directory to optimize. If not obvious from context, ask the user which skill to optimize before proceeding.

## Quick Audit

Run the structural validator against the target skill before the full loop:

```bash
bash scripts/validate.sh <skill-path>
```

If validation fails, fix structural issues first. Do not start the benchmark loop on a broken skill.

## Workflow

Copy this checklist and track progress:

```
Optimization Progress:
- [ ] Step 0: Build eval scenarios (skip if evals exist)
- [ ] Step 1: Measure baseline and skill-on scores
- [ ] Step 2: Diagnose failure pattern
- [ ] Step 3: Apply fix from matched reference
- [ ] Step 4: Re-measure — confirm improvement, no regressions
- [ ] Step 5: Pass release gates before shipping
```

**Step 0: Build evals first** *(low freedom — follow exactly)*

Before touching skill text, create ≥3 eval scenarios:
- One per core capability the skill claims
- One stressing omission-prone sections (footers, checklists)
- One with noisy context (long conversation, irrelevant files loaded)

Run evals WITHOUT the skill. Record baseline scores. This is the ground truth.

**Step 1: Measure** *(low freedom)*

Read [references/benchmark-loop.md](references/benchmark-loop.md). Produce the benchmark matrix. Do not skip this.

**Step 2: Diagnose** *(use decision tree)*

```
What does the data show?
├─ Skill is ignored by models         → read references/activation-design.md
├─ Scores dropped after skill change  → read references/regression-triage.md
├─ Skill text too large / context rot → read references/context-budget.md
└─ All clear, ready to ship           → read references/release-gates.md
```

**Step 3: Apply fix** *(follow the matched reference — each is atomic, one job)*

**Step 4: Re-measure** *(low freedom — feedback loop)*

Re-run the SAME eval scenarios from Step 1:
- If improvement AND no regressions → proceed to Step 5
- If regression on ANY scenario → read references/regression-triage.md, fix, re-measure
- Max 3 iterations before escalating

**Step 5: Release gate** *(low freedom)*

Read [references/release-gates.md](references/release-gates.md). Ship only if all MUST-PASS gates clear.

## Non-Negotiable Acceptance Criteria

Deliver nothing if any criterion fails.

1. **Evals exist** — ≥3 scenarios with baseline scores before any edit
2. **Baseline recorded** — with-skill vs without-skill scores for ≥2 models/agents
3. **No regressions** — zero negative deltas on any scenario after the edit
4. **Imperative wording only** — zero instances of "consider", "you may want", "optionally"
5. **Integrated example present** — ≥1 realistic before/after example per core capability
6. **Output format defined** — every procedure produces a documented artifact
7. **Description front-loaded** — key use case in first 250 chars; includes negative triggers

## Output

Every optimization produces exactly this artifact. Copy the template from [assets/report-template.md](assets/report-template.md) and fill it in.

## In This Reference

| File | One Job |
|------|---------|
| [benchmark-loop.md](references/benchmark-loop.md) | Produce the measurement matrix |
| [activation-design.md](references/activation-design.md) | Fix skill text so models follow it |
| [context-budget.md](references/context-budget.md) | Shrink token cost without losing behavior |
| [regression-triage.md](references/regression-triage.md) | Isolate and eliminate negative deltas |
| [release-gates.md](references/release-gates.md) | Go/no-go checklist before shipping |
