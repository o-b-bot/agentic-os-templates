# ADR-0009: Activate incrementally, one ecosystem first

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

The configuration can describe a large organization: many principals each with a Chief of Staff and a
co-engineer, twenty SE sub-organizations of four or more seats, several factories, workflows and
integrations. Rendering is cheap, so it is tempting to switch the whole thing on. In the reference
implementation almost every live failure was harness plumbing (an identifier a model could not echo, a
client timeout shorter than the slowest call, a configuration cap that crashed boot), and each was found
only by carrying one real task through the deployed stack. With hundreds of seats live at once, such
failures cannot be attributed, and content faults hide behind plumbing faults.

## Decision

- The schema's `rollout` section activates the OS in waves. Configured items not in an active wave are
  `planned` or `unscheduled` and are not run; `aof render --only-active` omits them.
- **Wave 0** is plumbing only: config, inventory, route health on the exact served models, ledger writes,
  host-framework connection. No agent does work.
- **Wave 1** is one ecosystem: one principal; a minimal Chief of Staff (intake-provenance,
  decision-briefing, exception-escalation); one SE sub-organization; one factory with one work cell; only
  that cell's tools. It carries one `firstTask` end to end.
- Every wave declares smoke checks (`command`, `evidence` or `manual`); `aof smoke --wave N --run` writes
  one evidence record per check; `aof gate --wave N` passes only when exit criteria hold and every smoke
  id has evidence of the required class. Earlier waves' checks re-run in later waves.
- Inside a wave the operator loops (run, fix, re-run) until the wave's `loopUntil` stop rule holds, then
  widens by one increment.
- An empty `waves` list means everything configured is active; this is acceptable only for a solo setup.

## Consequences

- Positive: every failure has one recent cause; plumbing is proven before content; principals see a
  working ecosystem within weeks; widening is reversible by lowering `currentWave`.
- Negative: the full organization takes longer to reach; sponsors must accept a deliberately small first
  wave.
- Follow-up: per-wave templates under `templates/rollout/per-wave/`; activation lines on every per-item
  file; the engagement playbook's phases map onto waves.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Activate everything configured at once | Untestable path count; failures not attributable |
| Activate by organ (all Chiefs of Staff, then all of SE, then all factories) | No end-to-end task runs until the last organ is live; integration faults surface last |
| Pilot without smoke checks, judged by impression | No evidence; regressions in earlier waves go unnoticed |

## References

NASA SE Handbook (product integration and verification are incremental); DoD SE Guidebook 2022
(incremental and iterative development); METHODOLOGY.md §3.
