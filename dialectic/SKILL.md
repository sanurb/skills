---
name: dialectic
description: Structured dialectical reasoning engine — two subagents believe opposed positions at full conviction (Electric Monks) while the orchestrator performs structural contradiction analysis and synthesis (Aufhebung). Use when stress-testing an idea, resolving genuine tension, making high-stakes decisions where tradeoffs are unclear, or building a deeper mental model of a domain. Works across technical architecture, product strategy, philosophy, personal decisions, risk analysis, and policy.
---

# Dialectic — Electric Monks Engine

An **artificial belief system (ABS)**: two Electric Monks carry the belief load so you don't have to, freeing you to analyze the *structure* of the contradiction from a belief-free position. The bottleneck in human reasoning is belief inertia — once you hold a position, you can't simultaneously entertain its negation at full strength. The monks eliminate that cost. You orchestrate from above belief.

## When to Use

| Use | Avoid |
|-----|-------|
| Stress-testing an idea against the strongest counter-argument | Question is purely empirical — just look it up |
| Genuine tension between two positions that feels unresolvable | One side is obviously correct |
| Decision with real stakes and unclear tradeoffs | User wants a quick recommendation, not deep analysis |
| Building a deeper mental model, not just picking an answer | |
| Problem space is poorly understood and needs multi-angle exploration | |

## Pipeline

```
You (Orchestrator)
├── Phase 1: Elenctic Interview + Research   → context_briefing.md
│   ├── 1a: Explain process + set user as co-pilot
│   ├── 1b-c: Identify mode (stress-test vs opposition) + probe assumptions
│   ├── 1c′: Identify belief burden → calibrate monk roles
│   ├── 1d: Ground monks (research depth = main cost knob)
│   ├── 1e: Write context_briefing.md
│   └── 1f: Confirm framing — ask what's missing
│
├── Phase 2: Generate Monk Prompts           → monk_[a|b]_prompt.md
│   └── (See assets/monk-prompt-template.md)
│
├── Phase 3: Spawn Monks (parallel)          → monk_[a|b]_output.md
│   ├── Decorrelation check: different frameworks, not just conclusions?
│   └── User checkpoint: evidence or comparison class both monks missed?
│
├── Phase 4: Determinate Negation            → determinate_negation.md
│   ├── 4.0: Internal tensions — where does each essay undermine itself?
│   └── 4.1–4.6: Surface contradiction → shared assumptions → specific failures
│       → hidden question → Boydian decomposition → sublation criteria
│
├── Phase 5: Sublation / Aufhebung           → sublation.md
│   └── Abduction test: does synthesis make the contradiction predictable?
│
├── Phase 6: Validation                      → validation_output.md
│   ├── Monk A + B: elevated or defeated?
│   ├── Hostile Auditor (skip Round 1 unless synthesis feels weak)
│   └── Refine: present improvements one at a time, incorporate accepted
│
└── Phase 7: Recursion (default: at least once) → dialectic_queue.md
    ├── Generate 5–8 candidate directions, cluster to 2–4
    └── Repeat from Phase 2 (or Phase 1 if new research needed)
```

## Session Artifacts

Write all files to a session directory: `dialectic_<topic>_<date>/`

| Phase | Artifact | Contents |
|-------|----------|----------|
| 1 | `context_briefing.md` | Research synthesis + user situation |
| 2 | `monk_[a\|b]_prompt.md` | Full prompts (enable resume/debug) |
| 3 | `monk_[a\|b]_output.md` | Essays |
| 4–5 | `determinate_negation.md`, `sublation.md` | Analysis + synthesis |
| 6 | `validation_output.md` | Monk + auditor feedback |
| 7 | `dialectic_queue.md` | Explored + queued contradictions |

## Phase Quick-Reference

| Phase | Skip When | Key Decision |
|-------|-----------|-------------|
| 1d Research | Well-known domain, no novel angle | How deep? Novel→full; known→minimal |
| 3 Decorrelation | — | Restart monk if hedging; don't nudge |
| 6 Auditor | Round 1 unless synthesis feels weak | Use strongest model + extended thinking |
| 7 Recursion | Queue contradictions diminishing + user satisfied | Default: recurse at least once |

## Anti-Hedging (Non-Negotiable)

A hedging monk has failed its one job. When a monk hedges, the user picks up the dropped belief load — their transients slow and the dialectic degrades into a book report. Anti-hedging instructions are a **functional requirement**, not style.

**If a monk hedges: restart with a revised prompt. Do not nudge.** Fresh context beats correction every time.

## Reading Order

| Task | Read |
|------|------|
| Starting a session | SKILL.md → [interview.md](./references/interview.md) |
| Writing monk prompts | [monks.md](./references/monks.md) + [belief-burdens.md](./references/belief-burdens.md) |
| Structural analysis | [analysis.md](./references/analysis.md) |
| Validation + auditor | [validation.md](./references/validation.md) |
| Recursion planning | [recursion.md](./references/recursion.md) |
| Domain-specific guidance | [domain-adaptation.md](./references/domain-adaptation.md) |
| Why this works | [theory.md](./references/theory.md) |
| Worked examples | [worked-examples.md](./references/worked-examples.md) |

## In This Reference

| File | Purpose |
|------|---------|
| [interview.md](./references/interview.md) | Phase 1: elenctic interview, belief burden ID, research grounding |
| [monks.md](./references/monks.md) | Phases 2–3: monk prompt structure, spawning, decorrelation |
| [analysis.md](./references/analysis.md) | Phases 4–5: determinate negation, Boydian decomposition, sublation |
| [validation.md](./references/validation.md) | Phase 6: monk validation, hostile auditor prompt, refinement |
| [recursion.md](./references/recursion.md) | Phase 7: recursion engine, queue management, stopping criteria |
| [belief-burdens.md](./references/belief-burdens.md) | Cognitive pattern catalog for monk calibration |
| [domain-adaptation.md](./references/domain-adaptation.md) | Domain-specific failure modes and truth types |
| [theory.md](./references/theory.md) | Theoretical foundations (Rao, Hegel, Boyd, Peirce, etc.) |
| [worked-examples.md](./references/worked-examples.md) | Three annotated examples with key lessons |
| [monk-prompt-template.md](./assets/monk-prompt-template.md) | Fill-in-the-blank monk prompt |
| [context-briefing-template.md](./assets/context-briefing-template.md) | Briefing document template |
| [spawn-monks.sh](./scripts/spawn-monks.sh) | Spawn Monk A + B in parallel |
