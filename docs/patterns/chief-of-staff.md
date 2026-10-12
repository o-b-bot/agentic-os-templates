# Pattern: the Chief of Staff ecosystem

Status: draft
Owner: maintainers of this template package

## Problem

A person with decision authority (a Director, a Lead, a founder) is the bottleneck of any agentic
system that does real work. Every matter eventually needs their attention, their judgement, or their
signature. The first instinct is to give them "an assistant": one capable model that listens, plans,
delegates, checks results and reports back. That assistant becomes an unbounded super-agent. It
captures the request, decides what it means, chooses who does it, judges whether it was done, and
tells the human it is finished. Nothing in that loop is independent, and nothing limits what it may
do if the model misreads a sentence or a document tells it to do something.

## The pattern

A **Chief of Staff ecosystem** is a small staff organization of seats that sits between one human
Principal and every other organ of the Agentic OS. It manages attention, intake, decisions and
coordination. It does no engineering itself (that is the Co-Engineer and the factories), and it
holds no authority to execute a protected effect.

The default seats are intake-provenance, context-knowledge, portfolio-dependencies,
delegation-receipts, decision-briefing, continuity-resumption, resource-cost-attention and
exception-escalation. Optional seats add status-rollup, correspondence-drafting, calendar-attention
and handoff-choreography. Each seat file states what the seat may **never** do before it states what
it does. A seat is a contract; the model and host behind it are a route bound to that contract. Losing
a route re-matches the seat to another qualified route; it never widens authority, and no other seat
absorbs a missing seat's work.

Four design choices carry most of the weight.

**Questions are not work until converted.** Every input is recorded as an immutable intake record
with `sourceTrust: untrusted-input` and `matterKind: question` by default. A question may be
answered, researched or briefed. It cannot dispatch anything until the Principal performs a separate,
explicit conversion with the assumptions written down. This one rule removes a whole class of
accidents: a forwarded email, a pasted log, or a prompt-injected document cannot become a work order.

**Deny by default, exact-target decisions.** Protected effects (merge, deploy, external send,
purchase, credential or infrastructure change, data export, production access, publishing) are denied
unless a Principal decision record authorizes that effect on an exact target with an exact payload
digest under a named policy epoch. One changed byte needs a new decision. One decision authorizes
one dispatch per target; a second dispatch is a replay and is refused. No effect is ever inferred
from a UI click, a model response, or silence.

**A visible journey with honest display rules.** Every intent moves through configured stages
(intent submitted, intake recorded, analysis, route plan, synthesis, council review, adjudication,
Principal briefing, Principal decision, dispatch, build, review, verification, candidate delivered,
briefed). Each stage names who may advance it and what evidence it needs. The Principal's view may
never show a step as complete without evidence in hand, never infers forward ("dispatched" is not
"succeeded"), shows missing fields as missing, and shows an unrecognized stage as degraded with no
action. The decide action exists only at the decision stage with a full package and no blocked reason.

**State lives in a journal, not in a model.** Matter state, decisions, receipts and effect records
are appended to a durable journal that survives restarts and upgrades. Another instance resumes by
taking a new fence and rebuilding from journaled events. Resuming from a chat transcript is
forbidden.

## Why an ecosystem rather than one assistant

- **Throughput.** Seats run concurrently; a matter has one decision state but many workers.
- **Small privileges.** Splitting intake, planning, delegation, briefing and checking means no single seat holds enough authority to do harm alone.
- **Independence.** The exception-escalation seat is independence-excluded from every other seat, and domain verification always comes from outside the Chief of Staff.
- **Replaceability and continuity.** Contracts outlive models; journals outlive processes.

## Engineering path

Engineering work follows one path: Principal → Chief of Staff → Systems Engineering → Chief of Staff
→ Principal (decision) → Chief of Staff → factory, and completion returns factory → Systems
Engineering → Chief of Staff → Principal. The Chief of Staff never receives completion directly from a
factory, because it is not qualified to adjudicate domain results. A consultation (a question) is
read-only end to end.

## Lessons, stated as rules

These come from defects observed in the reference implementation. Each is now a rule the templates
encode.

1. **Producer and consumer share one schema.** When a producer adds a field, an exact-key consumer
   that does not know it will reject the whole record. Share one schema module, add a contract test
   that feeds real producer output through the consumer's validator, and degrade one row rather than
   blanking the whole list.
2. **Ship request-shape changes with their callers.** A new required binding on the service side,
   deployed without the client change, turns the first real request into a refusal. Version request
   schemas and test the shell-to-service path end to end against the real service.
3. **Health is not readiness.** A green probe proves only that a probe ran. "Ready" is the AND of a
   commissioned route, a real model invocation, and commissioned adapters; only a real intent exercises
   the whole chain.
4. **Stuck states surface a reason.** Every terminal refusal writes a durable block event with its
   reason, and stage transitions come only from journaled events. A stuck matter with no reason is a
   defect.
5. **Long work is asynchronous.** A fixed client timeout shorter than the slowest downstream call
   silently cuts work. Accept now and return a completion envelope later, or set and test timeouts
   explicitly; outboxes retry on a timer.
6. **Revision counters are monotonic across producers.** A producer that stamps every revision with
   the same number gets every revision refused as stale. Base the next revision on the consumer's last
   accepted revision plus one.
7. **Briefings carry references, not payloads.** Embedding raw review output in a summary pushes
   bounded fields toward their limits and can fault the store. Reference by id and digest; reject an
   oversize field per operation without faulting the journal.
8. **Context changes cancel stale asks.** Tag every request with its context digest and drop a
   response whose digest no longer matches.
9. **A replay is byte-identical or rejected.** Each attempt gets its own transport id, and the same id
   always means the same request digest.
10. **Revision loops do not feed on vacuous findings.** Gates with no admitted input are suppressed;
    only real reviewer findings go into a revision.
11. **Matter state survives upgrades.** Keep it in a journal with explicit schema migration, never in
    per-release directories.
12. **Test approvals are not approvals.** The decision validator refuses synthetic actors outside
    test mode; a real decision is an explicit action by the configured Principal.

## What the templates render

- `chief-of-staff/ECOSYSTEM_OVERVIEW.md`: seat set, forbidden authorities, the protected-effect state
  machine, the configured journey stages with advancer and evidence, and the display rules.
- Per Principal: `CHARTER.md` (reporting and support lines, decision rights held versus escalated,
  enabled seats, forbidden authorities, cadence, rollups, entitlements, kill-switch rights),
  `INTAKE_AND_INTENTS.md`, `BRIEFING_FORMAT.md`, `DECISION_RECORD.md`, `CONTINUITY.md`, and one file per
  enabled seat plus an `AGENTS.md` beside them.

## Configuration

Principals, their decision rights, reporting lines, Chief of Staff seats, cadence, escalation target
and rollups live under `principals[]`. Organization defaults (journey stages, intake channels,
default seats and forbidden authorities) come from `config/defaults.yaml`. A Principal may add
forbidden authorities but never remove one.

## Out of scope

Signing, receipts with keys, rotation schedules and sandbox mandates are not part of this pattern for
internal tools. Correctness checks (schemas, contract tests, exact-target binding, independent review,
evidence bound to command, exit code and revision) are.
