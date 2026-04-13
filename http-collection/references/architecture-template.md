# `etc/http/ARCHITECTURE.md` Template

Use this as the starter for the collection's architecture contract.

```md
# PROJECT_NAME — HTTP Collection Architecture

## Structural Rules

### 1. Domain-first folders

Every top-level folder under `etc/http/` represents a business capability or bounded context.

Examples:

- `identity/`
- `billing/`
- `lifecycle/`
- `observability/`

Rejected patterns:

- `GET/`, `POST/`
- `controllers/`
- folder trees that mirror URLs instead of domain language

### 2. OpenCollection YAML is canonical

- `opencollection.yml` is the root
- request and folder files use `.yml`
- environments live in `environments/*.json`

### 3. Auth inheritance beats duplication

- collection-level auth defines the common default
- folder-level auth overrides are rare and justified
- request-level auth should usually be `inherit`

### 4. Variable layering

- environments define stable non-secret variables
- `.env` stores secrets
- environment JSON can read secrets via `{{process.env.NAME}}`
- request files consume interpolated variables only

### 5. Shared helpers live in `lib.js`

Put reusable assertions and test helpers in `etc/http/lib.js`.
Never copy-paste the same response checks across request files.

### 6. Every request has tags and `docs:`

Each request file documents:

- method and path
- parameters
- expected status codes
- error contract when relevant

### 7. Tags are operational, not decorative

Recommended starter taxonomy:

- `smoke`
- `regression`
- `write`
- `read-only`
- `ops`
- `platform`

### 8. Brownfield policy

When evolving an existing collection:

- add missing files without overwriting working ones
- collapse duplicate concepts into one canonical folder
- rename starter placeholders to real domain terms
- delete obsolete parallel structures after cutover
```
