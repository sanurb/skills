# Issue Template

Fill this template with the chosen design from Step 5. Create the issue via `gh issue create`.

## gh Command

```bash
gh issue create \
  --title "RFC: Deepen [module name] — [one-line summary]" \
  --body "$(cat <<'EOF'
[filled template below]
EOF
)"
```

Add `--label "architecture,refactor"` if those labels exist in the repo. If they don't, omit the flag rather than failing.

## Template

```markdown
## Problem

[Architectural friction discovered during exploration]

**Shallow modules involved:**
- `module-a`: [what it does, why it's shallow]
- `module-b`: [what it does, why it's shallow]

**Coupling evidence:**
- [Shared types, co-change frequency, call patterns]

**Integration risk:**
- [What breaks when these modules change independently]
- [Where bugs hide in the seams between them]

## Proposed Interface

**Signature:**

\`\`\`
[interface types and methods in the repo's language]
\`\`\`

**Usage example:**

\`\`\`
[how callers use the new interface]
\`\`\`

**What it hides internally:**
- [implementation detail 1]
- [implementation detail 2]

## Dependency Strategy

**Category:** [In-process / Local-substitutable / Ports & adapters / Mock at boundary]

**Handling:**
- [specific strategy for this candidate]
- [test stand-in or adapter details if applicable]

## Testing Strategy

Replace, don't layer. Old shallow-module tests become redundant once boundary tests exist.

**New boundary tests:**
- [ ] [behavior 1 — verified through the public interface]
- [ ] [behavior 2 — verified through the public interface]

**Tests to delete:**
- [ ] [shallow module test — now redundant]

**Test environment:**
- [local stand-ins, adapters, or infrastructure needed]

## Implementation Guidance

Durable direction — not coupled to current file paths.

**Owns:** [responsibilities]

**Hides:** [implementation details callers must not depend on]

**Exposes:** [the interface contract]

**Migration:** [incremental vs atomic; how existing callers transition]
```
