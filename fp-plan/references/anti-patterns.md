# Anti-Patterns

Recognize and avoid common planning mistakes.

## Checkbox Lists Instead of Sub-Issues

```bash
# BAD: Checkboxes in description — not trackable
fp issue create --title "Auth" --description "- [ ] Create dir\n- [ ] Setup package.json"

# GOOD: Proper sub-issues
fp issue create --title "Auth system"
fp issue create --title "Create directory structure" --parent <ID>
fp issue create --title "Setup package.json" --parent <ID> --depends "<PREV-ID>"
```

## Orphan Tasks

```bash
# BAD: Unconnected issues with no hierarchy
fp issue create --title "Add OAuth"
fp issue create --title "Add sessions"

# GOOD: Linked to a parent plan
fp issue create --title "Authentication system"
fp issue create --title "Add OAuth" --parent <PLAN-ID>
fp issue create --title "Add sessions" --parent <PLAN-ID> --depends "<OAUTH-ID>"
```

## Missing Dependencies

```bash
# BAD: Frontend and backend as independent tasks
fp issue create --title "Frontend UI" --parent <ID>
fp issue create --title "Backend API" --parent <ID>

# GOOD: Explicit dependency ordering
fp issue create --title "Backend API" --parent <ID>
fp issue create --title "Frontend UI" --parent <ID> --depends "<API-ID>"
```

## Monolithic Tasks

```bash
# BAD: Entire feature as one task
fp issue create --title "Build authentication system"

# GOOD: Decomposed into focused sessions
fp issue create --title "Authentication system"
fp issue create --title "OAuth integration" --parent <ID>
fp issue create --title "Session management" --parent <ID> --depends "<OAUTH-ID>"
fp issue create --title "Auth middleware" --parent <ID> --depends "<SESSION-ID>"
```
