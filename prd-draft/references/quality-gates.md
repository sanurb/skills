# Quality Gates

Run against every PRD draft before publishing. Two severity levels: blockers stop the publish, warnings are flagged to the user.

## Blockers — Must Fix

| # | Check | Fail Signal |
|---|-------|-------------|
| 1 | Problem-first | First section describes a feature, not a user problem |
| 2 | Requirement traceability | A requirement can't be traced to a user problem |
| 3 | Metric falsifiability | A success metric can't be determined pass/fail post-launch |
| 4 | Vanity metric | A bad implementation would still hit the metric |
| 5 | Non-goals exist | Fewer than 2 explicit exclusions |
| 6 | Edge cases exist | Fewer than 3 failure/degradation scenarios |
| 7 | NFR specificity | Any NFR uses adjective without number ("fast", "reliable") |
| 8 | Solution disguise | A requirement prescribes HOW instead of WHAT |
| 9 | Assumption encoding | An unvalidated belief is stated as a decided fact |
| 10 | Open question ownership | A TBD has no owner or deadline |

## Warnings — Flag to User

| # | Check | Fail Signal |
|---|-------|-------------|
| 1 | Rejected alternatives | No "considered but rejected" decisions documented |
| 2 | Rollout plan | Missing deployment strategy |
| 3 | Measurement plan | No analytics instrumentation specified |
| 4 | Assumption labeling | Assumptions section exists but < 2 entries |
| 5 | Stakeholder coverage | Only one stakeholder perspective represented |

## The Engineer Test

Before publishing, verify a strong engineer could:

1. Explain WHY this feature exists (from the PRD alone)
2. Make implementation tradeoffs without asking the PM
3. Know what's out of scope without guessing
4. Write tests from the acceptance criteria
5. Handle failure modes without inventing behavior

If any answer is "no", the PRD has a gap. Fix it.
