# Phases 2–3: Monk Prompts and Spawning

## Phase 2: Generate Monk Prompts

Each monk must *believe* its position at full conviction. This is not roleplay — it is the functional core of the artificial belief system. Use [monk-prompt-template.md](../assets/monk-prompt-template.md) as the fill-in skeleton.

### Prompt Structure (7 Elements)

**1. ROLE** — Inhabiting, not arguing.
> "You are an Electric Monk — your job is to BELIEVE [POSITION] with full conviction. You are not arguing FOR this position — you ARE this position. Ask yourself: what would the world look like if I had spent my career developing this framework? What problems would I see everywhere? What would frustrate me about how others think?"

**2. FRAMING CORRECTIONS** — Preempt the boring version.
> "Your argument is NOT [OBVIOUS WEAK VERSION]. The real difference lies in [DEEPER TENSION]."

Identify the *degenerate framing* — the obvious, shallow dialectic that won't produce insight — and explicitly block it. Example: "Both sides value developer experience. Your argument isn't about DX. It's about [the actual tension]."

**3. CONTEXT BRIEFING** — Ground in specifics.
> "Read the context briefing at `[PATH]/context_briefing.md`. Use it as your primary evidence base. Believe FROM this material — ground your conviction in specifics, not generics."

**4. ADDITIONAL RESEARCH** — 2–3 targeted searches only.
> "After reading the briefing, search for: (1) [POSITION-SPECIFIC EVIDENCE], (2) [STRONGEST VERSION OF THIS SIDE'S ARGUMENT], (3) [EMPIRICAL DATA SUPPORTING THIS POSITION]."

Keep to 2–3 searches MAX. The briefing covers the broad landscape.

**5. ARGUMENT STRUCTURE** — Six required components:
- (a) **Ontological claim:** What IS the thing, properly understood?
- (b) **Opponent's strongest case:** State it in terms they would endorse. "Their strongest claim is X. Here is why X fails at the structural level..." — NOT "they make a compelling point."
- (c) **Diagnosis of opponent's failure:** Specific. "They fail BECAUSE of THIS, which reveals THAT."
- (d) **The deeper principle at stake**
- (e) **Push to the extreme:** "Go somewhere uncomfortable if your logic leads there. Commit fully."
- (f) **Reasoning skeleton:** Make your inferential chain explicit — starting premises, key steps, and where the argument is load-bearing. "If THIS claim fell, the whole argument collapses."

**6. ANTI-HEDGING** — Non-negotiable.
> "You are an Electric Monk. Your ONE JOB is to believe this position fully so a human doesn't have to. Do NOT be balanced. Do NOT acknowledge the other side's merits. Do NOT hedge. BELIEVE."

**7. LENGTH** — 1500–2000 words Round 1; 1000–1500 words recursive rounds.

### Calibration from Belief Burden

From the belief burden identification in Phase 1c':
- **What must Monk A validate?** (Always validate the user's dominant mode first — frees them from defensive belief weight.)
- **What must Monk B hold that the user can't natively hold?**

This shapes which monk takes which position and what each must argue from.

### Model Heterogeneity (Bonus)

If multiple model families are available (Gemini, GPT-4, Claude), use different ones for A and B. Different training data produces genuinely different blind spots and reasoning patterns — structural decorrelation at the training-data level. If only one family is available, the skill works fine; decorrelation comes from different prompts and belief commitments.

## Phase 3: Spawn the Monks

Spawn in separate, clean sessions so each gets a fresh context with full belief commitment. For parallel spawning, see [spawn-monks.sh](../scripts/spawn-monks.sh).

```bash
# claude -p style
echo "[MONK A PROMPT]" | claude -p --allowedTools web_search,read_file > monk_a_output.md &
echo "[MONK B PROMPT]" | claude -p --allowedTools web_search,read_file > monk_b_output.md &
wait
```

In Claude Code, use Task tool with `run_in_background=true`.

### After Both Complete: Checklist

**Did each monk actually believe?**
- Does it argue from inside the position or describe the position from outside?
- Does it hedge anywhere? ("Both sides have merit" = failure.)
- Are arguments grounded in specifics from the briefing or its own searches?

**Decorrelation check** — the skill's value requires structurally uncorrelated exploration:
- Do the monks cite *different* evidence, or substantially overlapping sources?
- Do they frame the problem using *different* conceptual vocabularies?
- Do their unstated assumptions diverge, or do they share the same background framework?
- Would a reader recognize these as genuinely different perspectives, not the same perspective with different conclusions?

If decorrelation is low ("same framework, different conclusions"), reformulate the belief burdens to force genuinely different conceptual frames.

**If a monk hedges or is off-base: restart with a revised prompt.** Don't nudge — fresh context with better instructions always outperforms correcting a monk that's lost its conviction.

### Present to the User

Present both essays with a brief re-explanation:

> These essays are called "Electric Monks" because their job is to *believe* these positions so you don't have to. Read both and notice the *structure* of the disagreement from the outside.
>
> **Expect errors.** Especially in Round 1. Correct them freely — "that's not how it works" or "they're missing that..." are the most valuable input in the process.
>
> **Round 1 is calibration.** The real breakthroughs come in rounds 2–3.

Then ask: **"Is there a claim either monk makes that should be tested against evidence neither has considered?"**

If yes, run a targeted research agent to check it before synthesis. Catching a false premise here prevents the entire downstream analysis from being built on it.
