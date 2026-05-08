# Agent Skills

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A collection of composable agent skills that extend AI coding assistant capabilities across planning, architecture, development, and tooling. Each skill follows the [harness optimization](build-skill/SKILL.md) philosophy: atomic, granular tasks with non-negotiable acceptance criteria and exact output formats.

## Why These Skills

The most common failures with AI coding aren't bugs — they're harness problems. Here's what I've seen and what I built to fix it.

### #1: The Agent Didn't Do What I Want

> "No-one knows exactly what they want"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**The Problem**. The most common failure mode in software development is misalignment. You think the dev knows what you want. Then you see what they've built — and you realize it didn't understand you at all.

This is just the same in the AI age. There is a communication gap between you and the agent. The fix for this is a **grilling session** — getting the agent to ask you detailed questions about what you're building.

**The Fix** is to use [`/grill-with-docs`](./grill-with-docs/).

### #2: The Agent Is Way Too Verbose

> With a ubiquitous language, conversations among developers and expressions of the code are all derived from the same domain model.
>
> Eric Evans, [Domain-Driven Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**The Problem**: At the start of a project, devs and the people they're building the software for (the domain experts) are usually speaking different languages.

I felt the same tension with my agents. Agents are usually dropped into a project and asked to figure out the jargon as they go. So they use 20 words where 1 will do.

**The Fix** for this is a shared language. It's a document that helps agents decode the jargon used in the project.

<details>
<summary>
Example
</summary>

A quick BEFORE/AFTER showing the value of a shared language:

- **BEFORE**: "There's a problem when a lesson inside a section of a course is made 'real' (i.e. given a spot in the file system)"
- **AFTER**: "There's a problem with the materialization cascade"

This concision pays off session after session.

</details>

This is built into [`/grill-with-docs`](./grill-with-docs/). It's a grilling session that also helps you build a shared language with the AI and document hard-to-explain decisions in ADRs. (It's the merger of what used to be a separate `/ubiquitous-language` skill — I found that grilling and UL discipline were intertwined enough that splitting them apart was wasted ceremony.)

It's hard to explain how powerful this is. It might be the single coolest technique in this repo. Try it, and see.

> [!TIP]
> A shared language has many other benefits than reducing verbosity:
>
> - **Variables, functions and files are named consistently**, using the shared language
> - As a result, the **codebase is easier to navigate** for the agent
> - The agent also **spends fewer tokens on thinking**, because it has access to a more concise language

### #3: The Code Doesn't Work

> "Always take small, deliberate steps. The rate of feedback is your speed limit. Never take on a task that's too big."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**The Problem**: Let's say that you and the agent are aligned on what to build. What happens when the agent _still_ produces crap?

It's time to look at your feedback loops. Without feedback on how the code it produces actually runs, the agent will be flying blind.

**The Fix**: You need the usual tranche of feedback loops: static types, browser access, and automated tests.

For automated tests, a red-green-refactor loop is critical. This is where the agent writes a failing test first, then fixes the test. This helps give the agent a consistent level of feedback that results in far better code.

I've built a [`/tdd`](./tdd/) skill you can slot into any project. It encourages red-green-refactor and gives the agent plenty of guidance on what makes good and bad tests.

For debugging, I've also built a [`/diagnose`](./diagnose/) skill that wraps best debugging practices into a simple loop.

### #4: We Built A Ball Of Mud

> "Invest in the design of the system _every day_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**The Problem**: Most apps built with agents are complex and hard to change. Because agents can radically speed up coding, they also accelerate software entropy. Codebases get more complex at an unprecedented rate.

**The Fix** for this is a radical new approach to AI-powered development: caring about the design of the code.

This is built in to every layer of these skills:

- [`/prd-discover`](./prd-discover/) quizzes you about which modules you're touching before creating a PRD
- [`/zoom-out`](./zoom-out/) tells the agent to explain code in the context of the whole system

And crucially, [`/improve-codebase-architecture`](./improve-codebase-architecture/) helps you rescue a codebase that has become a ball of mud. I recommend running it on your codebase once every few days.

### Summary

Software engineering fundamentals matter more than ever. These skills are my best effort at condensing those fundamentals into repeatable practices, to help you ship the best apps of your career. Enjoy.

## Install

Each skill can be installed individually:

```bash
npx skills@latest add sanurb/skills/<skill-name>
```

If you're new to the repo, run [`setup-sanurb-skills`](./setup-sanurb-skills/) once per project — it scaffolds the `## Agent skills` block and `docs/agents/*.md` files that the engineering skills read for issue-tracker, triage-label, and domain-doc context.

## Planning & Design

Think through problems before writing code.

- **[grill-with-docs](grill-with-docs/)** — Stress-test a plan against the project's `CONTEXT.md` and ADRs. Sharpens terminology, surfaces hidden decisions, and updates docs inline as decisions crystallise.
  ```bash
  npx skills@latest add sanurb/skills/grill-with-docs
  ```
- **[spec-planner](spec-planner/)** — Develop specs through skeptical questioning and iterative refinement. Turns vague ideas into concrete technical plans.
  ```bash
  npx skills@latest add sanurb/skills/spec-planner
  ```
- **[prototype](prototype/)** — Build a throwaway prototype to flush out a design. Routes between a runnable terminal app for state/logic questions and several radically different UI variants for visual questions.
  ```bash
  npx skills@latest add sanurb/skills/prototype
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
- **[zoom-out](zoom-out/)** — Make the agent explain code in the context of the whole system before changing it. Counter-pressure against tunnel vision.
  ```bash
  npx skills@latest add sanurb/skills/zoom-out
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
- **[diagnose](diagnose/)** — Wrap best debugging practices into a tight feedback loop with reproduction, instrumentation, and exit criteria.
  ```bash
  npx skills@latest add sanurb/skills/diagnose
  ```
- **[code-simplification](code-simplification/)** — Refactor code for clarity without changing behavior. For when code works but is harder to read or extend than it should be.
  ```bash
  npx skills@latest add sanurb/skills/code-simplification
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

- **[herdr](herdr/)** — Control herdr (a terminal-native agent multiplexer) from inside it. Manage workspaces and tabs, split panes, spawn sibling agents, read pane output, and block until a specific line appears or another agent finishes.
  ```bash
  npx skills@latest add sanurb/skills/herdr
  ```
- **[tmux](tmux/)** — Remote control tmux sessions for interactive CLIs by sending keystrokes and scraping pane output.
  ```bash
  npx skills@latest add sanurb/skills/tmux
  ```
- **[http-collection](http-collection/)** — Scaffold or repair `etc/http/` OpenCollection trees for Bruno. Greenfield, brownfield, or Bruno/Postman migration.
  ```bash
  npx skills@latest add sanurb/skills/http-collection
  ```
- **[mermaid](mermaid/)** — Generate Mermaid diagrams for systems, workflows, data structures, and architecture.
  ```bash
  npx skills@latest add sanurb/skills/mermaid
  ```

## Domain-Driven Design

- **[domain-model](domain-model/)** — Build and refine a DDD domain model collaboratively from conversation context, scoped to a Bounded Context.
  ```bash
  npx skills@latest add sanurb/skills/domain-model
  ```
- **[context-map](context-map/)** — Produce a DDD Context Map showing relationships between Bounded Contexts.
  ```bash
  npx skills@latest add sanurb/skills/context-map
  ```

> The DDD glossary / ubiquitous-language work is now folded into [`/grill-with-docs`](./grill-with-docs/) — see Planning & Design above. A grilling session and UL maintenance turn out to be the same conversation.

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

- **[setup-sanurb-skills](setup-sanurb-skills/)** — Scaffold the `## Agent skills` block in `CLAUDE.md`/`AGENTS.md` and `docs/agents/*.md` so the engineering skills know this repo's issue tracker (GitHub / GitLab / fp / local), triage labels, and domain doc layout. Run once per project.
  ```bash
  npx skills@latest add sanurb/skills/setup-sanurb-skills
  ```
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
