# Agent Delegation

Ariadne treats sub-agents as context-isolated workers, not as independent decision owners.

The main agent remains the orchestrator: it talks with the user, frames the task, controls scope, makes final decisions, accepts or rejects sub-agent output, and produces the final user-facing summary.

Sub-agents do focused work: research, implementation, review, verification, documentation, or memory/spec updates. Their job is to return decision-grade artifacts that help the main agent decide safely.

The default coordination rule is no interrupt: once dispatched, a sub-agent should be allowed to finish its turn. The main agent should wait for completion or queue a message unless a documented exception applies.

## Core Model

```text
main agent = orchestrator + user interface + decision maker
sub-agent = context worker + artifact producer
task workspace = handoff bus + evidence bus + recovery point
```

## When To Delegate

Delegate when sub-agents improve at least one of these:

- Context isolation: large code reads, logs, docs, diffs, or search output should not pollute the main context.
- Implementation focus: the plan is clear enough for a worker to execute while the main agent preserves decision context.
- Parallelism: independent research, review, or validation tracks can run separately.
- Fresh review: a separate context can catch issues the implementer missed.
- Recovery: long tasks need artifacts and checkpoints that survive compaction or session changes.

Do not delegate just to create ceremony.

## When Not To Delegate

Avoid sub-agents when:

- The task is Level 0 discussion.
- The task is a Level 1 small fix or narrow explanation.
- The scope is too vague for a worker to act safely.
- The main agent has not recorded decisions that the worker needs.
- Multiple writer agents would edit the same files in the same worktree without coordination.
- The expected output is just another chat summary with no evidence or artifacts.

## Common Roles

| Role | Purpose | Writes Code? | Typical Output |
| --- | --- | --- | --- |
| Research | Explore code, docs, logs, external references, or alternatives | No | Research report with sources, facts, gaps, and implications |
| Implementation | Apply an approved spec/plan | Yes | Changed files, implementation notes, evidence, risks |
| Review | Inspect plan, diff, implementation, or evidence from fresh context | Usually no | Findings with severity, file references, and recommended fixes |
| Verification | Run or design checks against acceptance criteria | No by default | Commands, results, failures, residual risks |
| Documentation | Sync docs, examples, changelogs, or task artifacts | Sometimes | Docs changes and consistency notes |
| Memory / Spec | Capture durable knowledge for future tasks | Sometimes | Proposed memory/spec updates with rationale |

## Main Agent Responsibilities

Before delegation, the main agent must provide:

- Goal and non-goals.
- Relevant task/spec/artifact paths.
- Decisions already made.
- Allowed and forbidden edit areas.
- Acceptance criteria.
- Validation expectations.
- Expected output shape.
- Stop rules and escalation conditions.

After delegation, the main agent must:

- Read the sub-agent return.
- Inspect enough evidence to trust or reject the result.
- Resolve or escalate open decisions.
- Decide whether to accept, ask for repair, run review, or report a blocker.
- Avoid interrupting the sub-agent except under the No-Interrupt Rule exceptions.
- Produce the final user-facing summary.

## Sub-Agent Responsibilities

A sub-agent should:

- Stay within its assigned scope.
- Read the provided task/spec/artifact paths before acting.
- Avoid unapproved product, architecture, or scope decisions.
- Stop and report when required decisions are missing.
- Return decision-grade artifacts, not only chat narration.
- Include evidence, risks, and decisions needed.

A sub-agent should not:

- Claim final task completion unless explicitly assigned final verification.
- Rewrite the task scope.
- Spawn more sub-agents unless the main agent explicitly authorizes recursive delegation.
- Edit outside allowed areas.
- Hide failed checks or uncertain results.

## No-Interrupt Rule

Sub-agent interruption is an exceptional recovery path, not normal project management.

Default behavior:

- Let the sub-agent complete its current turn.
- Use host wait/status mechanisms for progress.
- Use queued messages for non-urgent additional context.
- Do not interrupt for impatience, routine status checks, minor clarifications, or low-priority hints.

Allowed interrupt reasons:

- The user explicitly asks to stop or redirect the worker.
- The worker is clearly off-scope and continued work will produce bad output.
- The handoff context is wrong enough that continued work is harmful.
- The worker is attempting unsafe, destructive, or unauthorized behavior.
- Resource usage is out of control.

Required interrupt record:

- Reason.
- Evidence.
- Replacement instruction.
- Affected agent.
- Follow-up action.

Record interrupts in the task artifact's Interrupt Log or in a linked report. If a host only supports hard termination, record the same fields plus any recovery steps needed before re-delegation.

## Single-Writer Rule

For a shared working tree, only one writer should modify overlapping source files at a time.

Safe patterns:

- One implementation sub-agent edits; review/verification agents are read-only.
- Multiple research/review agents run in parallel because they do not edit source files.
- Multiple writer agents work only on clearly disjoint areas or isolated worktrees.

If write ownership is unclear, the main agent should choose one writer and make all other sub-agents read-only.

## Delegation Lifecycle

```text
1. Route task level
2. Create or choose task workspace when useful
3. Record intent, constraints, decisions, and plan
4. Write sub-agent handoff
5. Run sub-agent using the host environment's native delegation mechanism
6. Store or link the sub-agent report
7. Main agent reviews evidence and open decisions
8. Accept, repair, re-delegate, or escalate to user
9. Record final evidence and residual risks
```

## Handoff Artifacts

Use handoff artifacts when delegation is non-trivial.

Suggested paths inside a task workspace:

```text
handoffs/<role>-handoff.md
reports/<role>-report.md
research/<topic>.md
review/<scope>.md
verification/<check>.md
```

Do not create these folders just for ceremony. Use them when outputs are large, important, or needed across sessions.

## Required Handoff Shape

Use `.ai/templates/subagent-handoff.md` when a structured handoff is useful.

Minimum handoff:

- Role.
- Goal.
- Non-goals.
- Current task/artifact paths.
- Relevant decisions.
- Allowed and forbidden edits.
- Expected evidence.
- Output format.
- Stop rules.

## Required Return Shape

Use `.ai/templates/subagent-report.md` when a structured report is useful.

Minimum report:

- Scope completed.
- Files/sources read.
- Key facts.
- Changes made or findings produced.
- Commands/checks run.
- Evidence and artifact paths.
- Residual risks.
- Decisions needed.
- Recommendation.

## Acceptance Rules

The main agent should not accept a sub-agent output solely because it says the work is done.

Accept when:

- The output matches the handoff scope.
- Evidence supports the claimed result.
- Open decisions are resolved or explicitly deferred.
- Residual risks are understood.
- Changed files or findings are consistent with the task spec.

For Level 3 or high-risk work, the main agent should inspect at least one of:

- Key diff or changed files.
- Verification output.
- Review findings.
- Critical source references.
- Task evidence artifacts.

## Repair / Re-Delegation Rules

Re-delegate when:

- Evidence is missing.
- The worker exceeded scope.
- Review finds required fixes.
- Validation fails.
- The report identifies a decision that the main agent/user resolves.

Do not interrupt and re-delegate as a routine repair loop. If the same issue repeats, stop and re-plan or escalate to the user.

## Platform Neutrality

Ariadne does not define how sub-agents are created.

Use the current environment's native delegation mechanism. Do not reimplement a sub-agent runtime unless the environment has no suitable mechanism.

The method layer cares about:

- When to delegate.
- What role to delegate.
- What context to provide.
- What artifact to return.
- How the main agent accepts the result.

It does not care whether the host calls that mechanism a task, agent, worker, chain, thread, or command.
