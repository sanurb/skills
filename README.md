# Agent Skills

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A collection of composable agent skills that extend AI coding assistant capabilities across planning, architecture, development, and tooling. Each skill follows the [harness optimization](build-skill/SKILL.md) philosophy: atomic, granular tasks with non-negotiable acceptance criteria and exact output formats.

## Install

Each skill can be installed individually:

```bash
npx skills@latest add sanurb/skills/<skill-name>
```

## Planning & Design

Think through problems before writing code.

- **[spec-planner](spec-planner/)** — Develop specs through skeptical questioning and iterative refinement. Turns vague ideas into concrete technical plans.
  ```bash
  npx skills@latest add sanurb/skills/spec-planner
  ```
- **[interviewing-plans](interviewing-plans/)** — Interrogate every design branch in a plan until assumptions are resolved and shared understanding is explicit.
  ```bash
  npx skills@latest add sanurb/skills/interviewing-plans
  ```
- **[dialectic](dialectic/)** — Stress-test ideas with structured dialectical reasoning. Two sub-agents argue opposed positions while the orchestrator synthesizes.
  ```bash
  npx skills@latest add sanurb/skills/dialectic
  ```
- **[design-an-interface](design-an-interface/)** — Generate multiple radically different interface designs in parallel, then compare trade-offs. Based on "Design It Twice."
  ```bash
  npx skills@latest add sanurb/skills/design-an-interface
  ```
- **[prd-to-issues](prd-to-issues/)** — Break a PRD GitHub issue into independently-grabbable vertical slice issues with dependency ordering.
  ```bash
  npx skills@latest add sanurb/skills/prd-to-issues
  ```
- **[request-refactor-plan](request-refactor-plan/)** — Create a structured refactor plan for an existing codebase.
  ```bash
  npx skills@latest add sanurb/skills/request-refactor-plan
  ```

## PRD Workflow

End-to-end Product Requirements Document pipeline.

- **[prd-discover](prd-discover/)** — Extract a validated problem brief through user interview and codebase exploration.
  ```bash
  npx skills@latest add sanurb/skills/prd-discover
  ```
- **[prd-interview](prd-interview/)** — Walk the design tree branch-by-branch until every decision is explicit. Runs after prd-discover.
  ```bash
  npx skills@latest add sanurb/skills/prd-interview
  ```
- **[prd-draft](prd-draft/)** — Assemble a PRD from validated artifacts, run quality gates, and publish. Runs after prd-interview.
  ```bash
  npx skills@latest add sanurb/skills/prd-draft
  ```

## Architecture

Analyze and improve codebase structure.

- **[improve-codebase-architecture](improve-codebase-architecture/)** — End-to-end orchestrator: index code → explore for friction → design module-deepening refactors as GitHub issue RFCs.
  ```bash
  npx skills@latest add sanurb/skills/improve-codebase-architecture
  ```
- **[index-codebase](index-codebase/)** — Index a codebase with [codemogger](https://github.com/glommer/codemogger/) (semantic + keyword search) and optionally [zoekt](https://github.com/sourcegraph/zoekt) (trigram regex search).
  ```bash
  npx skills@latest add sanurb/skills/index-codebase
  ```
- **[explore-architecture](explore-architecture/)** — Search an indexed codebase to find architectural friction and surface module-deepening candidates.
  ```bash
  npx skills@latest add sanurb/skills/explore-architecture
  ```
- **[design-deep-module](design-deep-module/)** — Design multiple interface options for a deepening candidate and create a refactor RFC as a GitHub issue.
  ```bash
  npx skills@latest add sanurb/skills/design-deep-module
  ```
- **[feature-slicing](feature-slicing/)** — Feature-Sliced Design (FSD) architecture for frontend projects.
  ```bash
  npx skills@latest add sanurb/skills/feature-slicing
  ```

## Development

Write, test, and fix code.

- **[tdd](tdd/)** — Strict red-green-refactor TDD with vertical slices. One test, one implementation, repeat.
  ```bash
  npx skills@latest add sanurb/skills/tdd
  ```
- **[triage-issue](triage-issue/)** — Investigate a bug via code search, find root cause, and file a GitHub issue with a TDD fix plan.
  ```bash
  npx skills@latest add sanurb/skills/triage-issue
  ```
- **[typescript-magician](typescript-magician/)** — TypeScript coding conventions and best practices.
  ```bash
  npx skills@latest add sanurb/skills/typescript-magician
  ```
- **[console-debugging](console-debugging/)** — Console.log debugging patterns for React/TypeScript data flow tracing.
  ```bash
  npx skills@latest add sanurb/skills/console-debugging
  ```
- **[feedback-loop](feedback-loop/)** — Self-validate work through deterministic feedback loops with repro, measurement, and exit criteria.
  ```bash
  npx skills@latest add sanurb/skills/feedback-loop
  ```
- **[ast-grep](ast-grep/)** — Write ast-grep rules for structural code search using AST patterns.
  ```bash
  npx skills@latest add sanurb/skills/ast-grep
  ```
- **[qa](qa/)** — Interactive QA session — user describes bugs conversationally, agent files GitHub issues with domain language and durable reproduction steps.
  ```bash
  npx skills@latest add sanurb/skills/qa
  ```

## Code Navigation & Search

Find code efficiently.

- **[librarian](librarian/)** — Multi-repository codebase exploration. Research library internals, find patterns across GitHub/npm/PyPI/crates.
  ```bash
  npx skills@latest add sanurb/skills/librarian
  ```
- **[opensrc](opensrc/)** — Fetch source code for npm, PyPI, or crates.io packages to understand how libraries work internally.
  ```bash
  npx skills@latest add sanurb/skills/opensrc
  ```
- **[index-knowledge](index-knowledge/)** — Generate hierarchical AGENTS.md knowledge base for a codebase.
  ```bash
  npx skills@latest add sanurb/skills/index-knowledge
  ```
- **[websearch](websearch/)** — Search the public web via Exa for up-to-date docs, release notes, and APIs.
  ```bash
  npx skills@latest add sanurb/skills/websearch
  ```

## Version Control

- **[jujutsu](jujutsu/)** — Jujutsu (jj) version control commands and workflows.
  ```bash
  npx skills@latest add sanurb/skills/jujutsu
  ```
- **[jj-hunk](jj-hunk/)** — Programmatic hunk selection for jj. Split commits and selectively squash without interactive UI.
  ```bash
  npx skills@latest add sanurb/skills/jj-hunk
  ```
- **[vcs-detect](vcs-detect/)** — Detect whether a project uses jj or git. Run before any VCS command.
  ```bash
  npx skills@latest add sanurb/skills/vcs-detect
  ```
- **[github](github/)** — Interact with GitHub using the `gh` CLI for issues, PRs, CI runs, and API queries.
  ```bash
  npx skills@latest add sanurb/skills/github
  ```
- **[git-guardrails-claude-code](git-guardrails-claude-code/)** — Set up Claude Code hooks to block dangerous git commands before they execute.
  ```bash
  npx skills@latest add sanurb/skills/git-guardrails-claude-code
  ```
- **[github-triage](github-triage/)** — Triage GitHub issues through a label-based state machine with interactive grilling sessions.
  ```bash
  npx skills@latest add sanurb/skills/github-triage
  ```

## Terminal & Tooling

- **[cmux](cmux/)** — Manage terminal sessions via cmux. Spawn workspaces, read output, send commands, orchestrate multi-terminal workflows.
  ```bash
  npx skills@latest add sanurb/skills/cmux
  ```
- **[tmux](tmux/)** — Remote control tmux sessions for interactive CLIs by sending keystrokes and scraping pane output.
  ```bash
  npx skills@latest add sanurb/skills/tmux
  ```
- **[mermaid](mermaid/)** — Generate Mermaid diagrams for systems, workflows, data structures, and architecture.
  ```bash
  npx skills@latest add sanurb/skills/mermaid
  ```

## Domain-Driven Design

- **[ubiquitous-language](ubiquitous-language/)** — Extract a DDD ubiquitous language glossary scoped to a Bounded Context.
  ```bash
  npx skills@latest add sanurb/skills/ubiquitous-language
  ```
- **[context-map](context-map/)** — Produce a DDD Context Map showing relationships between Bounded Contexts.
  ```bash
  npx skills@latest add sanurb/skills/context-map
  ```

## Project Workflow (FP)

Find, plan, review, and implement work using fp issue hierarchies.

- **[fp-plan](fp-plan/)** — Create plans and break them down into trackable fp issue hierarchies with dependencies.
  ```bash
  npx skills@latest add sanurb/skills/fp-plan
  ```
- **[fp-implement](fp-implement/)** — Find, claim, and complete work on fp issues with session handoff.
  ```bash
  npx skills@latest add sanurb/skills/fp-implement
  ```
- **[fp-review](fp-review/)** — Review code changes, assign commits to issues, leave structured feedback, and create stories.
  ```bash
  npx skills@latest add sanurb/skills/fp-review
  ```

## Meta

- **[build-skill](build-skill/)** — Create new agent skills with proper structure, progressive disclosure, and bundled resources. Read this first when building skills.
  ```bash
  npx skills@latest add sanurb/skills/build-skill
  ```
- **[skill-optimizer](skill-optimizer/)** — Measure and fix AI skill activation, clarity, and cross-agent reliability.
  ```bash
  npx skills@latest add sanurb/skills/skill-optimizer
  ```

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
