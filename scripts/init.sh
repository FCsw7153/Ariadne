#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/init.sh <target-directory>

Initialize Ariadne files in a target project.

The script copies missing files only, and merge-updates the Ariadne managed
block in AGENTS.md when that file already exists. It also refreshes Ariadne
version/hash metadata for safe future updates.

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
VERSION_FILE="$REPO_ROOT/VERSION"

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "Ariadne init template not found: $TEMPLATE_DIR" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

copied=0
skipped=0
updated=0

upsert_agents_file() {
  local target_file="$1"
  local template_file="$2"

  if [[ ! -e "$target_file" ]]; then
    mkdir -p "$(dirname "$target_file")"
    cp "$template_file" "$target_file"
    echo "copy: AGENTS.md"
    copied=$((copied + 1))
    return
  fi

  if grep -q '<!-- ARIADNE:START -->' "$target_file" && grep -q '<!-- ARIADNE:END -->' "$target_file"; then
    local tmp_file
    tmp_file="$(mktemp)"
    awk '
      NR == FNR { block = block $0 ORS; next }
      /<!-- ARIADNE:START -->/ { printf "%s", block; skipping = 1; next }
      /<!-- ARIADNE:END -->/ { skipping = 0; next }
      !skipping { print }
    ' "$template_file" "$target_file" > "$tmp_file"
    mv "$tmp_file" "$target_file"
    echo "update Ariadne block: AGENTS.md"
  else
    {
      printf '\n'
      cat "$template_file"
    } >> "$target_file"
    echo "append Ariadne block: AGENTS.md"
  fi

  updated=$((updated + 1))
}

upsert_agents_file "$TARGET_DIR/AGENTS.md" "$TEMPLATE_DIR/AGENTS.md"

while IFS= read -r -d '' source_file; do
  relative_path="${source_file#"$TEMPLATE_DIR/"}"
  target_file="$TARGET_DIR/$relative_path"

  if [[ "$relative_path" == "AGENTS.md" ]]; then
    continue
  fi

  if [[ -e "$target_file" ]]; then
    echo "skip existing: $relative_path"
    skipped=$((skipped + 1))
    continue
  fi

  mkdir -p "$(dirname "$target_file")"
  cp "$source_file" "$target_file"
  case "$relative_path" in
    *.sh|*.py) chmod 755 "$target_file" ;;
  esac
  echo "copy: $relative_path"
  copied=$((copied + 1))
done < <(find "$TEMPLATE_DIR" -type f -print0 | sort -z)

if [[ -x "$TARGET_DIR/.ai/scripts/ariadne-update.sh" ]]; then
  "$TARGET_DIR/.ai/scripts/ariadne-update.sh" \
    --refresh-hashes \
    --template-dir "$TEMPLATE_DIR" \
    --version-file "$VERSION_FILE" \
    "$TARGET_DIR"
else
  echo "warning: updater missing; version/hash metadata was not refreshed" >&2
fi

cat <<SUMMARY

Ariadne init complete.
Target: $TARGET_DIR
Copied: $copied
Updated managed blocks: $updated
Skipped existing: $skipped
Update metadata: .ai/ariadne-version and .ai/ariadne-template-hashes.json

Next steps:
1. Review AGENTS.md if the project already had custom instructions.
2. Edit .ai/config.json with the project name.
3. Fill .ai/memory/project-summary.md for the target project.
4. Add project-specific specs under .ai/spec/ when they become authoritative.
5. Decide which Ariadne working-state paths should be ignored by this project's git policy.
SUMMARY
