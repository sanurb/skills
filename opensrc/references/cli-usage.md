For MCP-based usage, read [mcp-usage.md](mcp-usage.md).


# opensrc CLI Reference

## Command Summary

| Command | Purpose | Key flags |
|---------|---------|-----------|
| `opensrc path <spec...>` | Fetch on cache miss, then print absolute cache paths | `--cwd`, `--verbose` |
| `opensrc list` | List cached sources | `--json` |
| `opensrc remove <spec...>` | Remove cached package or repo entries | none |
| `opensrc clean` | Remove cached groups | `--packages`, `--repos`, `--npm`, `--pypi`, `--crates` |

## Spec Formats

| Kind | Format | Example |
|------|--------|---------|
| npm package | `<name>` | `zod` |
| npm package at version | `<name>@<version>` | `zod@4.3.6` |
| PyPI package | `pypi:<name>` | `pypi:requests` |
| crates.io package | `crates:<name>` | `crates:serde` |
| GitHub repo | `owner/repo` | `vercel/ai` |
| Repo with ref | `owner/repo@ref` | `vercel/ai@v5.0.0` |
| Repo with branch | `owner/repo#branch` | `vercel/ai#main` |
| Explicit host | `github:owner/repo` | `github:facebook/react` |
| Full URL | `https://host/owner/repo` | `https://github.com/colinhacks/zod` |

## Annotated Example

```bash
ROOT="$(opensrc path @tanstack/react-query --cwd /repo)"
rg 'invalidateQueries' "$ROOT"
sed -n '1,200p' "$ROOT/packages/query-core/src/queryClient.ts"
```

- `opensrc path` fetches on cache miss and returns one absolute path per spec.
- `--cwd` points version detection at the target project.
- Store the path once, then run normal shell tools against it.

## Command Details

### `opensrc path`

```bash
opensrc path [--cwd <path>] [--verbose] <spec...>
```

- Prints resolved cache paths to stdout.
- Sends fetch progress to stderr.
- Accepts packages and repos in the same call.

### `opensrc list`

```bash
opensrc list [--json]
```

- Plain output groups cached packages and repos.
- `--json` returns machine-readable metadata with names, versions, registries, paths, and timestamps.

Example JSON shape:

```json
{
  "updatedAt": "2026-04-12T14:46:11.633211+00:00",
  "packages": [
    {
      "name": "zod",
      "version": "4.3.6",
      "registry": "npm",
      "path": "repos/github.com/colinhacks/zod/4.3.6",
      "fetchedAt": "2026-04-12T14:46:11.633200+00:00"
    }
  ]
}
```

### `opensrc remove`

```bash
opensrc remove <spec...>
```

- Removes the cached entries for the given package or repo specs.
- Use the same spec syntax you used to fetch the source.

### `opensrc clean`

```bash
opensrc clean [--packages] [--repos] [--npm] [--pypi] [--crates]
```

- `--packages` removes every cached package entry.
- `--repos` removes direct repo entries.
- `--npm`, `--pypi`, and `--crates` scope cleanup to one registry.

## Environment

| Variable | Effect |
|----------|--------|
| `OPENSRC_HOME` | Override the global cache root |

## Notes
- Cache entries are global, not per-project.
- Package resolution uses the target project only for version detection.
- Repo refs map to cache subdirectories under the normalized host/owner/repo path.
