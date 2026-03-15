# Issue Template

Fill this template with investigation results from Steps 1-2. Create via `gh issue create`.

## gh Command

```bash
gh issue create \
  --title "Bug: [one-line description of the problem]" \
  --body "$(cat <<'EOF'
[filled template below]
EOF
)"
```

Add `--label "bug"` if the label exists. Omit rather than failing.

## Template

```markdown
## Problem

- **Actual behavior**: [what happens]
- **Expected behavior**: [what should happen]
- **Reproduction**: [steps to reproduce, if applicable]

## Root Cause Analysis

[What was found during investigation]

- The code path involved (describe by module/behavior, not file paths)
- Why the current code fails
- Contributing factors (recent changes, missing edge case handling, etc.)

## TDD Fix Plan

1. **RED**: Write a test that [expected behavior description]
   **GREEN**: [Minimal change to make it pass]

2. **RED**: Write a test that [next behavior]
   **GREEN**: [Minimal change to make it pass]

**REFACTOR**: [Cleanup needed after all tests pass, if any]

## Acceptance Criteria

- [ ] [Criterion 1 — observable behavior]
- [ ] [Criterion 2 — observable behavior]
- [ ] All new tests pass
- [ ] Existing tests still pass
```
