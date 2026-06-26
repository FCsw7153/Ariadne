# Memory

Ariadne memory is a stable experience layer that helps future agents recover judgment faster.

Memory is not chat history, not a transcript, and not the highest authority. It should contain reusable knowledge that survives individual tasks and helps future work.

## Knowledge Layers

```text
AGENTS.md
= short hard rules and entry gates

.ai/spec/
= authoritative project facts, architecture constraints, contracts, and conventions

.ai/tasks/
= concrete task context, decisions, plans, evidence, sub-agent reports, and closure state

.ai/memory/
= cross-task reusable experience, preferences, recurring decisions, and known pitfalls

.ai/memory/pending-memory.md
= real-time candidate memory inbox before consolidation
```

## Core Rule

Capture candidates early, consolidate later.

During conversation, implementation, review, checkpoints, or sub-agent work, useful future knowledge should first go to `pending-memory.md`. Long-term memory, specs, workflow files, or `AGENTS.md` should only be updated through a deliberate consolidation pass.

## Real-Time Capture

Memory candidates may appear while the main task is still active.

Examples:

- The user states a stable preference.
- A workflow rule emerges from discussion.
- A recurring bug pattern or project pitfall is discovered.
- A sub-agent report identifies a durable memory/spec candidate.
- A checkpoint reveals context that future sessions need.
- A task decision is likely to affect future tasks.

The main agent may delegate memory capture to a memory sub-agent so the main session can continue planning, implementing, or talking with the user.

## Memory Sub-Agent Rule

A memory-capture sub-agent should write only to `pending-memory.md` unless explicitly authorized otherwise.

It should not directly update:

- `AGENTS.md`
- `.ai/spec/`
- `.ai/workflow.md`
- Long-term memory files such as `recurring-decisions.md` or `known-pitfalls.md`

Those destinations require consolidation and main-agent or user acceptance.

## Pending Memory Structure

`pending-memory.md` has two major areas:

- `Inbox`: candidates with no task source, unclear task source, or pure conversation source.
- `Task-Sourced Candidates`: candidates grouped by explicit source task.

Do not attach a candidate to a task by guessing. Use explicit source information when available.

## Source Resolution

Resolve candidate source in this order:

1. Explicit source task from a handoff, report, artifact, or user statement.
2. Explicit source artifact path that belongs to a task workspace.
3. User-provided task context.
4. High-confidence single-task context from the main agent.
5. Otherwise, put the candidate in `Inbox` with `Status: needs-source-resolution`.

If source assignment matters and is unclear, ask the user instead of guessing.

## Consolidation Destinations

When consolidating pending memory, choose one destination:

| Destination | Use For |
| --- | --- |
| Keep in task | Temporary task details or one-off implementation notes |
| `recurring-decisions.md` | Stable preferences, repeated decisions, and durable project direction |
| `known-pitfalls.md` | Reusable bug patterns, failure modes, and gotchas |
| `.ai/spec/` | Authoritative architecture, contract, style, testing, or interface rules |
| `.ai/workflow.md` | Reusable workflow behavior |
| `AGENTS.md` | Short hard rules all agents must always follow |
| Reject/discard | Candidate is not reusable, stable, or useful |

## Consolidation Gate

Before moving a candidate out of pending memory, ask:

- Will this affect future tasks?
- Is it stable rather than temporary?
- Does it have a source or evidence?
- Is memory the right destination, or should this become spec/workflow/AGENTS?
- Would storing it reduce future confusion more than it adds noise?

## Files

- `project-summary.md` — short durable project overview.
- `pending-memory.md` — real-time memory candidate inbox.
- `recurring-decisions.md` — accepted cross-task decisions and preferences.
- `known-pitfalls.md` — accepted recurring risks, bug patterns, and gotchas.
