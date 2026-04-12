# zod-openapi Patterns

## WE DO NOT BREAK USERSPACE
Stable API contracts are law. The server MAY add fields, but it MUST NOT rename fields, delete fields, or retune stable semantics after clients ship. The HTTP `Referer` header is misspelled forever because deployed clients beat taste every time. Once a reusable component is published with `.meta({ id: 'Name' })`, renaming that component or changing its wire type is forbidden unless the entire API version changes.

## Resource Design
| Method | Path | Purpose |
|---|---|---|
| `GET` | `/tasks` | Return a paginated collection |
| `POST` | `/tasks` | Create one task |
| `GET` | `/tasks/{taskId}` | Return one resource |
| `PATCH` | `/tasks/{taskId}` | Partially update provided fields |
| `PUT` | `/tasks/{taskId}` | Fully replace one resource |
| `DELETE` | `/tasks/{taskId}` | Delete or tombstone one resource |
| `GET` | `/tasks/{taskId}/comments` | Return nested sub-resources |

Use plural-noun kebab-case paths. Good: `/order-items`, `/tax-rates`, `/webhook-subscriptions`. Forbidden: `/createOrder`, `/OrderItems`, `/task_comments`.

```ts
import * as z from 'zod/v4';
import type { ZodOpenApiPathsObject } from 'zod-openapi';

const TaskId = z.string().meta({ id: 'TaskId', description: 'Task id', example: 'task_123' });
const Task = z.object({ id: TaskId, title: z.string() }).meta({ id: 'Task' });

export const paths: ZodOpenApiPathsObject = {
  '/tasks': {
    get: {
      operationId: 'listTasks',
      responses: {
        '200': {
          description: 'Tasks listed',
          content: { 'application/json': { schema: z.object({ data: z.array(Task) }) } },
        },
      },
    },
  },
};
```

## Path, Query, Header, Cookie Parameters
Put every parameter under `requestParams`. `parameters: [...]` arrays are forbidden because they duplicate location data and collide with `.meta({ param })`.

```ts
requestParams: {
  path: z.object({
    taskId: z.string().meta({ description: 'Task ID' }),
  }),
  query: z.object({
    search: z.string().optional(),
    pageSize: z.number().int().default(20),
  }),
  header: z.object({
    Authorization: z.string(),
    'Idempotency-Key': z.string().uuid().optional(),
  }),
  cookie: z.object({
    sessionId: z.string().optional(),
  }),
}
```

## Request Body
Use `requestBody.content` with Zod schemas. Set `required: true` when omission is invalid, and document the payload with `description`.

```ts
const CreateTaskInput = z.object({
  title: z.string().min(1),
  description: z.string().max(500).optional(),
}).meta({ id: 'CreateTaskInput' });

requestBody: {
  description: 'Task payload',
  required: true,
  content: {
    'application/json': {
      schema: CreateTaskInput,
    },
  },
}
```

## Responses and Headers
Success and failure responses live together under `responses`. Response headers are modeled as `z.object(...)`, not ad-hoc prose.

```ts
const RateLimitHeaders = z.object({
  'RateLimit-Limit': z.string(),
  'RateLimit-Remaining': z.string(),
  'RateLimit-Reset': z.string(),
}).meta({ id: 'RateLimitHeaders' });

const ProblemDetails = z.object({
  type: z.string().url().meta({ example: 'https://api.example.com/problems/not-found' }),
  title: z.string(),
  status: z.number().int(),
  detail: z.string().optional(),
  instance: z.string().optional(),
}).catchall(z.unknown()).meta({ id: 'ProblemDetails' });

responses: {
  '200': {
    description: 'OK',
    headers: RateLimitHeaders,
    content: {
      'application/json': {
        schema: z.object({ id: z.string() }),
      },
    },
  },
  '404': {
    description: 'Not Found',
    content: {
      'application/problem+json': {
        schema: ProblemDetails,
      },
    },
  },
}
```

## Component Registration
`.meta({ id })` is the only stable registration mechanism. Hand-written `$ref` strings are forbidden because they bypass the emitter and drift from the actual schema.

```ts
const User = z.object({
  id: z.string(),
  email: z.string().email(),
}).meta({ id: 'User' });
```

Forbidden:

```ts
const components = {
  schemas: {
    User: { $ref: '#/components/schemas/User' },
  },
};
```

## Input vs Output Components
A schema reused for both input and output can split into `Foo` and `FooOutput` components when request and response shapes diverge. Control naming with `outputId` on the schema or `outputIdSuffix` in `CreateDocumentOptions`.

```ts
const TaskInput = z.object({
  title: z.string(),
}).meta({ id: 'Task', outputId: 'TaskOutput' });

const TaskOutput = z.object({
  id: z.string(),
  title: z.string(),
  createdAt: z.string(),
}).meta({ id: 'TaskOutput' });
```

## Recursive and Lazy Schemas
Recursive schemas need `z.lazy()` plus an explicit id. Unnamed recursion produces unstable `__schemaN` component names and is forbidden.

```ts
type TreeNode = { name: string; children: TreeNode[] };

const TreeNodeSchema: z.ZodType<TreeNode> = z.object({
  name: z.string(),
  children: z.array(z.lazy(() => TreeNodeSchema)),
}).meta({ id: 'TreeNode' });
```

## Transforms Are Forbidden in Output
`createSchema(z.string().transform(...))` throws in output mode. Use `.pipe()`, `.overwrite()`, or `.meta({ override })` instead.

```ts
createSchema(z.string().transform((value) => value.trim()));
```

```ts
const Trimmed = z.string().pipe(z.string().min(1));
const Canonical = z.string().overwrite((value) => value.trim());
const Manual = z.string().meta({ override: ({ jsonSchema }) => ({ ...jsonSchema, pattern: '^[A-Z]+$' }) });
```

## Discriminated Unions
Register each branch with a stable id so the emitter can produce `oneOf` refs and `discriminator.mapping`.

```ts
const EmailJob = z.object({ type: z.literal('email'), subject: z.string() }).meta({ id: 'EmailJob' });
const SmsJob = z.object({ type: z.literal('sms'), phone: z.string() }).meta({ id: 'SmsJob' });

const Job = z.discriminatedUnion('type', [EmailJob, SmsJob]).meta({ id: 'Job' });
```

## Pagination
Cursor pagination is the default for unbounded datasets. Offset pagination is acceptable only for bounded datasets or admin views.

```ts
const TaskList = z.object({
  data: z.array(Task),
  nextCursor: z.string().nullable(),
}).meta({ id: 'TaskList' });

get: {
  requestParams: {
    query: z.object({
      cursor: z.string().optional(),
      pageSize: z.number().int().default(20),
    }),
  },
  responses: {
    '200': {
      description: 'OK',
      content: { 'application/json': { schema: TaskList } },
    },
  },
}
```

## Filtering and Sorting
Put filters and sorting in `requestParams.query`. Keep query keys camelCase even when path segments are kebab-case.

```ts
requestParams: {
  query: z.object({
    status: z.enum(['todo', 'in_progress', 'done']).optional(),
    createdAfter: z.string().datetime().optional(),
    sortBy: z.enum(['createdAt', 'updatedAt']).default('createdAt'),
    sortOrder: z.enum(['asc', 'desc']).default('desc'),
  }),
}
```

## PATCH vs PUT
PATCH is the default for partial updates. PUT is for full replacement semantics only.

```ts
const PatchTaskInput = z.object({
  title: z.string().optional(),
  status: z.enum(['todo', 'done']).optional(),
}).meta({ id: 'PatchTaskInput' });

const PutTaskInput = z.object({
  title: z.string(),
  status: z.enum(['todo', 'done']),
}).meta({ id: 'PutTaskInput' });

patch: {
  requestBody: { required: true, content: { 'application/json': { schema: PatchTaskInput } } },
  responses: { '200': { description: 'Updated', content: { 'application/json': { schema: Task } } } },
},
put: {
  requestBody: { required: true, content: { 'application/json': { schema: PutTaskInput } } },
  responses: { '200': { description: 'Replaced', content: { 'application/json': { schema: Task } } } },
}
```

## Idempotency
POST creates and side-effect triggers accept `Idempotency-Key` via `requestParams.header`. DELETE by resource id is naturally idempotent, and PUT is idempotent by HTTP semantics.

```ts
post: {
  requestParams: {
    header: z.object({
      Authorization: z.string(),
      'Idempotency-Key': z.string().uuid().optional(),
    }),
  },
  requestBody: {
    required: true,
    content: { 'application/json': { schema: CreateTaskInput } },
  },
  responses: {
    '201': { description: 'Created', content: { 'application/json': { schema: Task } } },
  },
}
```

## Expansions
Expensive or associated fields are opt-in with `?include=`.

```ts
requestParams: {
  query: z.object({
    include: z.array(z.enum(['subscription', 'posts'])).optional(),
  }),
}
```

## Authentication
Bearer auth is the baseline. OAuth2 and API key variants can coexist when the API needs them.

```ts
components: {
  securitySchemes: {
    bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
    apiKeyAuth: { type: 'apiKey', in: 'header', name: 'X-API-Key' },
    oauth2Auth: {
      type: 'oauth2',
      flows: {
        clientCredentials: {
          tokenUrl: 'https://auth.example.com/token',
          scopes: { 'tasks:read': 'Read tasks' },
        },
      },
    },
  },
},
security: [{ bearerAuth: [] }]
```

## Rate Limiting
Rate-limit headers are part of the public contract. On 429 and 503, set the HTTP `Retry-After` header and include a `retry_after` body field.

```ts
responses: {
  '200': {
    description: 'OK',
    headers: z.object({
      'RateLimit-Limit': z.string(),
      'RateLimit-Remaining': z.string(),
      'RateLimit-Reset': z.string(),
    }),
    content: { 'application/json': { schema: Task } },
  },
  '429': {
    description: 'Rate limited',
    headers: z.object({ 'Retry-After': z.string() }),
    content: {
      'application/problem+json': {
        schema: ProblemDetails.extend({ retry_after: z.number().int() }),
      },
    },
  },
}
```

APIs run at the speed of code; these headers let consumers back off deterministically instead of guessing.

## Versioning
Versioning is the last resort. Add fields first, preserve semantics, and only fork the surface when additive evolution is impossible. If a break is unavoidable, choose one style such as `/v2/tasks` or a vendor media type and apply it everywhere. Do NOT mix styles.

## createDocument Entry Point
`createDocument` is the single entry point. Build Zod schemas first, compose `components`, `security`, and `paths`, then emit the final `oas31.OpenAPIObject`.

```ts
import * as z from 'zod/v4';
import { createDocument } from 'zod-openapi';
import type { ZodOpenApiMetadata, ZodOpenApiObject, ZodOpenApiPathsObject, oas31 } from 'zod-openapi';

declare module 'zod/v4' {
  interface GlobalMeta extends ZodOpenApiMetadata {}
}

type Brand<T, TBrand extends string> = T & { readonly __brand: TBrand };
type TaskId = Brand<string, 'TaskId'>;

const TaskIdSchema = z.string().meta({ id: 'TaskId', description: 'Task id', example: 'task_123' });
const ProblemDetails = z.object({
  type: z.string().url().meta({ example: 'https://api.example.com/problems/not-found' }),
  title: z.string(),
  status: z.number().int(),
  detail: z.string().optional(),
  instance: z.string().optional(),
}).catchall(z.unknown()).meta({ id: 'ProblemDetails' });
const CreateTaskInput = z.object({ title: z.string().min(1) }).meta({ id: 'CreateTaskInput' });
const Task = z.object({ id: TaskIdSchema, title: z.string() }).meta({ id: 'Task' });
const RateLimitHeaders = z.object({
  'RateLimit-Limit': z.string(),
  'RateLimit-Remaining': z.string(),
  'RateLimit-Reset': z.string(),
}).meta({ id: 'RateLimitHeaders' });

const paths: ZodOpenApiPathsObject = {
  '/tasks': {
    post: {
      operationId: 'createTask',
      requestParams: {
        header: z.object({
          Authorization: z.string(),
          'Idempotency-Key': z.string().uuid().optional(),
        }),
      },
      requestBody: {
        description: 'Task payload',
        required: true,
        content: { 'application/json': { schema: CreateTaskInput } },
      },
      responses: {
        '201': {
          description: 'Created',
          headers: RateLimitHeaders,
          content: { 'application/json': { schema: Task } },
        },
        '422': {
          description: 'Validation failed',
          content: { 'application/problem+json': { schema: ProblemDetails } },
        },
      },
    },
  },
};

const documentConfig: ZodOpenApiObject = {
  openapi: '3.1.0',
  info: { title: 'Tasks API', version: '1.0.0' },
  components: {
    schemas: { Task, CreateTaskInput, ProblemDetails },
    securitySchemes: {
      bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
    },
  },
  security: [{ bearerAuth: [] }],
  paths,
};

export const openApiDocument: oas31.OpenAPIObject = createDocument(documentConfig);
```

## Status Code Discipline
| Status | Meaning |
|---|---|
| `200` | Successful read or update with a body |
| `201` | Resource created |
| `204` | Successful no-body operation |
| `400` | Malformed request or unsupported combination |
| `401` | Missing or invalid credentials |
| `403` | Authenticated but forbidden |
| `404` | Resource or parent resource missing |
| `409` | State conflict or duplicate |
| `422` | Parsed request with semantically invalid fields |
| `429` | Rate limited; include `Retry-After` and `retry_after` |
| `500` | Internal server error |
| `503` | Temporary unavailability; MAY include retry guidance |