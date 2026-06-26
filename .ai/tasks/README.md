# Tasks

Task workspaces preserve decision-grade context for Level 2 and Level 3 work.

They are not required for every request. Use them only when persistent context improves reliability, handoff, recovery, or verification.

## When To Create A Task Workspace

Create a task workspace when:

- The task is Level 2 and has multiple steps, files, decisions, or validation needs.
- The task is Level 3, unless the user explicitly opts out.
- Sub-agents need a shared artifact path for handoff or return summaries.
- The work may span context windows, sessions, or multiple user turns.
- The task needs durable evidence, decisions, or checkpoints.

Do not create a task workspace by default for:

- Level 0 discussion.
- Level 1 typo, small docs, or narrow one-file fixes.
- Tasks where the artifact would be more ceremony than value.

## Naming

Use date-first names so task folders sort chronologically.

```text
.ai/tasks/YYYY-MM-DD-short-task-name/
```

Examples:

```text
.ai/tasks/2026-06-23-router-rules/
.ai/tasks/2026-06-23-auth-flow-review/
.ai/tasks/2026-06-23-migration-plan/
```

Use lowercase words and hyphens. Keep names short and stable.

## Default Shape

For most Level 2 work, create one file:

```text
.ai/tasks/YYYY-MM-DD-short-task-name/task.md
```

Start from:

```text
.ai/templates/task.md
```

The minimum useful content is:

- Intent.
- Success criteria.
- Non-goals.
- Constraints.
- Baseline readset.
- Plan.
- Decisions.
- Verification evidence.
- Residual risks.

## When To Split Artifacts

Keep one `task.md` until it becomes hard to scan.

Split into separate files when:

- The task is Level 3.
- Multiple sub-agents are working from the same task.
- Research or verification output is too large.
- Decisions need a stable log.
- Long-task checkpoints are needed.
- Bugfix work needs root-cause and retirement tracking.

Suggested split:

```text
intent.md
questions.md
spec.md
plan.md
decisions.md
baseline-readset.md
checkpoints.md
evidence.md
verification.md
retirement.md
```

Do not create empty files just because they exist in this list.

## Task Status

Use simple status labels inside `task.md`:

```text
planning
in-progress
blocked
verifying
complete
deferred
```

Status meaning:

- `planning`: intent, questions, baseline, or spec are still being shaped.
- `in-progress`: implementation, research, or delegation is active.
- `blocked`: a user decision, missing dependency, failing check, or unknown risk blocks progress.
- `verifying`: implementation is done enough to validate.
- `complete`: evidence supports completion and residual risks are recorded.
- `deferred`: intentionally paused or out of scope for now.

## Sub-Agent Usage

When sub-agents are used, the task workspace is the shared evidence bus.

Main agent should write or provide:

- Goal and non-goals.
- Relevant task/spec/artifact paths.
- Decisions already made.
- Allowed and forbidden edit areas.
- Validation expectations.
- Required output shape.
- Stop rules and escalation conditions.

Sub-agent should return:

- Scope completed.
- Files/sources read.
- Key facts.
- Changes made or findings produced.
- Commands/checks run.
- Evidence and artifact paths.
- Residual risks.
- Decisions needed.
- Recommendation.

Store large sub-agent outputs as files under the task folder instead of relying only on chat history.

## Evidence Rules

Do not mark a task complete without evidence.

Acceptable evidence includes:

- Passing focused tests.
- Successful lint/typecheck/build commands.
- Manual checks with exact scenarios.
- Review findings and resolution notes.
- Changed-files summary.
- Artifact paths for specs, plans, research, or verification.
- Explicit residual risks when validation is incomplete.

If validation cannot be run, record why and provide the strongest available manual evidence.

## Checkpoints

Use checkpoints for long or risky tasks.

A useful checkpoint records:

- Current goal.
- Files changed or under consideration.
- Decisions made.
- Commands run.
- What remains.
- Open risks or blockers.

Checkpoint before:

- Context compaction.
- Ending a session mid-task.
- Delegating implementation after planning.
- Large or risky edits.

## Completion

The agent should not silently mark a task complete or archive it.

When the agent believes a task is complete:

1. Summarize success criteria and whether they are satisfied.
2. Summarize changed files or produced artifacts.
3. Summarize verification evidence.
4. Summarize residual risks and follow-up work.
5. Ask the user how to close the task.

Suggested closure options:

```text
1. Mark complete and archive
2. Mark complete but keep visible
3. Keep in-progress
4. Mark deferred
```

Before marking a task complete:

- Success criteria are satisfied or explicitly adjusted.
- Changed files are summarized.
- Verification evidence is recorded.
- Residual risks are listed.
- Follow-up work is separated from the completed scope.
- Durable memory/spec candidates are captured in `pending-memory.md`, not blindly promoted.
- The user has confirmed the closure decision.

Ariadne does not require automatic archival. Archive, keep, or delete completed task workspaces according to the host project's convention after user confirmation.
