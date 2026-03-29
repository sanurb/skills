# Output Format — UBIQUITOUS_LANGUAGE.md

Exact structure. No sections added, removed, or renamed. Agent must reject its own output if any section is missing.

```md
# Ubiquitous Language — {Bounded Context Name}

## {Group Name}

| Term | Kind | Definition | Aliases to avoid |
| ---- | ---- | ---------- | ---------------- |
| **Term** | Entity / Value Object / Command / Event / Policy | One-sentence: what it IS | Synonym1, synonym2 |

## Relationships

- A **Term** belongs to exactly one **OtherTerm** (one-to-one)
- A **Term** produces one or more **AnotherTerms** (one-to-many)

## Example dialogue

> **Dev:** "Question using **Terms** precisely?"
> **Domain expert:** "Answer that reveals a non-obvious boundary or invariant."

## Flagged ambiguities

- ⚠️ WITHIN-CONTEXT: "word" was used to mean both **TermA** and **TermB** — resolved: use **TermA** for X, **TermB** for Y.
- 🔀 CROSS-CONTEXT: "word" means **TermA** in {this context} but refers to a different concept in {other context} — boundary noted, not merged.
```

## Section Contract

| Section | Cardinality | Rejection criteria |
|---------|-------------|-------------------|
| Header | 1 | Missing Bounded Context name after em-dash. |
| Group tables | 1+ | Missing table, or a term without all 4 columns filled. Kind must be one of: Entity, Value Object, Command, Event, Policy. One table per subdomain cluster; single table if domain is cohesive. |
| Relationships | 1 | Terms not **bolded**, or cardinality missing. If no relationships exist, write "No cross-term relationships identified." |
| Example dialogue | 1 | Fewer than 3 exchanges, missing **Dev**/**Domain expert** labels, any domain term unbolded, or no modeling insight surfaced. The dialogue must reveal at least one boundary, invariant, or lifecycle rule. |
| Flagged ambiguities | 1 | Empty section, "TBD", or an ambiguity without classification (⚠️ WITHIN-CONTEXT or 🔀 CROSS-CONTEXT) and recommendation. If none exist, write "No ambiguities detected." |
