---
name: fp-implement
description: Find, claim, and complete work on fp issues with session handoff. Activate when the user says "work on issue", "pick up task", "what should I work on", "use fp", or "tackle next task". Not for planning or reviewing.
metadata:
  fp_skill_version: "1.0.0"
  fp_bundle_version: "2026-02-23"
  fp_cli_min: "0.14.0"
---

# FP Implement

Find, claim, and complete work on fp issues.

> **Activation guard:** Only run when the user asks to work on, resume, or find a task. If the user says "use fp" without specifying a phase, ask: plan, implement, or review?

## Prerequisites

```bash
fp --version    # Must be installed
fp tree         # Must be initialized
```

If `fp` is not installed: `curl -fsSL https://setup.fp.dev/install.sh | sh -s`
If project is not initialized: `fp init`

## Workflow

```
1. Find work     → fp tree --status todo
2. Claim work    → fp issue update --status in-progress <ID>
3. Do work       → implement (with tdd, feedback-loop as appropriate)
4. Comment often → fp comment <ID> "progress update"
5. Complete      → fp issue update --status done <ID>
```

## Decision Tree

```
What does the user want?
├─ "What should I work on?"          → Find Work (below)
├─ "Work on <ID>"                    → read references/claim-and-work.md
├─ "Continue work" / "Resume"        → read references/resume-work.md
├─ "Tackle next task in <epic>"      → read references/session-handoff.md
├─ "I'm done with <ID>"             → Complete (below)
└─ "This task is too big"            → read references/break-down.md
```

### Find Work

```bash
fp tree --status todo          # See available tasks with hierarchy
fp issue list --status todo    # Flat list of available tasks
```

Pick tasks that: have status `todo`, have all dependencies `done`, and match the current focus. Present options to the user. Let them choose.

### Complete

```bash
fp issue update --status done <ID>
fp comment <ID> "Completed. <summary of what was done and key decisions>"
```

After completing, check if there are more tasks ready:

```bash
fp tree --status todo
```

If more work exists in the same epic, suggest the user run `/clear` then resume with: "use fp. tackle the next task in \<epic\>". This prevents context rot across sessions.

## Non-Negotiable Acceptance Criteria

- [ ] Issue status is `in-progress` before any implementation starts
- [ ] A comment is posted when work begins, at each milestone, and on completion
- [ ] All dependencies are `done` before claiming a blocked task
- [ ] `fp issue update --status done` is called when work finishes
- [ ] User confirms which task to work on — never auto-pick
- [ ] Before ending a session: commit code, post a summary comment, mark done or capture state

## Composes With

| Skill | Relationship |
|-------|-------------|
| `fp-plan` | **Previous phase** — creates the issues worked on here |
| `fp-review` | **Next phase** — reviews code after implementation |
| `tdd` | Use for tasks that need tests. Claim the issue first, then follow TDD's red-green-refactor cycle. |
| `feedback-loop` | Use when validation is unclear. Run feedback-loop within the context of a claimed fp issue. |
| `github-triage` | Issues marked `ready-for-agent` can be imported into fp and worked on. |
| `vcs-detect` | Run before committing to detect whether the project uses git or jj. |

## In This Reference

| File | One Job |
|------|---------|
| [claim-and-work.md](references/claim-and-work.md) | Claim an issue and implement it |
| [resume-work.md](references/resume-work.md) | Resume previous in-progress work |
| [break-down.md](references/break-down.md) | Split a large task into sub-issues |
| [session-handoff.md](references/session-handoff.md) | Clean session boundaries to prevent context rot |
