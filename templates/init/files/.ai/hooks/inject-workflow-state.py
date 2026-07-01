#!/usr/bin/env python3
"""Emit Ariadne workflow-state context for hook-capable hosts."""

from __future__ import annotations

import os
import re
import sys
from pathlib import Path
from typing import Optional


TAG_RE = re.compile(
    r"\[workflow-state:([A-Za-z0-9_-]+)\]\s*\n(.*?)\n\s*\[/workflow-state:\1\]",
    re.DOTALL,
)


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


def load_templates(root: Path) -> dict[str, str]:
    content = read_text(root / ".ai" / "workflow.md")
    return {match.group(1): match.group(2).strip() for match in TAG_RE.finditer(content)}


def active_task(root: Path) -> Optional[str]:
    pointer = root / ".ai" / "state" / "current-task"
    if not pointer.is_file():
        return None
    value = read_text(pointer).strip().splitlines()
    if not value:
        return None
    return value[0].strip().rstrip("/")


def task_status(root: Path, task_ref: str) -> str:
    task_md = root / task_ref / "task.md"
    if not task_md.is_file():
        return "blocked"
    for line in read_text(task_md).splitlines():
        if line.startswith("- Status:"):
            status = line.split(":", 1)[1].strip()
            return status or "blocked"
    return "blocked"


def build(root: Path) -> str:
    templates = load_templates(root)
    task_ref = active_task(root)
    if not task_ref:
        body = templates.get(
            "no_task",
            "No active task. Classify the request and keep Level 0/1 lightweight.",
        )
        return f"<workflow-state>\nStatus: no_task\n{body}\n</workflow-state>"

    status = task_status(root, task_ref)
    body = templates.get(status)
    if body is None:
        body = templates.get(
            "blocked",
            "Active task state is unavailable. Read task.md and recover before continuing.",
        )
    return (
        "<workflow-state>\n"
        f"Task: {task_ref}\n"
        f"Status: {status}\n"
        f"{body}\n"
        "</workflow-state>"
    )


def main() -> int:
    if os.environ.get("ARIADNE_HOOKS") == "0" or os.environ.get("ARIADNE_DISABLE_HOOKS") == "1":
        return 0
    root = find_root(Path(os.environ.get("PWD", os.getcwd())))
    if root is None:
        return 0
    print(build(root))
    return 0


if __name__ == "__main__":
    sys.exit(main())
