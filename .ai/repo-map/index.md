# Repo Map

The repo-map layer helps agents understand where to look before reading too much.

It is optional. Use it when the project grows large enough that agents need a concise navigation map.

## Purpose

- Summarize important directories and files.
- Point agents to likely baseline readsets.
- Reduce blind full-repo searches.
- Help sub-agents receive compact handoffs.

## Current Structure

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | Entry rules for coding agents |
| `CLAUDE.md` | Claude-specific pointer file |
| `.agents/skills/` | On-demand method skills |
| `.ai/workflow.md` | Progressive workflow rules |
| `.ai/hooks/` | Required deterministic guardrail hooks |
| `.ai/scripts/` | Ariadne task, checkpoint, validation, and doctor commands |
| `.ai/state/` | Lightweight runtime state such as the active task pointer |
| `.ai/templates/` | Task and sub-agent templates |
| `.ai/tasks/` | Level 2/3 task workspaces |
| `.ai/agents/` | Sub-agent delegation protocol |
| `.ai/memory/` | Pending and accepted memory |
| `.ai/spec/` | Authoritative project constraints |

## Future Repo Map Shape

When this project grows, add:

```text
symbols.json       machine-readable summary when useful
baseline.md        common files to read by task type
packages.md        package/layer map for larger repos
commands.md        common validation and maintenance commands
```

## Rule

Repo maps are navigation aids, not authority. If repo-map conflicts with source files, specs, or current task evidence, verify against the source.
