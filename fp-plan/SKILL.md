---
name: fp-plan
description: Create plans and break them down into trackable fp issue hierarchies with dependencies. Activate when the user says "create a plan", "break down feature", "use fp", or "structure this work". Not for implementing tasks or reviewing code.
metadata:
  fp_skill_version: "1.0.0"
  fp_bundle_version: "2026-02-23"
  fp_cli_min: "0.14.0"
---

# FP Plan

Create plans and break them down into trackable fp issue hierarchies.

> **Activation guard:** Only run when the user asks to plan, break down, or structure work. If the user says "use fp" without specifying a phase, ask: plan, implement, or review?

## Prerequisites

```bash
fp --version    # Must be installed
fp tree         # Must be initialized
```

If `fp` is not installed: `curl -fsSL https://setup.fp.dev/install.sh | sh -s`
If project is not initialized: `fp init`

## Core Concept

In fp, a plan is an issue with a comprehensive description and child issues with dependencies:

```
Plan (Parent Issue)
├── Task 1 (Child) ─ no deps, can start immediately
├── Task 2 (Child) ─ depends on Task 1
└── Task 3 (Child) ─ depends on Task 1, Task 2
```

Typical depth: 2-3 levels. Typical task count: 3-8 per plan.

## Workflow

```
1. Gather input       → user description, PRD, or spec
2. Create parent      → fp issue create --title "..."
3. Break into tasks   → fp issue create --parent <ID> --depends <IDs>
4. Verify with user   → fp tree <ID>
```

## Step 1: Gather Input

Determine the source of the plan:

```
Where does the input come from?
├─ User describes feature in conversation  → proceed to Step 2
├─ PRD exists (from prd-to-issues)         → read references/import-from-prd.md
├─ Spec exists (from spec-planner)         → extract goals and tasks from the spec
└─ User wants to think it through first    → suggest running interviewing-plans or spec-planner first
```

If the request is vague or underspecified, suggest the user runs `spec-planner` or `interviewing-plans` first to sharpen requirements before creating issues.

## Step 2: Create the Parent Issue

```bash
fp issue create \
  --title "Add user authentication system" \
  --description "Goals, technical approach, and success criteria"
```

Write descriptions following [references/task-descriptions.md](references/task-descriptions.md).

## Step 3: Break Into Sub-Tasks

For each task, create an issue with parent and dependencies:

```bash
fp issue create --title "Design data models" --parent <PLAN-ID>
fp issue create --title "Implement OAuth flow" --parent <PLAN-ID> --depends "<MODELS-ID>"
fp issue create --title "Add session management" --parent <PLAN-ID> --depends "<MODELS-ID>,<OAUTH-ID>"
fp issue create --title "Write tests" --parent <PLAN-ID> --depends "<SESSION-ID>"
```

**Dependency modeling:**
- **Serial:** Task B depends on Task A (`--depends`)
- **Parallel:** No dependencies (can run concurrently)
- **Fan-out/Fan-in:** Multiple dependencies from/to one task

## Step 4: Verify with User

```bash
fp tree <PLAN-ID>
```

Present the tree. Ask: granularity right? Dependencies correct? Split or merge? Iterate until approved.

## Non-Negotiable Acceptance Criteria

- [ ] Every task has `--parent` linking it to the plan
- [ ] Dependencies modeled explicitly with `--depends` — no implicit ordering
- [ ] Each task is atomic: completable in one focused session (1-3 hours)
- [ ] Each task has a description with what/why/done criteria
- [ ] `fp tree` output shown to user before plan is finalized
- [ ] No markdown checkbox lists — create proper sub-issues instead
- [ ] User approves the breakdown before it is considered complete

## Composes With

| Skill | Relationship |
|-------|-------------|
| `spec-planner` | Run before fp-plan to sharpen vague requirements |
| `interviewing-plans` | Run before fp-plan to resolve design decisions |
| `prd-to-issues` | Import PRD vertical slices as fp issues — see [import-from-prd.md](references/import-from-prd.md) |
| `fp-implement` | **Next phase** — pick up tasks created here |
| `tdd` | Tag tasks that need test-first approach in their description |

## Anti-Patterns

Read [references/anti-patterns.md](references/anti-patterns.md) for what NOT to do.

## In This Reference

| File | One Job |
|------|---------|
| [task-descriptions.md](references/task-descriptions.md) | How to write clear task descriptions |
| [anti-patterns.md](references/anti-patterns.md) | Common mistakes to avoid |
| [import-from-prd.md](references/import-from-prd.md) | Bridge PRD issues into fp hierarchy |
