# Output Format — CONTEXT_MAP.md

Exact structure. No sections added, removed, or renamed. Agent must reject its own output if any section is missing.

```md
# Context Map — {System Name}

## Contexts

| Context | Core responsibility | Glossary |
| ------- | ------------------- | -------- |
| **{Name}** | One-sentence purpose | `UBIQUITOUS_LANGUAGE.md` path or "—" if none |

## Relationships

| Upstream | Downstream | Pattern | Integration mechanism |
| -------- | ---------- | ------- | --------------------- |
| **{Context A}** | **{Context B}** | Anticorruption Layer | REST API with translation adapter |
| **{Context A}** ↔ **{Context B}** | — | Partnership | Shared deploy pipeline |

## Translation Table

| Term | In {Context A} | In {Context B} | Notes |
| ---- | -------------- | -------------- | ----- |
| "account" | **Customer** (Entity) | **User** (Entity) | Different lifecycle — do not merge |

## Unresolved

- {Description of any relationship or boundary that needs domain expert input.}
```

## Section Contract

| Section | Cardinality | Rejection criteria |
|---------|-------------|-------------------|
| Header | 1 | Missing system name. |
| Contexts | 1 | Fewer than 2 rows. Missing responsibility. |
| Relationships | 1 | Pattern not from relationship-patterns.md. Missing direction. Fabricated relationship between non-communicating contexts. For symmetric patterns (Partnership, Shared Kernel), use `↔` — no upstream/downstream columns. |
| Translation Table | 1 | Shared term without both context definitions. If no terms are shared, write "No shared terms across contexts." |
| Unresolved | 1 | If none, write "No unresolved boundaries." Never leave empty, never write "TBD". |
