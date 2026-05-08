# herdr concepts

The data model the CLI operates on. Read once; the command catalog and recipes assume this vocabulary.

## Workspaces, tabs, panes

**Workspaces** are project contexts. Each workspace has one or more tabs. Unless manually renamed, a workspace's label follows the first tab's root pane — usually the repo name, otherwise the root pane's current folder name.

**Tabs** are subcontexts inside a workspace. Each tab has one or more panes.

**Panes** are terminal splits inside a tab. Each pane runs its own process — a shell, an agent, a server, anything.

## Agent status

`agent_status` is detected automatically by herdr. The API exposes one public field with five values:

- `idle` — running, no work in progress
- `working` — actively processing
- `blocked` — waiting on input or an external condition
- `done` — finished, AND you have not yet looked at that finished pane
- `unknown` — herdr cannot classify

`done` is "finished and unread" — it transitions to `idle` once the pane is viewed. Use `wait agent-status <pane> --status done` to block until that transition.

Plain shells still exist as panes, but herdr's sidebar agent section intentionally focuses on detected agents rather than listing every shell.

## ids

ids are compact public identifiers for the **current live session**. They are not durable.

- workspace ids — `1`, `2`, `3`
- tab ids — `1:1`, `1:2`, `2:1` (workspace `:` tab)
- pane ids — `1-1`, `1-2`, `2-1` (workspace `-` pane)

**Important: ids compact when tabs, panes, or workspaces are closed.** Do not assume an older `1-3` is still the same pane later. Re-read ids from `workspace list` / `tab list` / `pane list`, or parse them from `create` / `split` JSON responses, every time you need a current id.

## Environment detection

If you are running inside herdr, the environment variable `HERDR_ENV` is set to `1`. Check this before invoking any `herdr` command — outside herdr the binary either is not present or has nothing to talk to.

```bash
[ "$HERDR_ENV" = "1" ] || { echo "not inside herdr"; exit 1; }
```

## Raw protocol

`herdr` commands talk to the running herdr instance over a local unix socket. If you need the wire-level protocol or full API reference (beyond the CLI catalog in `commands.md`), read `SOCKET_API.md` — drop it next to this skill if the herdr team has shipped one with your version.
