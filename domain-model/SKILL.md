---
name: domain-model
description: Stress-test a plan against the domain model. Interrogates ambiguous terms, verifies claims against code, and updates CONTEXT.md, CONTEXT-MAP.md, and docs/adr/ inline. Do NOT use for greenfield ideation, code review, or AGENTS.md.
disable-model-invocation: true
---

# Domain Model

## Purpose

Run a relentless interview that walks every branch of a proposed plan, sharpens the ubiquitous language, and pins decisions into durable artifacts. Treat the project's existing language as the source of truth; force alignment or deliberate change.

## Instructions

**Step 1 — Discover.** Read `CONTEXT-MAP.md` at repo root if present, otherwise root `CONTEXT.md`. Walk the dependency tree of the plan. Ask ONE question at a time and wait for the answer. If a question can be resolved by reading the codebase, read the codebase instead of asking. State a recommended answer with every question.

**Step 2 — Challenge.** On every user statement, apply the moves in this table. Surface conflicts the moment they appear; never batch them.

| Move | Trigger | Action |
|------|---------|--------|
| Glossary conflict | User term disagrees with `CONTEXT.md` | Quote both, ask which one wins |
| Fuzzy term | Overloaded word (e.g. "process", "user") | Propose canonical name, ask to confirm |
| Concrete scenario | Boundary between two concepts is implicit | Invent an edge case that forces a choice |
| Code contradiction | Stated behaviour differs from code | Read the code, surface the contradiction |

**Step 3 — Persist.** As decisions crystallise, route each one with this table. Create files lazily — write only when there is something to record. Follow the schemas in `references/` exactly.

| Decision type | Target file | Schema |
|---------------|-------------|--------|
| Term resolved | `CONTEXT.md` (root or `src/<context>/`) | [references/context-format.md](./references/context-format.md) |
| Context relationship resolved | `CONTEXT-MAP.md` (root) | [references/context-map-format.md](./references/context-map-format.md) |
| Decision passing all 3 ADR triggers | `docs/adr/NNNN-<slug>.md` | [references/adr-format.md](./references/adr-format.md) |

ADR triggers (ALL three required): hard to reverse · surprising without context · real trade-off.

## Non-Negotiable Acceptance Criteria

Deliver nothing if any criterion fails.

1. Questions asked ONE at a time. Each waits for the user's answer.
2. Every term in `CONTEXT.md` is domain-specific. General programming concepts (timeouts, retries, utility patterns) are excluded.
3. Every glossary conflict, fuzzy term, and code contradiction is surfaced the moment it appears.
4. ADRs created only when ALL three triggers hold. Decisions failing any trigger produce no ADR.
5. Files created lazily. No empty `CONTEXT.md`. No empty `docs/adr/` directory.
6. Artifact formats follow the three reference schemas exactly.
7. Single-context repos use root `CONTEXT.md`. Multi-context repos use root `CONTEXT-MAP.md` plus `src/<context>/CONTEXT.md` per context.
8. The session-end footer (see `## Output`) is returned every time, with `none` used explicitly when a list is empty.

## Output

The skill produces two artifacts: mutated domain files in the repo and a session-end footer in this exact output format. After the session, the on-disk layout is one of:

Single-context repo:

```
/
├── CONTEXT.md
├── docs/adr/0001-<slug>.md
└── src/
```

Multi-context repo:

```
/
├── CONTEXT-MAP.md
├── docs/adr/                        # system-wide decisions
└── src/
    ├── <context-a>/
    │   ├── CONTEXT.md
    │   └── docs/adr/                # context-specific decisions
    └── <context-b>/
        ├── CONTEXT.md
        └── docs/adr/
```

Return to the caller verbatim, in this exact format:

```
CONTEXT_FILES_TOUCHED: <comma-separated relative paths, or "none">
ADRS_CREATED: <comma-separated relative paths, or "none">
OPEN_QUESTIONS: <numbered list, or "none">
```

## In This Skill

| File | Purpose |
|------|---------|
| [references/context-format.md](./references/context-format.md) | `CONTEXT.md` schema, term rules, example dialogue |
| [references/context-map-format.md](./references/context-map-format.md) | `CONTEXT-MAP.md` schema for multi-context repos |
| [references/adr-format.md](./references/adr-format.md) | ADR template, numbering, qualifying decisions |
