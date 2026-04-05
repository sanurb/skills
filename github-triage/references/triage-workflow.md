# Triage Workflow

Take a single issue from unexamined to a resolved state with maintainer approval.

## Step 1: Gather Context

Before presenting anything to the maintainer:

1. Read the full issue: body, all comments, all labels, reporter, timestamps.
2. Parse prior triage notes comments (from previous sessions) — understand what has been established.
3. Explore the codebase: domain, relevant interfaces, existing behavior related to the issue.
4. Read `.out-of-scope/*.md` files. Check if this issue matches a previously rejected concept.

## Step 2: Present Recommendation

Tell the maintainer:

- **Category:** bug or enhancement, with reasoning.
- **State:** where this issue should go, with reasoning.
- **Out-of-scope match:** if it matches a prior rejection, surface it: "This is similar to `.out-of-scope/concept-name.md` — we rejected this before because X. Do you still feel the same way?"
- **Codebase findings:** brief summary of what is relevant.

Wait for the maintainer's direction. They may:
- Agree → apply labels
- Want to flesh it out → start grilling session
- Override with a different state → apply their choice

## Step 3: Resolve

Depending on the outcome, produce the correct artifact. Show a **preview** of exactly what will be posted and which labels will be applied/removed. Only proceed on confirmation.

| Outcome | Action |
|---------|--------|
| `ready-for-agent` | Post agent brief (see [agent-brief.md](agent-brief.md), template: `assets/agent-brief-template.md`) |
| `ready-for-human` | Post human brief — same structure as agent brief but note why it cannot be delegated |
| `needs-info` | Post triage notes (template: `assets/needs-info-template.md`) capturing all progress |
| `wontfix` (bug) | Post polite explanation, close issue |
| `wontfix` (enhancement) | Write `.out-of-scope/` file (see [out-of-scope.md](out-of-scope.md)), post comment, close |
| `needs-triage` | Apply label. If partial progress exists, capture it in a comment. |

## Bug Reproduction (bugs only)

Before starting a grilling session for bugs, attempt reproduction:

1. Read the reporter's reproduction steps.
2. Explore relevant code paths.
3. Attempt to reproduce: run tests, execute commands, trace logic.
4. Report results to the maintainer:
   - **Reproduced:** specific behavior observed + where in the code it originates.
   - **Not reproduced:** may be environment-specific, already fixed, or report is inaccurate.
   - **Insufficient detail:** strong signal for `needs-info`.

Reproduction findings inform the grilling session and strengthen the agent brief.

## Grilling Session

If the issue needs fleshing out before it is ready for an agent, interview the maintainer:

- Ask questions one at a time.
- Provide a recommended answer for each question.
- If a question can be answered by codebase exploration, explore instead of asking.
- If prior triage notes exist, resume from where they left off — never re-ask resolved questions.
- For bugs: use reproduction findings to ask targeted questions ("I confirmed this happens because X — should the fix be Y or Z?").

Continue until all of these are established:
- Clear summary of desired behavior
- Concrete acceptance criteria
- Key interfaces that may change
- Explicit out-of-scope boundary

## Resuming Previous Sessions

When an issue already has triage notes:

1. Read all comments to find prior triage notes.
2. Parse what was established.
3. Check if the reporter has answered outstanding questions.
4. Present the maintainer with an updated picture: "Here's where we left off, and here's what the reporter has said since."
5. Continue from where it stopped.
