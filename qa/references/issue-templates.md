# Issue Templates

Use exactly one template per issue. Agent must pass the self-check list in SKILL.md before filing.

## Single Issue

Use when: one behavior is wrong, or all symptoms share the same root cause.

```md
## What happened

{Actual behavior in domain language. No file paths, no stack traces, no module names.}

## What I expected

{Specific expected behavior — never "it should work".}

## Steps to reproduce

1. {Action the user stated or confirmed}
2. {Domain terms, not module names}
3. {Include inputs, flags, or configuration}

**Frequency:** Every time / Intermittent / Once / Unknown

## Environment

{OS, browser, version, deploy target. Use "Not determined" if unknown — never omit.}

## Additional context

{Extra observations that help frame the issue. Omit section entirely if nothing to add.}
```

## Non-Reproducible Issue

Use when: user cannot provide concrete repro steps. File with `--label bug --label intermittent`.

```md
## What happened

{Actual behavior, as specific as the user can describe}

## What I expected

{Expected behavior}

## Reproduction attempts

- {What the user tried}
- {Under what conditions it appeared}
- {Frequency: "twice in the last week", "randomly after 10min idle", etc.}

## Environment

{OS, browser, version, deploy target — critical for intermittent bugs. Never omit.}

## Additional context

{Timing patterns, load conditions, anything that might help isolate.}
```

## Breakdown — Parent Issue

Use when: the report covers genuinely independent root causes — NOT multiple symptoms of one cause.

```md
## Summary

{One-paragraph overview of the full problem}

## Sub-issues

- [ ] #{number} — {one-line description}
- [ ] #{number} — {one-line description}
```

## Breakdown — Sub-Issue

File in dependency order so real issue numbers are available.

```md
## Parent issue

#{parent-number}

## What's wrong

{This specific behavior — just this slice}

## What I expected

{Expected behavior for this slice}

## Steps to reproduce

1. {Steps specific to THIS sub-issue}

**Frequency:** Every time / Intermittent / Once / Unknown

## Blocked by

#{issue-number} — {why this blocks}

Or: "None — can start immediately"
```

## Breakdown Decision

| Signal | Action |
|--------|--------|
| Multiple symptoms, one likely root cause | **Single issue.** List all symptoms under "What happened". |
| Genuinely independent failures in different areas | **Breakdown.** One sub-issue per independent root cause. |
| Unsure | **Single issue.** Developer splits later if needed. |

Default to single. Over-breakdown creates more noise than under-breakdown.

## Rejection Criteria

These mirror the self-check list in SKILL.md. If any fail, fix before filing.

| Check | Reject if |
|-------|-----------|
| Title | Generic ("Bug", "Broken", "Issue with X") or missing `[Area]` prefix |
| What happened | Contains file paths, line numbers, module names, stack traces, or internal error codes |
| What I expected | Vague — "should work", "should be fixed", "should be correct" |
| Steps to reproduce | Missing, unnumbered, or includes agent-inferred steps the user never stated |
| Environment | Section missing entirely |
| Body length | Over 300 words |
| Blocked by | References issue number that doesn't exist yet |
| Any section | Empty or contains "TBD" |
