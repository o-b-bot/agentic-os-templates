# ADR-0013: Unattended batch windows run the work; protected effects park for the morning

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

Factories, SE synthesis and review, drafting, surveys and indexing take hours of model time, and most
of it needs no human. Running it only while principals are at their desks wastes the night and fights
interactive work for the same GPUs. Running it unattended without rules risks the opposite failure: a
merge, a send or a board write at 03:00 that nobody approved, or a stuck task that burns budget until
morning.

## Decision

- `operations.batchWindows[]` define when unattended work runs: `days`, `start`, `end` (may cross
  midnight), `allowedWork` (factory-build, factory-review, factory-verify, se-synthesis, se-review,
  correspondence-drafting, document-drafting, survey, knowledge-indexing, evaluation,
  route-qualification, regression), optional `factories`, `maxParallelCells`, `tokenBudget` and `dataTiers`.
- **Protected effects park** (`protectedEffectsQueueForMorning`, constant `true`): nothing protected
  happens in a window. Merges, sends, publishes, board creates on principal-managed boards and every
  other protected effect become items in the next morning brief with the action ready in the console.
- **Failures park and report** (`onFailure: park-and-report` or `retry-once-then-park`): never a retry
  loop. A parked item carries its reason and appears under `failures-and-parked` in the brief.
- `longRunningTasks` checkpoints every N minutes, caps `maxUnattendedHours` and resumes after an outage
  from the last checkpoint.
- `quietHours[]` per principal: no notifications; drafts and updates accumulate for the brief; board
  pushes respect them when the sync entry says so.
- **The morning hand-off** is the brief (`principals[].chiefOfStaff.morningBrief`): compiled after the
  window ends (`aof brief build`), read in the console, acted on there.
- Batch windows are activated per rollout wave (`rollout.waves[].activates.batchWindows`), never before
  the work runs clean attended.

## Consequences

- Positive: the night does the heavy work; mornings start with decisions, not status hunting; nothing
  protected happens without a human; budgets bound runaway work.
- Negative: decisions wait up to a night; window and budget sizing needs a few iterations.
- Follow-up: the console shows batch-window status; Production evidence includes a restart inside a window.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Run only while principals are present | Wastes the night; contends with interactive work |
| Let approved policies auto-approve protected effects overnight | Violates deny-by-default exact-target decisions (ADR-0002) |
| Retry failures until they pass | Burns budget and hides the cause |

## References

ADR-0002; ADR-0009; METHODOLOGY.md §3.1.
