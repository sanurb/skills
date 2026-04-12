# opensrc MCP Usage

MCP server where agents write JS that runs server-side; source trees stay out of agent context.

## Execution Model

Use the MCP `execute` tool. Write JavaScript that runs inside the server sandbox against cached sources.

Sandbox API:

```ts
declare const opensrc: {
  list(): Source[];
  has(name: string, version?: string): boolean;
  get(name: string): Source | undefined;
  files(sourceName: string, glob?: string): Promise<FileEntry[]>;
  tree(sourceName: string, options?: { depth?: number }): Promise<TreeNode>;
  grep(pattern: string, options?: { sources?: string[]; include?: string; maxResults?: number }): Promise<GrepResult[]>;
  astGrep(sourceName: string, pattern: string, options?: { glob?: string; lang?: string | string[]; limit?: number }): Promise<AstGrepMatch[]>;
  read(sourceName: string, filePath: string): Promise<string>;
  readMany(sourceName: string, paths: string[]): Promise<Record<string, string>>;
  resolve(spec: string): Promise<ParsedSpec>;
  fetch(specs: string | string[], options?: { modify?: boolean }): Promise<FetchedSource[]>;
  remove(names: string[]): Promise<RemoveResult>;
  clean(options?: { packages?: boolean; repos?: boolean; npm?: boolean; pypi?: boolean; crates?: boolean }): Promise<RemoveResult>;
};
declare const sources: Source[];
declare const cwd: string;
```

## Core Methods

- `fetch`: `const fetched = await opensrc.fetch(['zod', 'vercel/ai']);`
- `files`: `const entries = await opensrc.files('github.com/vercel/ai', '**/*.ts');`
- `tree`: `const root = await opensrc.tree('github.com/vercel/ai', { depth: 2 });`
- `grep`: `const hits = await opensrc.grep('generateText', { sources: ['github.com/vercel/ai'] });`
- `astGrep`: `const hits = await opensrc.astGrep('github.com/vercel/ai', 'import { $$$A } from "zod"', { glob: '**/*.ts', lang: 'typescript' });`
- `read`: `const text = await opensrc.read('github.com/vercel/ai', 'packages/ai/core/generate-text.ts');`
- `readMany`: `const files = await opensrc.readMany('github.com/vercel/ai', ['package.json', 'pnpm-workspace.yaml']);`

## Globals

- `sources`: current cached source descriptors visible to the server
- `cwd`: server working directory for relative file operations inside the sandbox

## Storage

- MCP cache root: `~/.local/share/opensrc/`
- Override with `OPENSRC_DIR` or `XDG_DATA_HOME`
- CLI cache root: `~/.opensrc/`
- CLI override: `OPENSRC_HOME`

## Source Naming

`source.name` can differ from the fetch spec. Use the returned `name` field for follow-up calls.

| Fetch spec | Returned `source.name` |
|---|---|
| `zod` | `zod` |
| `npm:zod` | `zod` |
| `pypi:requests` | `requests` |
| `crates:serde` | `serde` |
| `vercel/ai` | `github.com/vercel/ai` |
| `github:vercel/ai` | `github.com/vercel/ai` |
| `vercel/ai@v5.0.0` | `github.com/vercel/ai` |

## Package Formats

| Kind | Format | Example |
|---|---|---|
| npm package | `<name>` | `zod` |
| npm package at version | `<name>@<version>` | `zod@4.3.6` |
| npm package with prefix | `npm:<name>` | `npm:zod` |
| PyPI package | `pypi:<name>` or `pip:<name>` | `pypi:requests` |
| crates.io package | `crates:<name>` or `cargo:<name>` | `crates:serde` |
| GitHub repo | `owner/repo` | `vercel/ai` |
| Repo with ref | `owner/repo@ref` | `vercel/ai@v5.0.0` |
| Explicit GitHub host | `github:owner/repo` | `github:facebook/react` |

## MCP vs CLI

Use MCP when:
- exploring multiple packages in one pass
- running structural code search with `astGrep`
- inspecting large repos without pulling source trees into agent context
- reading many files server-side before returning only the needed results

Use CLI when:
- resolving one package fast with `opensrc path <spec>`
- grabbing a single absolute path for local shell tools
- checking the existing cache with `opensrc list`
- removing or cleaning entries from the global CLI cache
