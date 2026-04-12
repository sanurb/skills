---
name: zod-openapi
description: Designs a REST API contract using zod-openapi v5 as the schema-first source of truth. Activate when the user says "Generate a OpenAPI document" or specifically wants as output a document in the OpenAPI specification
---

# zod-openapi

## Purpose
This skill produces one atomic REST API contract for a new or changed HTTP surface. Good APIs are boring, WE DO NOT BREAK USERSPACE, and zod-openapi keeps the schema-first source of truth in Zod while `createDocument` emits the OpenAPI contract. Use it only when the project already uses zod-openapi as the contract layer.

## Instructions
1. Define the Zod schema module. Read [references/typescript-interfaces.md](references/typescript-interfaces.md) and [references/zod-openapi-patterns.md](references/zod-openapi-patterns.md). Declare `GlobalMeta extends ZodOpenApiMetadata`, register every reusable component with `.meta({ id })`, model branded IDs, separate input from output schemas, and include the reusable `ProblemDetails` schema.
2. Define the error contract. Read [references/errors.md](references/errors.md). Enumerate every failure mode, model RFC 9457 Problem Details, use `application/problem+json` for every 4xx/5xx, keep `title` static per error class, put dynamic context in `detail`, and wire HTTP `Retry-After` plus `retry_after` on 429 and 503.
3. Emit via `createDocument`. Read [references/zod-openapi-patterns.md](references/zod-openapi-patterns.md). Compose the `ZodOpenApiObject` with `openapi: '3.1.0'`, `info`, `components.securitySchemes.bearerAuth`, `security`, and `paths` built from `requestParams`, `requestBody`, and `responses`; include rate-limit headers in response `headers`; then produce the final Output artifact.

## Non-Negotiable Acceptance Criteria
Deliver nothing if ANY criterion fails.

### General REST
1. Every 4xx and 5xx response MUST be RFC 9457 Problem Details under `application/problem+json`.
2. Every `type` URI MUST resolve to a url documentation.
3. Every error class MUST have a static `title`; dynamic context goes in `detail` only.
4. Every `instance` MUST be unique per occurrence.
5. Every 422 validation failure MUST include an `errors` array of `{ field, message, code }`.
6. Every 429 and 503 MUST set HTTP `Retry-After` and the `retry_after` body field.
7. Every `error_code` and `error_name` MUST come from a central catalog.
8. Every POST create or side-effect endpoint MUST accept `Idempotency-Key` via `requestParams.header`; DELETE by resource ID MUST NOT require it.
9. Every list endpoint MUST paginate; cursor MUST be the default for unbounded datasets; the response MUST include `next_page` or `nextCursor`.
10. Every response MUST set `RateLimit-Limit`, `RateLimit-Remaining`, and `RateLimit-Reset` headers.
11. Every endpoint MUST support long-lived API key auth via `Authorization: Bearer <key>` through `components.securitySchemes.bearerAuth`; OAuth MAY layer on top.
12. Every endpoint MUST have separate TypeScript input and output types.
13. Every input MUST be validated with Zod at the HTTP boundary before any service call.
14. Every path MUST use plural-noun kebab-case; verbs in paths are forbidden.
15. WE DO NOT BREAK USERSPACE. Stable contracts change additively only, and consumers MUST tolerate unexpected fields.
16. Versioning is a last resort. Additive extension MUST come first.
17. Expensive or associated response fields MUST be opt-in via `?include=<field>`.

### zod-openapi specific
18. The legacy helpers `extendZodWithOpenApi` and the `.openapi()` runtime extension (both removed in v5) are forbidden. Metadata flows through native Zod `.meta()` only.
19. Every project MUST declare `GlobalMeta extends ZodOpenApiMetadata` via `declare module 'zod/v4'` once per module graph.
20. Every reusable component MUST register through `.meta({ id: 'Name' })`; hand-written `$ref` strings and implicit `__schemaN` names are forbidden.
21. Every recursive or `z.lazy` schema MUST declare an explicit `.meta({ id })`.
22. `z.transform` in output schemas is forbidden; use `.pipe()`, `.overwrite()`, or manual `.meta({ override })`.
23. `createDocument` MUST be the single entry point; hand-written OpenAPI YAML and direct `oas31.OpenAPIObject` construction are forbidden.
24. `openapi:` MUST be `'3.1.0'` or newer unless a concrete downstream constraint requires 3.0.x; if 3.0.x is used, the generator file MUST document why inline.
25. Every failure response MUST use `content: { 'application/problem+json': { schema: ProblemDetails } }`, and `ProblemDetails` MUST register via `.meta({ id: 'ProblemDetails' })`.
26. Every request parameter MUST live under `requestParams: { path | query | header | cookie }`; hand-rolled `parameters: [...]` arrays are forbidden.

## Output
### 1. Resource Summary
Table columns: Method, Path (kebab-case plural), Purpose, Success Status, Auth Scope, Rate Limit Tier, Idempotency.

### 2. Zod Schema Module
TypeScript block with `import * as z from 'zod/v4';`, `import type { ZodOpenApiMetadata } from 'zod-openapi';`, `declare module 'zod/v4' { interface GlobalMeta extends ZodOpenApiMetadata {} }`, every input/output/reusable schema, branded IDs, and `ProblemDetails`.

### 3. createDocument Module
TypeScript block with `import { createDocument } from 'zod-openapi';`, `import type { ZodOpenApiObject, ZodOpenApiPathsObject } from 'zod-openapi';`, and a full `createDocument({ openapi: '3.1.0', info, components: { schemas, securitySchemes }, security, paths })` call using `requestParams`, `requestBody`, `responses`, and response `headers`.

### 4. Error Catalog
Table: `error_code`, `error_name`, `error_category`, `status`, `retryable`, `owner_action_required`, `title`, `type`.

### 5. ProblemDetails Instances
One JSON block per failure mode showing the complete RFC 9457 Problem Details body emitted at runtime.

### 6. TypeScript Input/Output Types
TypeScript block deriving types via `z.infer<>`, including the input/output split for schemas that diverge and can emit `Foo` / `FooOutput` components.

### 7. curl Examples
One success curl and one failure curl per endpoint. Every curl MUST include `Authorization: Bearer <key>`, and every success case MUST show `RateLimit-*` response headers.

## References
| File | One Job |
|---|---|
| [references/zod-openapi-patterns.md](references/zod-openapi-patterns.md) | zod-openapi v5 path modeling, requestParams, createDocument, auth, rate limits |
| [references/errors.md](references/errors.md) | RFC 9457 catalog rules and ProblemDetails wiring |
| [references/typescript-interfaces.md](references/typescript-interfaces.md) | GlobalMeta augmentation, branded IDs, input/output type split |