# Ariadne

Ariadne is a lightweight AI coding method pack for helping agents such as Codex, Claude Code, pi, Cursor, Cline, and similar tools complete software tasks more reliably.

It is not another heavy AI coding platform. Ariadne provides portable workflow discipline: short entry rules, progressive skills, task workspaces, project memory, evidence-based verification, and optional sub-agent delegation.

The name comes from Ariadne's thread: a guide through complex paths, long context, and difficult decisions.

## What Ariadne Optimizes For

- Keep small tasks fast.
- Make complex tasks explicit and recoverable.
- Separate intent, spec, plan, implementation, evidence, and memory.
- Use sub-agents for context isolation, implementation focus, and fresh review.
- Capture useful future knowledge without turning memory into a junk drawer.
- Require evidence before completion claims.

## What Ariadne Is Not

- Not a runtime or agent platform.
- Not a task database.
- Not a replacement for Codex, Claude Code, pi, Cursor, Cline, or similar tools.
- Not a requirement to create artifacts for every small task.
- Not a source of final truth for project contracts; use `.ai/spec/` for that.

## Initialize Ariadne In A Project

Ariadne currently provides a template-based init layer, not a packaged CLI.

From the Ariadne repository root:

```bash
./scripts/init.sh /path/to/target-project
```

The init script copies missing files only and does not overwrite existing project files. See `templates/init/README.md` for embedded and external workspace modes.

## Quickstart For Agents

1. Read `AGENTS.md`.
2. Read `.ai/workflow.md`.
3. Use `task-router` to classify the request.
4. For Level 0/1, stay light and avoid unnecessary artifacts.
5. For Level 2/3, create or update a task workspace when persistent context helps.
6. Use baseline-first before meaningful implementation.
7. Delegate to sub-agents when context isolation or fresh review improves quality.
8. Verify with evidence before claiming completion.
9. Capture reusable future knowledge in `pending-memory.md` when useful.

## Workflow Levels

| Level | Name | Use For |
| --- | --- | --- |
| 0 | Discussion | Questions, critique, naming, planning conversation |
| 1 | Fast Path | Small low-risk edits or narrow answers |
| 2 | Spec Path | Normal features, refactors, multi-file changes |
| 3 | Deep Path | High-risk, ambiguous, architectural, persistent, or long-running tasks |

## Repository Layout

```text
AGENTS.md                      Entry rules for coding agents
CLAUDE.md                      Claude-specific pointer file
.agents/skills/                On-demand method skills
.ai/workflow.md                Progressive workflow rules
.ai/config.json                Project identity and high-level config
.ai/templates/                 Task and sub-agent templates
.ai/tasks/                     Level 2/3 task workspaces
.ai/agents/                    Sub-agent delegation protocol
.ai/memory/                    Pending and accepted memory
.ai/spec/                      Authoritative project-level constraints
.ai/repo-map/                  Repository maps and baseline summaries
.ai/hooks/                     Optional deterministic guardrail notes
```

## Core Skills

- `task-router` — choose the lightest safe workflow level.
- `goal-framing` — turn fuzzy requests into goals, criteria, non-goals, risks, and questions.
- `requirements-clarification` — ask only high-value questions.
- `baseline-first` — establish the smallest useful project readset.
- `spec-writer` — create an implementation contract for Level 2/3 work.
- `verification` — collect evidence before completion claims.
- `memory-capture` — record pending memory candidates during work.
- `update-memory` — consolidate pending memory into memory/spec/workflow/AGENTS or discard.

## Sub-Agent Philosophy

Ariadne does not define how sub-agents are created. Use the current environment's native delegation mechanism.

Ariadne defines:

- When to delegate.
- Which role to delegate.
- What context to provide.
- What artifact to return.
- How the main agent accepts or rejects the result.

## Memory Philosophy

Memory is not chat history. Memory is stable, reusable knowledge that helps future agents recover judgment.

Use `pending-memory.md` as a real-time candidate pool. Promote candidates only through `update-memory` after source, stability, and destination are clear.

## Status

Ariadne is in early method-pack development. The current version is template-driven and intentionally platform-neutral. Automation, hooks, and adapters can be added after the workflow proves useful in real tasks.
