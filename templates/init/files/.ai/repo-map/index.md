# Repo Map

Summarize the target repository structure when useful.

This file is a navigation aid, not authority. If this map conflicts with source files, specs, or current task evidence, verify against the source.

## Current Structure

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | Always-loaded Ariadne entry protocol |
| `.agents/skills/` | On-demand workflow skills |
| `.ai/workflow.md` | Progressive workflow and workflow-state blocks |
| `.ai/hooks/` | Required deterministic guardrail hooks |
| `.ai/scripts/` | Ariadne task, checkpoint, validation, and doctor commands |
| `.ai/state/` | Lightweight runtime state such as the active task pointer |
| `.ai/tasks/` | Level 2/3 task workspaces, checkpoints, and evidence |
| `.ai/memory/` | Pending and accepted memory |
| `.ai/spec/` | Authoritative project-level constraints |
| `.ai/templates/` | Task and sub-agent templates |

## Useful Baseline Reads

| Task Type | Suggested Sources |
| --- | --- |
| Level 2/3 implementation | `AGENTS.md`, `.ai/workflow.md`, current task artifact, relevant `.ai/spec/` |
| Hook/debug workflow state | `.ai/hooks/`, `.ai/scripts/`, `.ai/state/current-task`, current task checkpoints |
| Sub-agent delegation | `.ai/agents/README.md`, `.ai/templates/subagent-handoff.md`, task artifact |
