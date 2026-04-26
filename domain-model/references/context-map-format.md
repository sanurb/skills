# CONTEXT-MAP.md Format

`CONTEXT-MAP.md` lives at the repo root when the repo contains more than one bounded context. It points to each context's `CONTEXT.md` and records the relationships between contexts.

## Structure

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md) — generates invoices and processes payments
- [Fulfillment](./src/fulfillment/CONTEXT.md) — manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

## Rules

- **List every context once** under `## Contexts`. Each entry links to the context's `CONTEXT.md` and gives a one-line description.
- **Record direction.** Use `→` for upstream → downstream (events, calls) and `↔` for shared types or symmetric relationships.
- **Name the integration mechanism.** State what crosses the boundary: domain event, synchronous call, shared type, anti-corruption layer.
- **Update the map when a new context is added or a relationship changes.** The map is the index — stale entries break navigation.
- **Keep the map flat.** No nested context trees. If a context becomes large enough to warrant sub-contexts, split it and add the sub-contexts to this map.

## When to create

Create `CONTEXT-MAP.md` the moment a second `CONTEXT.md` is introduced. Do not create it for single-context repos.
