# `etc/http/README.md` Template

Use this as the collection's onboarding doc. It replaces a rules-ledger
`ARCHITECTURE.md`. Keep it short and drift-proof: every line is either an
invariant that is true by construction or a how-to that does not depend on the
current file list. Do not turn it back into an inventory of folders, tags, or
auth models — those live in the collection itself and would go stale here.

```md
# PROJECT_NAME — HTTP Collection

Bruno / OpenCollection requests for the PROJECT_NAME API, organized by domain.

## How it's laid out

Each top-level folder is a business capability — a bounded context — not an
HTTP verb or URL shape. `opencollection.yml` is the root; everything else is
browsable from there. The folder tree is the map, so this README does not
repeat it.

## How to run it

1. Copy `.env.sample` to `.env` and fill in the secrets.
2. Open `etc/http/` in Bruno, or run it headless with the Bruno CLI.
3. Select an environment: `local`, `staging`, or `production`.

## How to extend it without creating drift

- Put a request in the folder for its capability; add a new domain folder only
  for a genuinely new capability.
- Reuse the assertions in `lib.js` instead of copying response checks.
- Let a request inherit collection auth unless it truly differs.
- Give every request tags and a `docs:` block. That block is the request's
  contract, and it lives next to the request — so it can't drift away from it.
```

## Why this stays current

It describes intent and navigation, not a snapshot. The churny details —
folder names, tag taxonomy, auth models, secret names — are deliberately left
to the structure that already encodes them (`opencollection.yml`, the folder
tree, request `docs:` blocks, `.env.sample`). Nothing here needs editing when a
request or folder is added, so nothing here rots.
