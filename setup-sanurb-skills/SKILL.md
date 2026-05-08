---
name: setup-sanurb-skills
description: Sets up an `## Agent skills` block in AGENTS.md/CLAUDE.md and `docs/agents/` so the engineering skills know this repo's issue tracker (GitHub, GitLab, fp, or local markdown), triage label vocabulary, and domain doc layout. Run before first use of `fp-plan`, `fp-implement`, `fp-review`, `to-issues`, `to-prd`, `triage`, `diagnose`, `tdd`, `improve-codebase-architecture`, or `zoom-out` — or if those skills appear to be missing context about the issue tracker, triage labels, or domain docs.
disable-model-invocation: true
---

# Setup Sanurb's Skills

## Purpose

Scaffold the per-repo configuration the engineering skills assume — issue tracker, triage label vocabulary, and domain doc layout — by inserting an `## Agent skills` block into `CLAUDE.md`/`AGENTS.md` and seeding three files under `docs/agents/`. This is what makes the rest of the skill set composable: `fp-plan`, `fp-implement`, `fp-review`, `to-issues`, `triage`, `diagnose`, `tdd`, `improve-codebase-architecture`, and `zoom-out` all read the same three files, so they speak the same vocabulary about THIS repo.

## Instructions

### 1. Discover the repo's starting state — read, don't ask

Collect facts BEFORE presenting a single decision:

- `git remote -v` and `.git/config` — GitHub remote? GitLab remote? Self-hosted?
- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section in either?
- `CONTEXT.md` and `CONTEXT-MAP.md` at the repo root.
- `docs/adr/` and any `src/*/docs/adr/` directories.
- `docs/agents/` — has this skill already produced output?
- `.scratch/` — sign that local-markdown issue tracking is already in use.
- `fp tree` (suppress errors) — sign that fp is initialised in this repo.

Do not propose anything yet. Just collect.

### 2. Walk three decisions one at a time, with detection-driven defaults

Present **Section A → wait for the user's answer → Section B → wait → Section C**. Never dump all three at once. Each section opens with a short explainer (assume the user does not know the term, why these skills need it, or what changes if they pick differently).

**Section A — Issue tracker.** Where issues live for this repo. Default by detection from Step 1:

- `git remote` points at GitHub → propose **GitHub** (uses `gh`). Seed: `references/issue-tracker-github.md`.
- `git remote` points at GitLab → propose **GitLab** (uses `glab`). Seed: `references/issue-tracker-gitlab.md`.
- `fp tree` returned a tree → propose **fp** (uses `fp issue ...`). Seed: `references/issue-tracker-fp.md`.
- `.scratch/` exists, or no remote → propose **Local markdown** under `.scratch/<feature-slug>/`. Seed: `references/issue-tracker-local.md`.
- Always also offer **Other** (Jira, Linear, etc.) — ask the user to describe the workflow in one paragraph; record it as freeform prose.

**Section B — Triage label vocabulary.** Five canonical roles: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Read: `references/triage-labels.md` for the seed table. Default each role's string to its name; ask the user if their tracker already uses different strings and map them. (For fp, state lives in the tree shape — the table maps idiomatically; see `references/issue-tracker-fp.md` for the divergence.)

**Section C — Domain docs.** Read: `references/domain.md` for the seed and consumer rules. Confirm layout:

- **Single-context** — one `CONTEXT.md` + `docs/adr/` at the repo root. Most repos.
- **Multi-context** — `CONTEXT-MAP.md` at the root pointing at per-context `CONTEXT.md` files. Default to single-context unless `CONTEXT-MAP.md` already exists.

After all three are answered, show the user the draft `## Agent skills` block and the three `docs/agents/*.md` file contents. Let them edit before writing.

### 3. Write the block and the three files

Pick the file: edit `CLAUDE.md` if it exists; else edit `AGENTS.md` if it exists; else ask the user which to create. Never create one when the other already exists.

If an `## Agent skills` block already exists in the chosen file, update it in place. Do not append a duplicate. Do not touch the surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary]. See `docs/agents/triage-labels.md`.

### Domain docs

[single-context | multi-context]. See `docs/agents/domain.md`.
```

Then write the three files under `docs/agents/`, seeded from the matching reference:

- `docs/agents/issue-tracker.md` ← copy from `references/issue-tracker-{github,gitlab,fp,local}.md`. For "Other" trackers, write from scratch using the user's description.
- `docs/agents/triage-labels.md` ← copy from `references/triage-labels.md` and fill in the user's mappings.
- `docs/agents/domain.md` ← copy from `references/domain.md`.

Then tell the user which engineering skills will now consume these files. Mention they can edit `docs/agents/*.md` directly later — re-running this skill is only necessary to switch issue trackers or restart from scratch.

## Non-Negotiable Acceptance Criteria

The skill delivers nothing if any of these fails:

- [ ] All Step-1 discovery (git remote, existing AGENTS/CLAUDE.md, existing `docs/agents/`, `.scratch/`, `fp tree`) completed BEFORE any decision was presented to the user.
- [ ] The three decisions were walked **one at a time** — Section A, then B, then C — never as a single dump.
- [ ] Each section opened with a short explainer aimed at a user who does not know the term.
- [ ] The default proposed for the issue tracker matches what was actually detected (GitHub remote → GitHub default; fp tree → fp default; etc).
- [ ] **Exactly ONE** of `CLAUDE.md` or `AGENTS.md` was edited. Never both. Never created the other when one already existed.
- [ ] An existing `## Agent skills` block was updated in place. No duplicate block was created. No surrounding sections were overwritten or reordered.
- [ ] All three files (`docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`, `docs/agents/domain.md`) exist after Step 3, even if the user accepted defaults verbatim.
- [ ] The user saw and approved the draft block + all three file contents BEFORE anything was written.
- [ ] No `CONTEXT.md`, `docs/adr/`, or `.scratch/` was created speculatively — those are produced by other skills lazily, not by this one.

## Output

Three artifact streams:

**Stream 1 — block** inserted in `CLAUDE.md` or `AGENTS.md` (whichever was already present), in this exact shape:

```markdown
## Agent skills

### Issue tracker

{one-line summary, e.g. "GitHub issues via `gh`."}. See `docs/agents/issue-tracker.md`.

### Triage labels

{one-line summary, e.g. "Five canonical roles, defaults verbatim."}. See `docs/agents/triage-labels.md`.

### Domain docs

{single-context | multi-context}. See `docs/agents/domain.md`.
```

**Stream 2 — three files** under `docs/agents/`:

- `docs/agents/issue-tracker.md` — seeded from `references/issue-tracker-{github,gitlab,fp,local}.md`, or written from scratch for "Other".
- `docs/agents/triage-labels.md` — seeded from `references/triage-labels.md`, with the user's mappings filled in.
- `docs/agents/domain.md` — seeded from `references/domain.md`.

**Stream 3 — confirmation message** listing the engineering skills that now read from these files: `fp-plan`, `fp-implement`, `fp-review`, `to-issues`, `to-prd`, `triage`, `diagnose`, `tdd`, `improve-codebase-architecture`, `zoom-out`. Note that re-running this skill is only needed to switch tracker / restart.
