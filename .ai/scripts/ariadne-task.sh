#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: .ai/scripts/ariadne-task.sh <command> [args]

Commands:
  start <task>       Set the active task pointer and mark task.md in-progress when possible
  current           Print the active task path
  finish            Clear the active task pointer
  validate [task]   Validate a Level 2/3 task artifact for closure readiness
  checkpoint [task] Write a compact recovery checkpoint for a task

Task arguments may be .ai/tasks/<name>, .ai/tasks/<name>/, an absolute path, or
just <name> for a directory under .ai/tasks.
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

repo_relative() {
  local root="$1"
  local path="$2"
  case "$path" in
    "$root"/*) printf '%s\n' "${path#"$root"/}" ;;
    *) printf '%s\n' "$path" ;;
  esac
}

normalize_task_ref() {
  local root="$1"
  local ref="${2:-}"
  local candidate

  if [[ -z "$ref" ]]; then
    if [[ -f "$root/.ai/state/current-task" ]]; then
      ref="$(sed -n '1p' "$root/.ai/state/current-task")"
    else
      echo "No task provided and no active task is set" >&2
      return 1
    fi
  fi

  ref="${ref%/}"
  if [[ "$ref" = /* ]]; then
    candidate="$ref"
    case "$candidate" in
      "$root"/*) ;;
      *)
        echo "Task path must be inside Ariadne root: $ref" >&2
        return 1
        ;;
    esac
  elif [[ "$ref" == .ai/tasks/* ]]; then
    candidate="$root/$ref"
  else
    candidate="$root/.ai/tasks/$ref"
  fi

  if [[ ! -d "$candidate" ]]; then
    echo "Task directory not found: $ref" >&2
    return 1
  fi

  repo_relative "$root" "$candidate"
}

task_md_path() {
  local root="$1"
  local task_ref="$2"
  printf '%s\n' "$root/${task_ref%/}/task.md"
}

set_task_status() {
  local task_md="$1"
  local status="$2"
  local tmp
  [[ -f "$task_md" ]] || return 0
  tmp="$(mktemp)"
  awk -v status="$status" '
    /^- Status:/ && !done { print "- Status: " status; done = 1; next }
    { print }
  ' "$task_md" > "$tmp"
  mv "$tmp" "$task_md"
}

section_content() {
  local file="$1"
  local section="$2"
  awk -v section="$section" '
    $0 == "## " section { inside = 1; next }
    inside && /^## / { exit }
    inside { print }
  ' "$file"
}

has_real_content() {
  awk '
    {
      line = $0
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
      if (line == "") next
      if (line ~ /^<!--/) next
      if (line ~ /^#+[[:space:]]/) next
      if (line ~ /^Do not claim completion/) next
      if (line ~ /^Only include questions/) next
      if (line ~ /^Every Level 2\/3 task/) next
      if (line ~ /^\|[[:space:]-]+\|/) next
      if (line ~ /^\|[[:space:]]*Source[[:space:]]*\|/) next
      if (line ~ /^\|[[:space:]]*Check[[:space:]]*\|/) next
      if (line ~ /^\|[[:space:]]*File[[:space:]]*\|/) next
      if (line ~ /^\|[[:space:]]*Decision[[:space:]]*\|/) next
      if (line ~ /^\|[[:space:]]*Role[[:space:]]*\|/) next
      if (line ~ /^\|[[:space:]]*\|/) next
      if (line ~ /^-[[:space:]]*$/) next
      if (line ~ /^-[[:space:]]*<.*>$/) next
      if (line ~ /^-[[:space:]]*TBD\.?$/) next
      if (line ~ /^-[[:space:]]*\[[[:space:]]*\][[:space:]]*$/) next
      if (line ~ /^What /) next
      if (line ~ /^Hard requirements/) next
      if (line ~ /^Small, ordered steps/) next
      if (line ~ /^Known limitations/) next
      ok = 1
    }
    END { exit ok ? 0 : 1 }
  '
}

require_section() {
  local file="$1"
  local section="$2"
  if ! grep -q "^## $section$" "$file"; then
    echo "missing section: $section"
    return 1
  fi
  if ! section_content "$file" "$section" | has_real_content; then
    echo "section has no real content: $section"
    return 1
  fi
}

validate_task() {
  local root="$1"
  local task_ref="$2"
  local task_md
  local failures=0
  task_md="$(task_md_path "$root" "$task_ref")"

  if [[ ! -f "$task_md" ]]; then
    echo "task.md not found: $task_md" >&2
    return 1
  fi

  echo "Validating $task_ref"

  for section in "Intent" "Success Criteria" "Baseline Readset" "Plan" "Verification Evidence" "Residual Risks"; do
    if ! require_section "$task_md" "$section"; then
      failures=$((failures + 1))
    fi
  done

  if ! grep -Eq 'Sub-agent decision: (delegated|not-useful|unavailable-in-host|disabled-by-user|disabled-by-system-instruction)' "$task_md"; then
    echo "missing resolved sub-agent decision"
    failures=$((failures + 1))
  fi

  if grep -Eq 'Sub-agent decision: pending' "$task_md"; then
    echo "sub-agent decision is still pending"
    failures=$((failures + 1))
  fi

  if ! grep -Eq 'Memory decision: (captured-to-pending-memory|no-durable-candidates)' "$task_md"; then
    echo "missing final memory decision"
    failures=$((failures + 1))
  fi

  if grep -Eq 'Memory decision: pending|Memory decision: deferred' "$task_md"; then
    echo "memory decision is not final"
    failures=$((failures + 1))
  fi

  if [[ "$failures" -eq 0 ]]; then
    echo "OK: task artifact is complete enough for closure review"
    return 0
  fi

  echo "FAILED: $failures issue(s)"
  return 1
}

extract_section_or_note() {
  local file="$1"
  local section="$2"
  if [[ -f "$file" ]] && grep -q "^## $section$" "$file"; then
    section_content "$file" "$section" | sed -n '1,80p'
  else
    echo "(section missing)"
  fi
}

write_checkpoint() {
  local root="$1"
  local task_ref="$2"
  local task_dir="$root/${task_ref%/}"
  local task_md="$task_dir/task.md"
  local checkpoint_dir="$task_dir/checkpoints"
  local stamp
  local checkpoint
  local status

  if [[ ! -d "$task_dir" ]]; then
    echo "Task directory not found: $task_ref" >&2
    return 1
  fi

  mkdir -p "$checkpoint_dir"
  stamp="$(date '+%Y%m%d-%H%M%S')"
  checkpoint="$checkpoint_dir/compact-$stamp.md"
  status="unknown"
  if [[ -f "$task_md" ]]; then
    status="$(sed -n 's/^- Status:[[:space:]]*//p' "$task_md" | sed -n '1p')"
  fi

  {
    echo "# Compact Checkpoint: $stamp"
    echo
    echo "- Task: \`$task_ref\`"
    echo "- Status: $status"
    echo "- Created: $(date '+%Y-%m-%d %H:%M:%S %z')"
    echo
    echo "## Current Plan"
    extract_section_or_note "$task_md" "Plan"
    echo
    echo "## Open Questions"
    extract_section_or_note "$task_md" "Open Questions"
    echo
    echo "## Decisions"
    extract_section_or_note "$task_md" "Decisions"
    echo
    echo "## Sub-Agent State"
    extract_section_or_note "$task_md" "Sub-Agent Handoffs"
    echo
    echo "## Verification State"
    extract_section_or_note "$task_md" "Verification Evidence"
    echo
    echo "## Memory State"
    extract_section_or_note "$task_md" "Memory / Spec Candidates"
    echo
    echo "## Git Dirty Summary"
    if command -v git >/dev/null 2>&1 && git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      git -C "$root" status --short || true
    else
      echo "(git unavailable or not a git worktree)"
    fi
    echo
    echo "## Recovery Notes"
    echo "- Continue from the task artifact first."
    echo "- Re-run relevant verification before claiming completion."
    echo "- Review pending memory candidates before consolidation."
  } > "$checkpoint"

  repo_relative "$root" "$checkpoint"
}

main() {
  local command="${1:-}"
  local root
  local task_ref

  if [[ -z "$command" || "$command" == "-h" || "$command" == "--help" ]]; then
    usage
    return 0
  fi

  root="$(find_root)"

  case "$command" in
    start)
      task_ref="$(normalize_task_ref "$root" "${2:-}")"
      mkdir -p "$root/.ai/state"
      printf '%s\n' "$task_ref" > "$root/.ai/state/current-task"
      set_task_status "$(task_md_path "$root" "$task_ref")" "in-progress"
      echo "Current task: $task_ref"
      ;;
    current)
      if [[ -f "$root/.ai/state/current-task" ]]; then
        sed -n '1p' "$root/.ai/state/current-task"
      else
        echo "No active task" >&2
        return 1
      fi
      ;;
    finish)
      rm -f "$root/.ai/state/current-task"
      echo "Cleared active task"
      ;;
    validate)
      task_ref="$(normalize_task_ref "$root" "${2:-}")"
      validate_task "$root" "$task_ref"
      ;;
    checkpoint)
      task_ref="$(normalize_task_ref "$root" "${2:-}")"
      write_checkpoint "$root" "$task_ref"
      ;;
    *)
      usage >&2
      return 2
      ;;
  esac
}

main "$@"
