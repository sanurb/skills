---
name: context-map
description: Produce a DDD Context Map showing relationships between Bounded Contexts from existing UBIQUITOUS_LANGUAGE.md glossaries or conversation context. Saves to CONTEXT_MAP.md. Triggers on "context map", "context mapping", "bounded context relationships", "how do these contexts relate", "upstream downstream".
---

# Context Map

Identify all Bounded Contexts in scope and classify the relationship between each pair using Evans/Vernon's canonical patterns. One map per system. Every relationship typed, every direction explicit.

## Instructions

1. **Discover contexts.** Scan the working directory for `UBIQUITOUS_LANGUAGE.md` files — each one names a Bounded Context in its header. If none exist, extract context boundaries from the current conversation. Ask the user if the boundary between two contexts is unclear. Minimum 2 contexts required — a map of one context is meaningless; tell the user to run `ubiquitous-language` first.

2. **Classify relationships.** For every pair of contexts that communicate, assign exactly one relationship pattern from [relationship-patterns.md](./references/relationship-patterns.md). Determine direction: which is upstream (supplier) and which is downstream (consumer). If a pair has no communication, omit it — do not invent relationships. Use `🔀 CROSS-CONTEXT` flags from glossaries as evidence when available.

3. **Write.** Produce `CONTEXT_MAP.md` in the working directory following the exact structure in [output-format.md](./references/output-format.md). Then print an inline summary: `N contexts | M relationships | K unresolved`.

## Non-Negotiable Acceptance Criteria

- Output file matches [output-format.md](./references/output-format.md) exactly. No sections added, removed, or renamed.
- Every relationship uses one pattern from [relationship-patterns.md](./references/relationship-patterns.md). No invented patterns.
- Every relationship states upstream/downstream direction. Symmetric patterns (Shared Kernel, Partnership) mark both sides explicitly.
- No relationship between contexts that don't actually communicate. Omission is correct; fabrication is not.
- Shared terms that mean different things across contexts appear in the Translation Table with both definitions.
- Minimum 2 contexts, minimum 1 relationship. If the conversation doesn't support this, tell the user — do not fabricate.
- Inline summary is the last thing printed. Format: `N contexts | M relationships | K unresolved`.

## Output

File: `CONTEXT_MAP.md` in the current working directory.
Format: [output-format.md](./references/output-format.md).
Inline: summary line after file is written.
