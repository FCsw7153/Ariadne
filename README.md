# Ariadne

Ariadne is a lightweight AI coding method pack for helping agents such as Codex, Claude Code, pi, Cursor, Cline, and similar tools complete software tasks more reliably.

It is not another heavy AI coding platform. Ariadne provides portable workflow discipline: short entry rules, progressive skills, required guardrail hooks, task workspaces, project memory, evidence-based verification, and optional sub-agent delegation.

The name comes from Ariadne's thread: a guide through complex paths, long context, and difficult decisions.

## What Ariadne Optimizes For

- Keep small tasks fast.
- Make complex tasks explicit and recoverable.
- Separate intent, spec, plan, implementation, evidence, and memory.
- Use sub-agents for context isolation, implementation focus, and fresh review.
- Keep sub-agents stable by waiting or queueing messages instead of interrupting by default.
- Capture useful future knowledge without turning memory into a junk drawer.
- Require evidence before completion claims.

## What Ariadne Is Not

- Not a runtime or agent platform.
- Not a task database.
- Not a replacement for Codex, Claude Code, pi, Cursor, Cline, or similar tools.
- Not a requirement to create artifacts for every small task.
- Not a source of final truth for project contracts; use `.ai/spec/` for that.

## Initialize Ariadne In A Project

Ariadne currently provides a template-based init/update layer, not a packaged CLI.

From the Ariadne repository root:

```bash
./scripts/init.sh /path/to/target-project
```

The init script copies missing files, merge-updates the Ariadne managed block in `AGENTS.md`, and writes version/hash metadata for future safe updates. See `templates/init/README.md` for embedded and external workspace modes.

## Update Ariadne In A Project

When Ariadne evolves, update installed managed files from the Ariadne repository root:

```bash
./scripts/update.sh --dry-run /path/to/target-project
./scripts/update.sh /path/to/target-project
```

Update uses `.ai/ariadne-template-hashes.json` to distinguish unmodified Ariadne-managed files from user-modified files. Unmodified files auto-update, user-modified files are preserved by default, user-deleted files stay deleted, and project data paths such as `.ai/tasks/`, `.ai/spec/`, `.ai/repo-map/`, `.ai/config.json`, `.ai/state/current-task`, and task memory files are protected.

## Quickstart For Agents

1. Read `AGENTS.md`.
2. Read `.ai/workflow.md`.
3. Use `task-router` to classify the request.
4. For Level 0/1, stay light and avoid unnecessary artifacts.
5. For Level 2/3, create or update a task artifact unless the user explicitly skips artifacts.
6. Use `.ai/scripts/ariadne-task.sh start <task>` to set active task state when implementation begins.
7. Use baseline-first before meaningful implementation.
8. Record a sub-agent decision, then delegate when context isolation or fresh review improves quality.
9. Verify with evidence before claiming completion.
10. Capture reusable future knowledge in `pending-memory.md` when useful, or record that there are no durable memory candidates.

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
.agents/skills/                On-demand method skills
.ai/workflow.md                Progressive workflow rules
.ai/ariadne-version            Installed Ariadne template version
.ai/ariadne-template-hashes.json Managed-template hash manifest
.ai/config.json                Project identity and high-level config
.ai/hooks/                     Required deterministic guardrail hooks
.ai/scripts/                   Ariadne task/checkpoint/update/doctor scripts
.ai/state/                     Lightweight runtime state
.ai/templates/                 Task and sub-agent templates
.ai/tasks/                     Level 2/3 task workspaces
.ai/agents/                    Sub-agent delegation protocol
.ai/memory/                    Pending and accepted memory
.ai/spec/                      Authoritative project-level constraints
.ai/repo-map/                  Repository maps and baseline summaries
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

If a host has no native sub-agent mechanism, record that decision in the task artifact instead of silently skipping delegation.

Sub-agent interrupts are exceptional. Ariadne's default coordination model is wait-or-queue: wait for completion or queue non-urgent messages, and record a reason/evidence log for every interrupt.

Ariadne defines:

- When to delegate.
- Which role to delegate.
- What context to provide.
- What artifact to return.
- How the main agent accepts or rejects the result.

## Memory Philosophy

Memory is not chat history. Memory is stable, reusable knowledge that helps future agents recover judgment.

Use `pending-memory.md` as a real-time candidate pool. Promote candidates only through `update-memory` after source, stability, and destination are clear.

Pre-compact hooks write checkpoints for recovery and add checkpoint-sourced pending-memory candidates. The candidate is a pointer for review, not an automatic long-term memory promotion.

## Status

Ariadne is in early method-pack development. The current version is template-driven and intentionally platform-neutral. Automation, hooks, and adapters can be added after the workflow proves useful in real tasks.
