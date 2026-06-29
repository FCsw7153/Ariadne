# Pending Memory

Pending memory is the real-time candidate pool for future reusable knowledge.

Do not treat this file as authoritative. Candidates must be consolidated before becoming long-term memory, spec, workflow, or hard rules.

## Inbox

Use Inbox for candidates with no task source, unresolved task source, pure conversation source, or source ambiguity.

### Candidate: <short title>

- Source type: conversation | checkpoint | sub-agent report | task artifact | unknown
- Source task: none | unresolved | `.ai/tasks/<date>-<short-name>/`
- Source path: none | `<path>`
- Source confidence: high | medium | low
- Candidate memory:
  - 
- Why it may matter later:
  - 
- Suggested destination: memory | spec | workflow | AGENTS | task | discard | unresolved
- Status: pending | needs-source-resolution | accepted | moved | rejected
- Notes:
  - 

## Task-Sourced Candidates

Group candidates by explicit source task. Do not attach candidates to a task by guessing.

### `.ai/tasks/<date>-<short-name>/`

#### Candidate: <short title>

- Source type: task artifact | sub-agent report | checkpoint | conversation
- Source path: `.ai/tasks/<date>-<short-name>/<artifact>.md`
- Source confidence: high | medium | low
- Candidate memory:
  - 
- Why it may matter later:
  - 
- Suggested destination: memory | spec | workflow | AGENTS | task | discard | unresolved
- Status: pending | needs-source-resolution | accepted | moved | rejected
- Notes:
  - 

## Consolidation Log

Record candidate movements so future agents can understand what happened.

| Date | Candidate | Source | Destination | Result | Notes |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |
