#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/init.sh <target-directory>

Initialize Ariadne files in a target project without overwriting existing files.

Examples:
  scripts/init.sh /path/to/project
  scripts/init.sh .
USAGE
}

if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

TARGET_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$REPO_ROOT/templates/init/files"

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "Ariadne init template not found: $TEMPLATE_DIR" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

copied=0
skipped=0

while IFS= read -r -d '' source_file; do
  relative_path="${source_file#"$TEMPLATE_DIR/"}"
  target_file="$TARGET_DIR/$relative_path"

  if [[ -e "$target_file" ]]; then
    echo "skip existing: $relative_path"
    skipped=$((skipped + 1))
    continue
  fi

  mkdir -p "$(dirname "$target_file")"
  cp "$source_file" "$target_file"
  echo "copy: $relative_path"
  copied=$((copied + 1))
done < <(find "$TEMPLATE_DIR" -type f -print0 | sort -z)

cat <<SUMMARY

Ariadne init complete.
Target: $TARGET_DIR
Copied: $copied
Skipped existing: $skipped

Next steps:
1. Review AGENTS.md and merge manually if the project already had one.
2. Edit .ai/config.json with the project name.
3. Fill .ai/memory/project-summary.md for the target project.
4. Add project-specific specs under .ai/spec/ when they become authoritative.
5. Decide which Ariadne working-state paths should be ignored by this project's git policy.
SUMMARY
