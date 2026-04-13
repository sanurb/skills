---
name: http-collection
description: Scaffold or repair `etc/http/` OpenCollection trees for Bruno. Use for new collections, brownfield standardization, or Bruno/Postman migration.
---

# HTTP Collection

Build one canonical `etc/http/` tree that matches the repo's real API surface and domain language.

Reference spec: https://spec.opencollection.com/ (`v1.0.0`).

## Trigger Signals

- Create a new `etc/http/` collection
- Repair a partial or inconsistent `etc/http/` tree
- Migrate Bruno/Postman requests into one OpenCollection structure
- Add missing environments, shared helpers, or architecture rules to an existing collection

## Do Not Use For

- One-off request debugging or ad-hoc `curl` snippets
- SDK generation
- GraphQL-, gRPC-, or WebSocket-only collections

## Non-Negotiables

1. Read the repo API surface first: routes, handlers, bounded contexts, and any existing request collections.
2. Detect the mode before editing: greenfield when `etc/http/opencollection.yml` is absent; brownfield when `etc/http/` or any collection item already exists.
3. Run `scripts/scaffold.sh <project-root>` to create the canonical starter tree.
4. Use `etc/http/opencollection.yml` as the collection root. Use OpenCollection YAML (`.yml`) for request and folder files.
5. Put non-secret variables in `etc/http/environments/*.json`. Put secrets in `.env`. Commit only `.env.sample`.
6. Organize folders by domain context (`identity/`, `billing/`, `lifecycle/`), never by HTTP verb or raw URL shape.
7. Put shared assertions and reusable test helpers in `etc/http/lib.js`. Put shared runtime setup in `opencollection.yml`.
8. Give every request tags and a `docs:` block.
9. In brownfield repos, add missing root files, preserve working request files, and remove placeholder starter folders after real domain folders replace them.

## Workflow

1. Read [the minimum schema summary](references/spec-summary.md).
2. Read [the starter templates](references/templates.md).
3. Read [the architecture contract template](references/architecture-template.md).
4. Detect the mode.
5. Run `scripts/scaffold.sh <project-root>`.
6. Replace `domain-context/` with real bounded-context folder names from the repo.
7. Rename sample requests to real business actions.
8. Adjust collection auth to the API's real auth model. If observability endpoints require auth, inherit auth there too.
9. Keep one canonical folder per capability. Delete parallel placeholders, duplicate imports, and verb-based folder trees after cutover.
10. Validate the final tree with the checklist below.

## Output Format

This skill produces one artifact. Return exactly this markdown artifact after applying the skill:

```markdown
## HTTP Collection Plan
- Mode: {greenfield | brownfield}
- Read: `references/spec-summary.md`, `references/templates.md`, `references/architecture-template.md`, `scripts/scaffold.sh`
- Ran: `scripts/scaffold.sh <project-root>`
- Created: {files}
- Updated: {files}
- Removed: {files or "none"}
- Customized domains: {folders}
- Validation:
  - [ ] `opencollection.yml` is the root
  - [ ] `environments/*.json` contain placeholders or `process.env` references only
  - [ ] `.env.sample` exists and `.env` stays uncommitted
  - [ ] `lib.js` holds shared assertions
  - [ ] every request has tags and `docs:`
  - [ ] folder names use domain language, not HTTP verbs
```

## Reading Order

| Task | Read |
|------|------|
| Understand required schema | [references/spec-summary.md](references/spec-summary.md) |
| Copy or adapt starter files | [references/templates.md](references/templates.md) |
| Write or refresh `ARCHITECTURE.md` | [references/architecture-template.md](references/architecture-template.md) |
| Generate starter tree | `scripts/scaffold.sh` |

## Integrated Examples

### Greenfield scaffold

**Before**

```text
repo/
└── src/
```

**After**

```text
etc/http/
├── opencollection.yml
├── lib.js
├── .env.sample
├── .gitignore
├── ARCHITECTURE.md
├── environments/
│   ├── local.json
│   ├── staging.json
│   └── production.json
├── observability/
│   ├── folder.yml
│   └── liveness.yml
└── identity/
    ├── folder.yml
    └── current-principal.yml
```

Use `identity/` because the repo's auth API is the real bounded context. Do not keep `domain-context/` once the real folder exists.

### Brownfield repair

**Before**

```text
etc/http/
├── identity/
│   └── current-principal.yml
├── billing/
│   └── invoice-summary.yml
└── domain-context/
    └── get-resource.yml
```

**After**

```text
etc/http/
├── opencollection.yml
├── lib.js
├── .env.sample
├── .gitignore
├── ARCHITECTURE.md
├── environments/
│   ├── local.json
│   ├── staging.json
│   └── production.json
├── observability/
│   ├── folder.yml
│   └── liveness.yml
├── identity/
│   └── current-principal.yml
└── billing/
    └── invoice-summary.yml
```

Keep `identity/` and `billing/`. Delete the placeholder `domain-context/` tree after the real contexts cover the domain.

## Validation Checklist

- `SKILL.md` stays lean; starter content lives in the reference files.
- `opencollection.yml` is valid OpenCollection YAML.
- Environment files contain placeholders only; secrets come from `.env` or `process.env`.
- Root helpers stay shared; request files do not duplicate assertion logic.
- Folder names reflect domain language, not transport trivia.