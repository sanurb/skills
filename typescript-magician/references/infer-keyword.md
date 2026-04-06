# The `infer` Keyword

## Contents
- Basic extraction patterns (array, promise, object)
- Template literal extraction
- Function type extraction
- Multiple captures and constraints
- Recursive extraction
- Pitfalls

## Basic Extraction

`infer` captures type information within conditional types — pattern matching for types:

```typescript
type ArrayElement<T> = T extends (infer U)[] ? U : never;
type PromiseValue<T> = T extends Promise<infer U> ? U : never;
type GetData<T>      = T extends { data: infer D } ? D : never;

type T1 = ArrayElement<string[]>;              // string
type T2 = PromiseValue<Promise<number>>;       // number
type T3 = GetData<{ data: { id: string } }>;   // { id: string }
```

## Template Literal Extraction

```typescript
type RemovePrefix<T> = T extends `maps:${infer Rest}` ? Rest : T;
type T1 = RemovePrefix<"maps:longitude">; // "longitude"

// Multiple captures
type ParseKV<T> = T extends `${infer Key}=${infer Value}` ? { key: Key; value: Value } : never;
type T2 = ParseKV<"name=John">; // { key: "name"; value: "John" }

// Before/after a delimiter
type Before<T> = T extends `${infer P}:${string}` ? P : T;
type After<T>  = T extends `${string}:${infer S}` ? S : T;
```

## Function Type Extraction

```typescript
type MyReturnType<T>  = T extends (...args: any[]) => infer R ? R : never;
type MyParameters<T>  = T extends (...args: infer P) => any ? P : never;
type FirstArg<T>      = T extends (first: infer F, ...rest: any[]) => any ? F : never;
type CtorParams<T>    = T extends new (...args: infer P) => any ? P : never;
```

## Infer with Constraints (TS 4.7+)

```typescript
type ExtractString<T> = T extends { value: infer V extends string } ? V : never;

type T1 = ExtractString<{ value: "hello" }>; // "hello"
type T2 = ExtractString<{ value: 123 }>;     // never — 123 is not a string
```

## Recursive Extraction

```typescript
// Deeply unwrap nested promises
type DeepAwaited<T> = T extends Promise<infer U> ? DeepAwaited<U> : T;
type T1 = DeepAwaited<Promise<Promise<Promise<string>>>>; // string
```

## Practical Examples

### Extract Route Parameters

```typescript
type ExtractParams<T extends string> =
  T extends `${string}:${infer Param}/${infer Rest}` ? Param | ExtractParams<`/${Rest}`>
  : T extends `${string}:${infer Param}` ? Param
  : never;

type Params = ExtractParams<"/users/:userId/posts/:postId">; // "userId" | "postId"
```

### Transform Object Keys

```typescript
type RemoveMaps<T> = T extends `maps:${infer Rest}` ? Rest : T;
type CleanKeys<T> = { [K in keyof T as RemoveMaps<K>]: T[K] };

type Cleaned = CleanKeys<{ "maps:lat": string; city: string }>;
// { lat: string; city: string }
```

### Extract Generic Parameters

```typescript
type ExtractGeneric<T> =
  T extends Array<infer U> ? U
  : T extends Map<infer K, infer V> ? { key: K; value: V }
  : T extends Set<infer U> ? U
  : never;
```

## Pitfalls

### Position matters

```typescript
type First<T> = T extends [infer F, ...any[]] ? F : never;
type Last<T>  = T extends [...any[], infer L] ? L : never;
```

### Greedy template literal matching

```typescript
type GetPath<T> = T extends `${infer Path}.json` ? Path : never;
type T = GetPath<"folder/file.backup.json">; // "folder/file.backup" (greedy)
```

### Union distribution with infer

```typescript
type ExtractArray<T> = T extends (infer U)[] ? U : never;
type T = ExtractArray<string[] | number[]>; // string | number (distributes)
```
