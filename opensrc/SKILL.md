---
name: opensrc
description: Fetch dependency source code to give AI agents deeper implementation context. Use for library internals, dependency debugging, and real implementation review. Skip simple API docs; route multi-repo work to librarian or context7.
allowed-tools: Bash(opensrc:*)
---

# Source Code Fetching with opensrc

Fetch cached dependency source fast, then inspect real implementation files instead of guessing from types or docs.

## Non-Negotiables

- Run `opensrc path <spec>` before reading dependency files. Do not guess cache locations.
- Quote `"$(opensrc path ...)"` in shell composition so spaces and multiple outputs stay correct.
- Route public API and docs questions to context7. Route multi-repo or cross-package discovery to librarian.
- State behavior only after inspecting fetched source or explicitly note that the dependency could not be resolved.

## Output Format

Return these facts in the final answer:

- resolved package or repo spec
- absolute source path or paths returned by `opensrc path`
- files or directories inspected
- source-grounded conclusion, including uncertainty when the code inspected is incomplete


## Core Pattern

```bash
rg 'discriminatedUnion' "$(opensrc path zod --cwd /repo)"
find "$(opensrc path @tanstack/react-query --cwd /repo)" -maxdepth 2 -type f
cat "$(opensrc path vercel/ai)/packages/ai/core/generate-text.ts"
```

Use `opensrc path ...` as the composition primitive. It prints the absolute cache path to stdout and sends progress to stderr, so shell composition stays clean.

One spec returns one absolute path. Multiple specs return one absolute path per output line.

Read files, search directories, and join shell pipelines from that path instead of teaching the agent a separate cache layout.

When `opensrc-mcp` is available as an MCP server, prefer it for batch operations and structural search. The agent sends JS to the server, the server reads cached source locally, and source trees stay out of agent context. Read [references/mcp-usage.md](references/mcp-usage.md) for the MCP pattern.

## Fetching Source Code

```bash
opensrc path zod --cwd /repo
opensrc path zod@4.3.6
opensrc path pypi:requests@2.31.0
opensrc path crates:serde@1.0.217
opensrc path vercel/ai
opensrc path vercel/ai#main
opensrc path react @tanstack/react-query pypi:fastapi
```

Use `@version` to pin package versions. Use `@tag`, `@commit`, or `#branch` for direct repo refs.

### Version Resolution

Run `opensrc path <package> --cwd <project>` to resolve the installed version from the target project. npm resolution uses the target directory, not the current shell directory.

Resolution order:
1. `node_modules/<pkg>/package.json`
2. `package-lock.json`
3. `pnpm-lock.yaml`
4. `yarn.lock`
5. `package.json`

## Managing the Cache

Cache lives in `~/.opensrc/`. Override it with `OPENSRC_HOME`.

```bash
opensrc list
opensrc list --json
opensrc remove zod vercel/ai
opensrc clean --packages
opensrc clean --repos
OPENSRC_HOME=/tmp/opensrc opensrc path zod --cwd /repo
```

## When to Fetch Source

Fetch source when:
- Inspect internal behavior, control flow, cache invalidation, parser logic, or hidden defaults.
- Debug dependency behavior that docs, types, stack traces, or generated API surfaces do not explain.
- Verify implementation details before claiming how a package or repo works.
- Read real code paths, file layout, and module boundaries inside a dependency.
- For batch exploration of multiple packages or structural code search, use opensrc-mcp if available. Read [references/mcp-usage.md](references/mcp-usage.md).

Do not fetch source when:
- Docs answer the question directly. Use context7 for standard API questions.
- The task needs cross-package discovery, multi-repo comparison, or routing across many candidates. Use librarian.
- The task is basic usage, installation, configuration, or examples from a public API surface.

## Reference

Read [references/cli-usage.md](references/cli-usage.md) for command reference, flags, JSON output, and environment variables.
Read [references/mcp-usage.md](references/mcp-usage.md) for MCP execution, server-side source access, and naming behavior.
Read [references/architecture.md](references/architecture.md) for cache layout, registry resolution, and failure behavior.
Read [references/registry-support.md](references/registry-support.md) for registry prefixes, repo refs, and host-specific quirks.
