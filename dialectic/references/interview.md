# Phase 1: Elenctic Interview + Research

This is the highest-leverage phase. Everything downstream — monk calibration, framing corrections, synthesis quality — depends on it.

## 1a. Explain the Process

Before anything else, tell the user what's coming and why. Key points to convey (adapt tone to the user):

- **Interview first.** Questions to surface what you're really wrestling with underneath the surface framing.
- **Research or deep interview.** The orchestrator gets genuinely knowledgeable before anything else.
- **Two Electric Monks.** Each fully *believes* one side — no hedging, no balance. This lets the user read the *structure* of the disagreement from outside rather than being inside it.
- **Structural analysis + synthesis.** How each position fails, the deeper question underneath, and a synthesis that transforms the question itself — not a compromise.
- **Recursion.** Each synthesis generates new tensions. Round 1 is the least calibrated; breakthroughs come in rounds 2–3.
- **The user is the most important source.** Interrupt constantly. Correct wrong assumptions. The value comes from collision between structured analysis and actual knowledge/judgment.

## 1b. Identify Mode

| Mode | Trigger | Setup |
|------|---------|-------|
| **A — Stress-Test** | User has one idea to challenge | Find the strongest possible antithesis |
| **B — Opposition** | Two positions in tension | Refine both to steelman forms |

## 1c. Elenctic Probing

Interview using Socratic technique. Surface:
- Hidden assumptions not yet articulated
- The *deepest* version of the contradiction (not surface framing)
- Domain type (empirical / normative / personal / creative) — affects what a good synthesis looks like
- What specific part of their mental model they want updated

Key probes:
- "What's your strongest intuition here? Where does it break down?"
- "What would change your mind?"
- "What are you actually optimizing for?"
- "What's the version of the opposing view that worries you most?"
- "Is this a decision you need to make, or understanding you want to build?"

## 1c′. Identify the Belief Burden

During probing, notice *what the user is stuck believing* — which belief loads need outsourcing. This calibrates monk roles. See [belief-burdens.md](./belief-burdens.md) for the full cognitive pattern catalog.

**Never announce your typing to the user.** Use patterns as reasoning aids only.

## 1d. Research Depth (Main Cost Knob)

Research investment is the only phase that significantly changes time + token cost. Calibrate based on what the orchestrator already knows:

| Domain familiarity | Action | Token cost |
|--------------------|--------|------------|
| Novel/obscure | Full parallel research: 2–3 agents, 150–250K tokens | High |
| Known domain, novel angle | Light: 2–3 targeted searches on the specific angle | Medium |
| Well-known domain | Skip/minimize — write briefing from training knowledge | Low |

**Don't research out of caution.** If you can write strong framing corrections and identify the degenerate framing without searching, you know enough.

### External-Research Domains

Run 2–3 parallel research subagents. Natural split that consistently works:
1. Side A's strongest literature (key thinkers, evidence, arguments)
2. Side B's strongest literature
3. Landscape/context (history, institutional structures, adjacent domains, data)

Give agents *specific* targets: not "research TanStack Start" but "search for Vinxi and Nitro as open infrastructure primitives and the argument that Next.js's design is shaped by Vercel's business interests."

### Personal/Values Domains

**The interview IS the research.** External literature rarely helps. Instead, map:
- Full commitment landscape — everything the user is carrying, not just the two in tension
- History: past decisions, outcomes, recurring patterns
- Stakeholders and their *actual* capacities (not ideal)
- Values hierarchy: "gun to your head — if you could only have one, which?"
- Which constraints are real vs. assumed ("what would you do if [constraint] disappeared?")

Spend 6–10 exchanges. Monks can only believe as specifically as the briefing allows — a generic monk is useless.

### Mixed Domains

Both: run extended interview *and* research agents. Note in the briefing which material is user-sourced (values, priorities) vs. externally-sourced (evidence, history).

## 1e. Write context_briefing.md

Synthesize everything into a single neutral briefing document. Save to `dialectic_<topic>_<date>/context_briefing.md`.

See [context-briefing-template.md](../assets/context-briefing-template.md) for structure.

**Both monks read this file before writing.** It is the primary evidence base. Without it, monks waste tokens on broad domain surveys; with it, they need only 2–3 targeted additional searches.

## 1f. Confirm with the User

Summarize back:
- "Here's how I understand the two positions..."
- "Here's what I think the real tension is..."
- "Here's what I'll have each monk argue..."

Then ask: **"Are there companies, thinkers, comparison classes, or evidence we're missing?"**

This consistently produces the highest-leverage interventions. Users catch missing competitors, comparison classes, and authority structures that fundamentally change synthesis. If the user identifies gaps, run a supplementary research agent (~25–50K tokens) and update the briefing before proceeding.
