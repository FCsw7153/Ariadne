# Contracts Spec

Authoritative contracts and invariants belong here.

## Sub-Agent Return Contract

- Rule: Sub-agents should return decision-grade artifacts, not only chat summaries.
- Rationale: Main agents need readset, facts, evidence, risks, and decisions needed to make safe choices.
- Applies to: sub-agent handoffs, reports, task workspace evidence.
- Source: agent delegation protocol.
- Verification: Handoff/report templates include required return fields.

## Pending Memory Contract

- Rule: Memory candidates are captured in `pending-memory.md` before promotion to long-term memory, spec, workflow, or hard rules.
- Rationale: This prevents memory from becoming a junk drawer or unauthorized authority layer.
- Applies to: memory-capture, update-memory, pending-memory.
- Source: memory design.
- Verification: Memory-capture writes only pending candidates unless explicitly authorized otherwise.
