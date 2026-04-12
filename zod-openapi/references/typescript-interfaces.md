# TypeScript Interface Patterns

## Input/Output Separation
Never reuse one type for both input and output. Inputs do not contain server-generated fields; outputs usually do, and they often include denormalized joins or metadata.

```typescript
export interface CreateTaskInput {
  title: string;
  description?: string;
  assigneeId?: UserId;
}

export interface Task {
  readonly id: TaskId;
  readonly title: string;
  readonly description: string | null;
  readonly assigneeId: UserId | null;
  readonly createdAt: string;
  readonly updatedAt: string;
  readonly createdBy: UserId;
}
```

## Discriminated Unions for Variants
Use discriminated unions when a value can be in multiple states with different required data.

```typescript
type TaskStatus =
  | { kind: "TODO" }
  | { kind: "IN_PROGRESS"; startedAt: string }
  | { kind: "BLOCKED"; reason: string }
  | { kind: "DONE"; completedAt: string };

function describeStatus(status: TaskStatus): string {
  switch (status.kind) {
    case "TODO":
      return "Not started";
    case "IN_PROGRESS":
      return `Started at ${status.startedAt}`;
    case "BLOCKED":
      return `Blocked: ${status.reason}`;
    case "DONE":
      return `Completed at ${status.completedAt}`;
    default:
      return assertNever(status);
  }
}
```

This lets TypeScript prove exhaustiveness. Add a new variant and every consumer missing a case becomes a type error.

## Branded Types for IDs
Use branded IDs to stop `TaskId` and `UserId` from being accidentally interchangeable.

```typescript
type Brand<T, TBrand extends string> = T & { readonly __brand: TBrand };

export type TaskId = Brand<string, "TaskId">;
export type UserId = Brand<string, "UserId">;

export function asTaskId(value: string): TaskId {
  return value as TaskId;
}

export function asUserId(value: string): UserId {
  return value as UserId;
}
```

## Optional vs Nullable
`field?: string` means absent from the input. `field: string | null` means present but explicitly empty. Rule of thumb: inputs use optional, outputs use nullable. That kills the ambiguity between “caller omitted it” and “caller explicitly cleared it.”

## Zod at Boundaries
Use one schema for runtime validation and type inference.

```typescript
import { z } from "zod";

export const CreateTaskSchema = z.object({
  title: z.string().min(1),
  description: z.string().max(500).optional(),
  assigneeId: z.string().optional(),
});

export type CreateTaskInput = z.infer<typeof CreateTaskSchema>;
```

## readonly and Immutability
Mark output fields as `readonly` to signal the caller should treat responses as immutable snapshots. Use `ReadonlyArray<T>` for response collections so accidental mutation becomes a type error instead of silent state drift.

## Exhaustiveness Helper
```typescript
function assertNever(value: never): never {
  throw new Error(`Unhandled variant: ${JSON.stringify(value)}`);
}
```

Use it in `default` branches of discriminated-union switches. Adding a new variant becomes a compile-time failure everywhere you forgot to handle it.

## Problem Details Type
Reuse the `ProblemDetails` interface from `errors.md` instead of inventing per-client error blobs.

```typescript
export type APIResult<T> =
  | { ok: true; data: T }
  | { ok: false; error: ProblemDetails };
```


## zod-openapi Type Integration

```ts
import type { ZodOpenApiMetadata } from 'zod-openapi';

declare module 'zod/v4' {
  interface GlobalMeta extends ZodOpenApiMetadata {}
}
```

This augmentation is required once per module graph so `.meta({ id, param, header, override, outputId, ... })` type-checks against Zod's global metadata surface.

```ts
import * as z from 'zod/v4';

const CreateTaskInput = z.object({
  title: z.string(),
}).meta({ id: 'CreateTaskInput' });

type CreateTaskInputType = z.infer<typeof CreateTaskInput>;
```

Use `z.infer<typeof InputSchema>` for request/input types. Response/output types can diverge; zod-openapi can emit `Foo` and `FooOutput` components when an object is used in both modes, and `CreateDocumentOptions.outputId` or `outputIdSuffix` controls that naming.

`createDocument` returns `oas31.OpenAPIObject`, re-exported from `@zod-openapi/openapi3-ts`.