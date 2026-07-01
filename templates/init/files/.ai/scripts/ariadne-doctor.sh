#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: .ai/scripts/ariadne-doctor.sh

Check whether Ariadne guardrail files are installed and internally consistent.
USAGE
}

find_root() {
  local dir="${PWD}"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.ai" ]]; then
      printf '%s\n' "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  echo "Ariadne root not found: no .ai directory above $PWD" >&2
  return 1
}

require_file() {
  local root="$1"
  local path="$2"
  if [[ ! -f "$root/$path" ]]; then
    echo "missing file: $path"
    return 1
  fi
}

require_dir() {
  local root="$1"
  local path="$2"
  if [[ ! -d "$root/$path" ]]; then
    echo "missing directory: $path"
    return 1
  fi
}

require_grep() {
  local root="$1"
  local path="$2"
  local pattern="$3"
  if ! grep -q "$pattern" "$root/$path"; then
    echo "missing pattern in $path: $pattern"
    return 1
  fi
}

main() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    return 0
  fi

  local root
  local failures=0
  root="$(find_root)"

  echo "Ariadne doctor: $root"

  for dir in ".ai" ".ai/hooks" ".ai/scripts" ".ai/state" ".ai/tasks" ".ai/memory" ".ai/templates" ".agents/skills"; do
    require_dir "$root" "$dir" || failures=$((failures + 1))
  done

  for file in \
    "AGENTS.md" \
    ".ai/workflow.md" \
    ".ai/hooks/README.md" \
    ".ai/hooks/inject-workflow-state.py" \
    ".ai/hooks/pre-compact-save.py" \
    ".ai/hooks/post-compact-restore.py" \
    ".ai/scripts/ariadne-task.sh" \
    ".ai/scripts/ariadne-doctor.sh" \
    ".ai/scripts/ariadne-update.sh" \
    ".ai/ariadne-version" \
    ".ai/ariadne-template-hashes.json" \
    ".ai/state/README.md" \
    ".ai/templates/task.md" \
    ".ai/memory/pending-memory.md"; do
    require_file "$root" "$file" || failures=$((failures + 1))
  done

  require_grep "$root" "AGENTS.md" "<!-- ARIADNE:START -->" || failures=$((failures + 1))
  require_grep "$root" "AGENTS.md" "<!-- ARIADNE:END -->" || failures=$((failures + 1))
  require_grep "$root" "AGENTS.md" "Hook Gate" || failures=$((failures + 1))
  require_grep "$root" "AGENTS.md" "No-Interrupt" || failures=$((failures + 1))

  for state in no_task planning in-progress verifying blocked; do
    require_grep "$root" ".ai/workflow.md" "\\[workflow-state:$state\\]" || failures=$((failures + 1))
  done

  require_grep "$root" ".ai/templates/task.md" "Sub-agent decision:" || failures=$((failures + 1))
  require_grep "$root" ".ai/templates/task.md" "Memory decision:" || failures=$((failures + 1))
  require_grep "$root" ".ai/templates/task.md" "Interrupt Log" || failures=$((failures + 1))
  require_grep "$root" ".ai/memory/pending-memory.md" "## Task-Sourced Candidates" || failures=$((failures + 1))
  require_grep "$root" ".ai/ariadne-template-hashes.json" '"__version"' || failures=$((failures + 1))
  require_grep "$root" ".ai/ariadne-template-hashes.json" '"hashes"' || failures=$((failures + 1))

  if command -v bash >/dev/null 2>&1; then
    bash -n "$root/.ai/scripts/ariadne-task.sh" || failures=$((failures + 1))
    bash -n "$root/.ai/scripts/ariadne-doctor.sh" || failures=$((failures + 1))
    bash -n "$root/.ai/scripts/ariadne-update.sh" || failures=$((failures + 1))
  fi

  if command -v python3 >/dev/null 2>&1; then
    PYTHONPYCACHEPREFIX="${PYTHONPYCACHEPREFIX:-${TMPDIR:-/tmp}/ariadne-pycache}" python3 -m py_compile \
      "$root/.ai/hooks/inject-workflow-state.py" \
      "$root/.ai/hooks/pre-compact-save.py" \
      "$root/.ai/hooks/post-compact-restore.py" || failures=$((failures + 1))
  else
    echo "warning: python3 not found; hook syntax not checked"
  fi

  if [[ "$failures" -eq 0 ]]; then
    echo "OK: Ariadne guardrails are installed"
    return 0
  fi

  echo "FAILED: $failures issue(s)"
  return 1
}

main "$@"
