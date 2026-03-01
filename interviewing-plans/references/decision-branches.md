# Decision Branches

Canonical branch tree for dependency-ordered planning interviews.

## Dependency-Ordered Tree

Use these branch IDs in ledger updates and response contracts.

| Branch | Depends On | Must Resolve Before Closing |
|--------|------------|------------------------------|
| B0 Problem framing | - | Target outcome, user/problem owner, why now |
| B1 Success criteria | B0 | Measurable outcomes, failure threshold |
| B2 Constraints | B0 | Non-negotiables: time, budget, compliance, platform |
| B3 Stakeholders | B0 | Decision rights, approvers, impacted teams |
| B4 Domain boundaries | B0,B2,B3 | In-scope/out-of-scope boundaries, core entities |
| B5 Architecture shape | B1,B2,B4 | Chosen approach + rejected alternatives |
| B6 Interfaces/contracts | B4,B5 | API/events/schemas and compatibility assumptions |
| B7 Reliability/failure modes | B2,B5,B6 | SLO/SLA targets, fallback behavior, blast radius |
| B8 Security/privacy/compliance | B2,B4,B6 | Threat model, access controls, data handling rules |
| B9 Delivery/migration | B5,B6,B7,B8 | Rollout sequence, cutover, rollback conditions |
| B10 Verification strategy | B1,B6,B7,B8,B9 | Test plan, acceptance gates, observability checks |
| B11 Ownership/operations | B7,B8,B9 | On-call ownership, runbooks, handoff expectations |

## Traversal Algorithm

1. Select the lowest-depth `open` branch whose dependencies are all `decided`.
2. If multiple branches are eligible, pick highest risk.
3. Ask one branch question via `ask`.
4. Record decision and contradiction checks.
5. If contradiction detected, switch to RECONCILE and resolve before new branch.
6. Repeat until all branches are `decided`, `deferred`, or `out-of-scope`.

## Branch Interview Prompts

For each branch, ask at least one **decision-forcing** question and one **failure-oriented** question.

### B0 Problem framing

- Decision-forcing: “Which exact pain are we solving first?”
- Failure-oriented: “What happens if we do nothing for one release?”

### B1 Success criteria

- Decision-forcing: “Which metric defines success unambiguously?”
- Failure-oriented: “At what metric value do we call this a failure?”

### B2 Constraints

- Decision-forcing: “Which constraints are hard vs negotiable?”
- Failure-oriented: “Which constraint, if violated, causes immediate stop?”

### B3 Stakeholders

- Decision-forcing: “Who can approve design decisions?”
- Failure-oriented: “Who can block launch at the last minute?”

### B4 Domain boundaries

- Decision-forcing: “What is explicitly in scope for v1?”
- Failure-oriented: “Which adjacent domain is tempting but must be excluded?”

### B5 Architecture shape

- Decision-forcing: “Which architecture option do we commit to now?”
- Failure-oriented: “Where does this architecture fail under peak load or misuse?”

### B6 Interfaces/contracts

- Decision-forcing: “What contract is guaranteed to consumers?”
- Failure-oriented: “What breaks first if producer and consumer drift?”

### B7 Reliability/failure modes

- Decision-forcing: “Which reliability target is mandatory for launch?”
- Failure-oriented: “What is the first degraded mode and who gets paged?”

### B8 Security/privacy/compliance

- Decision-forcing: “Which control set is mandatory on day one?”
- Failure-oriented: “What is the worst credible abuse case?”

### B9 Delivery/migration

- Decision-forcing: “What is the exact cutover strategy?”
- Failure-oriented: “What rollback trigger and rollback path are predefined?”

### B10 Verification strategy

- Decision-forcing: “Which tests and checks are release-blocking?”
- Failure-oriented: “What behavior could still regress despite current tests?”

### B11 Ownership/operations

- Decision-forcing: “Who owns incidents and post-launch maintenance?”
- Failure-oriented: “What operational task currently has no clear owner?”

## Reconcile Checks (Run After Every Decision)

- New decision does not violate B2 constraints.
- New decision does not invalidate accepted success criteria (B1).
- Interface assumptions (B6) still match architecture choice (B5).
- Reliability (B7) and security (B8) remain supportable by delivery plan (B9).
- Verification (B10) can actually detect failure modes named in B7/B8.

## Completion Gate

Interview is complete only when:

- All branches have terminal status (`decided`, `deferred`, `out-of-scope`)
- Every deferred branch has owner + revisit trigger
- Remaining risk list is explicit and accepted by user
