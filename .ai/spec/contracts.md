# Contracts Spec

Authoritative contracts and invariants belong here.

## Sub-Agent Return Contract

- Rule: Sub-agents should return decision-grade artifacts, not only chat summaries.
- Rationale: Main agents need readset, facts, evidence, risks, and decisions needed to make safe choices.
- Applies to: sub-agent handoffs, reports, task workspace evidence.
- Source: agent delegation protocol.
- Verification: Handoff/report templates include required return fields.

## Pending Memory Contract

- Rule: Memory candidates are captured in `pending-memory.md` before promotion to long-term memory, spec, workflow, or hard rules.
- Rationale: This prevents memory from becoming a junk drawer or unauthorized authority layer.
- Applies to: memory-capture, update-memory, pending-memory.
- Source: memory design.
- Verification: Memory-capture writes only pending candidates unless explicitly authorized otherwise.

## Active Task State Contract

- Rule: `.ai/state/current-task` stores the repo-relative active task workspace path when a Level 2/3 task is active.
- Rationale: Hooks and scripts need a deterministic pointer that does not depend on chat memory.
- Applies to: hooks, scripts, workflow-state injection, compact recovery.
- Source: Ariadne Guardrails v1.
- Verification: `ariadne-task.sh current` and `inject-workflow-state.py` read the same pointer.

## No-Interrupt Sub-Agent Contract

- Rule: Sub-agents are not interrupted by default; interruptions require an allowed reason and a task-artifact log entry.
- Rationale: Interrupting sub-agents destroys context isolation and has caused Ariadne workers to lose useful progress.
- Applies to: sub-agent handoffs, reports, task artifacts, workflow.
- Source: Ariadne Guardrails v1.
- Verification: Task templates include an Interrupt Log and delegation docs describe allowed interrupt reasons.

## Template Hash Update Contract

- Rule: `.ai/ariadne-template-hashes.json` records hashes only for Ariadne-managed template files that currently match installed template content.
- Rationale: Updates need a deterministic way to auto-update unmodified files while preserving user modifications and deletions.
- Applies to: init, update, doctor, managed scripts/hooks/skills/templates/workflow docs.
- Source: Ariadne update mechanism.
- Verification: `ariadne-update.sh` reports and handles new, unchanged, auto-update, modified, and user-deleted files separately.
