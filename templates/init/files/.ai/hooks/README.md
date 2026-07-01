# Hooks

Hooks are Ariadne's required deterministic guardrail layer for complete
installations.

Ariadne still keeps its core platform-neutral: hosts may wire these scripts
through native hooks, commands, prompts, or another equivalent injection
mechanism. If a host has no hook-like mechanism, Ariadne runs in degraded mode
and the agent must say so before Level 2/3 work.

## Required Hooks

| Hook | Purpose | Script |
| --- | --- | --- |
| workflow-state injection | Print the active task and current workflow state every turn | `.ai/hooks/inject-workflow-state.py` |
| pre-compact save | Save a task checkpoint before context compression and add a pending-memory candidate | `.ai/hooks/pre-compact-save.py` |
| post-compact restore | Restore active task and latest checkpoint after context compression | `.ai/hooks/post-compact-restore.py` |

## Script Contracts

### `inject-workflow-state.py`

- Reads `.ai/state/current-task`.
- Reads the task status from `task.md`.
- Parses `[workflow-state:<status>]` blocks from `.ai/workflow.md`.
- Prints a compact `<workflow-state>` block.
- Does not write files.

### `pre-compact-save.py`

- Reads the active task pointer.
- Writes `.ai/tasks/<task>/checkpoints/compact-YYYYMMDD-HHMMSS.md`.
- Appends a task-sourced candidate to `.ai/memory/pending-memory.md`.
- Does not promote memory, archive tasks, commit files, or edit implementation code.

### `post-compact-restore.py`

- Reads the active task pointer.
- Reads the latest compact checkpoint if present.
- Prints a compact `<ariadne-compact-restore>` block.
- Does not write files.

## Degraded Mode

If hooks cannot run, the agent must:

- State that Ariadne is running in degraded mode.
- Use `.ai/scripts/ariadne-task.sh current`, `checkpoint`, and `validate`
  manually when relevant.
- Record the residual risk in the task artifact.

## Rules

- Hooks may enforce deterministic guardrails, but strategic decisions remain
  with the main agent and user.
- Hooks must not perform product reasoning.
- Hooks must not auto-commit, auto-archive, or rewrite git history.
- Hooks must not silently change implementation files.
- Long-term memory/spec updates still require deliberate consolidation.

## Optional Future Hooks

| Hook | Purpose |
| --- | --- |
| pre-tool-guard | Warn or block protected files/actions |
| stop-verification | Remind agents not to claim completion without evidence |
| task-closure-reminder | Ask user before completing/archiving task |
