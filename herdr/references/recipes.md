# herdr recipes

Vetted multi-step patterns. Adapt rather than rebuild — the sharp edges (capturing pane ids, picking `--source`, choosing timeouts) are tuned in here.

## Run a server and wait until it is ready

```bash
NEW_PANE=$(herdr pane split 1-2 --direction right --no-focus \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
herdr pane run "$NEW_PANE" "npm run dev"
herdr wait output "$NEW_PANE" --match "ready" --timeout 30000
herdr pane read "$NEW_PANE" --source recent --lines 20
```

Why: capture the new pane id from JSON (don't guess); split with `--no-focus` so the user keeps focus; `wait output` blocks the agent without busy-polling; final `pane read` confirms the actual ready line for the user.

## Run tests in a separate pane and inspect the result

```bash
TEST_PANE=$(herdr pane split 1-2 --direction down --no-focus \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
herdr pane run "$TEST_PANE" "cargo test"
herdr wait output "$TEST_PANE" --match "test result" --timeout 60000
herdr pane read "$TEST_PANE" --source recent --lines 30
```

## Check what another agent is working on

```bash
herdr pane list
herdr pane read 1-1 --source recent --lines 80
```

Use this to read state, not to wait for it. If you need to block until something specific appears, switch to `wait output`.

## Watch another pane robustly

When you need to coordinate with a sibling pane and the matched text might be broken by soft-wrapping:

```bash
# inspect what is already there
herdr pane read 1-3 --source recent --lines 40

# wait only for the next output you expect (matches unwrapped text)
herdr wait output 1-3 --match "ready" --timeout 30000

# inspect the same transcript the waiter matched, unwrapped
herdr pane read 1-3 --source recent-unwrapped --lines 40
```

## Spawn a new agent and give it a task

```bash
AGENT_PANE=$(herdr pane split 1-2 --direction right --no-focus \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
herdr pane run "$AGENT_PANE" "claude"
herdr wait output "$AGENT_PANE" --match ">" --timeout 15000
herdr pane run "$AGENT_PANE" "review the test coverage in src/api/"
```

The intermediate `wait output` is what stops you from sending the task before the spawned agent's prompt is ready.

## Coordinate until another agent is done

```bash
herdr wait agent-status 1-1 --status done --timeout 120000
herdr pane read 1-1 --source recent --lines 100
```

Use this when you want the same `done` / `idle` distinction the herdr UI shows — the spawned agent has finished and you are about to look at its output (which will transition the status from `done` back to `idle`).
