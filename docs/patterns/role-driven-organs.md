# Pattern: role-driven organs

Status: draft
Owner: maintainers of this template package

## Problem

The first versions of the OS were built from the inside out: a Chief of Staff, co-engineers, a Systems
Engineering organization, factories, a ledger. Each piece was sound. But when we walked each principal's
actual week against it, role by role, every role still did a large share of its job by hand, outside the
OS, in mail, spreadsheets and meeting notes. The OS knew about the work it produced; it did not know about
the work the role exists to do.

The gap analysis below asked one question per role: "What does this person spend their week on that the
OS cannot see, prepare, or track?" Each answer became an organ, a set of seats, or a per-program artifact.
Every addition follows the same shape as the rest of the OS: seats draft and track, the ledger holds the
work, decision records hold the choices, protected effects stay with people.

## The per-role gap analysis

### Director

A Director's week is meetings, approvals, sponsor and stakeholder reporting, and deciding which
opportunities to pursue. Before v0.3 the OS produced a morning brief and decision briefs, but:

- **Meetings** arrived unprepared and ended with action items in someone's notebook. The meetings organ
  now prepares a brief before each meeting (agenda, open items per attendee, decisions pending, last
  minutes), writes action items to the ledger with owners and due dates, and turns decisions into records
  only when the Director confirms them.
- **Stakeholder reporting** was assembled by hand each period from status records. The `stakeholder-reporting`
  Chief of Staff seat drafts each sponsor report from program records and holds it for the named approver;
  `release-to-sponsor` is a protected effect.
- **Approvals** (travel, purchases, change orders) were scattered across systems. The `travel-and-approvals`
  seat keeps one honest queue: what each approval binds, its deadline, what is missing. It never approves.
- **Inbox** volume hid the few messages that needed the Director. The `inbox-triage` seat classifies
  messages into decision, reply, intent, information and noise without touching the mailbox.
- **Capture** (proposals, grants, task orders) is how a research directorate is funded. The capture organ
  runs the pipeline from scouting to a package ready to submit, and treats the solicitation as a
  requirement set so coverage is computed, not asserted. `submit-proposal` is protected.

### Principal cross-program engineer

The Principal holds technical coherence across programs and runs technical reviews. Missing pieces:

- **Cross-program technical authority**: a reference architecture, a reuse catalogue, interface and
  dependency registries that span programs, and a technical risk board. The decision scope of the
  technical authority is written down next to the Director's, so neither absorbs the other.
- **Review item discrepancies (RIDs)**: review findings lived in slide comments. RIDs are now records with
  dispositions, accepted ones become ledger work items, and a review closes only on its exit criteria.
- **Readiness**: TRL and MRL were stated in reports without evidence. Each program now has a readiness
  assessment that cites evidence and the environment the level was shown in.

### Lead security / agentic-AI systems engineer

This role owns how the OS itself is built and run safely, and the security of the systems the programs
build:

- **Secure development gates** mapped to the NIST SSDF practice groups, run as factory verification
  commands, with an SBOM required for delivery.
- **Authorization package**: a system security plan outline, a control mapping skeleton against a public
  control catalog, assessment evidence as evidence records, and plan-of-action items in the ledger.
- **Agent security monitoring**: a pinned telemetry convention, alert kinds specific to agents (tool
  allowlist violations, data-tier crossings, protected-effect attempts, injection, out-of-envelope input,
  tripped circuit breakers), runbooks per alert, and AI incident records that feed golden tasks.
- **AI bill of materials**: a registry of model, seat and dataset cards that together form the AI-BOM,
  with "no card, no route" and "no card, no activation" rules. An evaluation harness measures every seat
  and factory before trust and after change.

### Lead hardware engineer

Hardware work runs on lab time, change control and parts:

- **Lab operations**: assets with owners and calibration dates, bookings as ledger work items, test
  campaigns with procedures and reports. Actuating an asset stays `hardware-actuation`, protected.
- **Engineering change orders** with classes, an approver who holds `change-order-approval`, and a record
  that links the baseline it moves and the verification it forces.
- **Procurement and obsolescence**: requests as work items, a quote comparison format, lead-time and
  lifecycle watches. `purchase` is protected.
- **Test reports** drafted by the `test-report-writer` seat from run data, reviewed independently, with
  every result bound to evidence.

### Program leads

A Program Lead answers to a sponsor:

- **Milestones** mapped to technical reviews, with status that changes only on evidence.
- **Deliverables register**: what is owed to whom, when, at what data tier, and its state through
  delivery and acceptance.
- **Sponsor reports** at the program's cadence and format, held for the approver.
- **Members and access**: program membership now decides what principals and their seats see in consoles
  and knowledge stores, so restricted programs stay restricted without per-file rules.

### Everyone

Each principal also gets an adoption playbook (their seats, consoles, decision rights, how to turn a
question into an intent, how to approve a work item, circuit breakers, the kill switch), and each wave ends
with a retrospective whose lessons go to the knowledge store. Interop exposes the OS to other agent
ecosystems as one agent card per organ, with seats as skills, and an external agent inherits no data tier
it was not granted.

## The pattern

1. Start from a role's week, not from the OS's components.
2. For each recurring task, decide: a seat drafts or tracks it, the ledger holds it, a decision record
   captures the choice, and a person performs any protected effect.
3. Put the artifact where the role already looks: per principal (playbook, meeting prep format), per
   program (milestones, deliverables, readiness, sponsor report, members), or per organ.
4. Guard every new organ with an `enabled` flag so an organization that does not need it never sees it.
5. Bind every state change to evidence or a decision id.

## Rules

1. **A meeting decision is a candidate until the principal confirms it.** Only a confirmed decision becomes
   a decision record.
2. **Action items enter the ledger with an owner and a due date**, or as `unassigned` and visible in the
   brief; they are never dropped.
3. **Transcripts are read only under the configured policy**, with a consent reference recorded in the
   minutes when policy requires it.
4. **Sending, submitting, releasing, purchasing, approving change orders and actuating hardware stay
   protected effects.** Seats prepare; a principal who holds the right acts in the system of record.
5. **The compliance matrix is a requirement set** compiled by `aof trace`; coverage is computed, never
   typed.
6. **Every color-team review carries a planted defect.** A review that misses it is
   degraded and its pass does not count.
7. **Milestones and deliverables change state only with evidence**: a review record, a release decision,
   a sponsor acceptance reference.
8. **A readiness level names the environment it was demonstrated in and cites evidence**; analysis alone
   never supports more than TRL 3.
9. **No card, no route; no card, no activation; no card, no index.** Models, seats and datasets are
   registered before use.
10. **A bare model judge never gates a wave exit or a protected effect.** Gating suites use deterministic
    checks, people, or a model judge with a calibrated human sample, and report pass^k over k trials.
11. **Every confirmed AI incident becomes at least one golden task** before it is closed.
12. **Security gates are correctness checks, not ceremony.** A gate that did not run has failed; findings
    close by fix or recorded disposition.
13. **Program membership controls visibility.** Non-members see rollup status only; seats read program
    records only to serve a member, on routes allowed for the program's tier.
14. **The technical authority's decision scope is written next to the Director's.** Neither absorbs the
    other; disagreements escalate along the chain.
15. **An external agent inherits no data tier it was not granted**, and no published skill performs a
    protected effect.
16. **Every new organ is off unless configured**, and every per-item artifact shows its activation status.

## Anti-patterns

- An "assistant" that sends the follow-up because the meeting "clearly agreed".
- A compliance matrix kept in a spreadsheet beside the proposal, drifting from the draft.
- A sponsor report whose green status is not traceable to a status record.
- A model card typed by hand with evaluation scores nobody can reproduce.
- A purchase request that a seat splits to fit under an approval threshold.

## Where it lives in the templates

| Concern | Templates |
|---|---|
| Meetings | `templates/meetings/`, `templates/chief-of-staff/per-principal/seats/meeting-prep.md.j2` |
| Director attention | `inbox-triage`, `travel-and-approvals`, `stakeholder-reporting` Chief of Staff seats |
| Capture | `templates/capture/`, `compliance-matrix-builder` and `proposal-writer` co-engineer seats |
| Evaluation and registry | `templates/evaluation/`, `templates/registry/` |
| Security | `templates/security/`, `sbom-and-supply-chain` and `control-mapper` seats |
| Hardware | `templates/hardware/`, `eco-drafter`, `test-report-writer`, `lab-scheduler` seats |
| Programs | `templates/systems-engineering/per-program/` (milestones, readiness, sponsor report, members) |
| Cross-program | `templates/systems-engineering/CROSS_PROGRAM_TECHNICAL_AUTHORITY.md.j2`, `REVIEW_ITEM_DISCREPANCIES.md.j2` |
| Interop and adoption | `templates/interop/`, `templates/adoption/` |
