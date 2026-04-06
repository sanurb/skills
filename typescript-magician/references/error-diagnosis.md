# Diagnosing TypeScript Errors

## Contents
- General strategies (read bottom-up, hover, test types)
- Common error patterns with fixes
- Debugging techniques
- Massive error messages

## General Strategies

1. **Read errors bottom-up** — the actual cause is at the deepest indentation level
2. **Hover for type info** — check inferred types in the IDE
3. **Go-to-definition** — see overloads and expected shapes
4. **Create test types** — break complex expressions into steps:
   ```typescript
   type Step1 = SomeComplexType<Input>;
   type Step2 = Step1[keyof Input];
   type Step3 = Step2[number]; // isolate the issue
   ```

## Common Error Patterns

### "Type 'X' is not assignable to type 'Y'"

Check for literal vs widened type mismatch:

```typescript
const status = "active";                    // Type: string (widened)
function setStatus(s: "active" | "inactive") {}
setStatus(status);                          // Error
const statusConst = "active" as const;      // Fix: literal type
setStatus(statusConst);                     // OK
```

### "Property 'X' does not exist on type 'Y'"

Narrow the type first:

```typescript
function process(data: unknown) {
  if (typeof data === "object" && data !== null && "name" in data) {
    data.name; // OK after narrowing
  }
}
```

### "Type 'X' cannot be used to index type 'Y'"

Constrain the key:

```typescript
// Error: string can't index T
function getValue<T>(obj: T, key: string) { return obj[key]; }

// Fix
function getValue<T, K extends keyof T>(obj: T, key: K) { return obj[key]; }
```

### "Argument of type 'X' is not assignable to parameter of type 'Y'"

Common with `readonly` arrays:

```typescript
const items = ["a", "b", "c"] as const;
items.includes(someString); // Error
(items as readonly string[]).includes(someString); // Fix
```

### Generic constraint errors

```typescript
// Error: 'T' does not satisfy constraint '(...args: any) => any'
function process<T>(items: Parameters<T>) {}

// Fix: add the constraint
function process<T extends (...args: any) => any>(items: Parameters<T>) {}
```

## Debugging Techniques

### Simplify the chain

```typescript
const step1 = complexFunction();       // Hover — correct type?
const step2 = step1.map(transform);    // Hover — still correct?
const step3 = step2.filter(predicate); // Find the break
```

### Add explicit annotations to surface mismatches

```typescript
const data: ExpectedType = getData();          // Error here = getData returns wrong type
const result: ExpectedResult = data.process(); // Error here = process returns wrong type
```

### Use `@ts-expect-error` to confirm understanding

```typescript
// @ts-expect-error — string is not assignable to number
const x: number = "hello";
// If the directive is "unused", the code is actually valid
```

## Massive Error Messages

**Find the core issue** — long errors usually have one missing property or mismatched type buried at the end:

```
Type '{ fullName: string; id: string; age: number; }'
is not assignable to type '{ fullName: string; id: string; age: number; agePlus10: number }'.
Property 'agePlus10' is missing...
         ^^^^^^^^^^^ — the actual issue
```

**Create type aliases to compare:**

```typescript
type Actual = typeof problematicValue;
type Expected = SomeExpectedType;
// Hover both to see the diff
```

## Investigating Library Types

1. Go-to-definition on imports
2. Check `node_modules/@types/[library]` or `node_modules/[library]/dist/*.d.ts`
3. Look for `(+N overload)` in tooltips — go-to-definition reveals all overloads

## When Types Don't Match Reality

| Fix | Use Case |
|-----|----------|
| `as Type` assertion | You know better than TS (use sparingly) |
| `declare module` merging | Library types are incomplete |
| Report upstream | Library types are wrong |
