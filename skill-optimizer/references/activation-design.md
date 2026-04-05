# Activation Design

Fix skill text so models actually follow the instructions.

## Steps

*(Low freedom — follow exactly)*

1. **List missed behaviors.** From benchmark matrix, extract every criterion scoring 0% or near-0% with skill enabled.
2. **Apply fix patterns** (below) to the specific lines causing low activation.
3. **Re-run failing scenarios only.** Confirm targeted criteria now pass.

## Non-Negotiables

- Every previously-missed behavior passes on ≥1 model after the fix.
- Zero fuzzy language in edited lines.
- ≥1 integrated example per core capability.
- Critical rules sit in a top-level numbered checklist, not buried in prose.

## Fix Patterns

### 1. Make triggers explicit

List concrete signals near the top of the skill:

```markdown
## When to Use
- CSV parsing, OAuth callback, Fastify plugin
- Timeout errors, backpressure, flaky tests
- Commit footer, schema output, endpoint response
```

### 2. Front-load non-negotiables

Move missed behaviors into a numbered checklist with imperative wording.

### 3. Add integrated examples

One example combining multiple rules in a realistic scenario — not a toy.

### 4. Replace fuzzy → strict wording

| Before | After |
|--------|-------|
| "consider using" | "use" |
| "you may want to" | "must" |
| "try to include" | "include" |
| "optionally add" | "add" |
| "when possible" | *(remove — always do it, or specify the exact condition)* |

## Example

**Before** (skill text, activation score 3/10):
```markdown
## Guidelines
- Consider adding a Refs footer when citing sources
- You may want to use conventional commit format
- Try to keep commits atomic
```

**After** (activation score 9/10):
```markdown
## Non-Negotiables
1. Include `Refs: <url>` footer on every commit that references an issue. Do not omit.
2. Use conventional commit format: `type(scope): description`.
3. One logical change per commit. If the diff touches unrelated files, split it.
```

**Why it works:** Numbered list (front-loaded), imperative verbs ("include", "use", "split"), exact format shown, no wiggle room.
