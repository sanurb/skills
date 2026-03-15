---
name: clean-ddd-hexagonal
description: Apply boundary-driven architecture (Clean/Hexagonal/Ports-Adapters) with optional DDD tactical patterns for backend services. Separates domain logic from infrastructure through explicit boundaries. Adapts adoption depth to context — full hexagonal, partial boundaries, or principles-only. Use when domain complexity, testability needs, or infrastructure flexibility justifies the cost. Do NOT use for simple CRUD, prototypes, scripts, or frontend code. Not all modules in a system need the same architecture depth.
---

# Boundary-Driven Architecture

Apply architecture boundaries that separate domain logic from infrastructure. The depth of adoption (full hexagonal, partial, or principles-only) depends on context — read [decision-guide.md](references/decision-guide.md).

**This is not doctrine.** There is no single canonical folder structure, naming scheme, or pattern set that fits all codebases. Consistency within a repo matters more than ideological purity. Partial adoption is valid. Architecture serves the domain, team, and delivery constraints — not the other way around.

## Instructions

### Step 1. Assess context and determine adoption level

Before writing code, determine how deeply to apply architectural boundaries:

| Context | Adoption level |
|---------|---------------|
| Complex domain, many business rules, long-lived system | Full: hexagonal boundaries + DDD tactical patterns |
| Moderate domain, multiple entry points or infra swap needs | Partial: boundary interfaces for key infrastructure, domain logic separated |
| Simple CRUD, few rules, one entry point | Principles-only: keep domain logic free of framework imports |
| Prototype, MVP, throwaway | Skip: direct framework usage, evolve later |

Match the repo's existing conventions. If the codebase already has a structure, follow it rather than imposing a new one. Read [decision-guide.md](references/decision-guide.md) for the full adaptation matrix.

### Step 2. Apply boundaries at the appropriate granularity

Route code based on the dependency rule: **domain logic must not depend on infrastructure.**

```
Where does it go?
├─ Pure business logic, no I/O?              → domain boundary (inner)
├─ Orchestrates domain + coordinates I/O?    → application boundary (middle)
├─ Talks to external systems (DB, APIs)?     → infrastructure boundary (outer)
├─ Defines a capability contract?            → port (interface, in domain or app)
└─ Implements a port concretely?             → adapter (in infrastructure)
```

For DDD tactical patterns (entities, value objects, aggregates), read [ddd-tactical.md](references/ddd-tactical.md). These are **optional patterns for complex domains** — not mandatory in every module.

For the invariants/conventions distinction, read [principles-vs-conventions.md](references/principles-vs-conventions.md).

### Step 3. Validate the dependency rule

The only structural rule that must universally hold:

```
Infrastructure → Application → Domain
   (outer)         (middle)      (inner)
```

Inner layers never import from outer layers. The enforcement mechanism varies:

| Mechanism | When to use |
|-----------|-------------|
| Interfaces/traits | Multiple adapters exist or are expected |
| Module/package visibility | Language-level enforcement (Go `internal/`, Rust `pub(crate)`) |
| Convention + code review | Smaller teams, simpler domains |
| Architecture tests (ts-arch, ArchUnit) | Automated CI enforcement for larger codebases |

**Design test:** "Can I test my domain logic without starting a database, HTTP server, or message broker?" If yes, the boundary holds.

## Non-Negotiable (Architectural Invariants)

These are the actual principles. Everything else is convention — see [principles-vs-conventions.md](references/principles-vs-conventions.md).

- **Dependency direction is inward.** Domain does not import infrastructure. Violations here are structural defects, not style issues.
- **Domain logic is testable without infrastructure.** If you need a running database to test a business rule, the boundary is broken.
- **Boundaries are explicit.** The contract between inner and outer is intentional — through interfaces, module visibility, or explicit convention.

## Not Prescriptive (Valid Conventions That Vary)

These are common patterns, not universal requirements:

- Folder names (`domain/`, `core/`, `internal/`, `model/`)
- Whether to use DDD tactical patterns or plain models
- CQRS, event sourcing, or simple read/write
- Repository-per-aggregate vs pragmatic repository design
- DI style (constructor injection, framework, manual wiring)
- Whether adapters live in a separate tree or next to ports

## Output

Created/modified files placed according to the dependency rule, using the repo's existing conventions for naming and structure.

## References

| File | When to read |
|------|-------------|
| [principles-vs-conventions.md](references/principles-vs-conventions.md) | Step 2 — what must hold vs what may vary |
| [decision-guide.md](references/decision-guide.md) | Step 1 — adoption levels, adaptation matrix, anti-dogma safeguards |
| [layers.md](references/layers.md) | One common layer layout with code examples (not the only valid layout) |
| [ddd-tactical.md](references/ddd-tactical.md) | Entity, value object, aggregate patterns for complex domains |
| [ddd-strategic.md](references/ddd-strategic.md) | Bounded contexts, context mapping, subdomains |
| [hexagonal.md](references/hexagonal.md) | Ports and adapters patterns, naming variants |
| [cqrs-events.md](references/cqrs-events.md) | Command/query separation, domain events, outbox |
| [testing.md](references/testing.md) | Unit, integration, architecture test patterns |
