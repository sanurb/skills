---
name: fp-review
description: Review code changes, assign commits to issues, leave structured feedback, and create stories. Activate when the user says "review code", "assign commits", "create a story", "use fp", or "prepare for review". Not for planning or implementing tasks.
metadata:
  fp_skill_version: "1.0.0"
  fp_bundle_version: "2026-02-23"
  fp_cli_min: "0.14.0"
---

# FP Review

Review code, assign commits to issues, leave structured feedback, and create stories.

> **Activation guard:** Only run when the user asks to review, assign commits, or create a story. If the user says "use fp" without specifying a phase, ask: plan, implement, or review?

## Prerequisites

```bash
fp --version    # Must be installed
fp tree         # Must be initialized
```

If `fp` is not installed: `curl -fsSL https://setup.fp.dev/install.sh | sh -s`
If project is not initialized: `fp init`

## Decision Tree

```
What does the user want?
├─ "Review <ID>"                    → Review Workflow (below)
├─ "Review the whole feature"       → Review parent: fp issue diff <PARENT-ID> --stat
├─ "Assign commits to <ID>"        → read references/assign-commits.md
├─ "Create a story for <ID>"       → read references/stories.md
├─ "What's ready for review?"      → fp issue list --status done
└─ "Review working copy"           → fp review (no issue needed)
```

## Review Workflow

### Step 1: Check Assignments

```bash
fp issue files <ID>
```

If empty, commits are not yet assigned. Read [references/assign-commits.md](references/assign-commits.md).

### Step 2: View the Diff

```bash
fp issue diff <ID> --stat   # Overview of files changed
fp issue diff <ID>           # Full diff
fp review <ID>               # Open interactive review in desktop app
```

For parent issues, the diff aggregates all descendant changes — review an entire feature at once:

```bash
fp issue diff <PARENT-ID> --stat   # All changes across the epic
fp review <PARENT-ID>              # Interactive review of all children
```

### Step 3: Leave Comments

Use `fp comment` with file references and severity prefixes:

```bash
fp comment <ID> "[blocker] **src/auth.ts**: Missing input sanitization — SQL injection risk."
fp comment <ID> "[suggestion] **src/utils.ts:23**: Use optional chaining for cleaner code."
fp comment <ID> "[nit] **README.md**: Typo in setup instructions."
```

| Prefix | Meaning |
|--------|---------|
| `[blocker]` | Must fix before merging |
| `[suggestion]` | Recommended improvement |
| `[nit]` | Minor/cosmetic issue |

**Comment format:** `**filepath**: comment` or `**filepath:line**: comment` or `**filepath:start-end**: comment`

### Step 4: After Review

Depending on the outcome:

| Result | Action |
|--------|--------|
| All clear, no blockers | Tell user: ready to merge or continue to next task |
| Blockers found | Reopen the issue: `fp issue update --status in-progress <ID>`, then fix. Use `fp-implement` to resume. |
| Needs QA | Suggest the user runs `qa` skill to file structured bug reports |

## Non-Negotiable Acceptance Criteria

- [ ] Commits are assigned before reviewing diffs — verify with `fp issue files <ID>`
- [ ] User confirms commit assignment before it is applied
- [ ] Every blocker comment uses the `[blocker]` prefix
- [ ] Review working copy with `fp review` when user has not committed
- [ ] Stories use past-tense headings and lead with the user problem
- [ ] Parent diff aggregation is used for feature-level review, not per-task only

## Composes With

| Skill | Relationship |
|-------|-------------|
| `fp-implement` | **Previous phase** — produces the code reviewed here |
| `fp-plan` | View the full plan hierarchy during review: `fp tree <PLAN-ID>` |
| `vcs-detect` | Run before discovering commits to detect git vs jj |
| `qa` | After review, use for structured bug reporting sessions |
| `tdd` | Check test coverage during review — are acceptance criteria tested? |

## In This Reference

| File | One Job |
|------|---------|
| [assign-commits.md](references/assign-commits.md) | Match and assign commits to issues |
| [stories.md](references/stories.md) | Create narrative review documents |
