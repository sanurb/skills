# Agent Skills

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A collection of composable agent skills that extend AI coding assistant capabilities across planning, architecture, development, and tooling. Each skill follows the [harness optimization](build-skill/SKILL.md) philosophy: atomic, granular tasks with non-negotiable acceptance criteria and exact output formats.

## Planning & Design

Think through problems before writing code.

- **[spec-planner](spec-planner/)** — Develop specs through skeptical questioning and iterative refinement. Turns vague ideas into concrete technical plans.
- **[interviewing-plans](interviewing-plans/)** — Interrogate every design branch in a plan until assumptions are resolved and shared understanding is explicit.
- **[dialectic](dialectic/)** — Stress-test ideas with structured dialectical reasoning. Two sub-agents argue opposed positions while the orchestrator synthesizes.
- **[design-an-interface](design-an-interface/)** — Generate multiple radically different interface designs in parallel, then compare trade-offs. Based on "Design It Twice."
- **[prd-to-issues](prd-to-issues/)** — Break a PRD GitHub issue into independently-grabbable vertical slice issues with dependency ordering.
- **[request-refactor-plan](request-refactor-plan/)** — Create a structured refactor plan for an existing codebase.

## Architecture

Analyze and improve codebase structure.

- **[improve-codebase-architecture](improve-codebase-architecture/)** — End-to-end orchestrator: index code → explore for friction → design module-deepening refactors as GitHub issue RFCs.
- **[index-codebase](index-codebase/)** — Index a codebase with [codemogger](https://github.com/glommer/codemogger/) (semantic + keyword search) and optionally [zoekt](https://github.com/sourcegraph/zoekt) (trigram regex search).
- **[explore-architecture](explore-architecture/)** — Search an indexed codebase to find architectural friction and surface module-deepening candidates.
- **[design-deep-module](design-deep-module/)** — Design multiple interface options for a deepening candidate and create a refactor RFC as a GitHub issue.
- **[feature-slicing](feature-slicing/)** — Feature-Sliced Design (FSD) architecture for frontend projects.

## Development

Write, test, and fix code.

- **[tdd](tdd/)** — Strict red-green-refactor TDD with vertical slices. One test, one implementation, repeat.
- **[triage-issue](triage-issue/)** — Investigate a bug via code search, find root cause, and file a GitHub issue with a TDD fix plan.
- **[typescript](typescript/)** — TypeScript coding conventions and best practices.
- **[console-debugging](console-debugging/)** — Console.log debugging patterns for React/TypeScript data flow tracing.
- **[feedback-loop](feedback-loop/)** — Self-validate work through deterministic feedback loops with repro, measurement, and exit criteria.
- **[ast-grep](ast-grep/)** — Write ast-grep rules for structural code search using AST patterns.

## Code Navigation & Search

Find code efficiently.

- **[librarian](librarian/)** — Multi-repository codebase exploration. Research library internals, find patterns across GitHub/npm/PyPI/crates.
- **[opensrc](opensrc/)** — Fetch source code for npm, PyPI, or crates.io packages to understand how libraries work internally.
- **[index-knowledge](index-knowledge/)** — Generate hierarchical AGENTS.md knowledge base for a codebase.
- **[websearch](websearch/)** — Search the public web via Exa for up-to-date docs, release notes, and APIs.

## Version Control

- **[jujutsu](jujutsu/)** — Jujutsu (jj) version control commands and workflows.
- **[jj-hunk](jj-hunk/)** — Programmatic hunk selection for jj. Split commits and selectively squash without interactive UI.
- **[vcs-detect](vcs-detect/)** — Detect whether a project uses jj or git. Run before any VCS command.
- **[github](github/)** — Interact with GitHub using the `gh` CLI for issues, PRs, CI runs, and API queries.
- **[git-guardrails-claude-code](git-guardrails-claude-code/)** — Set up Claude Code hooks to block dangerous git commands before they execute.

## Terminal & Tooling

- **[cmux](cmux/)** — Manage terminal sessions via cmux. Spawn workspaces, read output, send commands, orchestrate multi-terminal workflows.
- **[tmux](tmux/)** — Remote control tmux sessions for interactive CLIs by sending keystrokes and scraping pane output.
- **[mermaid](mermaid/)** — Generate Mermaid diagrams for systems, workflows, data structures, and architecture.

## Meta

- **[build-skill](build-skill/)** — Create new agent skills with proper structure, progressive disclosure, and bundled resources. Read this first when building skills.

## Skill Structure

Every skill follows the same anatomy:

```
skill-name/
├── SKILL.md              # Core instructions (<200 lines)
├── references/           # Domain knowledge, loaded on demand
├── scripts/              # Deterministic automation
└── assets/               # Templates and static files
```

Each `SKILL.md` has five sections:

1. **Metadata** — Name, description, triggers (YAML frontmatter)
2. **Purpose** — One paragraph pitch
3. **Instructions** — 3 steps max, third-person imperative
4. **Non-Negotiable** — Acceptance criteria the agent must meet
5. **Output** — Exact format for chaining with other skills

See [build-skill](build-skill/) for the full authoring guide.

## License

[MIT](LICENSE) — David Urbano
