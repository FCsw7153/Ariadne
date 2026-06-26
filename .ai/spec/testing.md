# Testing And Verification Spec

Durable verification expectations belong here.

## Evidence Before Completion

- Rule: Agents must not claim completion without fresh evidence appropriate to task level and risk.
- Rationale: AI coding frequently fails by overclaiming unverified work.
- Applies to: verification skill, task closure, sub-agent reports, final summaries.
- Source: Ariadne workflow and verification skill.
- Verification: Level 2/3 tasks record verification evidence and residual risks before closure.

## User-Confirmed Task Closure

- Rule: Level 2/3 task workspaces should not be silently marked complete or archived by the agent.
- Rationale: The user owns final task closure, especially when multiple tasks may be active.
- Applies to: tasks README, task template, verification skill.
- Source: task closure protocol.
- Verification: Agent presents evidence and closure options before changing closure status.
