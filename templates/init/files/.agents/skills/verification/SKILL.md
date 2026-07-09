---
name: verification
description: Verify task completion with proportional evidence before claiming done. Use after implementation or analysis to map success criteria to tests, checks, manual review, changed files, residual risks, and completion judgment.
---

# Verification Skill

Use this skill before claiming a task is complete.

Verification replaces vague confidence with evidence. It should be proportional to task level and risk.

## Purpose

- Confirm success criteria are satisfied.
- Record evidence that future agents can inspect.
- Identify residual risks and failed checks honestly.
- Prevent premature completion claims.
- Support task closure when Level 2 or Level 3 work is done.

## Inputs

Read or gather:

- User request and success criteria.
- Relevant task artifact, if any.
- Changed files or produced artifacts.
- Applicable spec, plan, or decisions.
- Sub-agent reports, if any.
- Available test/build/lint/manual check options.

## Verification By Level

| Level | Evidence Standard |
| --- | --- |
| Level 0 | Reasoned answer, cited files/sources when applicable |
| Level 1 | Minimal check, manual review, or explanation why no command is useful |
| Level 2 | Focused tests/commands/manual checks + changed-files summary + residual risks |
| Level 3 | Strong evidence, fresh review when useful, residual risks, and recovery notes |

## Evidence Types

Acceptable evidence includes:

- Passing focused tests.
- Successful lint/typecheck/build commands.
- Manual scenario checks with exact steps.
- Review findings and resolution notes.
- Changed-files summary.
- Artifact paths for specs, plans, research, or verification.
- Sub-agent reports with evidence.
- Explicit residual risks when validation is incomplete.

## Process

1. Restate the success criteria or acceptance criteria.
2. Map each criterion to evidence or mark it unresolved.
3. Run the smallest useful checks first.
4. Escalate to broader checks when the change risk justifies it.
5. Record command/method, result, and notes.
6. Inspect changed files or artifacts enough to trust the result.
7. Record residual risks, skipped checks, or blockers.
8. If this is a task workspace, update `Verification Evidence`, `Changed Files`, and `Residual Risks`.
9. If the agent believes the task is complete, ask the user how to close it.

## Output Format

```text
Verification Summary
- Success criteria checked:
  - <criterion>: pass | fail | partial | not checked — <evidence>
- Commands/manual checks:
  - <command or method>: pass | fail | not run — <notes>
- Changed files/artifacts:
  - <path>: <purpose>
- Residual risks:
  - <risk or none>
- Completion judgment: complete | not complete | blocked | needs user decision
- Next action: <finish, repair, ask user, run review, defer>
```

## Failure Handling

If verification fails:

- Do not claim completion.
- Record the failure and likely cause.
- Decide whether to repair, re-plan, delegate review, or ask the user.
- Keep task status `in-progress`, `blocked`, or `verifying`.

If verification cannot be run:

- Say why.
- Provide the strongest available manual evidence.
- Record residual risk.
- Avoid overclaiming.

## Sub-Agent Review

Use a review or verification sub-agent when:

- The task is Level 3.
- The implementation is complex or high-risk.
- Fresh context is likely to catch issues.
- The main agent implemented the change and needs independent review.
- There is substantial evidence or logs to inspect.

The main agent still owns final acceptance.

## Task Closure

For Level 2 or Level 3 task workspaces, do not silently close or archive a task.

When the agent believes the task is complete, present:

- Success criteria status.
- Evidence summary.
- Changed files/artifacts.
- Residual risks.
- Follow-up work separated from completed scope.

Then ask the user whether to:

```text
1. Mark complete and archive
2. Mark complete but keep visible
3. Keep in-progress
4. Mark deferred
```

Only update task closure after the user confirms.

## Stop Rules

Stop and ask or report blocked when:

- Acceptance criteria are unclear.
- Evidence contradicts the claimed result.
- Required checks fail.
- Verification requires credentials, services, or approvals not available.
- A product/scope decision is needed before correctness can be judged.
