# Session Handoff

End a session cleanly so the next session starts fresh without context rot.

This is fp's killer feature. Agents degrade when context windows fill with stale conversation. Clean handoffs keep each session focused.

## When to Hand Off

- Task is complete (`done`) and more tasks exist in the epic.
- Session is getting long (compaction has fired, or context feels stale).
- Switching to a different area of work.

## Handoff Protocol

### Step 1: Commit and capture state

Commit all code changes. Use `vcs-detect` first to determine git vs jj:

```bash
# Git
git add -A && git commit -m "<descriptive message>"

# Jujutsu
jj describe -m "<descriptive message>"
```

### Step 2: Post a summary comment

```bash
fp comment <ID> "Session ending. State: <what is done, what remains, any blockers or decisions made>"
```

Include enough context that a fresh session can resume without re-reading the full conversation.

### Step 3: Mark status

- If task is complete: `fp issue update --status done <ID>`
- If task is mid-progress: leave as `in-progress` — the comment captures the state.

### Step 4: Guide the user

Tell the user:

> Session complete. To continue with the next task:
> 1. Run `/clear` to start fresh
> 2. Say: "use fp. tackle the next task in \<epic\>"

## Why This Matters

```
Session 1: Plan auth feature     → fp-plan creates 5 issues
Session 2: Implement OAuth       → fp-implement, claims FP-efgh, marks done
   /clear
Session 3: Implement sessions    → fp-implement, loads FP-mnop context fresh
   /clear
Session 4: Review all changes    → fp-review, aggregates diffs from parent
```

Each session loads only the context it needs via `fp context <ID>`. No stale conversation history. No context rot.

## Resuming in a New Session

When a user says "use fp. tackle the next task in \<epic\>":

1. Run `fp tree <EPIC-ID> --status todo` to find the next available task.
2. Follow the normal claim-and-work flow from [claim-and-work.md](claim-and-work.md).
