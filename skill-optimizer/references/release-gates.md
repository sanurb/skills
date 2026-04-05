# Release Gates

**One job:** Go/no-go decision before shipping a skill update.

## Steps

*(Low freedom — follow exactly)*

1. **Check MUST-PASS gates.** Every item must pass. Any failure = NO SHIP.
2. **Check SHOULD-PASS gates.** Failures do not block but must have a filed follow-up issue.
3. **Record the decision** using the output template.

## Non-Negotiables

- Every MUST-PASS gate checked and passes.
- Benchmark run log exists with date, matrix, and deltas.
- Every unresolved failure has a tracking issue.

## MUST-PASS Gates

```
Release Checklist:
- [ ] No universal 0% criteria with skill enabled
- [ ] No negative delta on any critical scenario
- [ ] Benchmark run recorded (date, matrix, deltas)
- [ ] SKILL.md links verified — no broken references
- [ ] Follow-up issues filed for every unresolved failure
- [ ] Tested with ≥2 models/agents (e.g., Sonnet + Gemini, or Claude + Codex)
```

## SHOULD-PASS Gates

```
- [ ] ≥1 measurable gain on a target weak model
- [ ] No context-size increase without measured benefit
- [ ] Validation script passes: `bash scripts/validate.sh <skill-path>`
```

## Output

```markdown
## Release Gate: {skill-name} — {date}

### MUST-PASS
- [x] No universal 0% criteria
- [x] No negative deltas
- [x] Benchmark logged
- [x] Links verified
- [x] Issues filed
- [x] Multi-model tested

### SHOULD-PASS
- [x] Gain on weak model: {model} +{delta}
- [ ] Context size: +{N} tokens (justified: {reason})

### Decision: {SHIP | NO-SHIP}
### Follow-ups: {issue links or "none"}
```

## Post-Ship

- Schedule rerun after next model update.
- Compare against prior run history.
- Prune stale guidance that no longer moves metrics.
