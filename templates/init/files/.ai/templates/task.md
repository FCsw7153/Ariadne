# Task: <short-title>

Use this as the default single-file task artifact for Level 2 work and as the starting index for Level 3 work.

Keep it concise. This file is a decision and recovery aid, not a transcript.

## Routing

- Level: 2 | 3
- Path: Spec Path | Deep Path
- Created: YYYY-MM-DD
- Status: planning | in-progress | blocked | verifying | complete | deferred
- Owner: main agent | sub-agent role | human
- User override: none | fast path | no sub-agents | use sub-agents | skip artifacts | other

## Intent

What is the user trying to accomplish?

- 

## Success Criteria

What must be true for this task to be accepted?

- 

## Non-Goals

What should explicitly not be done?

- 

## Constraints

Hard requirements, compatibility rules, project conventions, or safety limits.

- 

## Open Questions

Only include questions that can change scope, implementation, risk, or acceptance.

- [ ] 

## Baseline Readset

Files, docs, tests, specs, logs, or external references read before implementation.

| Source | Why It Matters | Notes |
| --- | --- | --- |
|  |  |  |

## Working Spec

Compact implementation contract. Write enough for a future agent to continue safely.

### Requirements

- 

### Expected Behavior

- 

### Edge Cases

- 

### Interfaces / Contracts

- 

## Plan

Small, ordered steps. Update when the plan changes materially.

- [ ] 

## Sub-Agent Handoffs

Use this section when delegation happens. Link to separate artifacts if the task grows.

| Role | Goal | Artifact / Output | Status |
| --- | --- | --- | --- |
|  |  |  |  |

Required return shape:

- Scope completed.
- Files/sources read.
- Key facts.
- Changes made or findings produced.
- Evidence collected.
- Residual risks.
- Decisions needed.

## Decisions

Record decisions that affect implementation, scope, verification, or future maintenance.

| Decision | Rationale | Decided By | Date |
| --- | --- | --- | --- |
|  |  |  |  |

## Implementation Notes

Concise notes about what changed and why. Avoid dumping raw diffs.

- 

## Verification Evidence

Do not claim completion without fresh evidence.

| Check | Command / Method | Result | Notes |
| --- | --- | --- | --- |
|  |  |  |  |

## Changed Files

| File | Purpose |
| --- | --- |
|  |  |

## Residual Risks

Known limitations, skipped checks, uncertainty, or follow-up work.

- 

## Closure

Do not silently mark the task complete. When the agent believes the task is done, summarize evidence and ask the user how to close it.

- Agent completion assessment: not-ready | ready-for-user-confirmation | confirmed-complete
- User closure decision: pending | complete-and-archive | complete-keep | keep-in-progress | defer
- Closure evidence summary:
  - 
- Follow-up separated from completed scope:
  - 

## Memory / Spec Candidates

Only list information likely to matter for future tasks. These candidates should be captured in `.ai/memory/pending-memory.md`, usually by the main agent or a memory-capture sub-agent.

- 

## Level 3 Split Artifacts

For Level 3 tasks, split this file when the sections become too large.

Suggested files:

- `intent.md`
- `questions.md`
- `spec.md`
- `plan.md`
- `decisions.md`
- `baseline-readset.md`
- `checkpoints.md`
- `evidence.md`
- `verification.md`
- `retirement.md` for bugfix or replacement work
