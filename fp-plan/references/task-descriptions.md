# Task Descriptions

Write descriptions that make tasks self-contained and actionable.

## Template

```bash
fp issue create \
  --title "[Clear, specific title]" \
  --parent "<PLAN-ID>" \
  --depends "<IDS>" \
  --priority "<low|medium|high>" \
  --description "
What: [What needs to be done]
Why: [Context or rationale]
How: [Technical approach or key interfaces]
Files: [Key files to create or modify]
Done: [Definition of done — when is this task complete?]
"
```

## Rules

- **Title:** specific verb + noun. "Implement OAuth callback handler" not "Auth stuff".
- **What:** one sentence summarizing the deliverable.
- **Why:** link back to the parent goal or user problem.
- **How:** name key interfaces, types, or patterns. Do not prescribe file paths or line numbers — they go stale.
- **Files:** directories or file patterns, not exact paths with line numbers.
- **Done:** testable conditions. "All tests passing" not "it works".

## Example

```bash
fp issue create \
  --title "Implement session management" \
  --parent FP-abcd \
  --depends "FP-efgh,FP-ijkl" \
  --description "
What: Create session creation, validation, and cleanup logic.
Why: Users need persistent login across requests (parent: auth system).
How: JWT tokens stored in D1. Session validation middleware on protected routes.
Files: src/auth/session.ts, src/middleware/auth.ts
Done: Sessions persist across requests. Expired sessions are rejected. Cleanup runs on schedule.
"
```
