# Pattern: unattended operations

Status: draft
Owner: maintainers of this template package

## Problem

The most valuable hours for an agentic OS are the ones nobody is watching: evenings, nights, weekends.
Local hardware is idle, queues are long, and a factory cell or an SE review can take hours. But
unattended work is where agent systems fail worst: a loop retries a dead route all night, a budget
evaporates, a half-finished change is pushed, a message goes out at 03:00, or the morning starts with
a wall of logs nobody can act on.

## The pattern

### Batch windows

Unattended work happens only inside declared **batch windows** (`operations.batchWindows`). Each
window names its days, start and end (it may cross midnight), the kinds of work allowed (factory
build, review and verify; SE synthesis and review; correspondence and document drafting; survey;
knowledge indexing; evaluation; route qualification; regression), the factories it may run, a
maximum number of parallel cells, a token budget, the data tiers it may touch, and a failure policy.

A typical configuration has a weeknight window for factories, SE work, drafting and indexing, and a
weekend window for surveys, route qualification, regression and long evaluations. Windows are
activated by rollout wave like everything else; a planned window does not run.

Only work that is `ready` (or parked with a valid checkpoint) and queued for the window starts, in a
fixed order: qualify routes first, then regression, then factory work with resumable items before new
ones, then SE packages, drafts, indexing, surveys and evaluations. Data tiers are enforced per step: a
restricted item waits for a qualified local route and never falls back to a remote one.

### The invariant: protected effects queue for the morning

`protectedEffectsQueueForMorning` is a constant, not a setting. During a window, nothing is merged,
deployed, sent, published, purchased, exported or otherwise made external. Requests are recorded,
held, and placed in the responsible Principal's morning brief with the one action that releases them.
The window keeps working on everything else.

### Budgets and parking

Budgets are hard. At 80 % of the token budget no new work starts; at 100 % running work checkpoints
and parks. Parallel cells never exceed the window's limit. The window closes on time; whatever is
still running checkpoints and parks with `reason: window-ended`.

**Parked** is a deliberate safe stop: the ledger item says `parked` with a reason, the last checkpoint
is complete, nothing external happened, and the item appears in the owner's next brief with one
action (re-queue, resume attended, reassign, cancel). Parking is not failure; a task that parks
cleanly did its job.

### Long-running tasks checkpoint and resume

Every multi-hour task has a ledger item and writes checkpoints as files at every stage boundary and at
least every configured interval: stage, attempt, inputs by digest, base revision, outputs so far,
evidence ids, budget used, next step. Steps are idempotent; anything that cannot be made idempotent is
a protected effect request, not a step. Resume re-verifies the world (revision exists, input digests
match, route qualified, kill switch not pulled) before continuing. A maximum unattended duration parks
anything that runs too long. After an outage, tasks resume if their window is still open; otherwise
they park with `reason: outage`. A protected effect is never retried, and an unknown outcome parks the
item for a person to check.

### Morning hand-off

Each window ends by writing a hand-off record (`state/batch/<window>/<date>.yaml`): budget used,
completed items with evidence ids, parked and failed items with reasons and suggested actions, every
held effect with its approver and payload digest, drafts with hold reasons, routes that went down, and
the audit sequence range written during the window. The `batch-window-end` audit event points to it.

At each Principal's brief time the Chief of Staff compiles the morning brief from that record, the
ledger, holds and decisions. A person spends a few minutes at 07:00 checking that the counts match,
the audit range verifies, every held effect is still held, and every parked item has a reason. Then
they act from the console.

### Quiet hours

Quiet hours per Principal stop interruptions, not work. Drafts, holds and decisions accumulate for the
brief. Only a pulled kill switch or a data-boundary breach may notify during quiet hours. Board
projections respect quiet hours too, unless a board is configured otherwise.

## Rules

1. Unattended work runs only inside an active batch window; nothing runs "whenever there is capacity".
2. Protected effects queue for the morning, always.
3. Every window has a token budget, a parallel-cell limit and a failure policy.
4. Stop starting work at 80 % of budget; checkpoint and park at 100 % and at window end.
5. Never retry a dead route in a loop; mark it unavailable for the window and park or move once.
6. A red verification is evidence; record it, never mark the item done.
7. Every long-running task has a ledger item, file checkpoints and idempotent steps.
8. Resume only after re-verifying revision, inputs, route and kill switch.
9. Never retry a protected effect; an unknown outcome parks for a person.
10. Every window ends with a hand-off record the brief is compiled from, and the morning check verifies the audit range.

## Anti-patterns

- **The infinite night loop.** Retrying a failing step until morning burns the budget and hides the failure.
- **Optimistic completion.** Marking items done because the builder said so, without the verifier.
- **Overnight sends.** "It was ready, so it went out" is the failure this pattern exists to prevent.
- **Log dumps as hand-off.** A morning of raw logs is a morning lost; the hand-off is structured and short.
- **Silent overrun.** A window that keeps running into the working day competes with attended work for routes and budget.

## Where it lives in the templates

- `operations/OPERATIONS.md` — windows, quiet hours, long-running settings, how the brief closes the loop.
- `operations/batch-windows/<window>/BATCH_WINDOW_RUNBOOK.md` — order, budget, parking, hand-off record, 07:00 check, failure modes.
- `operations/LONG_RUNNING_TASKS.md` — checkpoint and resume contract.
