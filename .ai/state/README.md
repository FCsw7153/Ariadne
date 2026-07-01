# Ariadne State

This directory stores lightweight runtime state for Ariadne guardrails.

Tracked template files should stay small. Runtime files are created by scripts
or hooks and may be ignored by project git policy.

## Runtime Files

- `current-task` — repo-relative path to the active task workspace, for example
  `.ai/tasks/2026-06-30-example/`.

## Rule

State files are recovery hints, not durable project knowledge. Durable decisions
belong in task artifacts, `.ai/spec/`, or consolidated memory.
