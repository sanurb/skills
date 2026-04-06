# Deriving Types from Runtime with `as const` and `typeof`

`as const` makes an object deeply readonly with literal types. `typeof` pulls runtime values into the type world.

## Core Pattern

```typescript
// ALWAYS: Create const object first, then extract type
const config = {
  GROUP: "group",
  ANNOUNCEMENT: "announcement",
  ONE_ON_ONE: "1on1",
} as const;

type Keys   = keyof typeof config;                           // "GROUP" | "ANNOUNCEMENT" | "ONE_ON_ONE"
type Values = typeof config[keyof typeof config];            // "group" | "announcement" | "1on1"
type Subset = typeof config["ONE_ON_ONE" | "ANNOUNCEMENT"];  // "1on1" | "announcement"
```

## `as const` Effects

1. **Literal inference** — values are `"group"`, not `string`
2. **Deep readonly** — all properties become `readonly` recursively
3. **Tuple inference** — arrays become `readonly ["a", "b"]`, not `string[]`

```typescript
const routes = ["home", "about", "contact"] as const;
// Type: readonly ["home", "about", "contact"]  (not string[])
```

## `Obj[keyof Obj]` — Object.values() for Types

```typescript
const statusCodes = { OK: 200, CREATED: 201, NOT_FOUND: 404 } as const;
type StatusCode = typeof statusCodes[keyof typeof statusCodes]; // 200 | 201 | 404
```

## Complete Example

```typescript
const HTTP_METHODS = {
  GET: "GET", POST: "POST", PUT: "PUT", DELETE: "DELETE", PATCH: "PATCH",
} as const;

type HttpMethod    = typeof HTTP_METHODS[keyof typeof HTTP_METHODS]; // "GET" | "POST" | ...
type SafeMethod    = typeof HTTP_METHODS["GET"];                      // "GET"
type MutatingMethod = typeof HTTP_METHODS["POST" | "PUT" | "DELETE" | "PATCH"];

function makeRequest(method: HttpMethod, url: string): void { /* ... */ }
makeRequest(HTTP_METHODS.GET, "/api/users"); // OK
makeRequest("INVALID", "/api/users");        // Error
```

## Pitfalls

### Forgetting `as const` — values widen to `string`/`number`

```typescript
const colors = { RED: "#ff0000" };           // typeof colors[keyof typeof colors] → string
const colors = { RED: "#ff0000" } as const;  // → "#ff0000"
```

### Mutation is blocked

```typescript
const config = { timeout: 5000 } as const;
config.timeout = 10000; // Error: Cannot assign to 'timeout' (readonly)
```
