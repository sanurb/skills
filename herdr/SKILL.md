---
name: herdr
description: Control herdr (a terminal-native agent multiplexer) from inside it. Manage workspaces and tabs, split panes, spawn sibling agents, read pane output, and wait for state changes — all via CLI commands that talk to the running herdr instance over a local unix socket. Use when running inside herdr (HERDR_ENV=1). Do not use outside herdr.
---

# herdr

## Purpose

You are running inside herdr — a terminal-native agent multiplexer that gives you workspaces, tabs, and panes. Each pane is a real terminal with its own shell, agent, server, or log stream, and the `herdr` binary on your PATH lets you control all of it from the CLI. Use this skill to inspect what other panes and agents are doing, split panes for parallel work (servers, tests, log streams, sibling agents), block until specific output or an agent state, and spawn additional agent instances.

## Instructions

### 1. Discover the live state before you assume any id

ids in herdr (`1` for workspaces, `1:1` for tabs, `1-1` for panes) are **compact public ids that compact silently when things close**. Always re-read them — never trust an id from earlier in the session.

```bash
herdr pane list                       # all panes; the focused one is yours
herdr workspace list                  # all workspaces
herdr tab list --workspace <ws-id>    # tabs inside a workspace
```

If you need the workspace / tab / pane / `agent_status` model spelled out (including the meaning of `done` vs `idle` and the id-compaction warning in detail), read: `references/concepts.md`.

### 2. Pick the operation; look up the exact command, do not guess

The full command catalog (workspace / tab / pane create-focus-rename-close, send-text / send-keys / run, split, read, wait, plus the JSON shape each command prints) lives in `references/commands.md`. Read it before composing a command — flag names, `--source` modes, and JSON paths for new ids are easy to get wrong from memory.

Two rules that prevent the most common mistakes:

- **Use `pane read` for output that ALREADY EXISTS; use `wait output` for output you EXPECT NEXT.** Do not poll `pane read` in a loop.
- **Parse new ids from the JSON response.** `workspace create` returns `result.workspace`, `result.tab`, `result.root_pane`. `tab create` returns `result.tab`, `result.root_pane`. `pane split` returns `result.pane.pane_id`. Capture these into shell variables before downstream calls.

### 3. For multi-pane coordination, adapt a vetted recipe

Read: `references/recipes.md` for tested multi-step patterns — running a server and waiting until ready, running tests in a sibling pane and inspecting the result, watching another pane robustly under soft-wrapping, spawning a new agent and giving it a task, and blocking until another agent finishes (`wait agent-status <pane> --status done`). Each recipe handles the sharp edges (capturing the new pane id, picking the right `--source`, picking realistic timeouts). Adapt rather than rebuild from primitives.

## Non-Negotiable Acceptance Criteria

The skill delivers nothing if any of these fails:

- [ ] `HERDR_ENV=1` was confirmed before any `herdr` command was issued. If the variable is unset, do not invoke this skill.
- [ ] No id was reused without first re-confirming it via `pane list` / `tab list` / `workspace list` — or by parsing it from a fresh `create` / `split` JSON response. ids compact silently.
- [ ] New pane / tab / workspace ids were parsed from the JSON response into a shell variable (e.g. `NEW_PANE=$(... | python3 -c '...')`). Never hard-coded, never guessed.
- [ ] `wait output` was used for FUTURE output the agent expects next; `pane read` was used only for output that already exists. No `pane read` in a polling loop.
- [ ] `--no-focus` was passed on `pane split`, `tab create`, and `workspace create` whenever the user's current focus should not be hijacked (default for headless agent runs).
- [ ] When the matched text could be broken by soft-wrapping, `--source recent-unwrapped` was used for inspection. (`wait output --source recent` already matches against unwrapped text by default.)
- [ ] `--regex` was passed on `wait output` only when the match string is actually a regex; literal matches do not set it.
- [ ] Timeouts on `wait output` and `wait agent-status` reflect the operation's real duration (servers ≈ 30s, tests ≈ 60s, full agent runs ≥ 120s). On exit code `1` (timeout), the agent diagnoses the cause — never blindly retries.
- [ ] When an operation prints JSON, the agent treats it as JSON (parses fields). When it prints text (`pane read`), the agent does not pipe it into a JSON parser.

## Output

This skill emits a stream of CLI invocations and their captured artifacts:

- **JSON-printing commands** (parse for ids and state): `workspace list`, `workspace create`, `tab list`, `tab create`, `tab get`, `tab focus`, `tab rename`, `tab close`, `pane list`, `pane get`, `pane split`, `wait output`, `wait agent-status`.
- **Text-printing commands**: `pane read` (the pane transcript itself).
- **Silent on success**: `pane send-text`, `pane send-keys`, `pane run`.

When a step creates a new pane / tab / workspace, capture the parsed id into a shell variable (`NEW_PANE`, `NEW_TAB`, `NEW_WS`) and reuse it for downstream calls in the same recipe. When you read a pane, surface the relevant lines to the user — do not dump the full transcript.
