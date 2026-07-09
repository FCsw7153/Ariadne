# Sub-Agent Handoff: <role> / <short-scope>

Use this template when the main agent delegates focused work to a sub-agent.

The handoff should be compact and concrete. Give the worker enough context to act safely, but do not dump the whole conversation.

## Role

Research | Implementation | Review | Verification | Documentation | Memory / Spec | Other

## Goal

What outcome should the sub-agent produce?

- 

## Non-Goals

What should the sub-agent explicitly avoid?

- 

## Task Context

- Task workspace: `.ai/tasks/<date>-<short-name>/`
- Primary task file: `.ai/tasks/<date>-<short-name>/task.md`
- Related artifacts:
  - 

## Relevant Decisions

Decisions already made by the user or main agent that the sub-agent must follow.

- 

## Scope

Files, packages, features, docs, logs, or concepts likely involved.

- 

## Allowed Edits

For read-only roles, write `none`.

- 

## Forbidden Edits

Areas the sub-agent must not change.

- 

## Baseline Read Requirements

Files or artifacts the sub-agent should read before acting.

- 

## Validation Expectations

Commands, tests, manual checks, or review criteria expected from the sub-agent.

- 

## Coordination Rules

- The main agent should wait for this sub-agent to complete or queue non-urgent messages.
- The main agent should not interrupt this sub-agent for status checks, impatience, minor clarifications, or low-priority hints.
- For pi sub-agents, do not pass `timeoutMs` or `maxRuntimeMs` unless the user explicitly requests a foreground runtime limit; prefer `async: true`, status checks, queued messages, and needs-attention signals.
- Interrupt is allowed only for explicit user redirect, harmful off-scope work, wrong handoff context, unsafe/destructive behavior, or resource control.
- If interrupted, the main agent must record reason, evidence, replacement instruction, affected agent, and follow-up action in the task artifact.

## Output Requirements

The sub-agent must return decision-grade output with:

- Scope completed.
- Files/sources read.
- Key facts.
- Changes made or findings produced.
- Commands/checks run.
- Evidence and artifact paths.
- Residual risks.
- Decisions needed.
- Recommendation.

## Artifact Destination

Where should the sub-agent write or reference its output?

- Report path: `.ai/tasks/<date>-<short-name>/reports/<role>-report.md`
- Additional artifacts:
  - 

## Stop Rules

Stop and report instead of guessing when:

- Required context is missing.
- The task requires an unapproved product, architecture, or scope decision.
- Validation fails in a way that changes the plan.
- The requested change would touch forbidden areas.
- The sub-agent cannot produce meaningful evidence.
- You are asked to continue after an interrupt but the replacement instruction conflicts with this handoff.

## Final Instruction

Stay within scope. Return evidence, risks, and decisions needed. Do not claim final task completion; the main agent owns final acceptance.
