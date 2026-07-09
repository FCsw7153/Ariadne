<!-- ARIADNE:START -->
# Ariadne Agent Instructions

These instructions are for AI coding agents working in this repository with Ariadne.

Ariadne is a lightweight AI coding method pack. It keeps small tasks fast and makes complex tasks explicit, recoverable, delegated when useful, memory-aware, and evidence-verified.

Follow this file as the always-loaded entry protocol. Detailed procedures live in `.agents/skills/`, `.ai/workflow.md`, or task artifacts, but the gates below are mandatory unless the user explicitly overrides them.

## Working Knowledge Map

- `.ai/workflow.md` — workflow levels, task routing, and default loops.
- `.agents/skills/` — on-demand skills for routing, clarification, baseline reading, spec writing, verification, and memory.
- `.ai/templates/` — reusable task and sub-agent templates.
- `.ai/tasks/` — task workspaces for Level 2 and Level 3 work.
- `.ai/agents/` — sub-agent delegation conventions.
- `.ai/scripts/` — deterministic Ariadne task, validation, checkpoint, and doctor commands.
- `.ai/state/` — lightweight runtime state such as the active task pointer.
- `.ai/ariadne-version` and `.ai/ariadne-template-hashes.json` — installed version and managed-template hashes for safe updates.
- `.ai/memory/` — pending and accepted reusable project memory.
- `.ai/spec/` — durable project-level architecture, style, testing, contracts, gotchas, and glossary documents.
- `.ai/repo-map/` — concise repository maps and baseline readsets when useful.
- `.ai/hooks/` — required deterministic guardrails for complete Ariadne installs.

## Core Operating Rules

- Use the lightest workflow that can safely complete the task.
- Keep Level 0 and Level 1 tasks fast; do not create artifacts for trivial discussion or small edits unless useful.
- For non-trivial implementation, separate intent, constraints, plan, implementation, and verification evidence in a task artifact.
- Read enough project facts before implementation; do not code from assumptions when repo context matters.
- Ask only high-value clarification questions; do not turn every task into an interview.
- Use sub-agents when context isolation, implementation focus, research depth, parallelism, or fresh review improves quality.
- Do not interrupt sub-agents by default. Wait for completion or queue a message unless the user explicitly redirects, the worker is clearly off-scope, context is wrong, behavior is unsafe, or resources are out of control.
- For pi sub-agents, do not pass `timeoutMs` or `maxRuntimeMs` unless the user explicitly requests a foreground runtime limit; prefer async/background runs plus status, queued messages, and needs-attention signals.
- Do not claim completion without fresh evidence such as tests, commands, review notes, changed files, or explicit manual checks.
- Do not automatically commit, push, merge, or rewrite git history unless the user explicitly asks.

## Ariadne Entry Protocol

- Start every request by classifying it as Level 0, 1, 2, or 3 from `.ai/workflow.md`; for Level 0/1 this may be a one-line internal or user-visible decision.
- Before Level 2/3 implementation, create or update `.ai/tasks/<date>-<short-name>/task.md` from `.ai/templates/task.md` unless the user explicitly says to skip artifacts.
- Treat the Level 2/3 task artifact as the PRD/spec/plan record: it must include intent, success criteria, non-goals, constraints, baseline readset, plan, sub-agent decision, verification evidence, and residual risks.
- If artifacts are skipped by user override, state that override and still keep a minimal plan, verification evidence, and memory decision in the chat or final report.
- Do not begin substantive Level 2/3 code changes before the baseline readset and compact plan/spec are recorded.
- For complete Ariadne installs, use `.ai/scripts/ariadne-task.sh start <task>` to set the active task before Level 2/3 implementation and `.ai/scripts/ariadne-task.sh finish` when the task is no longer active.

## Hook Gate

- Complete Ariadne installations require hooks or an equivalent host mechanism that can inject workflow state, save pre-compact checkpoints, and restore post-compact context.
- Hosts without hook support run in degraded mode: the agent must say the host is degraded, use the scripts manually, and record the residual risk.
- Hooks must remain deterministic guardrails. They may read state, write checkpoints, append pending-memory candidates, and print reminders; they must not make product decisions, auto-commit, auto-archive, or silently change implementation files.
- Before context compaction, run `.ai/hooks/pre-compact-save.py` or an equivalent host hook. After compaction, run `.ai/hooks/post-compact-restore.py` or an equivalent host hook.
- Use `.ai/hooks/inject-workflow-state.py` or an equivalent per-turn hook to keep the active task and workflow state visible to the agent.

## Skill Loading Rules

- Use the relevant skill files under `.agents/skills/` when their trigger matches the task.
- If the host environment has a native skill mechanism, invoke the skill by name.
- If the host environment has no skill mechanism, read the relevant `.agents/skills/<skill>/SKILL.md` file directly and follow it as instructions.
- Default skill sequence for Level 2/3 work: `task-router`, `goal-framing`, `baseline-first`, `spec-writer`, `verification`, then `memory-capture` when reusable knowledge appears.

## Workflow Gates

- Level 0: discussion only; no task artifact required.
- Level 1: small, local, low-risk work; no task artifact required by default.
- Level 2: normal feature, refactor, behavior change, multi-file change, meaningful bugfix, or non-obvious acceptance criteria; task artifact required unless explicitly skipped.
- Level 3: architectural, high-risk, ambiguous, security/data/migration/deployment, persistent bug, or long-running work; task workspace required unless explicitly skipped.
- When in doubt between Level 1 and Level 2, choose Level 2 and write the compact task artifact.

## Sub-Agent Gate

- For every Level 2/3 task, make an explicit sub-agent decision before implementation: delegate, or record why delegation is not useful or not available.
- Use native sub-agents for Level 3 by default when available, especially for research, implementation isolation, verification, or fresh review.
- For Level 2, use sub-agents when they reduce context load, improve review quality, or let the main agent stay focused on scope and decisions.
- If the host environment has no sub-agent mechanism, record `Sub-agent decision: unavailable in this host`; if host or system policy disables delegation, record `Sub-agent decision: disabled-by-system-instruction`.

## No-Interrupt Sub-Agent Rule

- Once a sub-agent is dispatched, the main agent should wait for its completion or use a queued message for non-urgent additions.
- Do not interrupt a sub-agent for status checks, impatience, minor clarifications, or low-priority context.
- Interrupt only when the user explicitly asks, the sub-agent is clearly off-scope, the handoff context is wrong enough to make continued work harmful, the worker is attempting unsafe/destructive behavior, or resource usage is out of control.
- Every interrupt must be recorded in the task artifact with reason, evidence, replacement instruction, affected agent, and follow-up action.

## Memory Gate

- During Level 2/3 work, capture reusable project knowledge candidates in `.ai/memory/pending-memory.md` using `memory-capture`.
- At task completion, record either the memory candidates captured or `No durable memory candidates`.
- Do not write long-term memory/spec updates directly unless the task explicitly includes memory consolidation.

## First Files To Read

When starting work, read:

- `.ai/workflow.md`
- `.ai/config.json`
- Relevant files under `.agents/skills/` for the task at hand

Managed by Ariadne. Edits outside this block are preserved; edits inside may be overwritten by a future Ariadne updater.
<!-- ARIADNE:END -->
