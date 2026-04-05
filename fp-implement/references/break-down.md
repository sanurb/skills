# Break Down Work

Split a task that is too large into trackable sub-issues.

## When to Split

Split when a task will take more than one focused session (1-3 hours) or touches multiple unrelated areas.

## Steps

1. **Create sub-tasks under the parent:**
   ```bash
   fp issue create --title "Part 1: Setup" --parent <ID>
   fp issue create --title "Part 2: Implementation" --parent <ID> --depends "<PART1-ID>"
   fp issue create --title "Part 3: Tests" --parent <ID> --depends "<PART2-ID>"
   ```

2. **Document the breakdown:**
   ```bash
   fp comment <ID> "Broke down into sub-tasks: <IDs>. Starting with <first>."
   ```

3. **Work on sub-tasks individually:**
   ```bash
   fp issue update --status in-progress <PART1-ID>
   ```

## Rules

- Each sub-task must be completable in one session.
- Model dependencies explicitly with `--depends`.
- Parent issue status reflects aggregate child progress.
