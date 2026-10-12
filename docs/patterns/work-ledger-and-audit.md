# Pattern: work ledger and audit journal

Status: draft
Owner: maintainers of this template package

## Problem

An agentic OS creates a lot of work: tasks decomposed from a Director's first pass, follow-ups from a
review, candidates from a factory, questions turned into intents. Two naive answers both fail.

The first writes everything straight into whatever board the organization already uses. Within a
week a Director's personal board is full of machine-made cards that read as commitments they never
made, nobody can say which cards came from where, and the board's own history is the only record of
what the OS did.

The second keeps everything inside the OS and never touches the boards. Now the engineering team's
board is stale, the Director tracks approved work in two places, and someone retypes status every
Friday.

Separately, every serious question about an autonomous system eventually becomes "what did it do,
for whom, and on what basis?" If the answer requires reading model transcripts, chat logs and three
tools' histories, the question is effectively unanswerable.

## The pattern

### The ledger is the source of truth

The OS keeps its own work ledger (`organs.workManagement`). Every item has an id (`WI-<yyyymmdd>-<seq>`
by default), an owning Principal, an optional program, an assignee, a source (intent, workflow,
factory, SE organization, manual, import), a data tier, a status, a due date, evidence ids, decision
ids and an append-only history. Items are created by workflows (`create-work-item`), by the Chief of
Staff when a Principal agrees that a question is work, by factories and the SE organization when they
decompose dispatched work, and by hand (`aof work new`). They are changed only through commands that
write history and audit events. They close with evidence or a decision, never with a bare claim.

### Boards are projections kept current

Each board the organization uses is declared once under `externalSync` with an adapter (Planner via
Graph, Azure DevOps work items, GitHub / GitLab / Gitea issues, Jira, Trello, an outbox for anything
else, or none) and a mode:

- **read-only** — import board items as context; never write.
- **create-on-approval-then-sync** — an item appears on the board when the approver approves it
  (normally the Principal who manages that board, often from the morning brief). After that,
  engineering progress in the ledger is pushed automatically: status, assignee, due date, completion
  and evidence links, as configured.
- **two-way** — as above, plus edits made on the board flow back into the ledger as history entries,
  with a declared conflict policy.

**Conflict policy values** (used when `pullChanges: true` on a `two-way` board):
- `ledger-wins` (default) — a board edit is pulled unless the ledger itself changed that field since the last push;
  then the ledger's value stands (`src/aof/sync.py`, the pull step).
- `board-wins` — a board edit is always pulled into the ledger, recorded as a `board:<id>` history entry.
- `newest-wins` — a board edit is pulled unless the ledger changed that field since the last push at or after the
  board's `updatedAt`.

Only pullable fields that are also listed in `syncFields` are read back; nothing else is ever pulled.
A board the engineering team owns may list `autoCreateFor` sources (factory, SE organization,
workflow) so their items appear without per-item approval. That is never valid on a board a Principal
manages personally. Deletion from the OS never happens; cancelled work shows as cancelled.

Noise is a first-class setting, because a projection that floods a board is as bad as a stale one:
`syncFields` limit what is pushed, `syncTriggers` limit when, `noiseFilter` coalesces rapid updates,
respects quiet hours, caps pushes per item per day, and sends notes as a daily digest or on
completion, never one by one. `statusMap` and `fieldMap` translate the ledger's vocabulary to the
board's.

`aof work sync` does the projecting, with `--dry-run` to preview, `--verify` to read back and report
drift, and `--pull` for two-way boards. If an adapter has no credentials, it writes change requests to
the outbox instead of failing silently. If the organization has no board at all, nothing is missing:
the ledger, the console and the brief are the task system.

### The audit journal answers "what did the OS do"

`governance.audit` is an append-only journal. Every intent, intake, conversion, delegation, dispatch,
tool call, model call, draft, hold, release, send request, work-item change, decision,
protected-effect state change, batch window start and end, brief compilation, evidence record, kill
switch and config change is one event, with the acting seat, the Principal it acted for, the subject
ids, the data tier, the route for model calls, digests of inputs and outputs, and the evidence and
decision ids it cites.

By default the journal stores **digests, not content**. The artifacts live in their tiered stores;
the journal can be read widely without leaking restricted text.

The journal is **hash-chained** for tamper evidence: each event's hash covers the previous hash and
the event, so `aof audit verify` finds any edit, deletion or reordering. That is all it does. It adds
no keys, signing or rotation; who acted is recorded in the event and protected by ordinary access
control on the state directory. For an internal tool that is the proportionate control: it checks
correctness without adding ceremony nobody will maintain.

Three questions should each be one query: who decided X and on what briefing; what the OS did
overnight; which model calls touched restricted data and on which route classes. The rendered
`governance/AUDIT_JOURNAL.md` shows the exact queries for the organization's configuration.

## Rules

1. The ledger is the only system of record for work the OS creates. Boards are projections of it.
2. An item is created on a board a Principal manages only when that Principal (or the configured
   approver) approves it. Updates to approved items need no further approval.
3. `autoCreateFor` is for boards the engineering team owns, never for a Principal-managed board.
4. The OS never deletes from a board. Cancellation is a status.
5. Every board has a noise filter. Notes are never pushed one by one.
6. A workflow writes work with `create-work-item`. `create-ticket` (a direct board write) is refused
   unless the board is two-way or its `autoCreateFor` covers the workflow source.
7. Every change to a work item is a history entry and an audit event; there are no silent edits.
8. `done` requires an evidence id or a decision id. The ledger never claims success on its own.
9. The audit journal stores digests by default and is verified with `aof audit verify` at every wave gate.
10. Hash-chaining is tamper evidence, not authentication. Do not add signing, receipts or key
    management to it; add access control to the state directory instead.

## Anti-patterns

- **Board as database.** Making the board the system of record means the OS's history is whatever the
  board vendor keeps and whatever its permissions allow.
- **Read-only forever.** Refusing to project after approval forces Principals to track approved work
  twice and guarantees the board goes stale.
- **Firehose sync.** Pushing every note and every intermediate status buries the few changes that
  matter. Configure triggers and the digest.
- **Content in the journal.** Storing prompts and drafts in a widely readable journal turns the audit
  trail into a data-boundary breach.
- **Audit by transcript.** Model transcripts are not an audit trail; they omit what tools did and
  include what the model imagined.

## Where it lives in the templates

- `work/WORK_LEDGER.md` — the ledger, statuses, record fields, board projection table, sync mechanics.
- `work/EXTERNAL_BOARDS_POLICY.md` — the quotable rule and what each board will show.
- `governance/AUDIT_JOURNAL.md` — event kinds, fields, chain, redaction, readers, retention, queries.
- `workflows/*` — the projection consequence of each `create-work-item` step and warnings for refused
  `create-ticket` steps.
