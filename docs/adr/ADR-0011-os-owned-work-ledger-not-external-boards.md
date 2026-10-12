# ADR-0011: The work ledger is the source of truth; boards are projections kept current

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

An OS that decomposes intents, dispatches factories and returns drafts creates a lot of work items. Two
earlier designs failed. The first wrote tasks straight into whatever board the workflow named, including
boards a Director manages personally: the Director's own system of record filled with machine-generated
noise nobody approved. The second swung the other way and made every principal's board read-only: the
OS's work became invisible in the place the principal actually looks, so progress had to be retyped by
hand. Neither kept one truthful record of what the OS was asked to do, by whom, and what happened.

Organizations also differ: some run Planner, some Azure DevOps work items, Jira, GitHub, GitLab or Gitea
issues, a Trello-style board, or nothing at all. The OS cannot assume one.

## Decision

- **The OS owns a work ledger** (`organs.workManagement.ledger`, items `WI-<yyyymmdd>-<seq>` under
  `state/work-items`). Every item the OS creates lives there first, with status, owner, history, links to
  decisions (`DEC-*`) and evidence (`EV-*`). The ledger is the source of truth; with no board configured,
  the ledger alone works.
- **Boards are projections** of the ledger through a `boardAdapter` (`planner-graph`,
  `azure-devops-workitems`, `github-issues`, `github-projects`, `gitlab-issues`, `gitea-issues`, `jira`,
  `trello`, `outbox`, `none`). `outbox` writes JSON change requests to `state/outbox/` for a connector the
  organization already runs.
- **Modes** per board (`externalSync[].mode`): `read-only` (import as context), `create-on-approval-then-sync`
  (the item appears on the board when the approver approves it, then mapped fields stay current
  automatically), `two-way` (as before, plus edits on the board flow back into the ledger with
  `pullChanges`).
- **Principal-managed boards** (`integrations[].principalManaged: true`) get an item only on that
  principal's (or the configured approver's) approval: `aof decide --work-item WI-… --decision approve`
  from the brief or console. `principalManagedBoardsRequireApprovalToCreate` is a constant. Updates to an
  already-approved item need no further approval.
- **Engineering's own board** may auto-create items from named sources (`autoCreateFor: [factory,
  se-organization, …]`). Never valid on a principal-managed board.
- **Never noisy:** only `syncFields` are pushed, only on `syncTriggers`; `noiseFilter` batches rapid
  updates, respects quiet hours, caps pushes per item per day and sends notes as a daily digest.
- **Never deleted:** `deleteExternally` is constant `false`. Cancelling an item maps to a board status.
- Workflow steps use `create-work-item` / `update-work-item`. `create-ticket` (a direct external create) is
  allowed only where the board is `two-way` or `autoCreateFor` covers the step's source.
- `aof work sync [--integration] [--dry-run] [--verify] [--pull]` pushes and pulls; every create, push,
  pull and approval is an audit event (ADR-0012).

## Consequences

- Positive: one record of all OS work, independent of tooling; principals see OS work in the board they
  already use, but only what they approved; progress is never retyped; switching boards is a config change.
- Negative: an adapter per board family; field and status maps need care per customer; two-way mode needs
  a conflict policy (`ledger-wins`, `board-wins`, `newest-wins`).
- Follow-up: Discovery inventories every board and who manages it; PoC proves one approval-then-sync round trip.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Write workflow tasks directly into the named board | Unapproved noise in a principal's system of record; no single truth |
| Make every principal-managed board read-only | Work becomes invisible where the principal looks; progress retyped by hand |
| Adopt one board product as the ledger | Locks the OS to one vendor; fails organizations with none or several |
| Push every ledger change and note | Turns a calm board into a log stream; principals stop reading it |

## References

ADR-0002; ADR-0012; ARCHITECTURE.md §8; OPERATING_PRINCIPLES.md group I.
