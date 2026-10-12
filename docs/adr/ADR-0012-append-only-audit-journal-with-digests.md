# ADR-0012: An append-only, hash-chained audit journal that stores digests, not content

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

The evidence ledger (EV-*) records claims about verification. It does not answer the questions a
principal, a reviewer or an incident asks afterwards: who submitted this intent, which seat dispatched
it, which model was called, which draft was held and who released it, who approved the board item, what
ran overnight. Those answers were scattered across logs that rotate, differ per host and can be edited
without trace. At the same time, copying prompts and drafts into a journal would duplicate sensitive
content outside its data tier, and adding signatures or key management to an internal tool is the
security theater ADR-0008 rejects.

## Decision

- Every OS action is an **audit event** appended to one journal (`governance.audit.journal`, default
  `state/audit/journal.jsonl`): intent submitted, intake, question converted, delegation, dispatch, tool
  call, model call, draft created, hold applied and released, send requested, work item created and
  updated, decision recorded, protected-effect state change, batch window start and end, brief compiled,
  evidence recorded, kill switch, config change (`eventKinds`).
- Each event carries actor seat, principal, timestamp, input digests and evidence or decision ids.
- **Hash-chained** (`hashChained: true`): each event includes the digest of the previous one, so any
  edit, deletion or reordering breaks the chain. `aof audit verify` recomputes it. This is
  tamper-evidence of the record, not authentication: no keys, no signing, no rotation.
- **Digests, not content** (`redaction: content-digests-only`): prompts, drafts and documents are
  referenced by path and sha256; their text stays in the tiered stores where the data boundary governs it.
- Append-only: the OS never rewrites a line. Corrections are new events that reference the old one.
- `readers` may read the whole journal; every principal may read their own events. `retentionDays`
  (null = keep) bounds it.
- CLI: `aof audit append|verify|tail|query`. Wave 0 of every profile verifies the chain.

## Consequences

- Positive: one place to reconstruct any journey; a broken chain is detected mechanically; no sensitive
  text leaks into the journal; no key management.
- Negative: the journal grows with every model and tool call; querying needs the CLI or a projection.
- Follow-up: consoles render the audit trail panel from the journal; incident runbooks start with `aof audit verify`.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Rely on host and service logs | Rotated, per-host, editable, inconsistent fields |
| Store full prompt and draft text | Copies sensitive content outside its tier |
| Signed events with managed keys | Security theater for an internal tool (ADR-0008); the chain already detects edits |
| A database without chaining | Silent edits are undetectable |

## References

ADR-0002; ADR-0008; EVIDENCE_RECORD.md; NIST SP 800-160 v1 (assurance evidence, public domain).
