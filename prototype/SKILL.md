---
name: prototype
description: Build a throwaway prototype to flush out a design before committing to it. Routes between two branches — a runnable terminal app for state/business-logic questions, or several radically different UI variations toggleable from one route. Use when the user wants to prototype, sanity-check a data model or state machine, mock up a UI, explore design options, or says "prototype this", "let me play with it", "try a few designs".
---

# Prototype

## Purpose

A prototype is throwaway code that answers exactly ONE question. The question decides the shape: state/logic questions get a tiny interactive terminal app over a pure module; visual/layout questions get several radically different UI variants on one route. Pick the right shape, build the smallest thing that lets the user feel the answer, capture the answer, delete the rest.

## Instructions

### 1. Pick the branch from the user's question

Classify the question and route to the matching playbook. Getting this wrong wastes the whole prototype.

- Question is about **business logic, state transitions, data shape, or API surface** ("does this state machine handle X then Y?", "does this data model represent...?", "what should this API look like?") → Read: `references/logic.md`. Build a tiny TUI over a pure reducer / state machine / function set.
- Question is about **what something looks like** ("what should this page look like?", "try a different layout for the settings screen", "I want to see options before committing") → Read: `references/ui.md`. Generate 3 (max 5) radically different variants on one route, switchable via `?variant=` and a floating bottom bar.

If the question is genuinely ambiguous AND the user is unreachable: default to the branch that matches the surrounding code (backend module → logic; page or component → UI), and write the assumption explicitly at the top of the prototype.

### 2. Build the prototype following the chosen branch

Execute the playbook end-to-end without inventing extra structure.

- Locate the prototype next to the code it's prototyping for. Name it so a casual reader sees `prototype` in the path or filename.
- Match the project's existing tooling, runtime, and routing convention. Do not introduce a new package manager, runtime, or top-level structure.
- Wire it to the project's existing task runner so it starts with one command (`pnpm <name>`, `python <path>`, `bun <path>`, etc).
- Logic branch: keep the logic module pure (no I/O, no terminal code, no `console.log` for control flow); the TUI is a thin shell over it. Each frame clears the screen and re-renders fully.
- UI branch: prefer sub-shape A (variants on an existing route). Use sub-shape B (new throwaway route) only when there is no plausible existing host page. Variants must differ structurally — different layout, different information hierarchy, different primary affordance.

### 3. Hand it over and leave the answer-capture in place

Ship the run command and a `NOTES.md` placeholder, not a write-up.

- Tell the user the run command and (UI branch) the URL plus the `?variant=` keys.
- Create `NOTES.md` next to the prototype with the question already filled in and a blank space for the answer. The user (or you, on the next pass) fills the verdict before the prototype gets deleted or absorbed.
- When the question is answered, fold the validated piece back into real code (the pure logic module; the winning variant rewritten properly) and delete the rest. Do NOT promote the TUI shell or the variant components directly to production.

## Non-Negotiable Acceptance Criteria

The prototype delivers nothing if any of these fails:

- [ ] The prototype answers exactly ONE question, written down explicitly in the prototype's location (top-of-file comment, README, or `NOTES.md`).
- [ ] The prototype's path or filename contains the word `prototype` so a casual reader cannot mistake it for production.
- [ ] One existing-task-runner command starts it. No path memorisation.
- [ ] No persistence by default. State is in-memory only, unless the question is specifically about persistence (then a clearly-named scratch DB).
- [ ] No tests, no production-grade error handling, no abstractions for future use cases.
- [ ] Full relevant state is surfaced after every action (logic) or on every variant switch (UI).
- [ ] No new package manager, runtime, or top-level routing structure was introduced.
- [ ] **Logic branch only:** the logic is in a pure, importable module. Zero `console.log`, prompts, or escape codes inside it. The TUI imports it; nothing flows the other direction.
- [ ] **UI branch only:** variants differ structurally, not just by colour or copy. Sub-shape A was chosen unless there is a written reason to use B.
- [ ] **UI branch only:** the floating switcher is hidden in production builds (`process.env.NODE_ENV !== 'production'` or equivalent gate).
- [ ] A `NOTES.md` exists next to the prototype with the question filled in and an empty answer slot.

## Output

- **Prototype code** at the chosen location, with `prototype` in the path/filename.
- **One run command** added to the project's existing task runner (`package.json` scripts, `Makefile`, `justfile`, `pyproject.toml`, etc).
- **`NOTES.md`** next to the prototype, in this exact shape:

  ```md
  # Prototype: {short name}

  ## Question
  {the one question this prototype answers}

  ## Answer
  {empty — fill in once the prototype has done its job}
  ```

- **Hand-off message to the user:** the run command, plus (UI branch only) the URL and the list of `?variant=` keys with their named exports. Nothing else — no narration, no plan recap.
