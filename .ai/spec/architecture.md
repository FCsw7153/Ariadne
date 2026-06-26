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
