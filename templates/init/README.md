# Ariadne Init Template

This directory contains the clean template used to initialize Ariadne in a target project.

It is different from the Ariadne framework repository root:

- The repository root documents and develops Ariadne itself.
- `templates/init/files/` contains project-neutral files safe to copy into another project.

## What Gets Installed

```text
AGENTS.md
.agents/skills/
.ai/workflow.md
.ai/ariadne-version
.ai/config.json
.ai/hooks/
.ai/scripts/
.ai/state/README.md
.ai/templates/
.ai/tasks/README.md
.ai/agents/README.md
.ai/memory/
.ai/spec/README.md
.ai/repo-map/index.md
```

`scripts/init.sh` also generates `.ai/ariadne-template-hashes.json` in the target project. That file is update metadata, not a static template file.

The init template intentionally does not include Ariadne's own framework-specific spec files or README.

## Manual Init

From the Ariadne repository root:

```bash
./scripts/init.sh /path/to/target-project
```

The script copies missing files only, except `AGENTS.md`: it appends or refreshes the Ariadne managed block between `ARIADNE:START` and `ARIADNE:END`.

## Manual Update

From the Ariadne repository root:

```bash
./scripts/update.sh --dry-run /path/to/target-project
./scripts/update.sh /path/to/target-project
```

Update behavior:

- New managed files are added.
- Managed files whose current hash matches the installed hash are auto-updated.
- User-modified managed files are preserved by default.
- User-deleted managed files remain deleted.
- `AGENTS.md` updates only the Ariadne managed block.

Conflict flags:

- `--force` overwrites user-modified managed files.
- `--create-new` writes new template content to `<file>.new`.
- `--skip-all` preserves all user-modified files explicitly.

Protected project data is not template-managed by update:

```text
.ai/config.json
.ai/tasks/
.ai/spec/
.ai/repo-map/
.ai/memory/pending-memory.md
.ai/memory/project-summary.md
.ai/memory/recurring-decisions.md
.ai/memory/known-pitfalls.md
.ai/state/current-task
```

## Existing AGENTS.md

If the target project already has `AGENTS.md`, the init script preserves existing content and updates only the Ariadne managed block.

Behavior:

- If no Ariadne block exists, append one to the end of `AGENTS.md`.
- If an Ariadne block exists, replace only that block with the current template.
- Keep project-specific instructions outside the managed block so future init runs preserve them.

## Git Tracking Guidance

Ariadne framework files and durable project rules may be tracked when intentionally adopted.

If a project tracks Ariadne framework files, it should also track:

```text
.ai/ariadne-version
.ai/ariadne-template-hashes.json
```

These files are the update baseline that lets Ariadne distinguish framework template changes from user edits.

Ariadne working state should usually stay local:

```text
.ai/tasks/<active-task>/
.ai/memory/pending-memory.md
.ai/state/current-task
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
