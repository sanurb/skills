# Decision Guide

When, how deeply, and how to adopt boundary-driven architecture.

## When Hexagonal Is a Strong Fit

- Complex business domain with many rules, workflows, or state machines
- Multiple entry points (REST, gRPC, CLI, events, scheduled jobs)
- Need to swap infrastructure (migrate databases, change brokers, multi-tenant)
- High test coverage requirements, especially for business logic
- Long-lived system that will outlive current framework choices
- Team of 5+ who need to work on different parts independently

## When a Lighter Architecture Is Better

- Simple CRUD with minimal business logic
- Prototype, MVP, or code with a known short lifespan
- Solo developer or team of 1-2
- Single entry point with no realistic infrastructure swap needs
- Framework provides strong conventions that fight separation (Rails, Django)

**In these cases:** Keep business rules in plain functions/classes, avoid framework imports in core logic, but don't force full port/adapter separation. Evolve boundaries when complexity justifies them.

## Adoption Levels

Most production systems are not fully hexagonal or fully framework-coupled. They live on a spectrum.

### Level 1: Principles Only

- Keep business rules free of framework imports
- No formal ports/adapters — just discipline and code review
- Test business logic in isolation
- **Suitable for:** small teams, simple domains, early-stage products, framework-heavy repos

### Level 2: Selective Boundaries

- Apply port/adapter pattern to the 2-3 most complex or infrastructure-sensitive modules
- Leave simple CRUD modules as direct framework usage
- Common in modular monoliths
- **Suitable for:** mixed-complexity domains, evolving systems, teams learning the patterns

### Level 3: Full Hexagonal

- Every module has explicit ports, adapters, and dependency direction enforced
- DDD tactical patterns where domain complexity warrants
- Architecture tests in CI
- **Suitable for:** complex domains, large teams, long-lived systems, multi-adapter requirements

**Applying Level 3 to your Order module and Level 1 to your Settings module is not inconsistency — it's appropriate calibration.** Not every module in a system needs the same depth.

## Adaptation Matrix

| Factor | Level 1 (Principles) | Level 2 (Selective) | Level 3 (Full) |
|--------|---------------------|--------------------:|----------------|
| Domain complexity | Few rules, CRUD | Moderate rules, some workflows | Many rules, complex state machines |
| Team size | 1-3 | 3-8 | 5+ |
| System lifespan | < 1 year | 1-3 years | 3+ years |
| Entry points | 1 (REST) | 2-3 | Multiple (REST, gRPC, events, CLI) |
| Infra swap likelihood | Fixed | Possible | Expected or required |
| Test requirements | Basic | Moderate | Domain logic must be isolated |
| Framework opinion | Strong (Rails, Django) | Moderate (Spring, Nest) | Weak (Go stdlib, Rust) |
| Codebase state | Legacy, tightly coupled | Some separation exists | Greenfield or well-structured |

## When Forcing Hexagonal Would Be Harmful

- The codebase has a working architecture that the team understands — don't rewrite for ideology
- The framework's conventions actively fight separation (migration cost > benefit)
- The team lacks experience with the patterns and has delivery pressure
- The domain is genuinely simple and unlikely to grow complex
- You're the only person who wants it — architecture is a team decision

## Evolving Architecture Over Time

Architecture is not decided once. Systems evolve:

```
Start simple → Extract boundaries when complexity emerges → Deepen where needed
```

**Signs it's time to add more structure:**
- Business logic tests require infrastructure setup
- Changes in one area break unrelated areas
- The same concept is implemented differently across modules
- New team members struggle to find where code goes

**Signs you've over-structured:**
- More interfaces than implementations
- Layers exist but every change touches all of them
- Simple features require creating 5+ files
- The team spends more time debating structure than shipping features

## Anti-Dogma Safeguards

Read these before enforcing any architectural rule:

1. **Architecture serves the product.** If a rule slows the team without measurable quality improvement, reconsider the rule.
2. **Consistency within a repo beats ideological purity.** If the repo uses `core/` instead of `domain/`, use `core/`. Don't rename for doctrine.
3. **Partial adoption is not failure.** A system where 30% of modules have clean boundaries and 70% are framework-coupled can be well-architected — boundaries are where complexity demands them.
4. **The dependency rule is the only structural invariant.** Everything else is a pattern choice. Elevating patterns to invariants creates unnecessary friction.
5. **A good architecture guide helps engineers reason, not comply.** If people follow rules without understanding why, the architecture is fragile — the first hard problem will break it.
6. **Architecture is a team decision under constraints.** Domain complexity, team cognition, delivery speed, testing needs, and operational constraints all matter. No single factor dominates.
