# Project Spec

The spec layer contains authoritative project-level constraints.

Specs are different from tasks and memory:

- Tasks record what happened for one task.
- Memory records reusable experience and preferences.
- Specs define durable rules, contracts, architecture constraints, and conventions future agents should treat as authoritative.

## When To Add A Spec

Add or update spec files when information is:

- Stable across tasks.
- Required for correct implementation.
- More authoritative than memory.
- Specific enough to guide code, docs, verification, or delegation.
- Supported by a source task, decision, or evidence.

Do not add transient task details or speculative ideas directly to specs.

## Suggested Files

- `architecture.md` — system shape, layers, ownership, and design constraints.
- `coding-style.md` — project conventions and style expectations.
- `testing.md` — verification strategy, commands, and evidence standards.
- `contracts.md` — public interfaces, data shapes, compatibility rules, and invariants.
- `gotchas.md` — authoritative gotchas that should guide implementation.
- `glossary.md` — shared terms and definitions.

## Promotion Rule

Most spec updates should start as:

```text
task evidence or discussion
→ pending-memory candidate
→ update-memory review
→ spec update proposal
→ accepted spec change
```

For urgent correctness constraints, a spec may be updated directly, but the source and rationale should still be recorded.

## Spec Entry Format

Use this shape when adding durable rules:

```markdown
## <rule or topic>

- Rule:
- Rationale:
- Applies to:
- Source:
- Verification:
```
