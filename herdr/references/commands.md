# herdr command reference

Full CLI catalog. The `herdr` binary is on your PATH inside herdr; all commands talk to the running instance over a local unix socket.

## Discovery

```bash
herdr pane list                          # all panes; focused one is yours
herdr workspace list                     # all workspaces
herdr tab list --workspace <ws-id>       # tabs in a workspace
herdr pane get <pane-id>                 # one pane's metadata
herdr tab get <tab-id>                   # one tab's metadata
```

All five print JSON.

## Workspaces

```bash
herdr workspace create [--cwd /path] [--label "name"] [--no-focus]
herdr workspace focus <ws-id>
herdr workspace rename <ws-id> "name"
herdr workspace close <ws-id>
```

- `workspace create` returns JSON with `result.workspace`, `result.tab`, and `result.root_pane`.
- Without `--label`, the workspace keeps cwd-based naming.
- `--no-focus` keeps the user's current terminal context focused.

## Tabs

```bash
herdr tab create --workspace <ws-id> [--label "name"]
herdr tab focus <tab-id>                 # tab id is "<ws>:<tab>"
herdr tab rename <tab-id> "name"
herdr tab close <tab-id>
```

- `tab create` returns JSON with `result.tab` and `result.root_pane`.
- Without `--label`, the tab keeps numbered naming.

## Panes — split and close

```bash
herdr pane split <pane-id> --direction <right|down> [--no-focus]
herdr pane close <pane-id>
```

`pane split` returns JSON; the new pane id is at `result.pane.pane_id`. Capture it:

```bash
NEW_PANE=$(herdr pane split 1-2 --direction right --no-focus \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
```

## Panes — send input

```bash
herdr pane send-text <pane-id> "text"     # no Enter
herdr pane send-keys <pane-id> Enter      # raw key (Enter, Up, etc.)
herdr pane run <pane-id> "cmd"            # send-text + Enter in one request
```

All three are silent on success.

## Panes — read output

```bash
herdr pane read <pane-id> --source <visible|recent|recent-unwrapped> --lines <N>
```

- `--source visible` — current viewport
- `--source recent` — recent scrollback as rendered (with soft wraps)
- `--source recent-unwrapped` — recent terminal text with soft wraps joined back together

Use `recent-unwrapped` when you want to inspect the same transcript that `wait output --source recent` matches against. `pane read` prints text, not JSON.

## Wait — block until a condition

```bash
herdr wait output <pane-id> --match "text" [--regex] --timeout <ms>
herdr wait agent-status <pane-id> --status <idle|working|blocked|done> --timeout <ms>
```

- `wait output` matches against unwrapped recent terminal text by default — pane width and soft wrapping won't break matches.
- `--regex` switches the match string from literal to regex.
- Exit code `1` means the wait timed out. Diagnose; do not blind-retry.

Both commands print JSON describing the matched state on success.

## Output shapes — quick lookup

| Command | Prints |
|---|---|
| `workspace list / create`, `tab list / create / get / focus / rename / close`, `pane list / get / split`, `wait output`, `wait agent-status` | JSON |
| `pane read` | text (the transcript) |
| `pane send-text`, `pane send-keys`, `pane run` | nothing on success |

## Common flags — quick lookup

| Flag | Where | Effect |
|---|---|---|
| `--no-focus` | `pane split`, `tab create`, `workspace create` | Don't steal user's focus |
| `--label "..."` | `tab create`, `workspace create` | Apply a custom name immediately |
| `--cwd /path` | `workspace create` | Start the root pane in that directory |
| `--source <mode>` | `pane read` | Visible / recent / recent-unwrapped |
| `--lines <N>` | `pane read` | Tail length |
| `--match "..."` | `wait output` | Substring or regex (with `--regex`) |
| `--regex` | `wait output` | Treat `--match` as regex |
| `--status <s>` | `wait agent-status` | idle / working / blocked / done |
| `--timeout <ms>` | both `wait` commands | Milliseconds before exit code 1 |
