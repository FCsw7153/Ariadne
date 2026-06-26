# Coding Style Spec

Durable coding and documentation style rules belong here.

## Documentation Style

- Rule: Prefer concise, decision-grade Markdown over transcript-style notes.
- Rationale: Ariadne artifacts should help future agents recover context quickly.
- Applies to: task artifacts, memory, specs, sub-agent reports.
- Source: workflow/task/memory design.
- Verification: New templates ask for summaries, evidence, risks, and decisions rather than raw chat logs.

## Platform Neutrality

- Rule: Method-layer docs should avoid platform-specific delegation APIs.
- Rationale: Ariadne should work across host environments.
- Applies to: README, workflow, skills, templates, agent delegation docs.
- Source: sub-agent design decisions.
- Verification: Generic docs describe native delegation mechanisms rather than a specific runtime API.
