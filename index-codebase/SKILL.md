---
name: index-codebase
description: Index a codebase with codemogger (semantic + keyword search) and optionally zoekt (trigram regex search) for efficient agent code navigation. Use when preparing for architecture analysis, exploring an unfamiliar codebase, or when grep/ripgrep returns too many irrelevant matches. Do NOT use if .codemogger/ already exists and is current, for non-code assets, or for single-file lookups where grep suffices.
---

# Index Codebase

One-time setup to enable fast semantic and keyword code search. Produces a local `.db` file (codemogger) and optionally a trigram index (zoekt). No Docker, no API keys, no servers.

## Instructions

### Step 1. Check prerequisites

Verify codemogger is available:

```bash
npx codemogger --version
```

If the `.codemogger/` directory already exists in the target repo, skip to Step 3 (verification). If files have changed since last index, run `codemogger reindex` instead of full index.

For zoekt (optional — use for large codebases needing regex + boolean queries):

```bash
which zoekt-index && which zoekt-webserver
```

If zoekt binaries are missing and the user wants trigram search, install via `go install github.com/sourcegraph/zoekt/cmd/...@latest`.

### Step 2. Index

Run codemogger against the target directory:

```bash
npx codemogger index <path-to-repo>
```

For zoekt (optional):

```bash
zoekt-git-index -index ~/.zoekt <path-to-repo>
```

Add `.codemogger/` to `.gitignore` if not already present:

```bash
echo '.codemogger/' >> <path-to-repo>/.gitignore
```

### Step 3. Verify

Run a test search to confirm the index works:

```bash
npx codemogger search "main entry point"
```

The search must return at least 1 result. If it returns 0, the index failed — re-run Step 2.

## Non-Negotiable

- `.codemogger/` database must exist and contain indexed chunks after completion.
- A test search must return at least 1 result.
- `.codemogger/` must be listed in `.gitignore`.
- Do NOT modify any source files during indexing.

## Output

```
Index complete.
- codemogger: <N> files indexed in .codemogger/
- zoekt: indexed at ~/.zoekt/ (if applicable)
- .gitignore: updated
```
