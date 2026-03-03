# Phase 6: Validation

The synthesis must be validated by the original monks — not by you, and not just by the user. Thesis and antithesis must each recognize themselves as preserved-but-elevated in the Aufhebung. A defeated monk dropped its belief load; a properly elevated monk *believes more* — it sees its original position as partial truth within a larger truth.

## Monk Validation

Send a **condensed summary** of the determinate negation and sublation to each monk separately. If your environment supports session resumption, use the same sessions. If not, include a summary of each monk's original argument in the prompt.

**Use strongest available model + extended thinking.** Validation is more subtle than it appears — the monk must reason about whether its core insight was genuinely preserved or quietly destroyed.

### Validation Prompt

```
You argued passionately for [POSITION]. Summary of your argument:
[CONDENSED SUMMARY — or omit if resuming same session]

A dialectician has proposed a synthesis of the contradiction between your position and your opponent's.

Structural analysis (key moves):
[CONDENSED DETERMINATE NEGATION — what was cancelled, what each monk's specific failure was]

Proposed synthesis:
[CONDENSED SUBLATION — what's cancelled, preserved, elevated, and the concrete proposal]

Evaluate from your committed position. Answer:

1. Does this synthesis PRESERVE your core insight? What specifically does it get right?

2. Does it reveal a genuine limitation in your position? What were you missing? What assumption were you trapped in?

3. Do you feel ELEVATED or DEFEATED? "Elevated" = "I see my position as partial truth within a larger truth I couldn't have reached alone." "Defeated" = "My position was dismissed or diluted." Be honest — if defeated, explain why.

4. What's wrong with this synthesis? Where is it weak, evasive, or splitting the difference rather than genuinely transcending?

5. DEFEASIBILITY: What is the single piece of evidence or argument that, if true, would force you to abandon even your elevated position? Is this something the synthesis addresses, or an open vulnerability?

Do NOT be agreeable. If the synthesis is compromise dressed up, call it out.
```

Open vulnerabilities from question 5 become recursion targets.

## Adversarial Validation

After both monks respond, ask: **"Would the strongest advocate for the position MOST challenged by this synthesis accept it? If not, why not?"**

This catches syntheses that are intellectually compelling but don't engage how decisions actually get made. A synthesis can be structurally right and practically irrelevant — the adversarial check surfaces that gap.

## The Hostile Auditor

Spawn a separate agent whose sole mandate is to find what's wrong with the synthesis. Not another monk with a position — it has no position. Its job is to be *correct*, not fair.

### When to Use

| Condition | Use Auditor? |
|-----------|-------------|
| Round 2+ | Always |
| Round 1, synthesis feels strong | Optional — skip and recurse |
| Round 1, synthesis feels weak | Yes |
| Synthesis feels too easy or agreeable | Yes (any round) |

### Critical Setup

**Use the strongest available model with extended thinking.** The auditor's value comes from catching what the orchestrator missed while embedded in the process.

**Give the auditor ONLY the monks' essays and the synthesis.** Do NOT give it the orchestrator's Phase 4 structural analysis — the auditor should attack from fresh eyes.

**Give the auditor domain context.** 2–3 sentences explaining how this domain actually works — who the actors are, what the current state is. Prevents critiques built on false premises about the domain.

### Auditor Prompt

```
You are a hostile auditor. Your job is not to be fair. Your job is to be correct.

DOMAIN CONTEXT: [2-3 sentences: relevant actors, mechanics, current state]

Read these two essays and the proposed synthesis, then evaluate:

1. COMPARE AGAINST STATUS QUO. Is this synthesis better than the current state of understanding? If the current state is confusion, 80% right is a massive improvement. Do NOT measure against a hypothetical perfect answer.

2. ATTACK THE SYNTHESIS, NOT THE POSITIONS. The monks had their day. Attack how the positions were COMBINED — does the synthesis actually resolve the contradiction, or paper over it? Is the reframing genuine or cosmetic?

3. HIDDEN SHARED ASSUMPTIONS. Find assumptions both essays and the synthesis share without questioning. These are often where the real limitation lives.

4. DEFEAT ANALYSIS (in priority order):
   a. UNDERCUTTING DEFEATERS (highest priority): Does the synthesis conflate analogy with identity? Assume shared frameworks that don't exist? Draw connections that are rhetorically compelling but logically ungrounded? An undercutting defeater shows the LINK between evidence and conclusion is broken.
   b. SELF-DEFEATING STRUCTURE: Does the synthesis, if accepted, undermine its own evidence? Does any step remove support for an earlier step?
   c. REBUTTING DEFEATERS (lowest priority): Evidence supporting the negation of the synthesis's central claim.

5. PROSPECTIVE HINDSIGHT: It is 6 months from now and this synthesis has been discredited. What was the fatal flaw? Work backward from failure to identify the weakest structural joint.

6. COMPROMISE DETECTION: Could BOTH original advocates have proposed this if feeling conciliatory? If yes, it's not a real sublation.

7. PROPOSE THE HARDER CONTRADICTION. Point toward what the synthesis misses. "This resolves the easy tension but the harder one is ___." Your most valuable output is identifying what the NEXT round should tackle.

8. CLOSURE CHECK: Could a monk BELIEVE this synthesis at full conviction and argue from it as a position? If not, recursion will stall.

Do NOT use generic skeptic moves ("where's the data," "maintenance burden") — these could be aimed at anything. Every critique must be SPECIFIC to this synthesis and this domain.

If the synthesis is genuinely strong, say so and stop. "I found no structural flaws; the sublation is genuine" is a valid output. Aim for 500–1000 words.

Your audience is an LLM orchestrator. Be concise. No scene-setting, no performative hostility.
```

## Interpreting Results

| Outcome | Action |
|---------|--------|
| Both monks elevated | Sublation is valid — proceed to recursion |
| One monk defeated | Synthesis is biased — revise Phase 5 to better preserve defeated monk's core insight |
| Both monks defeated | Synthesis is compromise — return to Phase 4, look for deeper hidden question |
| Auditor proposes harder contradiction | This is the auditor's highest-value output — often becomes best recursion direction |
| Auditor finds hidden shared assumptions | Frequently the most valuable recursion target |
| Auditor flags compromise-as-transcendence | Return to Phase 5 — synthesis must change the *question*, not split the difference |
| Auditor produces generic skepticism | Discard it — if critiques could apply to any proposal, they're not engaging this synthesis |

## Refinement Process

Do not dump validation + auditor output on the user. Digest it, identify actionable improvements, present **one at a time**.

1. **Summarize feedback** in 2–3 sentences: what landed, what didn't, how many improvements you see.
2. **Present one improvement. Wait for response. Discuss. Resolve. Then present the next.** Users skim lists — sequential presentation produces actual engagement. Their response to Improvement 1 often changes how you frame Improvement 2.
3. **Revise the synthesis** with accepted improvements. This often clarifies which remaining tensions are genuine recursion targets vs. gaps in the original draft.
4. **Present recursion directions.** Remaining feedback — harder contradictions, unresolved tensions that can't be patched — becomes the Phase 7 menu.
