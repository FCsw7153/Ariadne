<!-- ARIADNE:START -->
# Ariadne Agent Instructions

These instructions are for AI coding agents working in this repository.

Ariadne is a lightweight, portable AI coding framework that helps agents complete tasks more reliably without becoming a heavy coding platform.

The always-loaded entry rules should stay short. Detailed procedures belong in `.agents/skills/`, `.ai/workflow.md`, or task artifacts.

## Working Knowledge Map

The project knowledge you need lives in these places:

- `.ai/workflow.md` — workflow levels, task routing, and default loops.
- `.ai/config.json` — project identity and high-level configuration.
- `.agents/skills/` — on-demand skills for routing, clarification, baseline reading, spec writing, and verification.
- `.ai/templates/` — reusable task and artifact templates.
- `.ai/spec/` — durable project-level architecture, style, testing, contracts, gotchas, and glossary documents.
- `.ai/memory/` — stable project memory and recurring decisions that should survive sessions.
- `.ai/repo-map/` — concise repository maps and baseline readsets when the project grows.
- `.ai/tasks/` — task workspaces for Level 2 and Level 3 work.
- `.ai/agents/` — optional role definitions and delegation conventions.
- `.ai/hooks/` — optional deterministic guardrails; hooks are not required for the method to work.

## Core Operating Rules

- Use the lightest workflow that can safely complete the task.
- Keep Level 0 and Level 1 tasks fast; do not create artifacts for trivial discussion or small edits unless useful.
- For non-trivial implementation, separate intent, constraints, plan, implementation, and verification evidence.
- Read enough project facts before implementation; do not code from assumptions when repo context matters.
- Ask only high-value clarification questions; do not turn every task into an interview.
- Do not claim completion without fresh evidence such as tests, commands, review notes, changed files, or explicit manual checks.
- Do not automatically commit, push, merge, or rewrite git history unless the user explicitly asks.
- Keep durable rules short. Move specialized methods into skills, templates, or task artifacts.

## Workflow Levels

- Level 0: Discussion, critique, naming, planning, or explanation only. No project artifacts required.
- Level 1: Small, low-risk edit or narrow answer. No task workspace required by default.
- Level 2: Standard feature, refactor, multi-file change, or work with meaningful acceptance criteria. Create a task workspace when useful.
- Level 3: High-risk, ambiguous, architectural, migration, security, persistent bug, or long-running task. Use deeper planning, decisions, checkpoints, review, and delegation when useful.

## Task Workspace Rules

- Use `.ai/tasks/<date>-<short-name>/` for Level 2 or Level 3 tasks that need persistent context.
- Start from `.ai/templates/task.md` unless a more specific template exists.
- Persist decisions that affect implementation, scope, verification, or future maintenance.
- Store evidence in task artifacts instead of relying only on chat history.
- Keep task artifacts concise; write decision-grade summaries, not raw transcript dumps.

## Sub-Agent Delegation

Use sub-agents when delegation improves context isolation, parallelism, implementation focus, research depth, or fresh review.

The main agent remains responsible for:

- User alignment and clarification.
- Task framing and scope control.
- Final decisions and tradeoff calls.
- Acceptance of sub-agent outputs.
- Final user-facing summary.

Sub-agents should be given clear scope, constraints, expected artifacts, and evidence requirements. They should return decision-grade artifacts, not only chat summaries.

A good sub-agent handoff includes:

- Goal and non-goals.
- Relevant task/spec/artifact paths.
- Allowed and forbidden file areas.
- Validation expectations.
- Required output format.
- Open decisions that must be escalated.

A good sub-agent return includes:

- Scope completed.
- Files or sources read.
- Key facts discovered.
- Changes made or findings produced.
- Evidence collected.
- Residual risks.
- Decisions needed from the main agent or user.

Use the current environment's native delegation mechanism. Do not reimplement delegation unless the environment has no suitable mechanism.

## Command And Automation Preference

If a host environment provides Ariadne-aware commands, prompts, skills, hooks, or task runners, prefer them over hand-rolled steps when they match the task.

Automation should provide deterministic guardrails, not replace reasoning. Hooks may enforce checks, save context, restore state, or prevent unsafe actions, but strategic decisions remain with the main agent.

## First Files To Read

When starting work on Ariadne itself, read:

- `README.md`
- `.ai/workflow.md`
- `.ai/config.json`
- Relevant files under `.agents/skills/` for the task at hand

Managed by Ariadne. Edits outside this block are preserved; edits inside may be overwritten by a future Ariadne updater.
<!-- ARIADNE:END -->
