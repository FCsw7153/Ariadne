# Baseline First Skill

Use this skill before meaningful implementation work.

Baseline-first prevents assumption-driven coding. It establishes the smallest useful set of project facts before changing files or delegating implementation.

## Purpose

- Understand existing patterns before editing.
- Identify constraints, contracts, and tests.
- Choose the right workflow depth.
- Produce a baseline readset that future agents can trust.
- Avoid polluting context with unnecessary full-repo reading.

## When To Use

Use for:

- Level 2 and Level 3 tasks.
- Multi-file changes.
- Behavior changes.
- Refactors.
- Bugfixes requiring root-cause understanding.
- Sub-agent handoffs.
- Tasks where the agent is tempted to implement from assumptions.

Usually skip for:

- Level 0 discussion.
- Level 1 typo or tiny docs fixes.
- Pure naming or positioning conversation.

## Readset Levels

Choose the smallest readset that can prevent wrong work.

| Readset | Use For | Typical Sources |
| --- | --- | --- |
| none | Pure discussion or user-provided answer is enough | No files |
| minimal | Level 1 or obvious local work | 1-2 nearby files |
| focused | Level 2 implementation | Related code, tests, docs, configs, existing patterns |
| broad | Level 3 or high-risk work | Architecture docs, specs, multiple packages, logs, prior tasks, external references |

## Selection Heuristics

Start with likely entry points:

- Files named by the user.
- Existing task/spec/plan artifacts.
- Tests covering the behavior.
- Callers and callees of touched code.
- Nearby examples using the same pattern.
- Configuration or contracts that govern the behavior.
- Relevant docs or project specs.

Expand only when:

- The first files reveal a wider dependency.
- Existing behavior is unclear.
- Tests/contracts imply hidden constraints.
- The task touches architecture, data, security, or deployment.
- A sub-agent needs a reliable handoff.

## What To Capture

Record decision-grade context, not raw dumps.

Capture:

- Files/sources read.
- Why each source matters.
- Existing patterns to follow.
- Constraints or contracts discovered.
- Tests or checks relevant to the change.
- Unknowns that still matter.
- Risks that should affect the plan.

## Output Format

```text
Baseline Readset
- Level: none | minimal | focused | broad
- Sources read:
  - <path/source>: <why it matters>
- Existing patterns:
  - <pattern>
- Constraints discovered:
  - <constraint>
- Relevant checks:
  - <test/command/manual check>
- Unknowns:
  - <unknown or none>
- Risk impact:
  - <how this changes the plan or level>
```

## Task Artifact Update

For Level 2 tasks, record the baseline readset in `task.md` when it improves handoff or recovery.

For Level 3 tasks, record it by default in:

- `task.md` under `Baseline Readset`, or
- `baseline-readset.md` if the readset is large.

## Sub-Agent Handoff

Before sending an implementation sub-agent, provide enough baseline context for safe execution:

- Task/spec/plan paths.
- Relevant project patterns.
- Constraints and forbidden areas.
- Files likely involved.
- Validation expectations.

Do not overload the worker with raw context. Provide paths and decision-grade summaries.

## Stop Rules

Stop and ask or re-route when:

- The baseline reveals unclear product behavior.
- Required files/specs are missing.
- The task appears higher-risk than originally classified.
- The readset expands beyond the expected scope.
- Existing code contradicts the user's requested direction.
