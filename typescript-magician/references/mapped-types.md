# Mapped Types

## Contents
- Basic syntax and modifier manipulation
- Key remapping with `as`
- Filtering keys
- Deep mapped types
- Practical patterns (getters/setters, event handlers, validation)
- Pitfalls

## Basic Syntax

```typescript
type MappedType<T> = { [K in keyof T]: TransformedType };
```

### Modifier Manipulation

```typescript
type MyPartial<T>  = { [K in keyof T]?: T[K] };         // add optional
type MyRequired<T> = { [K in keyof T]-?: T[K] };         // remove optional
type MyReadonly<T> = { readonly [K in keyof T]: T[K] };   // add readonly
type Mutable<T>    = { -readonly [K in keyof T]: T[K] };  // remove readonly
```

## Key Remapping with `as`

```typescript
// Add prefix
type Prefixed<T, P extends string> = {
  [K in keyof T as K extends string ? `${P}${K}` : K]: T[K];
};
// Prefixed<{ name: string }, "user_"> → { user_name: string }

// Remove keys by remapping to never
type RemoveFields<T, K extends keyof T> = {
  [P in keyof T as P extends K ? never : P]: T[P];
};

// Transform keys (strip prefix)
type RemoveMaps<T> = T extends `maps:${infer Rest}` ? Rest : T;
type CleanKeys<T> = { [K in keyof T as RemoveMaps<K>]: T[K] };
```

## Filtering Keys

```typescript
// Keep only string-valued properties
type OnlyStrings<T> = {
  [K in keyof T as T[K] extends string ? K : never]: T[K];
};

// Keep only required properties
type RequiredKeys<T> = {
  [K in keyof T]-?: undefined extends T[K] ? never : K;
}[keyof T];
type OnlyRequired<T> = Pick<T, RequiredKeys<T>>;
```

## Deep Mapped Types

```typescript
type DeepReadonly<T> = T extends object
  ? { readonly [K in keyof T]: DeepReadonly<T[K]> }
  : T;

type DeepPartial<T> = {
  [K in keyof T]?: T[K] extends object ? DeepPartial<T[K]> : T[K];
};
```

## Practical Patterns

### Getters and Setters

```typescript
type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K];
};
type Setters<T> = {
  [K in keyof T as `set${Capitalize<string & K>}`]: (value: T[K]) => void;
};
// Getters<{ name: string }> → { getName: () => string }
```

### Event Handlers

```typescript
type EventHandlers<T> = {
  [K in keyof T as `on${Capitalize<string & K>}Change`]: (
    newValue: T[K], oldValue: T[K]
  ) => void;
};
```

### Form Validation Errors

```typescript
type ValidationErrors<T> = { [K in keyof T]?: string[] };
```

### Merge Two Types

```typescript
type Merge<A, B> = {
  [K in keyof A | keyof B]: K extends keyof B ? B[K] : K extends keyof A ? A[K] : never;
};
```

## Pitfalls

### Template literals require string key check

```typescript
// Error: Type 'K' is not assignable to type 'string'
type Wrong<T> = { [K in keyof T as `prefix_${K}`]: T[K] };

// Correct
type Right<T> = { [K in keyof T as K extends string ? `prefix_${K}` : never]: T[K] };
```

### Key remapping loses modifiers

```typescript
// Optional modifier lost after remap — re-add explicitly
type Transform<T> = { [K in keyof T as `new_${string & K}`]+?: T[K] };
```

### Deep recursion needs a base case

```typescript
// Unsafe — infinite recursion on circular types
type Bad<T> = { readonly [K in keyof T]: Bad<T[K]> };

// Safe — add primitive base case
type Safe<T> = T extends object
  ? { readonly [K in keyof T]: Safe<T[K]> }
  : T;
```
