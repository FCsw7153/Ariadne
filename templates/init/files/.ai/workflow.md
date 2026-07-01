# Ariadne Workflow

Ariadne uses progressive depth: make hard AI coding tasks safer without making easy tasks slow.

The workflow is platform-neutral. It defines when to clarify, when to create task artifacts, when to delegate to sub-agents, and what evidence is needed before claiming completion. Complete Ariadne installations require hooks or an equivalent host mechanism for workflow-state injection and compact recovery; hosts without hooks run in degraded mode.

## Core Principle

Use the lightest workflow that can safely complete the task.

Escalate only when complexity, ambiguity, risk, or context size requires it. De-escalate when the task is small, reversible, and easy to verify.

## Default Loop

```text
classify task
→ frame intent
→ ask only necessary questions
→ read baseline facts
→ choose artifact depth
→ set active task for Level 2/3 work
→ plan implementation
→ delegate when useful
→ implement narrowly
→ verify with evidence
→ validate task artifact
→ update durable memory when useful
```

## Routing Summary

| Level | Name | Use For | Task Workspace | Sub-Agent Use | Evidence |
| --- | --- | --- | --- | --- | --- |
| 0 | Discussion | Questions, critique, naming, planning conversation | No | No | Reasoned answer |
| 1 | Fast Path | Small low-risk edits or narrow answers | No by default | Usually no | Minimal check or explanation |
| 2 | Spec Path | Normal features, refactors, multi-file changes | Required unless user opts out | Decision required; delegate when useful | Required |
| 3 | Deep Path | High-risk, ambiguous, architectural, security, migration, persistent bugs, long tasks | Required unless user opts out | Recommended by default when available | Strong evidence + review |

## Runtime State And Hooks

Complete Ariadne installs use a small runtime state layer:

- `.ai/state/current-task` stores the active task workspace path.
- `.ai/ariadne-version` records the installed Ariadne template version.
- `.ai/ariadne-template-hashes.json` records hashes for managed template files that can be safely updated.
- `.ai/scripts/ariadne-task.sh start <task>` sets the active task and marks it `in-progress` when possible.
- `.ai/scripts/ariadne-task.sh checkpoint <task>` writes a recovery checkpoint.
- `.ai/scripts/ariadne-task.sh validate <task>` checks closure readiness.
- `.ai/scripts/ariadne-update.sh` updates managed Ariadne files while preserving user edits and protected project data.
- `.ai/scripts/ariadne-doctor.sh` checks that guardrails are installed.

Required hooks or equivalent host mechanisms:

- `inject-workflow-state.py` runs every turn to remind the agent of the active task and workflow state.
- `pre-compact-save.py` runs before context compaction to save a checkpoint and pending-memory candidate.
- `post-compact-restore.py` runs after context compaction to restore the latest task checkpoint.

If hooks are unavailable, the agent must state degraded mode, run the scripts manually when relevant, and record the residual risk in the task artifact.

## Workflow-State Blocks

Hooks parse these blocks as the single source of truth for compact per-turn guidance. Keep them short and deterministic.

[workflow-state:no_task]
No active task. Classify the request first. Level 0/1 should stay lightweight and should not create task artifacts by default. For Level 2/3, create or update a task artifact before substantive implementation, then run `.ai/scripts/ariadne-task.sh start <task>`.
[/workflow-state:no_task]

[workflow-state:planning]
Active task is planning. Finish intent, success criteria, non-goals, constraints, baseline readset, compact plan/spec, and sub-agent decision before implementation. Ask only high-value questions. Do not edit implementation files until the task artifact is decision-ready.
[/workflow-state:planning]

[workflow-state:in-progress]
Active task is in progress. Follow the task plan narrowly, keep evidence in the task artifact, and use hooks/scripts for checkpoints. If sub-agents are running, wait or queue messages; do not interrupt unless the No-Interrupt Rule allows it.
[/workflow-state:in-progress]

[workflow-state:verifying]
Active task is verifying. Map success criteria to evidence, run focused checks, update verification evidence, changed files, residual risks, and memory decision. Do not claim completion without fresh evidence.
[/workflow-state:verifying]

[workflow-state:blocked]
Active task is blocked or stale. Read `task.md` and the latest checkpoint, identify the blocker, and ask or repair only the specific missing decision/evidence. Do not continue broad implementation from memory.
[/workflow-state:blocked]

## Escalation Triggers

Move to a deeper level when any of these are true:

- The task touches multiple files, packages, layers, or user-visible behavior.
- Acceptance criteria are unclear or likely to change.
- The change affects architecture, data, security, auth, migrations, billing, or deployment.
- The task requires substantial repo exploration or external research.
- The work may outlive the current context window or session.
- A bug has resisted one or more previous fixes.
- The main agent would need to read large logs, diffs, docs, or code areas that would pollute conversation context.
- Fresh review would materially improve confidence.

## De-Escalation Triggers

Stay light or step down when these are true:

- The user is only asking a question or exploring ideas.
- The change is one small file or a localized typo/doc fix.
- The implementation is obvious, reversible, and easy to verify.
- The user explicitly asks to skip task artifacts or move quickly.
- Creating artifacts would cost more than the risk it reduces.

## Level 0: Discussion

Use for questions, naming, positioning, critique, architecture conversation, comparison, and planning before the user asks for implementation.

Artifacts:

- None required.

Agent behavior:

- Do not edit files unless the user asks.
- Ask clarifying questions only when needed for the discussion.
- If the conversation becomes actionable implementation work, reclassify the task before editing.

Completion:

- Provide a clear answer, recommendation, or next-step proposal.

## Level 1: Fast Path

Use for small edits, typos, simple docs, narrow explanations, dependency-free tweaks, and low-risk one-file changes.

Artifacts:

- None required by default.
- Optionally update a nearby README/spec if the change creates durable knowledge.

Agent behavior:

- Read only the minimum relevant files.
- Implement directly in the main session unless delegation is clearly useful.
- Avoid creating `.ai/tasks/` just for ceremony.

Verification:

- Run the smallest relevant check when practical.
- If no command is useful, perform a manual file/diff review and say so.

Completion:

- Report what changed and how it was checked.

## Level 2: Spec Path

Use for standard features, meaningful refactors, multi-file changes, behavior changes, or tasks with non-obvious acceptance criteria.

Artifacts:

- Required single-file task artifact unless the user explicitly opts out: `.ai/tasks/<date>-<short-name>/task.md`.
- Split into separate files only when useful: `intent.md`, `spec.md`, `plan.md`, `evidence.md`, `decisions.md`.

Agent behavior:

1. Frame intent, success criteria, non-goals, constraints, and risks.
2. Ask only the few clarification questions needed to prevent wrong implementation.
3. Read baseline project facts and record the useful readset.
4. Write or update a compact task artifact with the PRD/spec/plan before substantive implementation.
5. Run `.ai/scripts/ariadne-task.sh start <task>` or record degraded mode if hooks/scripts are unavailable.
6. Record an explicit sub-agent decision: delegated, not useful, unavailable, disabled by user, or disabled by host/system instruction.
7. Delegate implementation, review, or focused research when it improves context isolation or quality.
8. Integrate sub-agent outputs and make final decisions in the main session.
9. Verify with evidence before reporting completion.
10. Record memory candidates or `No durable memory candidates`.

Sub-agent guidance:

- Use an implementation sub-agent when the main session should stay focused on user alignment and decisions.
- Use a research sub-agent when exploration would produce noisy context.
- Use a review sub-agent when fresh context can catch mistakes.
- If the host has no sub-agent mechanism, record that as the sub-agent decision.
- Require decision-grade return artifacts: readset, key facts, changes/findings, evidence, risks, and decisions needed.
- Do not interrupt sub-agents by default. Wait for completion or queue a message unless the No-Interrupt Rule allows an exceptional interrupt.

Verification:

- Evidence is required.
- Prefer focused tests/checks over broad slow commands unless broad checks are appropriate.
- Record command output, manual checks, or reasons validation could not be run.

Completion:

- Summarize changed files, decisions made, verification evidence, and residual risks.

## Level 3: Deep Path

Use for high-risk, ambiguous, architectural, security, migration, persistent bug, long-running, or context-heavy tasks.

Artifacts:

- Create a task workspace unless the user explicitly opts out.
- Suggested files:
  - `intent.md`
  - `questions.md`
  - `spec.md`
  - `plan.md`
  - `decisions.md`
  - `baseline-readset.md`
  - `checkpoints.md`
  - `evidence.md`
  - `verification.md`
  - `retirement.md` for bugfix or replacement work

Agent behavior:

1. Frame the goal, non-goals, success criteria, risks, and unknowns.
2. Brainstorm solution paths and failure modes when the direction is not obvious.
3. Ask high-value clarification questions before locking scope.
4. Build a baseline readset from code, docs, tests, specs, logs, and prior task artifacts.
5. Write a spec and plan that are concrete enough for a sub-agent handoff.
6. Run `.ai/scripts/ariadne-task.sh start <task>` or record degraded mode if hooks/scripts are unavailable.
7. Delegate research, implementation, and/or review to sub-agents when useful.
8. Keep the main session focused on orchestration, decisions, scope control, and user communication.
9. Record checkpoints for long tasks or context-boundary risk.
10. Verify with strong evidence and fresh review when possible.
11. Update durable memory/spec only with information likely to matter again.

Sub-agent guidance:

- Prefer sub-agents for implementation, large research, noisy logs, independent validation, and fresh review.
- Do not let sub-agents make unapproved product, architecture, or scope decisions.
- Require artifact paths or structured summaries, not raw chat dumps.
- The main agent must inspect enough evidence to accept or reject the sub-agent output.
- Do not interrupt sub-agents by default. Wait for completion or queue a message unless the No-Interrupt Rule allows an exceptional interrupt.

## No-Interrupt Rule

Once dispatched, a sub-agent should be allowed to complete its turn.

Default:

- Wait for completion.
- Use queued messages for low-priority additions or clarifications.
- Use status/wait mechanisms for progress, if the host provides them.

Interrupt only when:

- The user explicitly asks to stop or redirect the sub-agent.
- The sub-agent is clearly off-scope and continued work will produce bad output.
- The handoff context is wrong enough that continued work is harmful.
- The sub-agent is attempting unsafe, destructive, or unauthorized behavior.
- Resource usage is out of control.

Every interrupt must be recorded in the task artifact with reason, evidence, replacement instruction, affected agent, and follow-up action.

Verification:

- Strong evidence is required before completion.
- Use targeted tests, type/lint/build checks, manual scenario checks, review findings, or documented residual risks.
- If verification fails, do not mark the task complete. Either fix, re-plan, or report the blocker.

Completion:

- Report final scope, implementation summary, evidence, review result, residual risks, and any follow-up tasks.

## Task Workspace Lifecycle

Create a task workspace when persistent context improves reliability.

Suggested name:

```text
.ai/tasks/YYYY-MM-DD-short-task-name/
```

Minimum useful task artifact:

```text
intent
success criteria
non-goals
constraints
baseline readset
plan
decisions
evidence
residual risks
```

Keep artifacts concise. They are decision and recovery aids, not transcripts.

Archive or leave task workspaces according to the host project convention. Ariadne itself does not require automatic archival.

## Sub-Agent Handoff Contract

A sub-agent handoff should include:

- Goal.
- Non-goals.
- Current task/artifact paths.
- Relevant decisions already made.
- Files, packages, or surfaces likely involved.
- Allowed and forbidden edits.
- Validation expectations.
- Expected output shape.
- Stop rules and escalation conditions.

A sub-agent return should include:

- Scope completed.
- Files/sources read.
- Key facts.
- Changes made or findings produced.
- Commands/checks run.
- Evidence and artifact paths.
- Residual risks.
- Decisions needed.
- Recommendation.

The main agent accepts responsibility for the final decision and user-facing report.

## Evidence Rules

Never claim completion from confidence alone.

Acceptable evidence includes:

- Passing focused tests.
- Successful lint/typecheck/build commands.
- Manual checks with exact scenarios.
- Review findings and resolution notes.
- Changed-files summary.
- Artifact paths for specs, plans, research, or verification.
- Explicit residual risks when validation is incomplete.

If no validation can be run, say why and provide the strongest available manual evidence.

## Memory And Spec Updates

Update durable memory or project specs only when the information is likely to help future tasks.

Good candidates:

- Recurring project conventions.
- Known pitfalls.
- Architectural decisions.
- Testing commands or constraints.
- Bug root causes that could recur.
- External integration contracts.

Do not write every temporary decision into long-term memory.

## User Overrides

User instructions override the default workflow unless they conflict with safety, repository rules, or explicit higher-priority instructions.

Common overrides:

- "Just answer" → Level 0.
- "Small direct change" → Level 1.
- "Create a task/spec first" → Level 2 or 3.
- "Use sub-agents" → delegate when useful.
- "No sub-agents" → keep work in the main session unless impossible.
- "Skip artifacts" → avoid task workspace, but still keep enough notes to complete safely.
