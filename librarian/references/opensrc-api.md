# opensrc-mcp API Reference

Use the opensrc-mcp server through its single codemode execute tool. Agents send JavaScript that runs server-side. Source trees stay out of agent context; only returned values enter the conversation.

## Core Rule

Capture `source.name` from `opensrc.fetch()` results and reuse it for every later call.

```javascript
async () => {
  const [{ source }] = await opensrc.fetch("vercel/ai");
  const files = await opensrc.files(source.name, "src/**/*.ts");
  return { sourceName: source.name, count: files.length };
}
```

## API Surface

### Discovery

```typescript
opensrc.list(): Source[]
opensrc.has(name: string, version?: string): boolean
opensrc.get(name: string): Source | undefined
opensrc.resolve(spec: string): Promise<ParsedSpec>
```

- `list()` returns fetched sources already available on the server.
- `has()` checks cache presence by source name and optional version.
- `get()` returns metadata for one fetched source.
- `resolve()` parses a package or repo spec before fetch.

### Fetch and Cleanup

```typescript
opensrc.fetch(
  specs: string | string[],
  options?: { modify?: boolean }
): Promise<FetchedSource[]>

opensrc.remove(names: string[]): Promise<RemoveResult>
opensrc.clean(options?: {
  packages?: boolean
  repos?: boolean
  npm?: boolean
  pypi?: boolean
  crates?: boolean
}): Promise<RemoveResult>
```

- `fetch()` accepts one spec or many specs.
- `modify: false` supports read-only fetch flows when the environment exposes that option.
- `remove()` deletes named fetched sources.
- `clean()` removes grouped caches.

### File and Tree Access

```typescript
opensrc.files(sourceName: string, glob?: string): Promise<FileEntry[]>
opensrc.tree(sourceName: string, options?: { depth?: number }): Promise<TreeNode>
opensrc.read(sourceName: string, filePath: string): Promise<string>
opensrc.readMany(
  sourceName: string,
  paths: string[]
): Promise<Record<string, string>>
```

- `files()` lists files and directories, filtered by optional glob.
- `tree()` returns a nested directory tree. Default depth is shallow; set `depth` when needed.
- `read()` returns one file as text.
- `readMany()` accepts explicit paths and globs. Failed reads come back as string values prefixed with `[Error:`.

### Search

```typescript
opensrc.grep(
  pattern: string,
  options?: {
    sources?: string[]
    include?: string
    maxResults?: number
  }
): Promise<GrepResult[]>

opensrc.astGrep(
  sourceName: string,
  pattern: string,
  options?: {
    glob?: string
    lang?: string | string[]
    limit?: number
  }
): Promise<AstGrepMatch[]>
```

- `grep()` runs regex search. Omit `sources` to search all fetched sources.
- `include` filters by file glob such as `*.ts` or `**/*.tsx`.
- `astGrep()` searches one source at a time with structural patterns.
- `lang` accepts one language or many. `limit` bounds result volume.

## Return Shapes

### Source Metadata

```typescript
Source {
  type: "npm" | "pypi" | "crates" | "repo"
  name: string
  version?: string
  ref?: string
  path: string
  fetchedAt: string
  repository: string
}

FetchedSource {
  source: Source
  alreadyExists: boolean
}
```

### Search Results

```typescript
GrepResult {
  source: string
  file: string
  line: number
  content: string
}

AstGrepMatch {
  file: string
  line: number
  column: number
  endLine: number
  endColumn: number
  text: string
  metavars: Record<string, string>
}
```

### File and Cleanup Results

```typescript
FileEntry { path: string; size: number; isDirectory: boolean }
TreeNode { name: string; type: "file" | "dir"; children?: TreeNode[] }
RemoveResult { success: boolean; removed: string[] }
```

## AST Pattern Syntax

| Pattern | Meaning |
|---------|---------|
| `$NAME` | Match one node and capture it |
| `$$$ARGS` | Match many nodes and capture them |
| `$_` | Match one node without capture |
| `$$$` | Match many nodes without capture |

## Error Behavior

- Most operations throw on failure. Wrap multi-step workflows in `try/catch`.
- `readMany()` mixes successful file contents and `[Error: ...]` strings in one record.

```javascript
async () => {
  try {
    const files = await opensrc.readMany("zod", ["src/index.ts", "missing.ts"]);
    return Object.fromEntries(
      Object.entries(files).filter(([, value]) => !value.startsWith("[Error:"))
    );
  } catch (error) {
    return { error: error.message };
  }
}
```

## Shared Spec Formats

| Format | Example | Resulting `source.name` |
|--------|---------|-------------------------|
| `<name>` | `"zod"` | `"zod"` |
| `<name>@<version>` | `"zod@3.22.0"` | `"zod"` |
| `npm:<name>` | `"npm:zod"` | `"zod"` |
| `pypi:<name>` | `"pypi:requests"` | `"requests"` |
| `crates:<name>` | `"crates:serde"` | `"serde"` |
| `owner/repo` | `"vercel/ai"` | `"github.com/vercel/ai"` |
| `owner/repo@ref` | `"vercel/ai@v1.0.0"` | `"github.com/vercel/ai"` |
| `github:owner/repo` | `"github:vercel/ai"` | `"github.com/vercel/ai"` |
