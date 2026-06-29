<!-- ARIADNE:START -->
# Ariadne Agent Instructions

These instructions are for AI coding agents working in this repository with Ariadne.

Ariadne is a lightweight AI coding method pack. It helps agents keep small tasks fast and complex tasks explicit, recoverable, delegated when useful, and evidence-verified.

The always-loaded entry rules should stay short. Detailed procedures belong in `.agents/skills/`, `.ai/workflow.md`, or task artifacts.

## Working Knowledge Map

- `.ai/workflow.md` — workflow levels, task routing, and default loops.
- `.agents/skills/` — on-demand skills for routing, clarification, baseline reading, spec writing, verification, and memory.
- `.ai/templates/` — reusable task and sub-agent templates.
- `.ai/tasks/` — task workspaces for Level 2 and Level 3 work.
- `.ai/agents/` — sub-agent delegation conventions.
- `.ai/memory/` — pending and accepted reusable project memory.
- `.ai/spec/` — durable project-level architecture, style, testing, contracts, gotchas, and glossary documents.
- `.ai/repo-map/` — concise repository maps and baseline readsets when useful.
- `.ai/hooks/` — optional deterministic guardrails.

## Core Operating Rules

- Use the lightest workflow that can safely complete the task.
- Keep Level 0 and Level 1 tasks fast; do not create artifacts for trivial discussion or small edits unless useful.
- For non-trivial implementation, separate intent, constraints, plan, implementation, and verification evidence.
- Read enough project facts before implementation; do not code from assumptions when repo context matters.
- Ask only high-value clarification questions; do not turn every task into an interview.
- Use sub-agents when context isolation, implementation focus, research depth, parallelism, or fresh review improves quality.
- Do not claim completion without fresh evidence such as tests, commands, review notes, changed files, or explicit manual checks.
- Do not automatically commit, push, merge, or rewrite git history unless the user explicitly asks.

## First Files To Read

When starting work, read:

- `.ai/workflow.md`
- `.ai/config.json`
- Relevant files under `.agents/skills/` for the task at hand

Managed by Ariadne. Edits outside this block are preserved; edits inside may be overwritten by a future Ariadne updater.
<!-- ARIADNE:END -->
