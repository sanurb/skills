# Registry Support

## Package Registries

### npm
- Prefix: none or `npm:`
- Source of truth for metadata: `https://registry.npmjs.org/<package>`
- Repo extraction: `repository.url` and monorepo `repository.directory`
- Special case: fully supports scoped packages such as `@babel/core`

### PyPI
- Prefixes: `pypi:`, `pip:`, `python:`
- Metadata endpoint: `https://pypi.org/pypi/<package>/json`
- Version forms: `pypi:requests==2.31.0` and `pypi:requests@2.31.0`
- Repo extraction: `project_urls.Source`, `project_urls.Repository`, then GitHub or GitLab homepages

### crates.io
- Prefixes: `crates:`, `cargo:`, `rust:`
- Metadata endpoint: `https://crates.io/api/v1/crates/<crate>`
- Version form: `crates:serde@1.0.217`
- Repo extraction: `crate.repository`

## Repo Hosts

### GitHub
- Formats: `owner/repo`, `github:owner/repo`, full HTTPS URL
- API: `https://api.github.com/repos/<owner>/<repo>`
- Notes: resolves default branch from provider metadata

### GitLab
- Formats: `gitlab:owner/repo`, full HTTPS URL
- API: `https://gitlab.com/api/v4/projects/<encoded-path>`
- Notes: path must be URL encoded before lookup

### Bitbucket
- Formats: `bitbucket:owner/repo`, full HTTPS URL
- Notes: parsing works; provider-specific API resolution is limited

## Ref Syntax

Use either syntax for direct repos:

```bash
opensrc path vercel/ai@v5.0.0
opensrc path vercel/ai@main
opensrc path vercel/ai#feature/cache-fix
opensrc path vercel/ai@abc1234
```

- `@tag` selects a tag.
- `@main` or `#main` selects a branch.
- `@<sha>` selects a commit.

## URL Normalization
- Remove `git+` prefixes.
- Remove `.git` suffixes.
- Convert SSH URLs to HTTPS when host parsing allows it.
- Normalize equivalent URLs onto the same cache key.

## Failure Cases
- Package metadata exposes no repository URL.
- Repo host is unsupported.
- Provider metadata is unavailable and the spec lacks enough information to continue.
- Requested ref does not exist and no fallback branch resolution succeeds.
