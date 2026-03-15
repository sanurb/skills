# Dependency Categories

Classify each candidate's dependencies into exactly one category. The category determines the deepening strategy and test approach.

## Decision Tree

```
Does the dependency involve I/O?
├─ No → In-process
└─ Yes
    ├─ Does a faithful local stand-in exist? (PGLite, SQLite, embedded Redis, in-memory FS)
    │   └─ Yes → Local-substitutable
    └─ No
        ├─ Do you own/control the service?
        │   └─ Yes → Remote but owned (Ports & Adapters)
        └─ No → True external (Mock at boundary)
```

## 1. In-Process

No I/O. Pure computation, in-memory state.

**Strategy:** Merge the modules directly. Test inputs-to-outputs.

**Example:** A validation module and a transformation module sharing types and co-changing. Merge into one deep module.

## 2. Local-Substitutable

I/O dependency with a local stand-in (PGLite, SQLite, embedded Redis).

**Strategy:** Merge modules. Run tests with the stand-in — real SQL, real transactions, no mocks.

**Example:** A Postgres-backed module tested via PGLite in the test suite.

**Key question:** Does a faithful local stand-in exist for this dependency?

## 3. Remote but Owned (Ports & Adapters)

Your own services across a network boundary — microservices, internal APIs, queues.

**Strategy:** Define a port (interface) at the module boundary. The deep module owns logic; transport is injected. Tests use an in-memory adapter. Production uses the real HTTP/gRPC/queue adapter.

**Example:** Module calling an internal pricing service. Define `PricingPort`, implement `HttpPricingAdapter` (production) and `InMemoryPricingAdapter` (tests).

**In the RFC, write:** "Define a shared interface (port), implement an HTTP adapter for production and an in-memory adapter for testing."

## 4. True External (Mock at Boundary)

Third-party services you don't control — Stripe, Twilio, AWS S3.

**Strategy:** Inject the external dependency as a port. Tests provide a mock returning canned responses.

**Example:** Billing module calling Stripe. Define `PaymentGateway` port, implement `StripeGateway` (production) and `MockGateway` (tests).

**Key distinction from category 3:** No integration tests against the real service in CI (rate limits, costs, flakiness). The mock IS the test boundary.

## Quick Reference

| Category | I/O | Strategy | Test approach |
|----------|-----|----------|---------------|
| In-process | No | Merge directly | Direct unit tests |
| Local-substitutable | Yes | Merge + stand-in | Integration with stand-in |
| Remote but owned | Yes | Ports & adapters | In-memory adapter |
| True external | Yes | Mock at boundary | Mock implementation |
