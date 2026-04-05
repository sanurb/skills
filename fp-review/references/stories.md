# Stories

Create narrative documents that walk a reviewer through code changes.

Stories combine markdown prose with embedded diffs and file excerpts.

## Prerequisites

```bash
fp feature enable experimental_story
```

## Creating a Story

Write a markdown file, then publish it:

```bash
fp story create <ID> --file story.md
```

The first `## ` heading becomes the story title. One story per issue — creating a new one replaces the previous.

## Story Directives

### Diff Directive

Show file changes from the issue's assigned commits:

```markdown
## Moved validation to a shared module

The old approach duplicated validation in each handler.

:::diff{file="src/validation.ts"}
Extracted from handler.ts and api.ts into a single module.
:::
```

- `file` (required): relative path to the changed file.
- Annotation text: 1-2 sentences of context.

### File Directive

Show file content or a slice:

```markdown
:::file{path="src/config.ts" lines="10-25"}
The new defaults that drive the behavior change.
:::
```

- `path` (required): relative path.
- `lines` (optional): line range, e.g. `"10-25"`.

### Chat Directive

Embed excerpts from an AI coding session:

```markdown
:::chat{source="claude" session="/path/to/session.jsonl" messages="msg1,msg2"}
The key design discussion that led to this approach.
:::
```

- `source`: `"claude"`, `"pi"`, or `"opencode"`.
- `session`: full path to session file.
- `messages`: comma-separated message IDs.

## Writing Guidelines

- **Headings are past-tense verbs** — "Moved validation" not "Move validation".
- **Start with the user problem** — opening prose explains why the change exists.
- **Show diff, then explain** — lead with `:::diff`, follow with annotation.
- **Annotations are 1-2 sentences** — brief context, not a full explanation.

## Managing Stories

```bash
fp story list                    # List all stories
fp story get <ID>                # Get story by issue ID
fp story delete <STORY-ID>       # Delete a story
fp review <ID> --with-story      # Open review with story panel
```
