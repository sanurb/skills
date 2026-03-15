---
name: improve-codebase-architecture
description: End-to-end workflow to improve codebase architecture by indexing code for search, exploring for friction, and designing module-deepening refactors as GitHub issue RFCs. Chains index-codebase → explore-architecture → design-deep-module. Use when the user asks to improve architecture holistically or says "find refactoring opportunities." Do NOT use for targeted single-module refactors (use design-deep-module directly), performance optimization, or greenfield architecture design.
---

# Improve Codebase Architecture

Orchestrator that chains three atomic skills to go from raw codebase to a module-deepening RFC. Each skill does one thing.

## Instructions

### Step 1. Index

Ensure the codebase is indexed for search. If `.codemogger/` exists, skip. Otherwise, invoke the **index-codebase** skill:

```
index-codebase → codemogger index <repo-path>
```

### Step 2. Explore

Invoke the **explore-architecture** skill. It runs co-change analysis and codemogger searches, then presents a numbered candidate list.

Wait for the user to pick a candidate before proceeding.

### Step 3. Design

Invoke the **design-deep-module** skill with the chosen candidate. It frames the problem, spawns parallel interface designs, and creates a GitHub issue RFC.

Share the issue URL with the user.

## Non-Negotiable

- Must execute skills in order: index → explore → design.
- Must wait for user input between explore (candidate list) and design (picked candidate).
- Must NOT skip indexing — codemogger search evidence is required in the exploration step.
- Final output must be a GitHub issue URL.

## Output

```
GitHub issue created: <URL>
```
