# domain-model — Eval Scenarios

Five scenarios. Score each criterion 0/1, sum to 0–10 (each scenario weights criteria so total ≤ 10).

## S1 — Glossary conflict (core capability: challenge moves)

**Setup.** Repo has `CONTEXT.md` defining `Order = customer's request to purchase items`. User says: *"When a user submits a purchase, we should kick off the fulfillment immediately."*

**Expected behavior.**
- (a) Surfaces the term collision: `purchase` vs `Order`, `user` vs `Customer`.
- (b) Asks ONE question, waits.
- (c) Recommends a canonical answer.
- (d) Does NOT update `CONTEXT.md` until the user resolves.

**Score (10 pts).** Conflict surfaced (3) · single question (2) · recommendation given (2) · no premature write (3).

## S2 — ADR triggers (core capability: persistence gating)

**Setup.** During interview, user says: *"Let's switch from REST to gRPC between Ordering and Billing because it's faster."*

**Expected behavior.**
- Evaluates the THREE ADR triggers (hard-to-reverse, surprising-without-context, real trade-off).
- States explicitly which triggers hold.
- Creates `docs/adr/0001-*.md` ONLY if all three pass.
- Refuses to create an ADR for trivial/easily-reversible decisions in a follow-up probe (*"we'll use snake_case for filenames"*).

**Score (10 pts).** Triggers enumerated (3) · trigger evaluation correct (3) · ADR created/refused correctly across both probes (4).

## S3 — Multi-context routing (core capability: artifact selection)

**Setup.** Repo has `CONTEXT-MAP.md` listing `ordering`, `billing`, `fulfillment`. User says: *"`OrderPlaced` should also notify Billing for invoice pre-allocation."*

**Expected behavior.**
- Reads `CONTEXT-MAP.md` first.
- Identifies this changes a context relationship → updates `CONTEXT-MAP.md` (not the per-context files).
- Uses `→` direction marker, names the integration mechanism (event).
- If a new shared term appears (`InvoicePreAllocation`), routes it to `src/billing/CONTEXT.md`, NOT root.

**Score (10 pts).** Reads map first (2) · routes relationship update to map (3) · uses correct schema (2) · routes term to correct per-context file (3).

## S4 — Stress: omission-prone footer (core capability: file output discipline)

**Setup.** End of a 30-minute interview session. Three terms resolved, one ADR-eligible decision, no relationship change. Session is wrapping up.

**Expected behavior.**
- Returns the footer block exactly:
  ```
  CONTEXT_FILES_TOUCHED: <paths>
  ADRS_CREATED: <paths>
  OPEN_QUESTIONS: <list or "none">
  ```
- Lists every file mutated (no omissions, no extras).
- Does NOT skip the footer when "OPEN_QUESTIONS" is "none".

**Score (10 pts).** Footer present (3) · all three keys present (3) · accurate file list (2) · `none` used correctly (2).

## S5 — Noisy context (cross-cutting robustness)

**Setup.** Long conversation: 6 unrelated TypeScript fixes, a Tailwind class debate, a screenshot review, then user says *"by the way let's also lock in our retry strategy as a domain decision."*

**Expected behavior.**
- Recognises **retry strategy** as a general programming concept, NOT a domain term.
- Refuses to add it to `CONTEXT.md` (rule: only domain-specific terms).
- Evaluates ADR triggers — may produce an ADR if all three hold, otherwise refuses both.
- Stays on-task: ignores the prior unrelated chatter.

**Score (10 pts).** Term refused for `CONTEXT.md` (4) · ADR triggers evaluated (3) · explanation given to user (3).

## Scoring Rubric

| Total | Verdict |
|-------|---------|
| 9–10  | Strong activation |
| 7–8   | Acceptable |
| 4–6   | Weak — apply activation-design.md |
| 0–3   | Broken — split or rebuild |
