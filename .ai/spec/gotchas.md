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
