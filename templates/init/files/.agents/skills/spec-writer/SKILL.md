# Spec Writer Skill

Use this skill for Level 2 and Level 3 tasks that need an implementation contract.

A spec is not a product essay. It is a compact agreement about what to build, what not to build, what constraints apply, and how completion will be verified.

## When To Use

Use for:

- Level 2 tasks with non-obvious acceptance criteria.
- Level 3 tasks by default.
- Sub-agent implementation handoffs.
- Multi-file behavior changes.
- Refactors with compatibility constraints.
- Bugfixes where root cause and regression prevention matter.

Usually skip for:

- Level 0 discussion.
- Level 1 small fixes.
- Tasks where a short plan is enough and no handoff is needed.

## Inputs

Read or gather:

- Goal frame.
- Clarification answers and decisions.
- Baseline readset.
- Existing project specs or conventions.
- User constraints and non-goals.
- Acceptance criteria.
- Verification expectations.
- Sub-agent handoff needs.

## Spec Depth

Match spec depth to workflow level.

| Level | Spec Shape |
| --- | --- |
| Level 1 | No spec by default |
| Level 2 | Compact spec in `task.md` or `spec.md` |
| Level 3 | Dedicated `spec.md`, often with `decisions.md` and `baseline-readset.md` |

## Output Sections

A useful implementation spec includes:

- Problem statement.
- Goals.
- Non-goals.
- User-visible behavior.
- Requirements.
- Constraints.
- Interfaces/contracts affected.
- Baseline facts.
- Implementation approach.
- Sub-agent boundaries, if delegation is planned.
- Acceptance criteria.
- Verification plan.
- Residual risks and open questions.

## Compact Spec Template

```markdown
# Spec: <short title>

## Problem

## Goals

## Non-Goals

## Requirements

## Constraints

## Existing Baseline

## Proposed Approach

## Sub-Agent Boundaries

## Acceptance Criteria

## Verification Plan

## Open Questions / Risks
```

## Writing Rules

- Write only what constrains implementation or verification.
- Prefer bullets over prose when possible.
- Separate confirmed decisions from assumptions.
- Keep non-goals explicit.
- Link or cite task artifacts instead of duplicating large content.
- Do not invent requirements.
- Do not hide uncertainty; mark it as open question or risk.

## Acceptance Criteria

Acceptance criteria should be observable and verifiable.

Good criteria:

- Describe behavior or artifact state.
- Can be checked with tests, commands, review, or manual scenario.
- Cover edge cases when relevant.
- Distinguish required from optional.

Avoid:

- "Works well."
- "Looks good."
- "Refactor cleanly."
- "No bugs."

## Sub-Agent Ready Spec

Before handing to an implementation sub-agent, ensure the spec includes:

- Goal and non-goals.
- Allowed and forbidden edit areas.
- Relevant baseline readset.
- Decisions already made.
- Acceptance criteria.
- Verification expectations.
- Stop rules for unapproved decisions.

If these are missing, do not delegate implementation yet.

## Bugfix / Retirement Additions

For persistent bugs or replacement work, add:

- Observed failure.
- Root-cause hypothesis.
- Canonical owner of the behavior.
- Old logic or fallback to retire.
- Regression test or detection strategy.
- Evidence that the fix is not only a patch on top of stale behavior.

## Task Artifact Update

For Level 2:

- Add compact spec content to `task.md` under `Working Spec`, or create `spec.md` if it improves clarity.

For Level 3:

- Prefer `spec.md` plus supporting `decisions.md` and `baseline-readset.md` when useful.

## Output Format

```text
Spec Writer Output
- Spec path: <path or inline>
- Scope: <confirmed scope>
- Non-goals: <important exclusions>
- Acceptance criteria: <summary>
- Verification plan: <summary>
- Open questions: <none or list>
- Ready for implementation: yes | no — <reason>
- Ready for sub-agent handoff: yes | no — <reason>
```

## Stop Rules

Stop and ask or keep spec in draft when:

- Requirements are contradictory.
- Acceptance criteria cannot be defined.
- A product, architecture, or safety decision is missing.
- Baseline facts contradict the intended plan.
- The spec would authorize edits beyond the user's requested scope.
