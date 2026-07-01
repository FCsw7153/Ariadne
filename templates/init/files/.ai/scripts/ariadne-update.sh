#!/usr/bin/env bash
set -euo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  echo "ariadne-update requires python3" >&2
  exit 1
fi

exec python3 - "$@" <<'PY'
from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys
from pathlib import Path


BLOCK_START = "<!-- ARIADNE:START -->"
BLOCK_END = "<!-- ARIADNE:END -->"
HASH_SCHEMA_VERSION = 1

PROTECTED_EXACT = {
    ".ai/ariadne-template-hashes.json",
    ".ai/config.json",
    ".ai/memory/known-pitfalls.md",
    ".ai/memory/pending-memory.md",
    ".ai/memory/project-summary.md",
    ".ai/memory/recurring-decisions.md",
    ".ai/state/current-task",
}

PROTECTED_PREFIXES = (
    ".ai/repo-map/",
    ".ai/spec/",
    ".ai/tasks/",
)

SPECIAL_TEMPLATE_FILES = {
    "AGENTS.md",
    ".ai/ariadne-version",
}


def posix(path: Path | str) -> str:
    return str(path).replace(os.sep, "/")


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    if path.suffix in {".sh", ".py"}:
        path.chmod(0o755)


def content_hash(content: str) -> str:
    normalized = content.replace("\r\n", "\n")
    return hashlib.sha256(normalized.encode("utf-8")).hexdigest()


def is_protected(rel: str) -> bool:
    if rel in PROTECTED_EXACT:
        return True
    return any(rel == prefix.rstrip("/") or rel.startswith(prefix) for prefix in PROTECTED_PREFIXES)


def load_hashes(root: Path) -> dict[str, str]:
    path = root / ".ai" / "ariadne-template-hashes.json"
    if not path.is_file():
        return {}
    try:
        parsed = json.loads(read_text(path))
    except (OSError, json.JSONDecodeError):
        return {}
    if isinstance(parsed, dict) and parsed.get("__version") == HASH_SCHEMA_VERSION:
        hashes = parsed.get("hashes")
        if isinstance(hashes, dict):
            return {posix(k): str(v) for k, v in hashes.items()}
    if isinstance(parsed, dict) and "hashes" not in parsed:
        return {posix(k): str(v) for k, v in parsed.items()}
    return {}


def save_hashes(root: Path, hashes: dict[str, str]) -> None:
    path = root / ".ai" / "ariadne-template-hashes.json"
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "__version": HASH_SCHEMA_VERSION,
        "hashes": {key: hashes[key] for key in sorted(hashes)},
    }
    path.write_text(json.dumps(payload, indent=2, sort_keys=False) + "\n", encoding="utf-8")


def source_version(template_dir: Path, version_file: Path | None) -> str:
    candidates = []
    if version_file is not None:
        candidates.append(version_file)
    candidates.append(template_dir / ".ai" / "ariadne-version")
    for candidate in candidates:
        if candidate.is_file():
            value = read_text(candidate).strip()
            if value:
                return value
    return "unknown"


def installed_version(root: Path) -> str:
    path = root / ".ai" / "ariadne-version"
    if path.is_file():
        value = read_text(path).strip()
        if value:
            return value
    return "unknown"


def write_version(root: Path, version: str) -> None:
    write_text(root / ".ai" / "ariadne-version", version + "\n")


def template_files(template_dir: Path) -> tuple[dict[str, str], list[str]]:
    files: dict[str, str] = {}
    protected: list[str] = []
    for path in sorted(template_dir.rglob("*")):
        if not path.is_file():
            continue
        rel = posix(path.relative_to(template_dir))
        if rel in SPECIAL_TEMPLATE_FILES:
            continue
        if is_protected(rel):
            protected.append(rel)
            continue
        files[rel] = read_text(path)
    return files, protected


def managed_block(content: str) -> str | None:
    start = content.find(BLOCK_START)
    if start == -1:
        return None
    end = content.find(BLOCK_END, start)
    if end == -1:
        return None
    return content[start : end + len(BLOCK_END)]


def upsert_agents_content(existing: str | None, template: str) -> str:
    if existing is None:
        return template
    template_block = managed_block(template)
    if template_block is None:
        return template

    start = existing.find(BLOCK_START)
    if start != -1:
        end = existing.find(BLOCK_END, start)
        if end != -1:
            return existing[:start] + template_block + existing[end + len(BLOCK_END) :]

    return existing.rstrip() + "\n\n" + template_block + "\n"


def analyze(root: Path, files: dict[str, str], hashes: dict[str, str]) -> dict[str, list[str]]:
    result = {
        "new": [],
        "unchanged": [],
        "auto_update": [],
        "modified": [],
        "user_deleted": [],
    }

    for rel, desired in files.items():
        target = root / rel
        desired_hash = content_hash(desired)
        if not target.exists():
            if rel in hashes:
                result["user_deleted"].append(rel)
            else:
                result["new"].append(rel)
            continue

        current = read_text(target)
        current_hash = content_hash(current)
        if current_hash == desired_hash:
            result["unchanged"].append(rel)
            continue

        if hashes.get(rel) == current_hash:
            result["auto_update"].append(rel)
        else:
            result["modified"].append(rel)

    return result


def print_list(title: str, items: list[str], marker: str) -> None:
    if not items:
        return
    print(f"  {title}:")
    for item in items:
        print(f"    {marker} {item}")
    print()


def refresh_hashes(root: Path, files: dict[str, str], hashes: dict[str, str]) -> int:
    count = 0
    for rel, desired in files.items():
        target = root / rel
        if target.is_file() and content_hash(read_text(target)) == content_hash(desired):
            hashes[rel] = content_hash(desired)
            count += 1
    save_hashes(root, hashes)
    return count


def main() -> int:
    parser = argparse.ArgumentParser(
        prog="ariadne-update",
        description="Safely update Ariadne managed files in a target project.",
    )
    parser.add_argument("target", nargs="?", default=".")
    parser.add_argument("--template-dir", default=os.environ.get("ARIADNE_TEMPLATE_DIR"))
    parser.add_argument("--version-file", default=os.environ.get("ARIADNE_SOURCE_VERSION_FILE"))
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--force", action="store_true", help="overwrite user-modified managed files")
    parser.add_argument("--skip-all", action="store_true", help="skip all user-modified managed files")
    parser.add_argument("--create-new", action="store_true", help="write new template content as <file>.new for modified files")
    parser.add_argument("--refresh-hashes", action="store_true", help="refresh version/hash tracking without changing managed files")
    args = parser.parse_args()

    conflict_modes = [args.force, args.skip_all, args.create_new]
    if sum(1 for enabled in conflict_modes if enabled) > 1:
        print("Choose at most one of --force, --skip-all, or --create-new.", file=sys.stderr)
        return 2

    root = Path(args.target).resolve()
    template_dir = Path(args.template_dir).resolve() if args.template_dir else None
    version_file = Path(args.version_file).resolve() if args.version_file else None

    if template_dir is None or not template_dir.is_dir():
        print("Ariadne template directory not found. Pass --template-dir or set ARIADNE_TEMPLATE_DIR.", file=sys.stderr)
        return 1
    if not root.exists():
        print(f"Target does not exist: {root}", file=sys.stderr)
        return 1

    files, protected = template_files(template_dir)
    hashes = load_hashes(root)
    next_version = source_version(template_dir, version_file)
    previous_version = installed_version(root)

    print(f"Ariadne update: {root}")
    print(f"Version: {previous_version} -> {next_version}")
    print()

    if args.refresh_hashes:
        if not args.dry_run:
            write_version(root, next_version)
            count = refresh_hashes(root, files, hashes)
            print(f"Refreshed template hashes for {count} managed file(s).")
            print("OK: Ariadne update metadata is current.")
        else:
            print("[Dry run] Would refresh version/hash metadata.")
        return 0

    analysis = analyze(root, files, hashes)

    agents_template_path = template_dir / "AGENTS.md"
    agents_status = "missing-template"
    agents_desired = None
    if agents_template_path.is_file():
        target_agents = root / "AGENTS.md"
        template = read_text(agents_template_path)
        existing = read_text(target_agents) if target_agents.is_file() else None
        agents_desired = upsert_agents_content(existing, template)
        if existing is None:
            agents_status = "new"
        elif existing == agents_desired:
            agents_status = "unchanged"
        else:
            agents_status = "managed-block-update"

    print("Scanning managed files...")
    if agents_status == "new":
        print("  AGENTS.md:")
        print("    + AGENTS.md")
        print()
    elif agents_status == "managed-block-update":
        print("  AGENTS.md:")
        print("    ^ AGENTS.md managed block")
        print()

    print_list("New files (will add)", analysis["new"], "+")
    print_list("Template updated (will auto-update)", analysis["auto_update"], "^")
    print_list("Modified by you (will preserve unless overridden)", analysis["modified"], "?")
    print_list("Deleted by you (preserved)", analysis["user_deleted"], "x")
    print_list("Protected project data (not template-managed)", protected, "o")

    if args.dry_run:
        print("[Dry run] No changes made.")
        return 0

    added = auto_updated = overwritten = created_new = skipped = agents_updated = 0

    if agents_desired is not None and agents_status in {"new", "managed-block-update"}:
        write_text(root / "AGENTS.md", agents_desired)
        agents_updated = 1

    for rel in analysis["new"]:
        write_text(root / rel, files[rel])
        added += 1

    for rel in analysis["auto_update"]:
        write_text(root / rel, files[rel])
        auto_updated += 1

    for rel in analysis["modified"]:
        target = root / rel
        if args.force:
            write_text(target, files[rel])
            overwritten += 1
        elif args.create_new:
            write_text(Path(str(target) + ".new"), files[rel])
            created_new += 1
        else:
            skipped += 1

    refresh_hashes(root, files, hashes)
    write_version(root, next_version)

    print("--- Summary ---")
    if agents_updated:
        print("  AGENTS managed block updated: 1")
    if added:
        print(f"  Added: {added}")
    if auto_updated:
        print(f"  Auto-updated: {auto_updated}")
    if overwritten:
        print(f"  Overwritten: {overwritten}")
    if created_new:
        print(f"  Created .new files: {created_new}")
    if skipped:
        print(f"  Preserved modified files: {skipped}")
    if not any([agents_updated, added, auto_updated, overwritten, created_new, skipped]):
        print("  Already up to date.")
    print("OK: Ariadne update complete.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
PY
