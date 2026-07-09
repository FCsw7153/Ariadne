---
name: goal-framing
description: Turn broad or non-trivial user requests into decision-grade goals, success criteria, non-goals, constraints, risks, and open questions. Use before planning, delegation, specs, or implementation when success is not obvious.
---

# Goal Framing Skill

Use this skill when a user request needs to become a clear task before planning, delegation, or implementation.

Goal framing turns broad intent into decision-grade context: goal, success criteria, non-goals, constraints, risks, and open questions.

## When To Use

Use for:

- New features.
- Meaningful refactors.
- Ambiguous requests.
- Large docs or method changes.
- Level 2 and Level 3 tasks.
- Any request where success is not obvious.

Usually skip for:

- Level 0 discussion that stays exploratory.
- Level 1 small fixes with obvious success criteria.

## Process

1. Restate the user's intent in one sentence.
2. Identify the workflow level or ask task-router to classify it.
3. List success criteria that can be verified.
4. List non-goals to prevent scope creep.
5. Identify hard constraints and assumptions.
6. Identify risks and unknowns.
7. Decide whether clarification is needed before baseline reading.
8. Write the frame into `task.md` for Level 2/3 work when a task workspace exists.

## Output Format

```text
Goal Frame
- Goal: <one sentence>
- Success criteria:
  - <verifiable outcome>
- Non-goals:
  - <explicitly out of scope>
- Constraints:
  - <hard rule or assumption>
- Risks:
  - <risk that affects approach>
- Open questions:
  - <question or none>
- Suggested level: 0 | 1 | 2 | 3
- Next action: clarify | baseline read | spec | implement | delegate | answer
```

## Good Success Criteria

A good success criterion is:

- Observable.
- Testable or reviewable.
- Tied to the user's goal.
- Specific enough to prevent false completion.

Weak:

```text
Make it better.
```

Stronger:

```text
Level 2 tasks have a single-file task template with success criteria, baseline readset, plan, evidence, and residual risks.
```

## Non-Goals

Use non-goals to protect scope.

Common non-goals:

- Do not build a platform/runtime.
- Do not change unrelated files.
- Do not add automation yet.
- Do not solve future phases in this task.
- Do not make platform-specific assumptions.

## Risk Framing

Escalate or clarify when risks involve:

- Data loss.
- Security or privacy.
- Architecture drift.
- Migration or deployment.
- User-visible behavior.
- Long-running context loss.
- Multiple sub-agent writers.

## Task Artifact Update

When using a task workspace, write or update:

- `Intent`
- `Success Criteria`
- `Non-Goals`
- `Constraints`
- `Open Questions`
- `Residual Risks`

Keep it concise. Do not paste the full conversation.

## Stop Rules

Stop and ask the user when:

- The goal is ambiguous and implementation would likely be wrong.
- Success criteria cannot be inferred.
- Non-goals are necessary to avoid scope creep.
- A product/architecture decision is required before planning.
