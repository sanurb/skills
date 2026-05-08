---
name: improve-codebase-architecture
description: Find deepening opportunities in a codebase, informed by the domain language in CONTEXT.md and the decisions in docs/adr/. Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable.
---

# Improve Codebase Architecture

## Purpose

Surface architectural friction in a codebase and propose deepening opportunities — refactors that turn shallow modules into deep ones — using the project's own domain language and respecting its recorded decisions. The aim is testability and AI-navigability: high leverage at small interfaces, change concentrated in one place, tests written at the seam where callers and tests cross the same surface.

## Instructions

### 1. Load vocabulary, then explore with the project's own language

Read the architecture vocabulary and the project's own docs BEFORE generating any candidates.

- Read: `references/language.md`. Use these terms exactly: **module, interface, implementation, depth, seam, adapter, leverage, locality**. Do not drift into "component," "service," "API," or "boundary."
- Read the project's `CONTEXT.md` (or follow `CONTEXT-MAP.md`) and every ADR in `docs/adr/` that touches the area being explored.
- Use the Agent tool with `subagent_type=Explore` to walk the codebase. Note where you experience friction: where understanding requires bouncing between many small modules; where modules are shallow (interface nearly as complex as implementation); where pure functions exist for testability without locality; where seams leak; where parts are untested or hard to test through their current interface.
- Apply the deletion test to every suspect module: would deleting it concentrate complexity, or just move it? Only "concentrates" qualifies as a candidate.

### 2. Present candidates and stop

Present a numbered list of deepening opportunities, then halt for user selection. Do NOT propose interfaces yet.

- Use `CONTEXT.md` vocabulary for domain things ("the Order intake module," not "the FooBarHandler" or "the Order service").
- Use `references/language.md` vocabulary for architecture things.
- If a candidate contradicts an existing ADR, surface it ONLY when the friction is real enough to warrant revisiting, marked: _"contradicts ADR-NNNN — but worth reopening because…"_. Do not list theoretical refactors that ADRs forbid.
- End with: _"Which of these would you like to explore?"_ Then stop.

### 3. Run the chosen candidate to ground via grilling loop

Once the user picks one candidate, drop into a grilling conversation. Walk the design tree: constraints, dependency category, shape of the deepened module, what sits behind the seam, what tests survive.

- Read: `references/deepening.md` for dependency categorisation and seam strategy (in-process / local-substitutable / remote-but-owned / true external).
- If the user wants alternative interface designs, read: `references/interface-design.md` and follow its parallel-sub-agent pattern.
- Side effects happen inline as decisions crystallise (never batched):
  - New domain term named during the conversation → update `CONTEXT.md` immediately. Format: `../grill-with-docs/references/context-format.md`. Create the file lazily.
  - User rejects the candidate with a load-bearing reason that future explorers would need to avoid re-suggesting it → offer an ADR. Format: `../grill-with-docs/references/adr-format.md`. Skip ADR offers for ephemeral reasons ("not worth it right now") or self-evident ones.

## Non-Negotiable Acceptance Criteria

The skill delivers nothing if any of these fails:

- [ ] `references/language.md` was read before any candidate was generated.
- [ ] `CONTEXT.md` and relevant ADRs were read before any candidate was generated.
- [ ] Architecture vocabulary is used exactly. Zero occurrences of "component," "service," "API," or "boundary" as a substitute for **module / interface / seam**.
- [ ] Domain things in candidates are named using `CONTEXT.md` vocabulary, not invented names or framework names.
- [ ] Every candidate passes the deletion test: deleting the proposed module concentrates complexity rather than moving it.
- [ ] No interface design was proposed before the user picked a candidate.
- [ ] No port was recommended for a single-adapter situation. One adapter = hypothetical seam; two = real seam.
- [ ] Internal seams used by a deep module's own tests were NOT exposed through its external interface.
- [ ] An ADR offer happened only when all three gates pass (hard to reverse, surprising without context, real trade-off).
- [ ] `CONTEXT.md` updates during grilling happened inline (same turn as the resolution), never batched at the end.
- [ ] ADR conflicts were flagged ONLY when the friction warranted revisiting the ADR, not as theoretical objections.

## Output

**Phase 1 output — numbered candidates list.** Exactly this shape per item:

```
### {N}. {Module name in CONTEXT.md vocabulary}

**Files:** {paths}
**Problem:** {friction described in references/language.md vocabulary}
**Solution:** {plain-English description of the deepened shape}
**Benefits:** {locality + leverage + how the test surface improves}
{optional: contradicts ADR-NNNN — but worth reopening because …}
```

End the list with the literal question: _"Which of these would you like to explore?"_

**Phase 2 output — problem-space framing for the chosen candidate:**

- Constraints any new interface would need to satisfy.
- Dependency category (per `references/deepening.md`) and the test/adapter strategy that follows from it.
- A rough illustrative code sketch to ground the constraints — not a proposal, just a grounding.

**Phase 3 output — inline file artifacts (only if the conversation produces them):**

- New term entries in `CONTEXT.md` per `../grill-with-docs/references/context-format.md`.
- New file `docs/adr/NNNN-slug.md` per `../grill-with-docs/references/adr-format.md` (only on accepted ADR offers).

If the user requested alternative interfaces, the parallel-sub-agent output schema in `references/interface-design.md` is binding and replaces nothing in this list.
