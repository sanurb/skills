# Opaque Types (Brand Types)

## Contents
- The structural typing problem
- Creating opaque types
- Constructor functions
- Combining with type guards
- Patterns (IDs, units, validated strings)
- Pitfalls

## The Problem

TypeScript uses structural typing — these are interchangeable:

```typescript
type UserId = string;
type PostId = string;

const userId: UserId = "user-123";
const postId: PostId = "post-456";
getUser(postId); // No error — both are just strings. BUG!
```

## Creating Opaque Types

Add a phantom brand property:

```typescript
type Opaque<TValue, TBrand> = TValue & { __brand: TBrand };

type UserId = Opaque<string, "UserId">;
type PostId = Opaque<string, "PostId">;

function getUser(id: UserId): User { /* ... */ }
function getPost(id: PostId): Post { /* ... */ }

getUser(postId); // Error — PostId is not assignable to UserId ✓
```

## Constructor Functions

Regular strings can't be assigned to opaque types. Create constructors:

```typescript
function UserId(id: string): UserId { return id as UserId; }
function PostId(id: string): PostId { return id as PostId; }

const uid = UserId("user-123");
const pid = PostId("post-456");
getUser(uid); // OK
getUser(pid); // Error
```

## Combining with Validation

```typescript
type ValidEmail = Opaque<string, "ValidEmail">;

function validateEmail(input: string): ValidEmail {
  if (!input.includes("@")) throw new Error("Invalid email");
  return input as ValidEmail;
}

function sendEmail(to: ValidEmail) { /* guaranteed valid */ }

sendEmail("raw@string");          // Error — must validate first
sendEmail(validateEmail("a@b"));  // OK
```

## Combining with Type Guards

```typescript
function isValidEmail(email: string): email is ValidEmail {
  return email.includes("@") && email.includes(".");
}

function handleSubmit(email: string) {
  if (!isValidEmail(email)) throw new Error("Invalid");
  sendEmail(email); // Narrowed to ValidEmail
}
```

## Pattern: Numeric IDs

```typescript
type OrderId = Opaque<number, "OrderId">;
type InvoiceId = Opaque<number, "InvoiceId">;

function OrderId(n: number): OrderId { return n as OrderId; }
function InvoiceId(n: number): InvoiceId { return n as InvoiceId; }
```

## Pattern: Units

```typescript
type Meters = Opaque<number, "Meters">;
type Kilometers = Opaque<number, "Kilometers">;

function metersToKm(m: Meters): Kilometers {
  return (m / 1000) as unknown as Kilometers;
}

const distance = 5000 as Meters;
metersToKm(distance);    // OK
metersToKm(5000);        // Error — raw number not assignable
```

## Pattern: Database Entity IDs

```typescript
type DbId<TEntity extends string> = Opaque<string, `${TEntity}Id`>;

type UserId = DbId<"User">;
type PostId = DbId<"Post">;
type CommentId = DbId<"Comment">;

// Generic CRUD
function findById<T extends string>(table: T, id: DbId<T>): Promise<unknown> { /* ... */ }
```

## Pitfalls

### Arithmetic breaks brands

```typescript
const a = 10 as Meters;
const b = 20 as Meters;
const c = a + b; // Type: number — brand lost! Must re-cast.
```

### Serialization strips brands

JSON.stringify/parse loses brand information. Re-validate after deserialization.

### Over-branding

Not every string needs a brand. Use for values that are **semantically distinct but structurally identical** (IDs, validated inputs, units). Regular strings are fine for display text, log messages, etc.
