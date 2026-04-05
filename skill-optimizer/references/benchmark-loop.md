# Benchmark Loop

**One job:** Produce a with/without-skill measurement matrix across models or agents.

## Steps

*(Low freedom — follow exactly)*

1. **Define matrix.** Pick ≥2 models/agents (e.g., Sonnet + Haiku, or Claude + Gemini). Pick ≥3 scenarios from Step 0 evals.
2. **Run evals.** For each (model × scenario): run WITHOUT skill, run WITH skill. Record per-criterion pass/fail and overall score (0–10).
3. **Fill the output template.** Flag universal failures and regressions.

## Non-Negotiables

- ≥2 models/agents evaluated.
- ≥3 scenarios tested.
- Both with-skill AND without-skill runs for every cell.
- Delta column computed (`with − without`). No missing cells.

## Output

```markdown
## Benchmark: {skill-name} — {date}

| Model/Agent | Scenario | Without | With | Delta |
|-------------|----------|---------|------|-------|
| {A}         | {S1}     | {score} | {score} | {+/-} |
| {B}         | {S1}     | {score} | {score} | {+/-} |

Universal failures (0% with skill): {list or "none"}
Regressions (negative delta): {list or "none"}
```

## Reading the Matrix

| Pattern | Action |
|---------|--------|
| High baseline, tiny delta | Model already knows this — reduce verbosity or specialize edge-cases |
| Low baseline, high delta | Skill adds strong value — preserve and refine |
| Low baseline, low skill-on | Skill text is weak — apply activation-design.md |
| Negative delta | Skill confuses model — apply regression-triage.md immediately |

## Validation Methods

Use these LLM-assisted checks alongside numeric scoring. Paste the prompts below into a fresh agent session.

### Discovery validation

Test whether the description triggers correctly and does not false-trigger:

> Given this skill metadata, generate 3 prompts that SHOULD trigger it and 3 that should NOT. Critique the description — is it too broad? Suggest a rewrite.

### Logic validation

Feed the full SKILL.md + directory tree to an agent and ask it to simulate execution:

> Act as an agent that just triggered this skill. Simulate step-by-step execution. For each step: (1) what are you doing, (2) which file are you reading/running, (3) flag any line where you are forced to guess because the instructions are ambiguous.

### Edge-case testing

Ask an agent to attack the skill logic:

> Act as a QA tester. Ask 3-5 highly specific questions about edge cases, failure states, or missing fallbacks in this SKILL.md. Do not fix — just ask the questions.

## Example

**Input:** skill `commit-format` tested on Haiku + Sonnet, 3 scenarios.

**Output:**
```markdown
## Benchmark: commit-format — 2026-04-05

| Model  | Scenario       | Without | With | Delta |
|--------|----------------|---------|------|-------|
| Haiku  | simple-commit  | 4       | 8    | +4    |
| Haiku  | merge-commit   | 3       | 7    | +4    |
| Haiku  | noisy-context  | 2       | 5    | +3    |
| Sonnet | simple-commit  | 7       | 9    | +2    |
| Sonnet | merge-commit   | 6       | 8    | +2    |
| Sonnet | noisy-context  | 5       | 7    | +2    |

Universal failures (0% with skill): none
Regressions (negative delta): none
```
