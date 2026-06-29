# Task Router Skill

Use this skill to classify a user request and choose the lightest safe Ariadne workflow.

The task router prevents two failure modes:

- Over-processing small tasks with unnecessary specs and artifacts.
- Under-processing complex tasks that need clarification, baseline facts, delegation, or evidence.

## Principle

Choose the shallowest level that can safely complete the task. Escalate only when ambiguity, risk, context size, or verification needs justify it.

## Inputs To Consider

Classify using the current user request plus any visible project state.

Consider:

- User intent: discussion, edit, feature, refactor, bugfix, review, research, or planning.
- Scope: no files, one file, multiple files, multiple packages/layers, or unknown.
- Risk: user-visible behavior, data, security, auth, deployment, migrations, billing, or architecture.
- Ambiguity: missing acceptance criteria, unclear product decision, multiple viable approaches.
- Context load: amount of repo reading, logs, external research, or diff inspection needed.
- Verification: whether completion can be checked simply or needs stronger evidence.
- Duration: whether work may exceed the current context window or session.
- User override: explicit request to move fast, create a task, use sub-agents, or avoid sub-agents.

## Output Format

Return a compact routing decision before starting substantive work.

```text
Routing Decision
- Level: 0 | 1 | 2 | 3
- Path: Discussion | Fast Path | Spec Path | Deep Path
- Reason: <1-3 bullets>
- Task workspace: none | optional | recommended | required
- Clarification: none | ask now | defer until after baseline read
- Baseline read: none | minimal | focused | broad
- Sub-agents: none | optional | recommended
- Required artifacts: <none or list>
- Verification: <expected evidence>
- Next action: <what to do immediately>
```

For very small Level 0/1 tasks, this can be shortened to one sentence if an explicit routing block would be more ceremony than value.

## Level 0: Discussion

Choose Level 0 when the user is asking for conversation, critique, naming, comparison, explanation, or planning, and no file changes are requested.

Signals:

- "What do you think?"
- "Explain this."
- "Compare these options."
- Naming, positioning, brainstorming, or methodology discussion.
- The user explicitly says not to implement yet.

Default behavior:

- Do not edit files.
- Do not create task artifacts.
- Answer directly, with recommendations when useful.
- If the user turns the discussion into implementation, re-route before editing.

Artifacts:

- None.

Sub-agents:

- No, unless the discussion needs substantial independent research.

Verification:

- Reasoned answer, cited files/sources if applicable.

## Level 1: Fast Path

Choose Level 1 when the task is small, low-risk, localized, reversible, and easy to verify.

Signals:

- Typo or wording fix.
- Small docs update.
- Simple one-file change.
- Narrow code explanation.
- Obvious local bug with clear fix.
- User explicitly asks for a quick/direct change.

Default behavior:

- Read the minimum relevant files.
- Implement directly in the main session.
- Do not create `.ai/tasks/` by default.
- Keep final response short.

Artifacts:

- None by default.
- Optional memory/spec update only if the change reveals durable project knowledge.

Sub-agents:

- Usually no.
- Use only if a fresh review or isolated check would be clearly cheaper than main-session work.

Verification:

- Smallest relevant check, manual review, or explanation of why no command was useful.

Escalate to Level 2 if:

- More files are involved than expected.
- Acceptance criteria are not obvious.
- Verification is non-trivial.
- The fix reveals broader design or product questions.

## Level 2: Spec Path

Choose Level 2 for normal implementation work with meaningful acceptance criteria.

Signals:

- New feature or behavior change.
- Multi-file change.
- Meaningful refactor.
- Standard bugfix requiring root-cause understanding.
- Test additions or updates.
- Documentation change tied to behavior or API changes.
- User asks for a plan, spec, or task artifact.

Default behavior:

1. Frame intent, success criteria, non-goals, constraints, and risks.
2. Ask only necessary clarification questions.
3. Read focused baseline facts before implementation.
4. Create or update a compact task artifact when useful.
5. Decide whether implementation/review/research should be delegated.
6. Implement or delegate within the approved scope.
7. Verify with evidence before reporting completion.

Task workspace:

- Recommended when the work needs persistent context, multiple steps, or sub-agent handoff.
- Use `.ai/tasks/<date>-<short-name>/task.md` as the default single-file artifact.
- Split into `intent.md`, `spec.md`, `plan.md`, `evidence.md`, or `decisions.md` only when it improves clarity.

Sub-agents:

- Optional but often useful.
- Recommended for implementation when the main agent should stay focused on user alignment, decisions, and final acceptance.
- Recommended for fresh review when correctness matters.

Verification:

- Evidence required: tests, commands, manual checks, review notes, changed-files summary, or residual risks.

Escalate to Level 3 if:

- Security, migration, architecture, data integrity, deployment, or long-task risk appears.
- Multiple independent research or implementation tracks emerge.
- The task cannot be safely specified without deeper exploration.
- A bug has resisted previous fixes.

## Level 3: Deep Path

Choose Level 3 when the task is high-risk, ambiguous, long-running, context-heavy, or likely to cause architectural drift.

Signals:

- Architecture or cross-layer change.
- Security, auth, privacy, billing, data, migration, deployment, or infrastructure work.
- Persistent bug or repeated failed fix loop.
- Large refactor or behavior redesign.
- Unclear requirements with important product tradeoffs.
- Requires substantial external research or noisy log analysis.
- Requires multiple sub-agents or fresh-context review.
- Work may exceed the current session/context window.

Default behavior:

1. Frame goal, success criteria, non-goals, constraints, risks, and unknowns.
2. Brainstorm solution paths and failure modes when needed.
3. Ask high-value clarification questions before locking scope.
4. Build and record a baseline readset.
5. Write a spec and implementation plan.
6. Delegate research, implementation, and review when useful.
7. Keep the main agent focused on orchestration, decisions, and user communication.
8. Record checkpoints for recovery.
9. Verify with strong evidence and fresh review when possible.
10. Update durable memory/spec only for reusable knowledge.

Task workspace:

- Required unless the user explicitly opts out.
- Suggested artifacts: `intent.md`, `questions.md`, `spec.md`, `plan.md`, `decisions.md`, `baseline-readset.md`, `checkpoints.md`, `evidence.md`, `verification.md`, and `retirement.md` for bugfix/replacement work.

Sub-agents:

- Recommended.
- Use them for context-heavy research, implementation, validation, noisy logs, or fresh review.
- Require decision-grade returns: readset, facts, findings/changes, evidence, risks, and decisions needed.

Verification:

- Strong evidence required.
- If verification fails or is incomplete, do not report completion without residual risks and next steps.

## Clarification Rules

Ask questions only when the answer can change implementation, scope, risk, or acceptance.

Good clarification questions:

- Resolve product behavior.
- Define acceptance criteria.
- Choose between materially different implementation paths.
- Confirm constraints, compatibility, or rollout needs.
- Identify what should explicitly not be done.

Avoid questions that:

- Ask the user to restate obvious context.
- Can be answered by reading the repo.
- Only satisfy process ceremony.
- Block a reversible Level 1 fix.

Question budget:

- Level 0: ask freely if the discussion needs it.
- Level 1: avoid unless necessary.
- Level 2: ask the smallest useful set, usually 1-3 questions.
- Level 3: ask high-value questions and record decisions.

## Baseline Read Rules

Choose the smallest baseline readset that prevents assumption-driven work.

- `none`: pure discussion or user-provided answer is enough.
- `minimal`: one or two local files.
- `focused`: related files, tests, docs, configs, and existing patterns.
- `broad`: architecture docs, multiple packages, logs, specs, prior tasks, or external references.

Record the baseline readset for Level 2 when useful and for Level 3 by default.

## Sub-Agent Routing Rules

Use sub-agents when they improve context isolation, parallelism, implementation focus, research depth, or fresh review.

Do not use sub-agents just to create ceremony.

The main agent remains responsible for:

- User alignment.
- Scope and decisions.
- Accepting or rejecting sub-agent outputs.
- Final verification judgment.
- Final user-facing summary.

Platform-specific creation details are out of scope for this skill. Use the current environment's native delegation mechanism.

## Artifact Decision Rules

Create artifacts when they reduce future confusion more than they cost to maintain.

No artifacts by default for:

- Level 0 discussion.
- Level 1 small fixes.

Use a single task artifact for:

- Most Level 2 tasks.
- Work that needs a compact durable handoff.

Split artifacts for:

- Level 3 tasks.
- Multiple sub-agent handoffs.
- Long-running work.
- Work with meaningful decisions, evidence, or checkpoints.

## Verification Decision Rules

Before completion, decide what evidence is appropriate.

- Level 0: reasoning or cited source/file references.
- Level 1: minimal check or manual review.
- Level 2: focused tests/commands/manual checks and changed-files summary.
- Level 3: strong evidence, review findings, residual risks, and recovery notes.

If validation cannot be run, report why and provide the strongest available alternative evidence.

## Routing Examples

```text
"Explain this architecture" → Level 0
"Fix this typo" → Level 1
"Add a setting to this feature" → Level 2
"Refactor auth flow" → Level 3
"This bug keeps coming back" → Level 3
"Implement this small README wording change" → Level 1
"Add tests for this behavior across two modules" → Level 2
"Design and implement a migration" → Level 3
```

## Stop Conditions

Stop routing and ask the user when:

- The request is too ambiguous to classify safely.
- The user asks for mutually conflicting constraints.
- The likely level conflicts with an explicit user override and the risk is non-trivial.
- The work appears unsafe, destructive, or outside allowed scope.

Otherwise, route the task and proceed with the next action.
