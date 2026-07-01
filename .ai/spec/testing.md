# Testing And Verification Spec

Durable verification expectations belong here.

## Evidence Before Completion

- Rule: Agents must not claim completion without fresh evidence appropriate to task level and risk.
- Rationale: AI coding frequently fails by overclaiming unverified work.
- Applies to: verification skill, task closure, sub-agent reports, final summaries.
- Source: Ariadne workflow and verification skill.
- Verification: Level 2/3 tasks record verification evidence and residual risks before closure.

## User-Confirmed Task Closure

- Rule: Level 2/3 task workspaces should not be silently marked complete or archived by the agent.
- Rationale: The user owns final task closure, especially when multiple tasks may be active.
- Applies to: tasks README, task template, verification skill.
- Source: task closure protocol.
- Verification: Agent presents evidence and closure options before changing closure status.

## Guardrail Script Verification

- Rule: Changes to Ariadne hooks or scripts should run syntax checks and targeted behavior checks.
- Rationale: Hooks are required for complete installs and failures can silently degrade workflow safety.
- Applies to: `.ai/hooks/`, `.ai/scripts/`, init templates.
- Source: Ariadne Guardrails v1.
- Verification: Run `bash -n` on shell scripts, `python3 -m py_compile` on hooks, and focused simulations for workflow-state, checkpoint, restore, and task validation.

## Update Script Verification

- Rule: Changes to Ariadne init/update behavior should test fresh installs, update dry-runs, auto-updates, modified-file preservation, user-deleted preservation, and protected path behavior.
- Rationale: The update mechanism is allowed to write many framework files and must prove it does not erase project data or local customizations.
- Applies to: `scripts/init.sh`, `scripts/update.sh`, `.ai/scripts/ariadne-update.sh`, doctor, init templates.
- Source: Ariadne update mechanism.
- Verification: Use temporary target directories and inspect update output plus resulting files/hash manifests.
