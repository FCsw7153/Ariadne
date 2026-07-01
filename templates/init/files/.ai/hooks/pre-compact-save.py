#!/usr/bin/env python3
"""Save an Ariadne task checkpoint before context compaction."""

from __future__ import annotations

import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Optional


def find_root(start: Path) -> Optional[Path]:
    cur = start.resolve()
    while cur != cur.parent:
        if (cur / ".ai").is_dir():
            return cur
        cur = cur.parent
    return None


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except OSError:
        return ""


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def active_task(root: Path) -> Optional[str]:
    pointer = root / ".ai" / "state" / "current-task"
    if not pointer.is_file():
        return None
    lines = read_text(pointer).strip().splitlines()
    if not lines:
        return None
    return lines[0].strip().rstrip("/")


def task_status(task_md: Path) -> str:
    for line in read_text(task_md).splitlines():
        if line.startswith("- Status:"):
            return line.split(":", 1)[1].strip() or "unknown"
    return "unknown"


def section(content: str, name: str, limit: int = 80) -> str:
    lines = content.splitlines()
    out: list[str] = []
    inside = False
    for line in lines:
        if line == f"## {name}":
            inside = True
            continue
        if inside and line.startswith("## "):
            break
        if inside:
            out.append(line)
            if len(out) >= limit:
                out.append("...[truncated]")
                break
    text = "\n".join(out).strip()
    return text if text else "(none recorded)"


def git_dirty(root: Path) -> str:
    try:
        result = subprocess.run(
            ["git", "status", "--short"],
            cwd=str(root),
            text=True,
            capture_output=True,
            timeout=5,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired):
        return "(git unavailable)"
    if result.returncode != 0:
        return "(not a git worktree)"
    return result.stdout.strip() or "(clean)"


def append_pending_memory(root: Path, task_ref: str, checkpoint_ref: str, stamp: str) -> None:
    pending = root / ".ai" / "memory" / "pending-memory.md"
    if not pending.is_file():
        print(f"warning: pending memory missing: {pending}", file=sys.stderr)
        return

    candidate = f"""
### `{task_ref}/`

#### Candidate: Compact checkpoint {stamp}

- Source type: checkpoint
- Source path: `{checkpoint_ref}`
- Source confidence: high
- Candidate memory:
  - Ariadne saved a compact recovery checkpoint before context compression. Review the source checkpoint before deciding whether any durable knowledge should be promoted.
- Why it may matter later:
  - It helps future agents recover task state after compaction without relying on chat history.
- Suggested destination: task
- Status: pending
- Notes:
  - Automatically added by `.ai/hooks/pre-compact-save.py`.
"""

    content = read_text(pending)
    marker = "\n## Consolidation Log\n"
    if marker in content:
        content = content.replace(marker, candidate + marker, 1)
    else:
        content = content.rstrip() + "\n" + candidate + "\n"
    write_text(pending, content)


def task_dir_for(root: Path, task_ref: str) -> Path:
    task_path = Path(task_ref)
    return task_path if task_path.is_absolute() else root / task_ref


def display_path(root: Path, path: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return path.as_posix()


def save_checkpoint(root: Path, task_ref: str) -> Path:
    task_dir = task_dir_for(root, task_ref)
    task_md = task_dir / "task.md"
    content = read_text(task_md)
    stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    checkpoint = task_dir / "checkpoints" / f"compact-{stamp}.md"
    checkpoint_ref = display_path(root, checkpoint)
    status = task_status(task_md)

    body = f"""# Compact Checkpoint: {stamp}

- Task: `{task_ref}`
- Status: {status}
- Created: {datetime.now().astimezone().isoformat(timespec="seconds")}

## Current Plan

{section(content, "Plan")}

## Open Questions

{section(content, "Open Questions")}

## Decisions

{section(content, "Decisions")}

## Sub-Agent State

{section(content, "Sub-Agent Handoffs")}

## Verification State

{section(content, "Verification Evidence")}

## Memory State

{section(content, "Memory / Spec Candidates")}

## Git Dirty Summary

{git_dirty(root)}

## Recovery Notes

- Continue from `task.md` first.
- Re-run relevant verification before claiming completion.
- Review pending memory candidates before consolidation.
"""
    write_text(checkpoint, body)
    append_pending_memory(root, task_ref, checkpoint_ref, stamp)
    return checkpoint


def main() -> int:
    if os.environ.get("ARIADNE_HOOKS") == "0" or os.environ.get("ARIADNE_DISABLE_HOOKS") == "1":
        return 0
    root = find_root(Path(os.environ.get("PWD", os.getcwd())))
    if root is None:
        return 0
    task_ref = active_task(root)
    if task_ref is None:
        print("<ariadne-pre-compact>No active task; no checkpoint written.</ariadne-pre-compact>")
        return 0
    task_dir = task_dir_for(root, task_ref)
    task_md = task_dir / "task.md"
    if not task_dir.is_dir() or not task_md.is_file():
        print(
            "<ariadne-pre-compact>\n"
            f"Active task is stale or incomplete: {task_ref}\n"
            "No checkpoint written. Repair `.ai/state/current-task` or restore the task artifact before compacting.\n"
            "</ariadne-pre-compact>"
        )
        return 0
    checkpoint = save_checkpoint(root, task_ref)
    print(
        "<ariadne-pre-compact>\n"
        f"Checkpoint written: {display_path(root, checkpoint)}\n"
        "Pending memory candidate added for review.\n"
        "</ariadne-pre-compact>"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
