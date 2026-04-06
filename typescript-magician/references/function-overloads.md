# Function Overloads

## Contents
- Syntax and resolution order
- Wrapping overloaded functions
- Event handler pattern
- Overloads vs unions vs generics
- Pitfalls

## Syntax

```typescript
// Overload signatures (visible to callers)
function greet(name: string): string;
function greet(first: string, last: string): string;

// Implementation signature (must handle all overloads)
function greet(nameOrFirst: string, last?: string): string {
  return last ? `Hello, ${nameOrFirst} ${last}!` : `Hello, ${nameOrFirst}!`;
}
```

**Resolution:** TypeScript tries overloads top-to-bottom, uses the first match. Put specific overloads before general ones.

## Wrapping Overloaded Functions

Mirror the overloads to preserve inference:

```typescript
// Problem: simple wrapper loses overload behavior
const nonNull = (tag: string) => {
  const el = document.querySelector(tag);
  if (!el) throw new Error(`Not found: ${tag}`);
  return el; // Always returns Element — lost HTMLBodyElement etc.
};

// Fix: mirror querySelector overloads
function nonNull<K extends keyof HTMLElementTagNameMap>(tag: K): HTMLElementTagNameMap[K];
function nonNull(tag: string): Element;
function nonNull(tag: string): Element {
  const el = document.querySelector(tag);
  if (!el) throw new Error(`Not found: ${tag}`);
  return el;
}

nonNull("body"); // HTMLBodyElement
nonNull(".cls"); // Element
```

## Event Handler Pattern

```typescript
interface EventMap {
  click: MouseEvent;
  keydown: KeyboardEvent;
}

interface Emitter {
  on<K extends keyof EventMap>(event: K, handler: (e: EventMap[K]) => void): void;
  on(event: string, handler: (e: Event) => void): void;
}

emitter.on("click", (e) => e.clientX);   // e: MouseEvent
emitter.on("custom", (e) => e.type);     // e: Event (fallback)
```

## Overloads vs Alternatives

| Approach | Use When |
|----------|----------|
| **Overloads** | Return type depends on input type |
| **Union params** | Return type is always the same |
| **Generics** | Single signature covers all cases |

```typescript
// Overloads — different return type per input
function parse(input: string): object;
function parse(input: object): string;
function parse(input: string | object) { /* ... */ }

// Union — same return type
function process(input: string | number): string { return String(input); }

// Generic — single signature
function identity<T>(value: T): T { return value; }
```

## Method Overloads in Classes

```typescript
class Calculator {
  add(a: number, b: number): number;
  add(a: string, b: string): string;
  add(a: number | string, b: number | string): number | string {
    if (typeof a === "number" && typeof b === "number") return a + b;
    return String(a) + String(b);
  }
}
```

## Pitfalls

### Implementation signature is NOT visible to callers

```typescript
function example(a: string): string;
function example(a: number): number;
function example(a: string | number): string | number { return a; }

example(true); // Error — no matching overload (even though impl would accept it)
```

### Wrong overload order

```typescript
// BAD — general overload catches everything
function bad(x: any): any;
function bad(x: string): string; // Never reached

// GOOD — specific first
function good(x: string): string;
function good(x: any): any;
```

### Implementation must handle all overloads

```typescript
function process(x: string): string;
function process(x: number): number;
// Error: implementation only handles string
function process(x: string): string { return x.toUpperCase(); }

// Fix: handle all cases
function process(x: string | number): string | number { /* ... */ }
```
