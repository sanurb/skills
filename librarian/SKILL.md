---
name: librarian
description: Deep codebase exploration across remote repositories. Fetch, search, and compare library source code. Use for internals, architecture analysis, and cross-repo patterns. Skip simple API or docs questions.
references:
  - references/tool-routing.md
  - references/opensrc-api.md
  - references/opensrc-examples.md
  - references/linking.md
  - references/diagrams.md
---
# Librarian Skill
Deep codebase exploration across remote repositories.
## Non-Negotiables
- Use `source.name` from fetch results for every subsequent opensrc call. Never re-derive it.
- Route simple API and docs questions to `context7` first. Use opensrc only for implementation internals.
- Return the final comprehensive answer in the last message only.
- Link every cited source file with a GitHub or GitLab URL. Follow `references/linking.md`.
- Never mention internal tool names to the user.
## How to Use This Skill
### Reference Structure
| File | Purpose | When to Read |
|------|---------|--------------|
| `tool-routing.md` | Tool selection decision trees | Read first |
| `opensrc-api.md` | opensrc-mcp codemode API surface | Writing exploration code |
| `opensrc-examples.md` | Multi-step exploration workflows | Reusing proven patterns |
| `linking.md` | GitHub and GitLab URL patterns | Formatting citations |
| `diagrams.md` | Mermaid patterns | Visualizing architecture |
### Reading Order
1. Read `tool-routing.md`.
2. If the route uses opensrc, read `opensrc-api.md` and `opensrc-examples.md`.
3. Before the final answer, read `linking.md` and `diagrams.md`.
## Tool Arsenal
| Tool | Best For | Limitations |
|------|----------|-------------|
| **grep_app** | Find patterns across public GitHub | Literal search only |
| **context7** | Library docs, API examples, usage | Known libraries only |
| **opensrc** | Fetch full source for deep exploration | Fetch before read |
## Quick Decision Trees
### "How does X work?"
```
Known library?
├─ Yes → context7.resolve-library-id → context7.query-docs
│        └─ Need internals? → opensrc.fetch → read source
└─ No  → grep_app search → opensrc.fetch top result
```
### "Find pattern X"
```
Specific repo?
├─ Yes → opensrc.fetch → opensrc.grep → read matches
└─ No  → grep_app search → opensrc.fetch interesting repos
```
### "Explore repo structure"
```
1. opensrc.fetch(target)
2. opensrc.tree(source.name) → quick overview
3. opensrc.files(source.name, "**/*.ts") → detailed listing
4. Read README, package.json, src/index.*
5. Create architecture diagram from findings
```
### "Compare X vs Y"
```
1. opensrc.fetch(["X", "Y"])
2. Capture source.name from each fetch result
3. opensrc.grep(pattern, { sources: [nameX, nameY] })
4. Read comparable files
5. Synthesize differences
```
## Critical: Source Naming Convention
**After fetching, use `source.name` for every later call:**
```javascript
const [{ source }] = await opensrc.fetch("vercel/ai");
const files = await opensrc.files(source.name, "**/*.ts");
```
| Type | Fetch Spec | Source Name |
|------|------------|-------------|
| npm | `"zod"` | `"zod"` |
| npm scoped | `"@tanstack/react-query"` | `"@tanstack/react-query"` |
| pypi | `"pypi:requests"` | `"requests"` |
| crates | `"crates:serde"` | `"serde"` |
| GitHub | `"vercel/ai"` | `"github.com/vercel/ai"` |
| GitLab | `"gitlab:org/repo"` | `"gitlab.com/org/repo"` |
## When Not to Use opensrc
| Scenario | Use Instead |
|----------|-------------|
| Simple library API questions | context7 |
| Finding examples across many repos | grep_app |
| Very large monorepos (>10GB) | Clone locally |
| Private repositories | Direct access |
## Output Format
1. Return one comprehensive final answer in the last message only.
2. Cite every file reference as a markdown link.
3. Use comparison tables for cross-repo findings.
4. Add diagrams for complex structure or flow.
5. Describe actions generically. Do not expose internal tool names.
## References
- [Tool Routing Decision Trees](references/tool-routing.md)
- [opensrc-mcp API Reference](references/opensrc-api.md)
- [opensrc Exploration Examples](references/opensrc-examples.md)
- [GitHub Linking Patterns](references/linking.md)
- [Mermaid Diagram Patterns](references/diagrams.md)
