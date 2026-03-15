---
name: explore-architecture
description: Search an indexed codebase to find architectural friction and surface module-deepening candidates. Use after index-codebase has run, when the user asks to find refactoring opportunities, identify shallow modules, assess coupling, or improve testability. Do NOT use for greenfield architecture design, performance optimization, or before the codebase is indexed with codemogger.
---

# Explore Architecture

Use codemogger semantic/keyword search and git co-change analysis to find architectural friction. Output a numbered list of deepening candidates with quantitative evidence.

A *deep module* (Ousterhout) has a small interface hiding a large implementation. This skill finds shallow modules that should be deepened.

## Instructions

### Step 1. Gather quantitative signals

Run the co-change analysis script against the target repo:

```bash
bash <skill-dir>/scripts/co-change-analysis.sh <path-to-repo>
```

Then run targeted codemogger searches to detect coupling patterns:

```bash
npx codemogger search "shared types imported across modules"
npx codemogger search "wrapper adapter delegate"
npx codemogger search "interface implementation"
```

Use keyword mode for precise identifier lookups when you spot a suspicious type or function:

```bash
npx codemogger search "TypeName" --mode keyword
```

If zoekt is indexed, use it for regex and boolean queries:

```bash
zoekt 'sym:InterfaceName' 
zoekt 'file:test -file:fixture error handling'
```

### Step 2. Classify friction

For each friction signal found, cross-reference co-change data with search results. Look for:

- Modules whose interface is nearly as complex as the implementation (shallow)
- Files that always change together but live in separate modules (coupling)
- Pure functions extracted "for testability" where real bugs live in call-site integration
- Adapter/wrapper layers that pass through without adding depth
- Shared types imported by many modules (hidden coupling)
- Untested or brittle test boundaries

Classify each candidate's dependency category using the decision tree:

```
I/O involved?
├─ No → in-process (merge directly)
└─ Yes
    ├─ Local stand-in exists? → local-substitutable
    └─ No
        ├─ You own the service? → ports-adapters
        └─ No → mock-boundary
```

### Step 3. Present candidates

Output the candidate list in the exact format specified below. Do NOT propose interfaces — only list candidates. Ask which to explore.

## Non-Negotiable

- Must run co-change script before presenting candidates.
- Each candidate must have quantitative coupling evidence (co-change frequency OR cross-reference count from codemogger).
- Each candidate must be classified into exactly one dependency category.
- Must NOT propose interfaces or solutions — output is candidates only.
- Must use codemogger search results as evidence, not just the agent's intuition.

## Output

```
## Deepening Candidates

### 1. [Cluster name]
- **Modules**: `path/to/a`, `path/to/b`
- **Coupling**: [shared types | co-change N times | M cross-references]
- **Category**: [in-process | local-substitutable | ports-adapters | mock-boundary]
- **Test impact**: [which tests become redundant at boundary]
- **Depth gain**: [interface surface shrink vs implementation absorbed]

### 2. [Cluster name]
...

Which candidate would you like to explore?
```

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/co-change-analysis.sh` | Detect files that frequently change together via git history |
