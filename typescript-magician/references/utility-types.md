# TypeScript Utility Types

## Contents
- Function utilities: `Parameters`, `ReturnType`, `Awaited`
- Object utilities: `Partial`, `Required`, `Omit`, `Pick`, `Record`
- Union utilities: `Extract`, `Exclude`, `NonNullable`
- Reusable wrapper pattern
- Pitfalls

## Function Utilities

### Parameters<T>

```typescript
function fetchUser(id: string, opts?: { timeout?: number }): Promise<User> { /* ... */ }

type P = Parameters<typeof fetchUser>; // [id: string, opts?: { timeout?: number }]

// Use in wrapper
const withLogging = async (...args: Parameters<typeof fetchUser>) => {
  console.log("Fetching:", args[0]);
  return fetchUser(...args);
};
```

### ReturnType<T>

```typescript
function createUser(name: string, email: string) {
  return { id: crypto.randomUUID(), name, email, createdAt: new Date() };
}
type User = ReturnType<typeof createUser>;
```

### Awaited<T>

```typescript
type T1 = Awaited<Promise<string>>;          // string
type T2 = Awaited<Promise<Promise<number>>>; // number (deep unwrap)

// Combine with ReturnType for async functions
type Result = Awaited<ReturnType<typeof fetchUser>>; // User, not Promise<User>
```

## Object Utilities

### Record<Keys, Type>

```typescript
type Role = "admin" | "user" | "guest";
type Permissions = Record<Role, string[]>;
```

### Partial<T> and Required<T>

```typescript
function updateUser(id: string, updates: Partial<User>): User { /* ... */ }
updateUser("123", { name: "New" }); // OK — only updating name

type FullConfig = Required<{ host?: string; port?: number }>;
// { host: string; port: number }
```

### Omit<T, Keys> and Pick<T, Keys>

```typescript
type PublicUser = Omit<User, "password">;
type Credentials = Pick<User, "email" | "password">;
type CreateInput = Omit<User, "id">;
```

## Union Utilities

```typescript
type Colors = "red" | "green" | "blue" | "yellow";
type Primary = Extract<Colors, "red" | "blue">;     // "red" | "blue"
type Other = Exclude<Colors, "red" | "blue">;        // "green" | "yellow"
type Definite = NonNullable<string | null | undefined>; // string
```

## Wrapping External Library Functions

Combine `Parameters`, `ReturnType`, and `Awaited` for type-safe wrappers when the library doesn't export types:

```typescript
import { fetchUser } from "external-lib";

type FetchUserReturn = Awaited<ReturnType<typeof fetchUser>>;

export const fetchUserWithFullName = async (
  ...args: Parameters<typeof fetchUser>
): Promise<FetchUserReturn & { fullName: string }> => {
  const user = await fetchUser(...args);
  return { ...user, fullName: `${user.firstName} ${user.lastName}` };
};
```

### Reusable wrapper type

```typescript
type WrapFunction<
  TFunc extends (...args: any) => any,
  TExtra = {}
> = (...args: Parameters<TFunc>) => Promise<Awaited<ReturnType<TFunc>> & TExtra>;
```

## Quick Reference

| Utility | Use Case |
|---------|----------|
| `Parameters<T>` | Wrapping functions, creating variants |
| `ReturnType<T>` | Extracting unexported return types |
| `Awaited<T>` | Unwrapping Promise types |
| `Record<K, V>` | Object types with dynamic keys |
| `Partial<T>` | Update/patch operations |
| `Required<T>` | Ensure all options provided |
| `Omit<T, K>` | Remove sensitive/internal fields |
| `Pick<T, K>` | Focused subsets |
| `Exclude<T, U>` | Filter union types |
| `Extract<T, U>` | Select from union types |
| `NonNullable<T>` | Remove null/undefined |

## Pitfalls

### ReturnType on async functions gives Promise<T>, not T

```typescript
type Wrong = ReturnType<typeof asyncFn>;          // Promise<string[]>
type Right = Awaited<ReturnType<typeof asyncFn>>;  // string[]
```

### Forgetting `typeof` for runtime functions

```typescript
type Params = Parameters<myFunc>;          // Error — myFunc is a value
type Params = Parameters<typeof myFunc>;   // Correct
```
