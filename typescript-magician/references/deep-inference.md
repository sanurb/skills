# Deep Type Inference

## Contents
- The widening problem
- Solutions: `as const`, `F.Narrow`, const type parameters (TS 5.0+)
- Comparison table
- Pitfalls

## The Widening Problem

TypeScript widens types when inferring objects and arrays:

```typescript
const makeRouter = <TConfig>(config: TConfig) => ({ config });

const router = makeRouter({
  "/search": { search: ["query", "page"] },
});
// search is string[], NOT ["query", "page"] — literal tuple lost
```

## Solution 1: `as const` (User-Provided)

```typescript
const router = makeRouter({
  "/search": { search: ["query", "page"] },
} as const);
// search is readonly ["query", "page"] — literals preserved
```

**Drawbacks:** Users must remember it. Types become `readonly`.

## Solution 2: `F.Narrow` from ts-toolbelt

```typescript
import { F } from "ts-toolbelt";

const makeRouter = <TConfig extends BaseRouterConfig>(config: F.Narrow<TConfig>) => ({ config });

const router = makeRouter({
  "/search": { search: ["query", "page"] },
});
// search is ["query", "page"] — automatic, no as const needed
```

## Solution 3: `const` Type Parameter (TS 5.0+) ← Preferred

```typescript
const makeRouter = <const TConfig extends BaseRouterConfig>(config: TConfig) => ({ config });

const router = makeRouter({
  "/search": { search: ["query", "page"] },
});
// search is ["query", "page"] — built-in, no library
```

## Practical Example: Type-Safe Router

```typescript
type TupleToSearchParams<T extends string[]> = { [K in T[number]]?: string };

const makeRouter = <const TConfig extends Record<string, { search?: string[] }>>(config: TConfig) => ({
  goTo: <TRoute extends keyof TConfig>(
    route: TRoute,
    search?: TConfig[TRoute]["search"] extends string[]
      ? TupleToSearchParams<TConfig[TRoute]["search"]>
      : never
  ) => { /* impl */ },
});

const router = makeRouter({
  "/": {},
  "/dashboard": { search: ["page", "perPage", "sort"] },
});

router.goTo("/dashboard", { page: "1", sort: "name" }); // Type-safe
router.goTo("/dashboard", { invalid: "x" });             // Error
```

## Other Use Cases

```typescript
// Configuration with literal values
const createTheme = <const T extends Record<string, string>>(theme: T): T => theme;
const theme = createTheme({ primary: "#0066cc" });
// theme.primary is "#0066cc", not string

// Event maps
const events = createEventMap({ click: (x: number) => {}, keydown: (key: string) => {} });
// Event names are literal unions, handlers properly typed
```

## Comparison

| Technique | Pros | Cons |
|-----------|------|------|
| `as const` | No dependencies | Manual, readonly types |
| `F.Narrow` | Automatic, flexible | External dependency |
| `const` type param | Built-in, clean | TS 5.0+ only |

## Pitfalls

### Forgetting constraints with F.Narrow

```typescript
// BAD — no base for inference
const bad = <TConfig>(config: F.Narrow<TConfig>) => config;

// GOOD — constrained
const good = <TConfig extends Record<string, unknown>>(config: F.Narrow<TConfig>) => config;
```

### Readonly arrays from `as const`

```typescript
const config = { values: [1, 2, 3] } as const;
config.values.push(4); // Error — readonly [1, 2, 3]
```

### Deep nesting performance

Very deeply nested types can slow the compiler. Keep nesting practical.
