#!/usr/bin/env python3
"""Restore compact Ariadne context after context compaction."""

from __future__ import annotations

import os
import sys
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


def latest_checkpoint(task_dir: Path) -> Optional[Path]:
    checkpoint_dir = task_dir / "checkpoints"
    if not checkpoint_dir.is_dir():
        return None
    checkpoints = sorted(checkpoint_dir.glob("compact-*.md"))
    return checkpoints[-1] if checkpoints else None


def task_dir_for(root: Path, task_ref: str) -> Path:
    task_path = Path(task_ref)
    return task_path if task_path.is_absolute() else root / task_ref


def display_path(root: Path, path: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return path.as_posix()


def excerpt(path: Path, max_chars: int = 4000) -> str:
    text = read_text(path).strip()
    if len(text) <= max_chars:
        return text
    return text[:max_chars] + f"\n...[truncated {len(text) - max_chars} chars]"


def main() -> int:
    if os.environ.get("ARIADNE_HOOKS") == "0" or os.environ.get("ARIADNE_DISABLE_HOOKS") == "1":
        return 0
    root = find_root(Path(os.environ.get("PWD", os.getcwd())))
    if root is None:
        return 0

    task_ref = active_task(root)
    if task_ref is None:
        print(
            "<ariadne-compact-restore>\n"
            "No active task. Classify the next request from `.ai/workflow.md` and keep Level 0/1 lightweight.\n"
            "</ariadne-compact-restore>"
        )
        return 0

    task_dir = task_dir_for(root, task_ref)
    task_md = task_dir / "task.md"
    if not task_dir.is_dir() or not task_md.is_file():
        print(
            "<ariadne-compact-restore>\n"
            f"Active task is stale or incomplete: {task_ref}\n"
            "Status: blocked\n"
            "Latest checkpoint: (unavailable because task artifact is missing)\n\n"
            "Next: repair `.ai/state/current-task`, restore the task artifact, or clear the active task before continuing.\n"
            "</ariadne-compact-restore>"
        )
        return 0
    status = task_status(task_md)
    checkpoint = latest_checkpoint(task_dir)
    checkpoint_text = "(no compact checkpoint found)"
    checkpoint_path = "(none)"
    if checkpoint is not None:
        checkpoint_path = display_path(root, checkpoint)
        checkpoint_text = excerpt(checkpoint)

    print(
        "<ariadne-compact-restore>\n"
        f"Task: {task_ref}\n"
        f"Status: {status}\n"
        f"Latest checkpoint: {checkpoint_path}\n\n"
        f"{checkpoint_text}\n\n"
        "Next: read task.md, continue from the checkpoint, and re-run verification before claiming completion.\n"
        "</ariadne-compact-restore>"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
