---
name: memory-capture
description: Capture reusable project knowledge candidates into pending memory during Level 2/3 work. Use when stable preferences, recurring pitfalls, workflow rules, task decisions, or sub-agent memory candidates appear.
---

# Memory Capture Skill

Use this skill when the agent notices information that may be useful for future tasks while continuing the current work.

Memory capture is real-time and low-friction. It writes candidates to `.ai/memory/pending-memory.md`; it does not directly update long-term memory, specs, workflow, or `AGENTS.md`.

## When To Use

Use memory capture when one of these appears:

- The user states a stable preference or project principle.
- A workflow rule emerges from discussion or implementation.
- A recurring pitfall, bug pattern, or agent failure mode is discovered.
- A sub-agent report includes memory/spec candidates.
- A checkpoint includes recovery information likely to matter later.
- A task decision may affect future tasks.

Do not capture:

- One-off implementation details.
- Temporary task status.
- Raw transcript content.
- Information already recorded in the correct long-term destination.
- Candidates with no plausible future value.

## Recommended Delegation

When the main agent is busy planning, implementing, or talking with the user, it may delegate memory capture to a memory sub-agent.

The memory sub-agent should:

- Receive only the candidate, source information, and suggested destination.
- Write only to `.ai/memory/pending-memory.md`.
- Avoid modifying `.ai/spec/`, `.ai/workflow.md`, `AGENTS.md`, or accepted memory files.
- Deduplicate against existing pending candidates.
- Preserve source task/path/confidence when known.
- Put ambiguous candidates in `Inbox` with `Status: needs-source-resolution` instead of guessing.

## Source Routing

Resolve source in this order:

1. Explicit source task from a handoff, report, artifact, or user statement.
2. Explicit source artifact path under `.ai/tasks/`.
3. User-provided task context.
4. High-confidence single-task context from the main agent.
5. Otherwise, `Inbox` with `needs-source-resolution`.

Ask the user when source assignment matters and cannot be inferred safely.

## Capture Format

Append a candidate using the structure in `.ai/memory/pending-memory.md`.

Required fields:

- Source type.
- Source task.
- Source path.
- Source confidence.
- Candidate memory.
- Why it may matter later.
- Suggested destination.
- Status.

## Output

After capture, report briefly:

- Whether a candidate was added, updated, or skipped.
- Where it was placed: `Inbox` or a task group.
- Any unresolved source questions.

## Stop Rules

Stop and report instead of writing when:

- The candidate contains secrets or sensitive data that should not be persisted.
- The destination would require modifying authoritative files.
- Source assignment is critical but ambiguous and the user must decide now.
