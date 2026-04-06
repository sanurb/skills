# Conditional Types

## Contents
- Basic syntax
- Distribution over unions (and how to prevent it)
- Filtering with `never`
- Nested conditionals
- Practical patterns

## Basic Syntax

```typescript
type Conditional = SomeType extends OtherType ? TrueType : FalseType;
```

```typescript
type IsString<T> = T extends string ? true : false;

type Test1 = IsString<string>;  // true
type Test2 = IsString<number>;  // false
type Test3 = IsString<"hello">; // true (literal extends string)
```

## Distribution Over Unions

Conditional types **distribute** over union members:

```typescript
type ToArray<T> = T extends any ? T[] : never;
type Result = ToArray<string | number>; // string[] | number[]  (NOT (string | number)[])
```

### Preventing Distribution

Wrap both sides in a tuple:

```typescript
type ToArrayNonDist<T> = [T] extends [any] ? T[] : never;
type Result = ToArrayNonDist<string | number>; // (string | number)[]
```

## Filtering with `never`

Return `never` to remove types from a union (this is how `Extract`/`Exclude` work):

```typescript
type ExtractStrings<T> = T extends string ? T : never;
type OnlyStrings = ExtractStrings<"a" | "b" | 1 | 2 | true>; // "a" | "b"

// Built-in equivalents
type Extract<T, U> = T extends U ? T : never;
type Exclude<T, U> = T extends U ? never : T;
```

## Nested Conditionals

```typescript
type TypeName<T> = T extends string ? "string"
  : T extends number ? "number"
  : T extends boolean ? "boolean"
  : T extends Function ? "function"
  : "object";
```

### Deep transformation with base case

```typescript
type DeepReadonly<T> = T extends Function ? T
  : T extends object ? { readonly [K in keyof T]: DeepReadonly<T[K]> }
  : T;
```

## Practical Patterns

### Conditional function arguments

```typescript
const makeRouter = <TConfig extends Record<string, { search?: string[] }>>(config: TConfig) => ({
  goTo: <TRoute extends keyof TConfig>(
    route: TRoute,
    search?: TConfig[TRoute]["search"] extends string[]
      ? { [K in TConfig[TRoute]["search"][number]]?: string }
      : never
  ) => { /* impl */ },
});

const router = makeRouter({ "/": {}, "/search": { search: ["query", "page"] } });
router.goTo("/");                                  // No search param
router.goTo("/search", { query: "test", page: "1" }); // Type-safe search params
```

### Unwrap wrappers

```typescript
type UnwrapPromise<T> = T extends Promise<infer U> ? U : T;
type UnwrapArray<T> = T extends (infer U)[] ? U : T;
```

## Pitfalls

### Forgetting distribution

```typescript
type IsArray<T> = T extends any[] ? true : false;
type Test = IsArray<string | number[]>; // boolean (distributes!)

type IsArrayCorrect<T> = [T] extends [any[]] ? true : false;
type Test2 = IsArrayCorrect<string | number[]>; // false (checks whole union)
```

### Over-complicated conditions

Sometimes a discriminated union or overload is simpler than nested conditionals.

### Forgetting the false branch

Always provide a sensible fallback (usually `never` or the original type `T`).
