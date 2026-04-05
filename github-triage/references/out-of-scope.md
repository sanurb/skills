# Out-of-Scope Knowledge Base

**One job:** Maintain `.out-of-scope/` as institutional memory for rejected feature requests.

## Purpose

1. **Institutional memory** — why a feature was rejected, so reasoning is not lost.
2. **Deduplication** — surface prior rejections when similar requests arrive.

## Directory Structure

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

One file per **concept**, not per issue. Multiple issues for the same thing go in one file.

## File Format

Write in a readable style — short design document, not a database entry. Include code samples when they clarify the reasoning.

```markdown
# Dark Mode

This project does not support dark mode or user-facing theming.

## Why This Is Out of Scope

The rendering pipeline assumes a single color palette in `ThemeConfig`.
Supporting multiple themes would require a theme context provider,
per-component theme-aware resolution, and a persistence layer. This
is a significant change that does not align with the project's focus
on content authoring.

## Prior Requests

- #42 — "Add dark mode support"
- #87 — "Night theme for accessibility"
- #134 — "Dark theme option"
```

### File naming

Kebab-case concept name: `dark-mode.md`, `plugin-system.md`. Recognizable without opening.

### Writing the reason

The reason must be substantive — not "we don't want this" but **why**.

Good reasons reference: project scope/philosophy, technical constraints, strategic decisions.

Do not reference temporary circumstances ("we're too busy"). Those are deferrals, not rejections.

## When to Check

During triage Step 1 (Gather Context), read all `.out-of-scope/*.md` files. Match by concept similarity, not keyword — "night theme" matches `dark-mode.md`.

If there is a match, surface it: "This is similar to `.out-of-scope/dark-mode.md` — we rejected this before because [reason]. Do you still feel the same way?"

The maintainer may:
- **Confirm** → append new issue to "Prior Requests", close.
- **Reconsider** → delete/update the file, proceed with normal triage.
- **Disagree** → issues are related but distinct, proceed normally.

## When to Write

Only when an **enhancement** (not a bug) is rejected as `wontfix`:

1. Check if a matching `.out-of-scope/` file exists.
2. If yes: append new issue to "Prior Requests".
3. If no: create a new file with concept, decision, reason, first prior request.
4. Post a comment on the issue explaining the decision.
5. Close with the `wontfix` label.

## Updating or Removing

If the maintainer changes their mind: delete the file. Do not reopen old issues — they are historical records.
