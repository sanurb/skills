---
name: github-triage
description: Triage GitHub issues through a label-based state machine with interactive grilling sessions. Activate when the user says "triage issues", "review incoming issues", or "what needs triage". Not for creating issues, writing code, or PR reviews.
allowed-tools: Read Grep Glob Bash
---

# GitHub Issue Triage

Triage issues in the current repo using a label-based state machine. Infer the repo from `git remote`. Use `gh` for all GitHub operations.

> **Activation guard:** Only run when the user explicitly requests issue triage. Do not activate on general issue discussion, code reviews, or implementation requests.

## Labels

| Label | Type | Meaning |
|-------|------|---------|
| `bug` | Category | Something is broken |
| `enhancement` | Category | New feature or improvement |
| `needs-triage` | State | Maintainer must evaluate |
| `needs-info` | State | Waiting on reporter |
| `ready-for-agent` | State | Fully specified, ready for AFK agent |
| `ready-for-human` | State | Requires human implementation |
| `wontfix` | State | Will not be actioned |

Every issue must have exactly **one** state label and **one** category label. If conflicting state labels exist, flag the conflict and ask the maintainer before proceeding.

## State Machine

| From | To | Trigger | Action |
|------|----|---------|--------|
| unlabeled | `needs-triage` | Skill (first look) | Apply label after presenting recommendation |
| unlabeled | `ready-for-agent` | Maintainer | Write agent brief, apply label |
| unlabeled | `ready-for-human` | Maintainer | Write human brief, apply label |
| unlabeled | `wontfix` | Maintainer | Close with comment (+ `.out-of-scope/` for enhancements) |
| `needs-triage` | `needs-info` | Maintainer | Post triage notes + questions for reporter |
| `needs-triage` | `ready-for-agent` | Maintainer | Write agent brief, apply label |
| `needs-triage` | `ready-for-human` | Maintainer | Write human brief, apply label |
| `needs-triage` | `wontfix` | Maintainer | Close with comment (+ `.out-of-scope/`) |
| `needs-info` | `needs-triage` | Skill (detects reply) | Surface to maintainer for re-evaluation |

An issue can only move along these transitions. Flag unusual overrides.

## Workflow Decision Tree

```
What does the maintainer want?
├─ "Show me what needs attention"    → Overview (below)
├─ "Let's look at #N"               → read references/triage-workflow.md
├─ "Move #N to <state>"             → Quick Override (below)
└─ "What's ready for agents?"       → Query: gh issue list --label ready-for-agent
```

### Overview

Query GitHub and present a summary in three buckets:

1. **Unlabeled issues** — never triaged. Show oldest first.
2. **`needs-triage` issues** — maintainer must evaluate. Oldest first.
3. **`needs-info` with new activity** — reporter replied since last triage notes.

For each issue: number, title, age, one-line summary. Let the maintainer pick which to dive into.

### Quick State Override

When the maintainer explicitly says "move #N to \<state\>":

1. Show confirmation: which labels added/removed, whether a comment or close happens.
2. On confirmation, apply. Skip grilling.
3. If moving to `ready-for-agent` without a prior grilling, ask if they want a brief agent brief.

## Triage a Specific Issue

Read [references/triage-workflow.md](references/triage-workflow.md) for the full step-by-step procedure.

## Non-Negotiable Acceptance Criteria

Every triage action must satisfy ALL of these:

- [ ] Maintainer sees a preview of labels and comments BEFORE anything is posted
- [ ] Every issue ends with exactly one state label and one category label
- [ ] No label is applied without maintainer confirmation
- [ ] Agent briefs follow the template in [assets/agent-brief-template.md](assets/agent-brief-template.md) — no file paths, no line numbers
- [ ] `needs-info` comments capture all grilling progress — no resolved question is lost
- [ ] `wontfix` enhancements produce a `.out-of-scope/` file — see [out-of-scope.md](references/out-of-scope.md)
- [ ] Resuming a previous session never re-asks resolved questions

## In This Reference

| File | One Job |
|------|---------|
| [triage-workflow.md](references/triage-workflow.md) | Step-by-step for triaging a single issue |
| [agent-brief.md](references/agent-brief.md) | How to write durable agent briefs |
| [out-of-scope.md](references/out-of-scope.md) | How the `.out-of-scope/` knowledge base works |
| [agent-brief-template.md](assets/agent-brief-template.md) | Copy-and-fill template for agent briefs |
| [needs-info-template.md](assets/needs-info-template.md) | Copy-and-fill template for needs-info comments |
