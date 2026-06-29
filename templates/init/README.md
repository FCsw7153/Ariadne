# Ariadne Init Template

This directory contains the clean template used to initialize Ariadne in a target project.

It is different from the Ariadne framework repository root:

- The repository root documents and develops Ariadne itself.
- `templates/init/files/` contains project-neutral files safe to copy into another project.

## What Gets Installed

```text
AGENTS.md
CLAUDE.md
.agents/skills/
.ai/workflow.md
.ai/config.json
.ai/templates/
.ai/tasks/README.md
.ai/agents/README.md
.ai/memory/
.ai/spec/README.md
.ai/repo-map/index.md
.ai/hooks/README.md
```

The init template intentionally does not include Ariadne's own framework-specific spec files or README.

## Manual Init

From the Ariadne repository root:

```bash
./scripts/init.sh /path/to/target-project
```

The script copies missing files only. It does not overwrite existing files.

## Existing AGENTS.md

If the target project already has `AGENTS.md`, do not blindly overwrite it.

Use one of these approaches:

- Manually merge the `ARIADNE:START` block into the existing file.
- Keep the existing file and copy Ariadne instructions to `AGENTS.ariadne.md` for manual review.
- Use a future merge-aware init command.

## Git Tracking Guidance

Ariadne framework files and durable project rules may be tracked when intentionally adopted.

Ariadne working state should usually stay local:

```text
.ai/tasks/<active-task>/
.ai/memory/pending-memory.md
sub-agent reports
checkpoints
runtime logs
```

Use project-specific `.gitignore` rules based on team preference.

## Modes

### Embedded Mode

Ariadne files live inside the target project.

```text
target-project/
  AGENTS.md
  .agents/
  .ai/
  src/
```

Use this when the project should carry its AI coding workflow with it.

### External Workspace Mode

Ariadne working files live outside the target repo, and the target repo is cloned inside or referenced by the workspace.

```text
workspace/
  AGENTS.md
  .agents/
  .ai/
  repos/
    target-project/
```

Use this when you want AI working state outside the target project's git repository.
