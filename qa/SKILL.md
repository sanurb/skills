---
name: qa
description: Interactive QA session — user describes bugs conversationally, agent files GitHub issues with domain language and durable reproduction steps. Triggers on "QA session", "report bugs", "file issues", "QA mode".
---

# QA Session

User talks, you file. Convert each bug report into a durable GitHub issue written in the project's domain language. Issues must still make sense after a major refactor.

## Instructions

1. **Preflight (once).** Run `gh auth status` and verify CWD is a git repo. If either fails, stop and tell the user what to fix. Check if `UBIQUITOUS_LANGUAGE.md` exists — if so, load it as the term authority for the entire session. This step runs once, before the first report.

2. **Clarify.** Let the user describe the problem. Classify it:
   - **Bug** — behavior differs from intent → proceed.
   - **Feature request** — new behavior that never existed → tell the user this skill files bugs only. Suggest `gh issue create --label enhancement` manually. Do not file.
   - **Unclear** — ask one question: "Is this something that used to work correctly, or something new you'd like added?"
   
   For bugs, gather exactly three things: (a) what happened, (b) what they expected, (c) steps to reproduce. Ask 1–3 questions until you have all three. If the user cannot provide repro steps, ask: "Is this intermittent, environment-specific, or did it happen only once?" — use the answer to select the Non-Reproducible template. Never infer steps the user didn't state or explicitly confirm. If the user provides stack traces or code snippets, note the information internally but do not include it in the issue body.

3. **File.** Execute in this exact order — do not skip or reorder:
   - **Duplicate check:** `gh issue list --search "{2-3 keywords from the report}" --state open --limit 5`. If a likely match exists, show the user the URL and ask: "This looks related — same problem or different?" If same, do not file.
   - **Draft:** Write the issue body using [issue-templates.md](./references/issue-templates.md). Translate the user's language into domain terms from `UBIQUITOUS_LANGUAGE.md` when loaded. Write the title in format `[Area] wrong behavior description`.
   - **Self-check:** Re-read the draft against the Self-Check List (below). Fix any violation before proceeding.
   - **Create:** `gh issue create --title "{title}" --body "{body}" --label bug`. Add `--label intermittent` if non-reproducible. If `gh` fails, show the error and ask the user if they want to retry or skip.
   - **Confirm:** Print the issue URL. Ask: "Next issue, or are we done?" Repeat from step 2.

## Self-Check List

Before every `gh issue create`, verify all pass:

- [ ] Body contains zero file paths, zero line numbers, zero module names, zero stack traces, zero internal error codes.
- [ ] Title matches `[Area] description` format — not generic ("Bug", "Broken", "Issue").
- [ ] "What I expected" is specific — not "it should work" or "it should be fixed".
- [ ] Every repro step was stated or confirmed by the user — none inferred.
- [ ] Environment section present (use "Not determined" if unknown — never omit).
- [ ] Body is ≤ 300 words. If longer, cut to essential facts.

## Non-Negotiable Acceptance Criteria

- Preflight passes before any issue is filed. No exceptions.
- Every bug is duplicate-checked against open issues before filing. Duplicates shown to user, never silently filed.
- Classification gate: bugs only. Feature requests redirected. Ambiguous reports clarified before proceeding.
- Every issue has: what happened, what was expected, and repro steps or explicit "Non-reproducible: {reason}" with the Non-Reproducible template.
- Repro steps contain only user-stated or user-confirmed actions. Codebase knowledge informs your understanding — it never appears in the issue body.
- One canonical term per concept when `UBIQUITOUS_LANGUAGE.md` is loaded. When it isn't, normalize vague language ("the thing", "that screen", "it") to a concrete noun before writing.
- Breakdowns only when root causes are genuinely independent. Three symptoms of one cause = one issue. Default to single — a developer can split later.
- If `gh issue create` fails, surface the error. Never silently swallow a failed filing.

## Output

Artifact: GitHub issues created via `gh issue create --label bug`.
Format: [issue-templates.md](./references/issue-templates.md).
Inline: issue URL after each successful filing.
