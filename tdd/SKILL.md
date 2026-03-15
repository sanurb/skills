---
name: tdd
description: Build features or fix bugs using strict red-green-refactor TDD with vertical slices. Use when the user wants test-first development, mentions "red-green-refactor", wants integration-style tests, or asks to build something with TDD. Do NOT use for writing tests after implementation, adding tests to untested legacy code retroactively, or pure unit testing of isolated functions.
---

# Test-Driven Development

Strict red-green-refactor in vertical slices. One test, one implementation, repeat. Never all tests first.

**Critical anti-pattern — horizontal slicing:** Writing all tests first then all implementation produces tests that verify _imagined_ behavior, not _actual_ behavior. Tests become insensitive to real changes. Always vertical: one RED→GREEN cycle at a time, each informed by what the previous cycle revealed.

```
WRONG (horizontal):   RED: test1,test2,test3  →  GREEN: impl1,impl2,impl3
RIGHT (vertical):     RED→GREEN: test1→impl1  →  RED→GREEN: test2→impl2  →  ...
```

## Instructions

### Step 1. Plan

Confirm with the user which behaviors to test. Ask ONE question:

> "What should the public interface look like, and which behaviors are most important to test?"

From the answer, produce an ordered list of behaviors (not implementation steps). Prioritize critical paths and complex logic. Design interfaces for testability — see [interface-design.md](references/interface-design.md).

Do NOT proceed until the user approves the behavior list.

### Step 2. RED-GREEN loop

Execute one cycle at a time. For each behavior:

1. **RED**: Write one test that verifies the behavior through the public interface. Confirm it fails.
2. **GREEN**: Write the minimal code to make that test pass. No more.

First cycle is the tracer bullet — proves the path works end-to-end. Each subsequent cycle adds one behavior.

Mock only at system boundaries (external APIs, databases, time/randomness). See [mocking.md](references/mocking.md) for guidelines. For good vs bad test examples, see [tests.md](references/tests.md).

### Step 3. Refactor

After all tests pass, look for cleanup: extract duplication, deepen modules (move complexity behind simple interfaces), apply SOLID where natural. See [refactoring.md](references/refactoring.md).

Run tests after each refactor step. Never refactor while RED.

## Non-Negotiable

- Tests verify behavior through public interfaces, not implementation details.
- Vertical slices only: one RED→GREEN per cycle. Never all tests first.
- Tests must survive internal refactors — if renaming a function breaks a test, the test was wrong.
- Minimal code per GREEN — only enough to pass the current test.
- Never refactor while RED — get to GREEN first.
- Must confirm behavior list with user before starting (do not test imagined behavior).

## Output

Per cycle:

```
RED:   [test name] — [behavior it verifies] → FAIL
GREEN: [change made] → PASS
```

After all cycles:

```
REFACTOR: [what was cleaned up]
All tests passing: [N] tests
```

## References

| File | When to read |
|------|-------------|
| [tests.md](references/tests.md) | Step 2 (good vs bad test examples) |
| [mocking.md](references/mocking.md) | Step 2 (when to mock, when not to) |
| [interface-design.md](references/interface-design.md) | Step 1 (designing testable interfaces) |
| [refactoring.md](references/refactoring.md) | Step 3 (refactor candidates after GREEN) |
