# Type Narrowing

## Contents
- Built-in narrowing (`typeof`, `instanceof`, `in`, equality, truthiness)
- Discriminated unions and exhaustiveness
- Custom type guards (predicates, generics, assertion functions)
- Array filtering with type guards
- Pitfalls

## Built-in Narrowing

```typescript
// typeof
function process(value: string | number) {
  if (typeof value === "string") return value.toUpperCase();
  return value.toFixed(2);
}

// instanceof
function logError(error: Error | string) {
  if (error instanceof Error) console.log(error.stack);
  else console.log(error);
}

// in operator
function move(animal: { swim: () => void } | { fly: () => void }) {
  if ("swim" in animal) animal.swim();
  else animal.fly();
}

// Equality
function example(x: string | number, y: string | boolean) {
  if (x === y) x.toUpperCase(); // Both narrowed to string
}
```

## Discriminated Unions

Use a common literal property to discriminate:

```typescript
interface Circle { kind: "circle"; radius: number }
interface Rectangle { kind: "rectangle"; width: number; height: number }
type Shape = Circle | Rectangle;

function getArea(shape: Shape): number {
  switch (shape.kind) {
    case "circle": return Math.PI * shape.radius ** 2;
    case "rectangle": return shape.width * shape.height;
    default:
      const _exhaustive: never = shape; // Catches missing cases
      throw new Error(`Unhandled: ${_exhaustive}`);
  }
}
```

## Custom Type Guards

### Type Predicates

```typescript
function isNotNull<T>(value: T | null | undefined): value is T {
  return value !== null && value !== undefined;
}

const filtered = [1, null, 2, undefined, 3].filter(isNotNull); // number[]
```

### Object Property Check

```typescript
function hasProperty<T extends object, K extends string>(
  obj: T, key: K
): obj is T & Record<K, unknown> {
  return key in obj;
}
```

### Assertion Functions

Must use `function` declaration, not arrow functions:

```typescript
function assertIsUser(value: unknown): asserts value is { id: string; name: string } {
  if (typeof value !== "object" || value === null || !("id" in value) || !("name" in value))
    throw new Error("Invalid user object");
}

function handleData(data: unknown) {
  assertIsUser(data);
  console.log(data.name); // data is { id: string; name: string }
}
```

## Narrowing with Branded Types

```typescript
type ValidEmail = string & { __brand: "ValidEmail" };

function isValidEmail(email: string): email is ValidEmail {
  return email.includes("@") && email.includes(".");
}

function sendEmail(email: ValidEmail) { /* validated */ }

function handleSubmit(email: string) {
  if (!isValidEmail(email)) throw new Error("Invalid email");
  sendEmail(email); // email narrowed to ValidEmail
}
```

## Array Filtering with Type Guards

```typescript
type Item = { type: "a"; value: string } | { type: "b"; count: number };

const typeAItems = items.filter(
  (item): item is Extract<Item, { type: "a" }> => item.type === "a"
);
```

## Pitfalls

### Narrowing does not persist across callbacks

```typescript
function example(value: string | null) {
  if (value !== null) {
    setTimeout(() => {
      value; // string | null again — TS is conservative about callbacks
    }, 0);
  }
}
```

### Type guards must use `is` return type

```typescript
// Does NOT narrow — returns plain boolean
function isFish(pet: Fish | Bird) { return "swim" in pet; }

// Narrows correctly
function isFish(pet: Fish | Bird): pet is Fish { return "swim" in pet; }
```

### Boolean variables do not carry narrowing

```typescript
function example(value: string | number) {
  const isStr = typeof value === "string";
  if (isStr) { value; } // still string | number — must check inline
}
```

| Technique | Use Case |
|-----------|----------|
| `typeof` | Primitive checks |
| `instanceof` | Class instances |
| `in` | Property existence |
| Discriminated unions | Related types with common discriminant |
| Type predicates | Custom narrowing logic |
| Assertion functions | Validation with early throw |
