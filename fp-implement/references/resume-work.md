# Resume Work

Pick up where a previous session left off.

## Steps

1. **Find in-progress work:**
   ```bash
   fp issue list --status in-progress
   ```

2. **Load context:**
   ```bash
   fp context <ID>
   ```

3. **Review recent activity:**
   ```bash
   fp log <ID> --limit 5
   ```

4. **See what has changed so far:**
   ```bash
   fp issue diff <ID> --stat
   ```

5. **Post a resume comment and continue:**
   ```bash
   fp comment <ID> "Resuming work. Current focus: <what to do next>"
   ```

Read the last comments to understand where work stopped. Do not redo completed steps.
