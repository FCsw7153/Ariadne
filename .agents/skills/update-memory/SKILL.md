# Update Memory Skill

Use this skill to consolidate pending memory candidates into the correct long-term destination.

Update-memory is deliberate. It is different from memory capture:

- `memory-capture` records candidates in `.ai/memory/pending-memory.md` during work.
- `update-memory` reviews candidates and moves, accepts, rejects, or escalates them.

## Inputs

Read before consolidating:

- `.ai/memory/README.md`
- `.ai/memory/pending-memory.md`
- Relevant source task artifacts, if the candidate is task-sourced.
- Relevant `.ai/spec/`, `.ai/workflow.md`, or `AGENTS.md` sections if the suggested destination points there.

## Consolidation Gate

For each candidate, ask:

- Will this affect future tasks?
- Is it stable rather than temporary?
- Does it have a source or evidence?
- Is memory the right destination, or should this become spec/workflow/AGENTS?
- Would storing it reduce future confusion more than it adds noise?
- Does it duplicate an existing rule, memory, or spec?

## Destination Rules

Choose one destination:

| Destination | Use For |
| --- | --- |
| Keep in task | Temporary task details or one-off implementation notes |
| `recurring-decisions.md` | Stable preferences, repeated decisions, durable project direction |
| `known-pitfalls.md` | Reusable bug patterns, failure modes, gotchas |
| `.ai/spec/` | Authoritative architecture, contract, style, testing, or interface rules |
| `.ai/workflow.md` | Reusable workflow behavior |
| `AGENTS.md` | Short hard rules all agents must always follow |
| Reject/discard | Candidate is not reusable, stable, or useful |
| Keep pending | Candidate needs more evidence or source resolution |

## Authority Rules

Do not silently promote candidates to authoritative locations.

- Moving to `recurring-decisions.md` or `known-pitfalls.md` may be done when the evidence is clear and low-risk.
- Moving to `.ai/spec/`, `.ai/workflow.md`, or `AGENTS.md` should be proposed to the main agent/user when it changes project behavior.
- If a candidate conflicts with existing rules, stop and ask.
- If source is ambiguous, ask or keep it pending with `needs-source-resolution`.

## Process

1. Group candidates by status and source.
2. Resolve obvious duplicates.
3. For each candidate, choose destination or keep pending.
4. Move accepted content into the destination file with source and date.
5. Update `pending-memory.md` status and `Consolidation Log`.
6. Report what moved, what stayed pending, what was rejected, and what needs user decision.

## Output

Return:

- Candidates processed.
- Candidates moved and destinations.
- Candidates kept pending and why.
- Candidates rejected and why.
- User decisions needed.
- Files changed.

## Stop Rules

Stop and ask before changing authoritative behavior when:

- The candidate belongs in `AGENTS.md`, `.ai/workflow.md`, or `.ai/spec/` but changes obligations.
- Evidence is weak or source is unresolved.
- The candidate contradicts existing memory/spec/rules.
- The candidate includes sensitive information.
