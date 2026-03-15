# Principles vs Conventions

Architecture has invariants (must hold) and conventions (may vary). Confusing them creates dogma.

## Architectural Invariants

Non-negotiable regardless of language, framework, team size, or codebase age.

### 1. Dependency Direction

Dependencies point inward. Domain code never imports infrastructure code.

This is the ONE structural rule of boundary-driven architecture. Everything else is implementation strategy.

**What this means in practice:**
- A domain entity does not import an ORM decorator
- A business rule does not call an HTTP client
- A domain service does not reference a database driver

**What this does NOT mean:**
- That you must have exactly three layers named `domain/application/infrastructure`
- That you must use interfaces for every dependency
- That you need a DI container
- That you need a `ports/` and `adapters/` directory

### 2. Testability of Domain Logic

Business rules must be verifiable without infrastructure. If testing "orders over $100 get free shipping" requires a running database, the boundary is broken.

**What this means in practice:**
- Domain tests run in milliseconds, no I/O
- Business rules are functions of inputs → outputs (or inputs → state changes)

**What this does NOT mean:**
- That integration tests are bad
- That you can't test with real databases elsewhere
- That every function must be pure

### 3. Explicit Boundaries

The contract between domain and infrastructure is intentional. Code doesn't accidentally cross boundaries — it crosses through defined interfaces, module boundaries, or explicit conventions.

**What this means in practice:**
- You can point to where domain ends and infrastructure begins
- New team members can understand what goes where

**What this does NOT mean:**
- That interfaces must exist for every dependency
- That boundaries must be package-level (folder conventions are valid)
- That boundaries never move or evolve

## Common Conventions (Not Universal)

These are patterns most implementations use, but they vary legitimately across repos:

| Convention | Variants | Choose based on |
|-----------|----------|----------------|
| Layer naming | `domain/app/infra`, `core/service/adapter`, `internal/pkg` | Language idiom, team preference |
| Port definition | Explicit interfaces, duck typing, module exports | Language capabilities, team discipline |
| Adapter location | Separate `infrastructure/` tree, co-located with ports, plugins | Number of adapters, swap frequency |
| DI approach | Constructor injection, framework (Spring/Nest), manual wiring | Framework, testing needs |
| Repository design | Per-aggregate, per-entity, per-use-case, query objects | Domain complexity, query patterns |
| Domain modeling | DDD tactical (entities/VOs/aggregates), plain models, functional core | Domain complexity |
| Application layer | Use cases, app services, command handlers, thin controllers | Team preference, CQRS adoption |
| Event strategy | Domain events, integration events, none, CQRS+ES | Coupling needs, consistency model |

**Two repos can both follow hexagonal architecture correctly while having completely different folder structures, naming conventions, and pattern adoption.**

## Terminology Mapping

Different teams and books use different names for the same concepts:

| Concept | Also called |
|---------|------------|
| Port (inbound) | Driving port, primary port, use case interface, API |
| Port (outbound) | Driven port, secondary port, SPI, repository interface |
| Adapter (inbound) | Driving adapter, controller, handler, endpoint |
| Adapter (outbound) | Driven adapter, repository impl, gateway, client |
| Application service | Use case, command handler, interactor |
| Domain service | Business service (stateless, multi-entity logic) |
| Domain model | Core, business logic, inner hexagon |
| Infrastructure | Outer hexagon, framework layer, adapter layer |

Match whatever the repo already uses. Consistency within a codebase beats adherence to any book.

## Anti-Pattern: Convention Elevated to Doctrine

Signs that convention has been confused with principle:

- "You MUST name the folder `domain/`" — naming choice
- "Every repository must be per-aggregate" — modeling choice
- "You need a DI container" — wiring choice
- "Entities must not have setters" — encapsulation choice
- "You must use CQRS" — pattern choice
- "Rich domain model is mandatory" — modeling philosophy, not architecture

These are all valid conventions that many teams adopt successfully. But they are not architectural invariants. Treating them as invariants creates friction with existing codebases and makes the architecture brittle when context changes.
