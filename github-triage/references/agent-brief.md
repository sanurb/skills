# Writing Agent Briefs

Write a structured comment on a GitHub issue that an AFK agent can work from without asking questions.

## Principles

### Durability over precision

The issue may sit in `ready-for-agent` for days or weeks. The codebase will change.

- **Do** describe interfaces, types, and behavioral contracts.
- **Do** name specific types, function signatures, or config shapes.
- **Do not** reference file paths — they go stale.
- **Do not** reference line numbers.

### Behavioral, not procedural

Describe **what** the system should do, not **how** to implement it.

- Good: "The `SkillConfig` type should accept an optional `schedule` field of type `CronExpression`"
- Bad: "Open src/types/skill.ts and add a schedule field on line 42"

### Complete acceptance criteria

Every criterion must be independently testable. The agent must know when it is done.

### Explicit scope boundaries

State what is NOT in scope. Prevent gold-plating.

## Template

Copy the template from `assets/agent-brief-template.md` and fill every section.

## Example: Bug

```markdown
## Agent Brief

**Category:** bug
**Summary:** Skill description truncation drops mid-word

**Current behavior:**
When a description exceeds 1024 chars, it truncates at exactly 1024
regardless of word boundaries, producing broken output ("confi...").

**Desired behavior:**
Truncate at the last word boundary before 1024 chars. Append "...".

**Key interfaces:**
- `SkillMetadata.description` — no type change; validation logic must
  respect word boundaries
- Any function reading SKILL.md frontmatter that extracts the description

**Acceptance criteria:**
- [ ] Descriptions under 1024 chars are unchanged
- [ ] Descriptions over 1024 chars truncate at last word boundary
- [ ] Truncated descriptions end with "..."
- [ ] Total length including "..." does not exceed 1024 chars

**Out of scope:**
- Changing the 1024 char limit
- Multi-line description support
```

## Example: Enhancement

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** Add `.out-of-scope/` directory for tracking rejected features

**Current behavior:**
Rejected features are closed with `wontfix` and a comment. No persistent
record of the decision. Future similar requests require re-litigating.

**Desired behavior:**
Rejected features documented in `.out-of-scope/<concept>.md` files. New
issues checked against these during triage.

**Key interfaces:**
- Markdown format: `# Concept`, `**Decision:**`, `**Reason:**`, `**Prior requests:**`
- Triage workflow reads `.out-of-scope/*.md` early and matches by concept

**Acceptance criteria:**
- [ ] Closing a feature as wontfix creates/updates `.out-of-scope/` file
- [ ] File includes decision, reasoning, and issue link
- [ ] Duplicate concepts append to existing file instead of creating new
- [ ] Triage checks `.out-of-scope/` and surfaces matches

**Out of scope:**
- Automated matching (human confirms)
- Reopening rejected features
- Bug reports (only enhancements go to `.out-of-scope/`)
```

## Anti-Pattern

```markdown
## Agent Brief
**Summary:** Fix the triage bug
**What to do:** Look at the main file and fix it. Line ~150 has the issue.
**Files:** src/triage/handler.ts (line 150), src/types.ts (line 42)
```

This fails because: no category, vague description, stale file/line references, no acceptance criteria, no scope boundaries.
