# Assign Commits

Match commits to the correct fp issue and assign them.

## Steps

1. **Detect VCS** — use `vcs-detect` skill or check manually:
   ```bash
   [ -d .jj ] && echo "jujutsu" || echo "git"
   ```

2. **Find relevant commits:**
   ```bash
   git log --oneline -20    # Git
   jj log --limit 20        # Jujutsu
   ```

3. **Match commits to issues** by comparing:
   - Files changed in commit vs issue description
   - Commit message content vs issue title
   - Code changes vs issue requirements

4. **Confirm with user before assigning.** Present the matches:
   > I found these commits related to `<ID>`:
   > - `abc123` — Add user model
   > - `def456` — Implement auth middleware
   >
   > Assign them to the issue?

5. **Assign on confirmation:**
   ```bash
   fp issue assign <ID> --rev abc123,def456
   ```

6. **Verify:**
   ```bash
   fp issue files <ID>
   fp issue diff <ID> --stat
   ```

## Commands

```bash
fp issue assign <ID> --rev <COMMITS>   # Assign specific commits
fp issue assign <ID>                    # Assign current HEAD
fp issue assign <ID> --reset            # Clear and reassign
```

## Review Without Commits

If the user has not committed yet:

```bash
fp review    # Reviews working copy — no commit assignment needed
```
