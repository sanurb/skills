# Context Budget Optimization

Shrink skill token cost without losing behavior.

## Steps

*(Medium freedom — apply judgment on what to cut)*

1. **Audit every line.** For each line: "Does removing this change model behavior?" If no → cut it.
2. **Apply compression patterns** (below).
3. **Re-run benchmark.** Confirm no regressions. If a regression appears, restore only the line that caused it.

## Non-Negotiables

- Token count decreased (measure with `wc -w` before/after).
- Zero regressions on any benchmarked scenario.
- SKILL.md under 200 lines. Reference files under 150 lines each.
- No duplicated content across files.

## What to Keep

- Trigger lists
- Decision tables
- Short checklists (≤7 items)
- One integrated example per core capability
- Non-negotiable acceptance criteria

## What to Cut

Claude is already smart. Only add what it does not know.

- Background explanations for well-known concepts
- Duplicate examples teaching the same lesson
- Prose that restates what a checklist already says
- Rationale paragraphs (move to one section, cross-link)

## Compression Patterns

| Before | After |
|--------|-------|
| Paragraph explaining a rule | Bullet checklist |
| 3 similar examples | 1 example + annotated variants |
| Inline rationale per rule | One "Rationale" section at bottom |
| Deep detail in SKILL.md | Move to references/, link |

## Layering Rule

```
SKILL.md    →  Triggers, non-negotiables, workflow checklist, links
references/ →  Atomic procedures, examples, deep detail
```

Promote detail to SKILL.md ONLY when repeated eval failures prove it is being missed.

## Example

**Before** (287 words):
```markdown
## Error Handling
When you encounter an error in the application, it's important to handle
it properly. Errors can come from many sources including network failures,
invalid user input, and database timeouts. You should consider using...
[continues for 3 more paragraphs]
```

**After** (41 words):
```markdown
## Error Handling
1. Catch at the boundary (API handler, event listener). Do not catch inside business logic.
2. Log with structured context: `{ error, userId, action }`.
3. Return typed error responses. Do not expose stack traces.
```
