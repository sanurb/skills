## Skill Optimization Report: {skill-name}

### Structural Validation
- validate.sh: {PASS | FAIL with details}

### Eval Scenarios
1. {scenario}: {what it tests}
2. {scenario}: {what it tests}
3. {scenario}: {what it tests}

### Baseline (without skill)
| Model/Agent | S1 | S2 | S3 |
|-------------|----|----|-----|
| {A}         | {score} | {score} | {score} |
| {B}         | {score} | {score} | {score} |

### With Skill
| Model/Agent | S1 | S2 | S3 |
|-------------|----|----|-----|
| {A}         | {score} | {score} | {score} |
| {B}         | {score} | {score} | {score} |

### Deltas
| Model/Agent | S1 | S2 | S3 |
|-------------|----|----|-----|
| {A}         | {+/-} | {+/-} | {+/-} |
| {B}         | {+/-} | {+/-} | {+/-} |

### Diagnosis
- Pattern: {universal failure | model-specific | regression | context rot}
- Root cause: {one sentence}

### Fix Applied
{exact diff or description}

### Post-Fix Verification
| Model/Agent | Before Fix | After Fix | Delta |
|-------------|-----------|-----------|-------|
| {A}         | {score}   | {score}   | {+/-} |

### Gate: {PASS | FAIL}
