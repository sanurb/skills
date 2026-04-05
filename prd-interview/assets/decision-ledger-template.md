# Decision Ledger: {Feature Name}

**Date:** {YYYY-MM-DD}
**Branches resolved:** {N}/8

## B1: Success Criteria
**Status:** decided

| Metric | Target | Timeframe | Type |
|--------|--------|-----------|------|
| {metric} | {threshold} | {window} | Primary |
| {metric} | {threshold} | {window} | Secondary |
| {metric} | {must not regress} | {window} | Guardrail |

## B2: Scope Boundaries & Non-Goals
**Status:** decided

**In scope:**
- {item}

**Non-goals (explicit exclusions):**
- {exclusion + why excluded}

## B3: Solution Approach
**Status:** decided

**Approach:** {outcome-level description — what, not how}

**Key decisions:**
- **Decision:** {what}
  - Rationale: {why}
  - Rejected: {alternative + why rejected}
  - Risk: {what could go wrong}

## B4: Data Model & State
**Status:** decided | deferred

{Source of truth, migrations, cross-system dependencies}

## B5: Edge Cases & Failure Modes
**Status:** decided

- Given {failure condition}, then {expected behavior}
- Given {empty/malformed input}, then {handling}
- Given {concurrent access}, then {resolution}

## B6: Non-Functional Requirements
**Status:** decided

| Attribute | Specification | Measurement |
|-----------|--------------|-------------|
| {e.g., Performance} | {p95 < 200ms at 1K users} | {how measured} |

## B7: Module Design & Testing
**Status:** decided

| Module | Change | Interface | Test in Isolation? |
|--------|--------|-----------|-------------------|
| {name} | {what changes} | {how others interact} | Yes/No |

**Testing approach:** {unit/integration/e2e}
**Prior art:** {existing similar tests in codebase}

## B8: Rollout & Measurement
**Status:** decided | deferred

- Strategy: {feature flag / A/B / phased / full}
- Instrumentation: {events to track}
- Rollback: {plan}
- Review: {who, when}

## Deferred Decisions

| Decision | Owner | Revisit When | Blocks |
|----------|-------|-------------|--------|
| {question} | {who} | {trigger} | {what} |

## Assumptions (Unvalidated)

| Assumption | Risk if Wrong | Validation Plan |
|------------|--------------|-----------------|
| {belief} | {consequence} | {how to test} |
