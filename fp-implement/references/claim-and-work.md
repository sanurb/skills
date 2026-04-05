# Claim and Work

Take an issue from `todo` to `done` with full progress tracking.

## Step 1: Claim the Issue

```bash
fp issue update --status in-progress <ID>
fp context <ID>
fp comment <ID> "Starting work. First step: <what you will do first>"
```

`fp context` loads the full issue details, description, and related context. Read it before implementing.

## Step 2: Implement

Choose the implementation approach based on the task:

| Task type | Approach |
|-----------|----------|
| Needs tests first | Use `tdd` skill — claim the fp issue first, then follow red-green-refactor |
| Validation is unclear | Use `feedback-loop` skill — define exit criteria, iterate |
| Straightforward change | Implement directly |

Comment at every key milestone:

```bash
fp comment <ID> "Completed schema design. Added User, Session models."
fp comment <ID> "Hit a snag: OAuth library missing refresh support. Investigating."
fp comment <ID> "Resolved: using custom refresh logic. Proceeding."
```

**When to comment:**
- When starting
- When completing a significant milestone
- When discovering important information
- When encountering and resolving problems
- When making a design decision (capture the rationale)

## Step 3: Complete

Commit all changes before marking done:

```bash
fp issue update --status done <ID>
fp comment <ID> "Task completed. <summary of what was built and key decisions>"
```

If more tasks exist in the same epic, suggest a clean session handoff — see [session-handoff.md](session-handoff.md).

## Checking Progress

```bash
fp issue diff <ID> --stat   # Files changed since task started
fp issue files <ID>          # List of changed files
fp issue diff <ID>           # Full diff
```

For parent issues, these aggregate all descendant changes:

```bash
fp issue diff <PARENT-ID> --stat
```
