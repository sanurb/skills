# Interview Branch Probes

Lookup table of probe questions per branch. Read during Step 2 of prd-interview.

## B1: Success Criteria

- "How will we know this worked 30 days after launch?"
- "What metric would tell us this FAILED?"
- "Could a bad implementation still hit that metric?" → if yes, it's vanity — revise
- "What's the minimum behavior that counts as success?"

**Distinction check:** success metric vs vanity metric.

## B2: Scope Boundaries & Non-Goals

- "What is explicitly NOT in scope?"
- "What's the adjacent feature you're tempted to include?"
- "If we only had 2 weeks, what would you cut?"
- "Is this a constraint (can't change) or a preference (could change)?"
- "Does [stakeholder request] solve the user problem, or is it organizational pressure?"

**Distinction check:** scope boundary vs implementation prescription; requirement vs constraint; user problem vs stakeholder pressure.

## B3: Solution Approach

- "Is this what to achieve or how to achieve it?" → redirect solutions to outcomes
- "Could engineering find a better way if we only specified the outcome?"
- "What assumption are we making that could be wrong?"
- "What's the simplest version that solves the core problem?"
- "What would you try first to validate this in 3 days?"

**Distinction check:** requirement vs solution; requirement vs assumption.

## B4: Data Model & State

- "What's the source of truth for this data?"
- "What happens to existing data when this ships?"
- "Who else reads or writes this data?"
- "What if two users modify this simultaneously?"

## B5: Edge Cases & Failure Modes

- "What happens when [dependency] is down?"
- "What if the input is empty, malformed, or enormous?"
- "What does the user see when something goes wrong?"
- "What's the worst thing that could happen?"
- "What if the user starts this and abandons halfway?"

## B6: Non-Functional Requirements

For every adjective, demand a number:

| User says | Ask instead |
|-----------|-------------|
| "Fast" | "What response time, at what percentile, under what load?" |
| "Reliable" | "What uptime? What's acceptable degradation during failure?" |
| "Secure" | "Against which threats? What compliance framework?" |
| "Scalable" | "How many users/records/requests? Over what timeline?" |
| "Accessible" | "WCAG AA or AAA? Which assistive technologies?" |

## B7: Module Design & Testing

- "What are the major components we need to build or change?"
- "Which module hides the most complexity behind the simplest interface?"
- "Can this module be tested in isolation?"
- "Which modules do you want tests for?"
- "What existing test patterns in the codebase should we follow?"

## B8: Rollout & Measurement

- "Feature flag, A/B test, or full rollout?"
- "What analytics events need instrumentation?"
- "What's the rollback plan?"
- "Who reviews results post-launch, and when?"
