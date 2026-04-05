# Regression Triage

Isolate and eliminate negative deltas (skill-on < skill-off).

## Steps

*(Low freedom — follow exactly)*

1. **Isolate.** From benchmark matrix, find the exact (model, scenario, criterion) with a negative delta. Re-run that single scenario 2× to confirm it is not noise.
2. **Locate cause.** Read the skill text the model received. Identify the instruction line causing confusion. Classify using the table below.
3. **Fix and verify.** Rewrite the offending line. Re-run isolated scenario — delta must be ≥0. Then broad-rerun all scenarios to check for collateral.

## Non-Negotiables

- Regression confirmed with ≥2 runs (not a single flaky result).
- Root cause documented (which line, which category).
- Post-fix delta ≥0 on the affected scenario.
- No new regressions on any other scenario.

## Cause Categories

| Category | Example | Fix |
|----------|---------|-----|
| Instruction collision | Two rules contradict | Make one an explicit exception of the other |
| Optional on mandatory | "Include refs when relevant" | "Include `Refs: <url>`. Do not omit." |
| Over-broad suppression | "Be concise" kills needed detail | Add "except for X, Y which must be detailed" |
| Bad example default | Edge-case shown as typical | Replace with typical-case, add edge-case separately |

## Output

```markdown
## Regression Fix: {skill-name} — {date}

### Isolated Regression
- Model: {model}
- Scenario: {scenario}
- Criterion: {criterion}
- Delta: {negative value} (confirmed over {N} runs)

### Root Cause
- Category: {collision | optional-mandatory | over-broad | bad-example}
- Line: `{exact text}`
- Why: {one sentence}

### Fix
```diff
- {old line}
+ {new line}
```

### Verification
- Affected scenario delta: {now ≥0}
- Broad rerun regressions: {none | list}
```

## Example

**Input:** Skill `code-review` causes Haiku to skip security checks (delta −2).

**Diagnosis:** Line "Focus on readability and maintainability" (over-broad suppression — Haiku interprets as "skip security").

**Fix:**
```diff
- Focus on readability and maintainability
+ Check for: security vulnerabilities, readability, maintainability. Do not skip any category.
```

**Result:** Security check delta goes from −2 to +1. No collateral regressions.
