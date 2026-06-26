# Hooks

Hooks are optional deterministic guardrails.

Ariadne should work without hooks. Add hooks only after the manual workflow proves useful and the rule is deterministic enough to automate.

## Appropriate Hook Uses

Good hooks:

- Save task state before context compaction.
- Restore minimal task context after compaction.
- Guard protected files or dangerous commands.
- Remind agents to record verification evidence.
- Inject compact project/task context.
- Warn when a Level 2/3 task appears complete but closure has not been confirmed by the user.

Bad hooks:

- Complex product reasoning.
- Automatic long-term memory promotion.
- Silent task archival.
- Hidden implementation changes.
- Platform-specific behavior in generic method docs.

## Candidate Hooks

| Hook | Purpose | Status |
| --- | --- | --- |
| pre-compact-save | Save task, decisions, modified files, and open questions | idea |
| post-compact-inject | Restore minimal current task context | idea |
| pre-tool-guard | Warn or block protected files/actions | idea |
| stop-verification | Remind agent not to claim completion without evidence | idea |
| task-closure-reminder | Ask user before completing/archiving task | idea |
| pending-memory-capture | Suggest memory capture for durable candidates | idea |

## Rule

Hooks may enforce deterministic guardrails, but strategic decisions remain with the main agent and user.
