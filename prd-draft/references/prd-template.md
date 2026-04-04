# PRD Template

Exact output format. Fill every section from the problem brief and decision ledger. If a section is empty, the upstream interview missed something — go back.

```markdown
# {Feature Name}

> **Status:** Draft
> **Date:** {YYYY-MM-DD}
> **Author:** {name}
> **Stakeholders:** {list}

---

## Problem Statement

{Who is struggling, what is the pain, what happens if we do nothing.
Written from the user's perspective. Grounded in evidence.
NOT a feature description.}

**Current state:** {what users do today}
**Impact:** {quantified: time, errors, churn, revenue}

## Success Metrics

| Metric | Target | Timeframe | Type |
|--------|--------|-----------|------|
| {primary} | {threshold} | {window} | Primary |
| {secondary} | {threshold} | {window} | Secondary |
| {guardrail} | {must not regress} | {window} | Guardrail |

## User Stories

1. As a {actor}, I want {capability}, so that {outcome}
2. ...

## Solution Approach

{What the system will do — at outcome level, not implementation level.}

### Key Decisions

- **Decision:** {what was decided}
  - Rationale: {why}
  - Rejected: {alternative, why rejected}
  - Risk: {what could go wrong}

### Modules

| Module | Change | Interface | Testable in Isolation? |
|--------|--------|-----------|----------------------|
| {name} | {what changes} | {how others interact} | Yes/No |

## Acceptance Criteria

### Core Flows
- [ ] Given {context}, when {action}, then {outcome}
- [ ] Given {context}, when {action}, then {outcome}

### Edge Cases & Failure Modes
- [ ] Given {failure condition}, then {degradation behavior}
- [ ] Given {empty/malformed input}, then {error handling}
- [ ] Given {concurrent access}, then {resolution}

## Non-Functional Requirements

| Attribute | Specification | Measurement |
|-----------|--------------|-------------|
| Performance | {e.g., p95 < 200ms at 1K users} | {method} |
| Reliability | {e.g., 99.9% uptime} | {method} |
| Security | {specific controls} | {method} |

## Scope

### In Scope
- {what this PRD covers}

### Non-Goals
- {what we are NOT building, and why}
- {adjacent feature excluded, and why}

### Intentionally Open
- {decision left for engineering/design, and who owns it}

## Assumptions & Risks

### Assumptions
| Assumption | Risk if Wrong | Validation Plan |
|------------|--------------|-----------------|
| {belief} | {consequence} | {how to test} |

### Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| {risk} | H/M/L | H/M/L | {plan} |

### Dependencies
| Dependency | Owner | Impact if Unavailable |
|------------|-------|----------------------|
| {what} | {who} | {consequence} |

## Open Questions

| Question | Owner | Deadline | Blocks |
|----------|-------|----------|--------|
| {question} | {who} | {when} | {what} |

## Testing Strategy

- **Modules under test:** {from B7}
- **Approach:** {unit / integration / e2e}
- **Prior art:** {existing similar tests}

## Rollout Plan

- **Strategy:** {feature flag / A/B / phased / full}
- **Instrumentation:** {events}
- **Rollback:** {plan}
- **Post-launch review:** {who, when}

## Future Considerations

- {Deferred item — why deferred, trigger to revisit}
```
