# Array Index Access with `[number]`

Access array element types using indexed access. `[number]` extracts a union of all possible element types.

## Core Pattern

```typescript
const roles = ["user", "admin", "anonymous"] as const;

type First   = typeof roles[0];      // "user"
type AnyRole = typeof roles[number]; // "user" | "admin" | "anonymous"
```

`[number]` is conceptually `[0 | 1 | 2 | ...]` — it accesses all numeric indices.

## Tuple vs Array

```typescript
// Tuple (as const) — each position has a literal type
const tuple = ["hello", 42, true] as const;
type T = typeof tuple[number]; // "hello" | 42 | true

// Array — single element type
const arr: string[] = ["a", "b"];
type A = typeof arr[number]; // string
```

## Nested Access: Extract All Actions from All Roles

```typescript
const access = {
  user: ["update-self", "view"],
  admin: ["create", "update-self", "update-any", "delete", "view"],
  anonymous: ["view"],
} as const;

type Role   = keyof typeof access;                   // "user" | "admin" | "anonymous"
type Action = typeof access[Role][number];            // "update-self" | "view" | "create" | ...
```

## Combine with `Parameters<>`

```typescript
type ParamsUnion = Parameters<typeof someFunc>[number]; // Union of all param types
```

## Practical Example: Type-Safe Access Control

```typescript
const canAccess = (role: Role, action: Action): boolean =>
  (access[role] as ReadonlyArray<Action>).includes(action);

canAccess("admin", "delete");   // OK
canAccess("admin", "invalid");  // Error: "invalid" not assignable to Action
```

## Pitfalls

### Forgetting `as const` — elements widen

```typescript
const actions = ["view", "edit"];              // typeof actions[number] → string
const actions = ["view", "edit"] as const;     // → "view" | "edit"
```

### `.includes()` on readonly arrays

```typescript
const items = ["a", "b", "c"] as const;
items.includes(someString); // Error: string not assignable to "a" | "b" | "c"
(items as readonly string[]).includes(someString); // Fix
```
