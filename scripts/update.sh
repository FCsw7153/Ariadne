#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/update.sh [options] <target-directory>

Safely update Ariadne managed files in a target project.

Options:
  --dry-run       Show what would change without writing files
  --force         Overwrite user-modified managed files
  --skip-all      Preserve all user-modified managed files
  --create-new    Write new template content as <file>.new for modified files

Examples:
  scripts/update.sh --dry-run /path/to/project
  scripts/update.sh /path/to/project
USAGE
}

if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$REPO_ROOT/templates/init/files"
VERSION_FILE="$REPO_ROOT/VERSION"
UPDATER="$TEMPLATE_DIR/.ai/scripts/ariadne-update.sh"

if [[ ! -x "$UPDATER" ]]; then
  echo "Ariadne updater not found or not executable: $UPDATER" >&2
  exit 1
fi

exec "$UPDATER" --template-dir "$TEMPLATE_DIR" --version-file "$VERSION_FILE" "$@"
