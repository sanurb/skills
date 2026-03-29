---
name: ubiquitous-language
description: Extract a DDD ubiquitous language glossary from conversation context into UBIQUITOUS_LANGUAGE.md, scoped to a Bounded Context. Triggers on "ubiquitous language", "domain glossary", "define terms", "DDD", "domain model", "harden terminology".
---

# Ubiquitous Language

Turn messy domain conversations into a single-source-of-truth glossary scoped to one Bounded Context. One concept = one canonical term. Every ambiguity resolved, never deferred.

## Instructions

1. **Extract.** Read the full conversation. Identify the Bounded Context — ask the user if unclear. For every domain noun, verb, process, or concept, create a candidate entry: `term | kind | definition | aliases to avoid`. Kind is one of: Entity, Value Object, Command, Event, Policy. Skip generic programming words (array, endpoint, function) unless they carry domain-specific meaning. If `UBIQUITOUS_LANGUAGE.md` already exists in the working directory, read it first — existing terms are the baseline. New terms add, conflicts overwrite with the latest understanding, stale terms stay unless contradicted.

2. **Resolve.** Walk the candidate list and classify every problem as one of two types. **Within-context ambiguity** (same word → different meanings inside this Bounded Context): pick ONE canonical term, write a recommendation, list alternatives as aliases to avoid. **Cross-context term** (word means something different in another Bounded Context): note the boundary — do not merge, do not force-resolve. Both types go in Flagged Ambiguities with their classification. If zero issues exist, write "No ambiguities detected" — never leave empty, never write "TBD".

3. **Write.** Produce `UBIQUITOUS_LANGUAGE.md` in the working directory following the exact structure in [output-format.md](./references/output-format.md). Then print an inline summary: `N terms | M ambiguities flagged | K terms needing domain expert input`.

## Non-Negotiable Acceptance Criteria

- Output file matches [output-format.md](./references/output-format.md) exactly. No sections added, removed, or renamed.
- Glossary header names the Bounded Context this language belongs to.
- Every term has a Kind: Entity, Value Object, Command, Event, or Policy.
- Every definition is one sentence that says what the term IS in the domain expert's language — not what it does technically, not how it's implemented.
- One canonical term per concept within this context. Every alternative appears in "Aliases to avoid".
- Every ambiguity has an explicit recommendation. Within-context ambiguities are resolved. Cross-context differences are noted as boundaries — never force-merged.
- Relationships section uses **bolded** term names and states cardinality.
- Example dialogue has 3–5 exchanges between **Dev** and **Domain expert**. Every domain term appears **bolded**. The dialogue must surface at least one non-obvious modeling insight — a boundary, invariant, or lifecycle rule that wasn't explicit before.
- Minimum 3 terms extracted. If the conversation has fewer than 3 domain concepts, tell the user — do not fabricate terms.
- Inline summary is the last thing printed. Format: `N terms | M ambiguities flagged | K terms needing domain expert input`.

## Output

File: `UBIQUITOUS_LANGUAGE.md` in the current working directory.
Format: [output-format.md](./references/output-format.md).
Inline: summary line after file is written.
