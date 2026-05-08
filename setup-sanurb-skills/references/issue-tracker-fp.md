# Issue tracker: fp

Issues and plans for this repo live in [fp](https://fp.dev) — a CLI-driven issue tracker with hierarchical parents, explicit dependencies, and a tree-shaped view. Use the `fp` CLI for all operations.

If `fp` isn't installed: `curl -fsSL https://setup.fp.dev/install.sh | sh -s`.
If the project isn't initialised: `fp init`.

## Conventions

- **Create an issue**: `fp issue create --title "..." --description "..."`. Use a heredoc for multi-line descriptions; pass `--description -` to read from stdin / open an editor.
- **Create a child or dependency**: add `--parent <ID>` to nest under an existing plan and/or `--depends "<ID-A>,<ID-B>"` to declare prerequisites.
- **Read an issue**: `fp issue view <ID>`.
- **List issues**: `fp issue list` (filter flags vary — check `fp issue list --help`).
- **View the tree**: `fp tree [<ID>]` — visualises parent/child structure and dependency order.
- **Comment**: `fp issue comment <ID> --message "..."`.
- **Close**: `fp issue close <ID>`. If the close needs an explanation, post it as a comment first.

Infer the repo from the local `fp` initialisation — `fp` operates on the current working tree once `fp init` has run.

## Triage state — important divergence

fp models issue state through **tree position and dependency edges**, not free-form labels. The five canonical roles in `triage-labels.md` therefore map onto fp idiomatically rather than literally:

- `needs-triage` → top-level issue with no parent and no dependencies set yet
- `needs-info` → an open comment requesting reporter input (no special label needed; the conversation IS the state)
- `ready-for-agent` → all `--depends` issues are closed and the description is complete enough that `fp-implement` can pick it up with no human context
- `ready-for-human` → same as above, but the description explicitly flags it as human-only (e.g. `Owner: human` line)
- `wontfix` → closed with a comment explaining why

If you genuinely need label-style filtering, encode it as a `Status:` line in the description rather than fighting the fp model.

## When a skill says "publish to the issue tracker"

Run `fp issue create --title "..." --description "..."`. Add `--parent <ID>` if it logically belongs under an existing plan. Add `--depends "<IDs>"` if it has prerequisites.

## When a skill says "fetch the relevant ticket"

Run `fp issue view <ID>`. The user will pass the ID directly. Use `fp tree <ID>` if you also need the surrounding parent/child context.

## Composes with

- `/fp-plan` — break a plan into a tracked fp hierarchy with parents and dependencies
- `/fp-implement` — pick up a `ready-for-agent` issue and work on it
- `/fp-review` — review work done on an issue and assign feedback
