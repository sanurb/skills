# Issue tracker: GitHub

Issues and PRDs for this repo live as GitHub issues. Use the [`gh`](https://cli.github.com) CLI for all operations.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies; pass `--body -` to read from stdin.
- **Read an issue**: `gh issue view <number> --comments`. Use `--json <fields>` for machine-readable output.
- **List issues**: `gh issue list --json number,title,labels` with appropriate `--label` / `--state` filters.
- **Comment on an issue**: `gh issue comment <number> --body "..."`.
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`. Multiple labels can be comma-separated or by repeating the flag.
- **Close**: `gh issue close <number> --comment "..."`. The closing comment is posted in the same call.
- **Pull requests**: `gh pr create`, `gh pr view`, `gh pr comment`, etc. — same shape as `gh issue ...` with `pr` in place of `issue`.

Infer the repo from `git remote -v` — `gh` does this automatically when run inside a clone.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.
