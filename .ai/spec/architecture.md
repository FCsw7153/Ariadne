# Architecture Spec

Authoritative architecture constraints belong here.

## Ariadne Shape

- Rule: Ariadne is a method pack, not an agent runtime or heavy platform.
- Rationale: The framework should remain portable across coding agents and host environments.
- Applies to: workflow, skills, templates, adapters, hooks.
- Source: project positioning.
- Verification: New docs or automation should not require one specific sub-agent runtime.

## Progressive Depth

- Rule: Small tasks should stay light; complex tasks should escalate through task workspaces, evidence, memory, and delegation when useful.
- Rationale: The framework should improve reliability without slowing trivial work.
- Applies to: workflow, task-router, task templates, README.
- Source: Ariadne workflow.
- Verification: Level 0/1 paths do not require task artifacts by default.

## Required Guardrail Hooks

- Rule: Complete Ariadne installations require deterministic hooks or an equivalent host injection mechanism for workflow-state reminders and compact recovery.
- Rationale: Workflow rules are too easy for agents to forget without per-turn state injection and pre-compact checkpoints.
- Applies to: AGENTS.md, workflow, hooks, scripts, init templates.
- Source: Ariadne Guardrails v1.
- Verification: `ariadne-doctor.sh` checks required hook and workflow-state files.

## Safe Template Updates

- Rule: Ariadne init installs missing framework files, while update refreshes managed files using version/hash metadata.
- Rationale: Framework rules evolve, but initialized projects may contain user edits and runtime data that must not be overwritten blindly.
- Applies to: `scripts/init.sh`, `scripts/update.sh`, `.ai/scripts/ariadne-update.sh`, init templates, doctor.
- Source: Ariadne update mechanism.
- Verification: Update dry-run and fixture scenarios distinguish new, unmodified, modified, deleted, and protected files.
