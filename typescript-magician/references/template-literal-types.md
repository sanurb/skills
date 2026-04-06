# Template Literal Types

## Contents
- Basic syntax and union distribution
- Built-in string manipulation utilities
- Object key transformation patterns
- Route parameter extraction
- Validation patterns
- Pitfalls

## Basic Syntax

```typescript
type Greeting = `Hello, ${string}`;
const valid: Greeting = "Hello, World"; // OK
const bad: Greeting = "Hi, World";      // Error
```

## Union Distribution

Template literals distribute over unions:

```typescript
type Size = "small" | "medium" | "large";
type Color = "red" | "blue";
type SizedColor = `${Size}-${Color}`;
// "small-red" | "small-blue" | "medium-red" | "medium-blue" | "large-red" | "large-blue"
```

## Built-in String Utilities

```typescript
type U = Uppercase<"hello">;     // "HELLO"
type L = Lowercase<"HELLO">;     // "hello"
type C = Capitalize<"hello">;    // "Hello"
type N = Uncapitalize<"Hello">;  // "hello"
```

## Pattern Matching with `infer`

```typescript
type RemovePrefix<T> = T extends `maps:${infer Rest}` ? Rest : T;
type Split<S extends string, D extends string> =
  S extends `${infer Head}${D}${infer Tail}` ? [Head, ...Split<Tail, D>] : S extends "" ? [] : [S];

type Parts = Split<"a-b-c", "-">; // ["a", "b", "c"]
```

## Key Transformation Patterns

### Add prefix/suffix to keys

```typescript
type AddPrefix<T, P extends string> = {
  [K in keyof T as K extends string ? `${P}${K}` : K]: T[K];
};
// AddPrefix<{ name: string }, "user_"> → { user_name: string }
```

### snake_case to camelCase

```typescript
type SnakeToCamel<S extends string> =
  S extends `${infer P1}_${infer P2}${infer P3}`
    ? `${Lowercase<P1>}${Uppercase<P2>}${SnakeToCamel<P3>}`
    : S;

type CamelizeKeys<T> = { [K in keyof T as K extends string ? SnakeToCamel<K> : K]: T[K] };

type Result = CamelizeKeys<{ user_id: string; first_name: string }>;
// { userId: string; firstName: string }
```

### CSS property to camelCase

```typescript
type CamelCase<S extends string> =
  S extends `${infer P1}-${infer P2}${infer P3}`
    ? `${Lowercase<P1>}${Uppercase<P2>}${CamelCase<P3>}`
    : Lowercase<S>;

type T = CamelCase<"background-color">; // "backgroundColor"
```

### Event name generation

```typescript
type EventName<T extends string> = `on${Capitalize<T>}`;
type Getter<T extends string> = `get${Capitalize<T>}`;
type Setter<T extends string> = `set${Capitalize<T>}`;
```

## Route Parameter Extraction

```typescript
type ExtractRouteParams<T extends string> =
  T extends `${string}:${infer Param}/${infer Rest}` ? Param | ExtractRouteParams<`/${Rest}`>
  : T extends `${string}:${infer Param}` ? Param
  : never;

type RouteParams<T extends string> = { [K in ExtractRouteParams<T>]: string };
type P = RouteParams<"/users/:userId/posts/:postId">; // { userId: string; postId: string }
```

## Validation Patterns

```typescript
type ValidEmail = `${string}@${string}.${string}`;
type ValidUrl = `${"http" | "https"}://${string}`;

function fetchUrl(url: ValidUrl) { return fetch(url); }
fetchUrl("https://api.example.com"); // OK
fetchUrl("ftp://files.example.com"); // Error
```

## Complex Parsing

```typescript
type ParseQS<T extends string> =
  T extends `${infer K}=${infer V}&${infer Rest}` ? { [P in K]: V } & ParseQS<Rest>
  : T extends `${infer K}=${infer V}` ? { [P in K]: V }
  : {};

type ParsePath<T extends string> =
  T extends `${infer K}.${infer Rest}` ? [K, ...ParsePath<Rest>] : [T];
```

## Pitfalls

### Recursion limits — deep operations may fail

### Greedy matching — captures as much as possible

```typescript
type GetPath<T> = T extends `${infer P}.json` ? P : never;
type T = GetPath<"a/b.backup.json">; // "a/b.backup" (greedy)
```

### Symbol keys — template literals only work with strings

```typescript
// Filter out symbol keys
type Prefixed<T, P extends string> = {
  [K in keyof T as K extends string ? `${P}${K}` : never]: T[K];
};
```
