# Import From PRD

Bridge external PRD content into an fp issue hierarchy.

## From prd-to-issues (GitHub Issues)

If a PRD was broken into GitHub issues via `prd-to-issues`:

1. **Fetch the PRD issue:**
   ```bash
   gh issue view <number> --json title,body
   ```

2. **Fetch child issues:**
   ```bash
   gh issue list --search "parent:#<number>" --json number,title,body
   ```

3. **Create fp parent from the PRD:**
   ```bash
   fp issue create --title "<PRD title>" --description "<PRD body>"
   ```

4. **Create fp sub-tasks from each child issue, preserving dependency order:**
   ```bash
   fp issue create --title "<child title>" --parent <FP-PARENT> --description "<child body>"
   ```

5. **Model dependencies with `--depends`** based on the "Blocked by" sections in the GitHub issues.

## From prd-draft (Local Artifact)

If a PRD exists at `/tmp/prd-{name}/prd-draft.md`:

1. Read the file.
2. Extract the title, user stories, and acceptance criteria.
3. Create the fp parent issue with the full PRD as description.
4. Break user stories into fp sub-tasks.

## From External URLs

**GitHub Issues** (`github.com/owner/repo/issues/N`):
```bash
gh issue view <url> --json title,body,labels
```

**Linear Issues** (`linear.app/...`):
Use the `get_issue` MCP tool from the Linear server if available.

**Notion Pages** (`notion.so/...`):
Use the `notion-fetch` MCP tool if available.

After fetching, create an fp parent issue from the extracted content, then offer to break it down into sub-tasks.
