---
name: feature-slicing
description: Apply Feature-Sliced Design (FSD) architecture when creating or modifying frontend code. Routes code to correct layers (app/pages/widgets/features/entities/shared) and enforces strict downward-only import rules. Use when creating components, pages, features, or restructuring React/Next.js/Vue/Remix projects. Do NOT use for backend services, non-UI libraries, single-file scripts, or projects with fewer than 5 components.
---

# Feature-Sliced Design

Apply FSD layer hierarchy and import rules when creating or modifying frontend code. Organizes code by business domain, not technical role.

## Instructions

### Step 1. Route code to the correct layer

Determine where the code belongs:

```
Where does it go?
├─ Reusable infrastructure, no business logic? → shared/
├─ Business domain data model (noun)?          → entities/{name}/
├─ User interaction with business value (verb)?
│   ├─ Reused across pages                    → features/{name}/
│   └─ Single page only                       → pages/{page}/ (keep in page slice)
├─ Complex reusable UI composition?            → widgets/{name}/
├─ Full page / route component?                → pages/{name}/
└─ App-wide config, providers, routing?        → app/
```

**Entity vs Feature:** Entities are THINGS with identity (user, product, order). Features are ACTIONS with side effects (auth, add-to-cart, checkout).

**Minimal setup:** Start with `app/`, `pages/`, `shared/`. Add `entities/`, `features/`, `widgets/` as complexity grows.

### Step 2. Create the slice with segments and public API

Place code in purpose-driven segments within the slice:

| Segment | Contents |
|---------|----------|
| `ui/` | React components, styles |
| `api/` | Backend calls, data fetching, DTOs |
| `model/` | Types, schemas, stores, business logic |
| `lib/` | Slice-specific utilities |
| `config/` | Feature flags, constants |

Expose a public API via `index.ts` with explicit named exports:

```typescript
// entities/user/index.ts
export { UserCard } from './ui/UserCard';
export { getUser } from './api/userApi';
export type { User } from './model/types';
```

For cross-entity references, use `@x/` notation — see [public-api.md](references/public-api.md).

### Step 3. Validate import rules

Check that all imports flow strictly downward:

```
app → pages → widgets → features → entities → shared
```

| Violation | Fix |
|-----------|-----|
| Cross-slice (same layer): `features/a` → `features/b` | Extract shared logic to `entities/` or `shared/` |
| Upward: `entities/user` → `features/auth` | Move shared code to a lower layer |
| `shared/` importing from any layer | Shared has zero internal deps — only external packages |
| Direct internal import: `@/entities/user/ui/UserCard` | Import from public API: `@/entities/user` |

## Non-Negotiable

- Imports flow downward only. No upward, no cross-slice within the same layer.
- Every slice has an `index.ts` with explicit named exports. No wildcard re-exports (`export *`).
- Segment names are purpose-driven (`ui/`, `api/`, `model/`). Never generic (`components/`, `hooks/`, `types/`).
- External code imports from `index.ts` only, never from internal paths.
- `shared/` contains zero business domain logic.
- `app/` and `shared/` have no slices (internal cross-segment imports are allowed within them).

## Output

Created/modified files placed in the correct layer → slice → segment with a valid `index.ts` public API. All imports validated against the layer hierarchy.

## References

| File | When to read |
|------|-------------|
| [layers.md](references/layers.md) | Detailed layer specs when routing is ambiguous |
| [public-api.md](references/public-api.md) | @x cross-entity notation, tree-shaking, barrel files |
| [implementation.md](references/implementation.md) | Code patterns: entities, features, widgets with React Query |
| [nextjs.md](references/nextjs.md) | Next.js App Router / Pages Router integration |
| [migration.md](references/migration.md) | Migrating a legacy codebase to FSD incrementally |
| [cheatsheet.md](references/cheatsheet.md) | Quick reference, import matrix |
