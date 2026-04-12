# opensrc Architecture

## Scope
- Resolve package or repo specs into canonical source locations.
- Materialize cached source trees under a global cache.
- Return stable paths that shell pipelines can compose.

## High-Level Flow
1. Parse the input as a package spec or direct repo spec.
2. Resolve package metadata through the registry adapter when the input is a package.
3. Normalize the repo URL, ref, and version target.
4. Clone or reuse the cached source tree.
5. Return the absolute cache path.

## Module Layout

```text
src/
├── index.ts
├── commands/
│   ├── path.ts
│   ├── list.ts
│   ├── remove.ts
│   └── clean.ts
└── lib/
    ├── git.ts
    ├── repo.ts
    ├── version.ts
    ├── settings.ts
    └── registries/
        ├── index.ts
        ├── npm.ts
        ├── pypi.ts
        └── crates.ts
```

## Registry Resolution Pipeline

### Package inputs
- Detect registry from prefix or default to npm.
- Parse name and requested version.
- Query the registry API for package metadata.
- Extract the repository URL.
- Resolve the git ref from the requested or detected version.

### Repo inputs
- Parse `owner/repo`, explicit host prefixes, or full URLs.
- Resolve host metadata when the provider supports it.
- Normalize the default branch or explicit ref.

## Version Detection

npm package resolution checks the target project in this order:
1. `node_modules/<pkg>/package.json`
2. `package-lock.json`
3. `pnpm-lock.yaml`
4. `yarn.lock`
5. `package.json`

That lookup runs relative to `--cwd`.

## Cache Structure

Default cache root: `~/.opensrc/`
Override: `OPENSRC_HOME`

```text
.opensrc/
├── repos/
│   └── github.com/
│       └── owner/
│           └── repo/
│               └── <resolved-version-or-ref>/
└── settings.json
```

Packages resolve to repo cache entries after registry lookup. Direct repo fetches land in the same tree.

## Repo Normalization
- Strip `git+` prefixes.
- Strip `.git` suffixes.
- Convert SSH URLs to HTTPS when possible.
- Preserve host, owner, repo, and explicit ref separately.
- Reuse a single cache entry for equivalent URL spellings.

## Tag and Ref Selection
- Packages first try a tag that matches the resolved version.
- Common tag forms such as `v<version>` and `<version>` are attempted before default branch fallback.
- Direct repos honor explicit tags, branches, and commit SHAs.

## Error Handling
- Fail when registry metadata lacks a usable repository URL.
- Fail when repo parsing cannot produce host, owner, and repo.
- Fail when a requested registry is unsupported.
- Return a cache miss as a fetch path operation, not a silent no-op.
- Surface provider or network errors instead of fabricating defaults.

## Extension Points

### Add a registry
1. Add a registry adapter under `lib/registries/`.
2. Teach the registry router to detect its prefix.
3. Implement metadata lookup and repo extraction.
4. Map version syntax to a git ref strategy.

### Add a host
1. Extend repo parsing for the host format.
2. Add provider-specific default branch resolution when needed.
3. Keep cache keys stable across equivalent URLs.
