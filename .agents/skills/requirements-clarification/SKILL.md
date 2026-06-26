# Requirements Clarification Skill

Use this skill when the user's request is important but underspecified.

The goal is not to interrogate the user. Ask the smallest number of high-value questions needed to prevent wrong implementation or wrong scope.

## When To Use

Use when:

- Acceptance criteria are unclear.
- There are multiple materially different implementation paths.
- Product behavior is ambiguous.
- Risk is high enough that assumptions are unsafe.
- The requested scope conflicts with existing constraints.
- A sub-agent handoff would be unsafe without a decision.

Usually do not use when:

- The task is Level 1 and reversible.
- The answer can be found by reading the repo.
- The question would only satisfy process ceremony.
- The user explicitly asked for fast direct work and risk is low.

## Question Budget

- Level 0: ask as needed for discussion.
- Level 1: avoid unless necessary.
- Level 2: usually 1-3 questions.
- Level 3: ask high-value questions and record decisions.

Prefer one good question over many weak ones.

## Good Questions

Good clarification questions:

- Change implementation direction.
- Clarify acceptance criteria.
- Select between meaningful tradeoffs.
- Define non-goals.
- Confirm compatibility or rollout constraints.
- Identify risk tolerance.

Avoid questions that:

- Ask the user to restate obvious context.
- Can be answered by baseline reading.
- Are unrelated to near-term decisions.
- Block a safe reversible edit.

## Option Shape

When asking, provide concrete options when useful:

```text
Question: <specific decision needed>
Recommended: <option> because <reason>
Options:
1. <option> — <tradeoff>
2. <option> — <tradeoff>
3. <option> — <tradeoff>
```

Include a recommendation when the agent has enough context.

## Decision Recording

When the user answers, record the decision where it belongs:

- Level 0/1: final response may be enough.
- Level 2: `task.md` under `Decisions` or relevant section.
- Level 3: `decisions.md` or task `Decisions` section.
- Durable cross-task decisions: propose memory capture into `pending-memory.md`.
- Authoritative project rules: propose update-memory/spec update.

## Output Format

```text
Clarification Need
- Ambiguity: <what is unclear>
- Why it matters: <how it affects scope/implementation/verification>
- Recommended question: <question>
- Options:
  - <option>: <tradeoff>
- If unanswered: <safe default, defer, or block>
- Record answer in: <task/decisions/memory/spec/none>
```

## Handling No Answer

If the user does not answer:

- Use a safe default only when reversible and low-risk.
- Defer the ambiguous part when possible.
- Mark the task blocked when correctness depends on the answer.
- Record assumptions explicitly.

## Stop Rules

Stop and ask before implementation when:

- The answer changes user-visible behavior.
- The answer affects data/security/auth/billing/deployment.
- The answer affects public API or migration behavior.
- The answer determines whether work is in or out of scope.
