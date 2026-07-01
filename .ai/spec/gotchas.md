# Gotchas Spec

Authoritative gotchas that should guide future implementation belong here.

## Do Not Confuse Method With Runtime

- Rule: Ariadne should not reimplement sub-agent creation in generic method docs.
- Rationale: Host environments may already provide native delegation mechanisms.
- Applies to: sub-agent docs, workflow, skills, adapters.
- Source: sub-agent design discussion.
- Verification: Method-layer docs stay platform-neutral.

## Do Not Guess Memory Source Task

- Rule: Do not attach a memory candidate to a task unless source task or source artifact is explicit, or confidence is high and justified.
- Rationale: Multiple tasks may be active at once.
- Applies to: memory-capture, pending-memory, update-memory.
- Source: memory source resolution design.
- Verification: Ambiguous candidates go to Inbox with `needs-source-resolution` or trigger a user question.

## Do Not Treat Checkpoints As Accepted Memory

- Rule: Compact checkpoint candidates in pending memory are source pointers, not promoted long-term memory.
- Rationale: Checkpoints contain recovery state and may include temporary task details.
- Applies to: pre-compact hooks, pending-memory, update-memory.
- Source: Ariadne Guardrails v1.
- Verification: Consolidation reviews the checkpoint before promoting any stable reusable knowledge.

## Do Not Use Init As An Updater

- Rule: `scripts/init.sh` installs/backfills missing Ariadne files and refreshes update metadata; existing managed files should be upgraded through `scripts/update.sh`.
- Rationale: Init must remain safe for existing projects, while update needs hash-based protection for user modifications and deletions.
- Applies to: init, update, doctor, template docs.
- Source: Ariadne update mechanism.
- Verification: Re-running init does not overwrite existing managed files except the `AGENTS.md` managed block; update scenarios cover auto-update and preservation paths.
