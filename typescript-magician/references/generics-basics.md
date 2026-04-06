# Generics Fundamentals

## Contents
- Basic generic functions and inference
- Constraints with `extends`
- Default type parameters
- Multiple generics and `keyof` patterns
- Generics in classes
- Pitfalls

## Basic Generic Functions

```typescript
function identity<T>(value: T): T { return value; }

const num = identity(42);       // T inferred as number
const str = identity("hello");  // T inferred as string
```

## Inference Dependencies

When one parameter's type depends on another:

```typescript
const createComponent = <TConfig extends Record<string, string>>(config: TConfig) => {
  return (variant: keyof TConfig, ...classes: string[]): string =>
    config[variant] + " " + classes.join(" ");
};

const btn = createComponent({ primary: "bg-blue-300", secondary: "bg-green-300" });
btn("primary", "px-4");   // OK — variant is "primary" | "secondary"
btn("tertiary", "px-4");  // Error
```

## Constraints with `extends`

```typescript
// Without constraint — error: 'length' does not exist on T
function getLength<T>(item: T): number { return item.length; }

// With constraint — T must have length
function getLength<T extends { length: number }>(item: T): number {
  return item.length;
}

getLength("hello");    // 5
getLength([1, 2, 3]);  // 3
getLength(42);         // Error: number doesn't have length
```

## Default Type Parameters

```typescript
type WrapFunction<
  TFunc extends (...args: any) => any,
  TExtra = {} // Defaults to empty object
> = (...args: Parameters<TFunc>) => Promise<Awaited<ReturnType<TFunc>> & TExtra>;
```

## Inference — When It Works and When It Doesn't

```typescript
// GOOD — TConfig IS the argument, inference works
const create = <TConfig extends Record<string, string>>(config: TConfig) => config;

// BAD — TConfig not used in argument position, defaults to unknown
const create = <TConfig>(config: Record<string, string>) => config;
```

## Multiple Generics

```typescript
function map<TIn, TOut>(items: TIn[], transform: (item: TIn) => TOut): TOut[] {
  return items.map(transform);
}
const numbers = map(["1", "2"], (s) => parseInt(s)); // number[]
```

## `keyof` with Generics

```typescript
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}

const user = { name: "Alice", age: 30 };
getProperty(user, "name"); // string
getProperty(user, "age");  // number
getProperty(user, "email"); // Error: "email" not in keyof
```

## Generics in Classes

```typescript
class Container<T> {
  constructor(private value: T) {}
  getValue(): T { return this.value; }
  map<U>(fn: (v: T) => U): Container<U> { return new Container(fn(this.value)); }
}

const str = new Container(42).map(n => n.toString()); // Container<string>
```

## Pitfalls

### Unnecessary generics

```typescript
// BAD — generic adds no value
function greet<T extends string>(name: T): string { return `Hello, ${name}`; }

// GOOD
function greet(name: string): string { return `Hello, ${name}`; }
```

### Over-constraining

```typescript
// BAD — requires properties you don't use
function process<T extends { id: string; name: string; email: string }>(obj: T) {}

// GOOD — require only what you access
function process<T extends { id: string }>(obj: T) {}
```

### Forgetting to constrain

```typescript
// BAD — 'name' doesn't exist on T
function getName<T>(obj: T): string { return obj.name; }

// GOOD
function getName<T extends { name: string }>(obj: T): string { return obj.name; }
```
