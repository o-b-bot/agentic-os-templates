# Pattern: upward signals and briefs

Rendered files: `signals/CAPABILITY_SIGNALS.md`, `signals/SIGNAL_RECORD_TEMPLATE.md`, `signals/TRIAGE_FORMAT.md`,
`signals/OPPORTUNITY_VIEW_FORMAT.md`, `reporting/REPORTING_FABRIC.md`, `reporting/PROGRESS_REPORT_FORMAT.md`,
`reporting/EXEMPLARS.md`, and `reporting/upward-briefs/<brief-id>/UPWARD_BRIEF_FORMAT.md` per configured brief.
Inputs: `organs.capabilitySignals`, `reporting.*`, `knowledge.exemplars`, `organs.capture`.
Seats: Chief of Staff `signal-triage`, `opportunity-pipeline`, `upward-brief-drafting`; co-engineer
`progress-report-contributor`, `white-paper-author`.

## Two directions of travel

Most agent systems are built to push work **down**: a principal asks, a factory builds. A directorate also needs things
to travel **up**. Engineers notice that a component built for one program solves a problem in another, that a sponsor
mentioned a need nobody is funded for, that a demo is finally ready to show. Directors need a monthly picture of the
portfolio for the people above them, and sponsors need progress reports that are accurate and on time.

This pattern gives the upward direction two channels with the same discipline:

- **Capability signals**: small structured records of something new, triaged quickly, ranked, decided.
- **The reporting fabric**: status records, rollups, upward briefs and progress reports, each compiled from the layer
  below and citing it.

## Capability signals

Anyone may raise a signal: a principal, or a seat on a principal's behalf. A signal is one capability sentence plus
kind, programs touched, maturity (TRL by default, using the public NASA definitions), evidence ids, potential customer
classes and the data tier of the record itself.

The triage principal's `signal-triage` seat drafts a triage note within the triage SLA. Triage answers four questions:
duplicate or new; which registry entry it maps to (the cross-program reuse catalogue when cross-program SE is enabled);
whether the cited evidence supports the claimed maturity; and whether it can cross the boundaries it needs to. The
principal signs the note; the seat never does.

Signed notes feed the decision principal's opportunity view, kept by the `opportunity-pipeline` seat: a ranked table
scored on value, assessed maturity, fit to the organization's domains and customers, and funding path, with the next
step and a decide-by date. The decision principal chooses `pursue` (a capture entry), `fold-into` an existing program,
`park` until a date, `reject`, or `stand-up-program`, which is a protected effect run through a configured workflow
that drafts a program entry, PoP plan and staffing plan for review.

## The reporting fabric

| Layer | Compiled from | By |
|---|---|---|
| Status record | work items, evidence ledger, milestones | each program and factory |
| Rollup | status records | `status-rollup` of the receiving principal |
| Upward brief | rollups, decisions, finance aggregates, capture pipeline, signals, risks, hiring | `upward-brief-drafting` |
| Progress report | contributor entries, evidence, finance aggregates, deliverables | contributors + compiler |
| Sponsor deliverable | progress reports and review packages | the program owner |

Each upward brief is configured with an audience, cadence, format and an ordered list of sections. The format sets the
length: one page for a memo, at most ten slides for a deck, three spoken sentences per section for talking points.
Each section names what it draws from, so the drafting seat assembles rather than writes.

Progress reports take sections from configuration (summary, accomplishments, technical progress, issues and risks,
plans, funding and schedule, deliverables status, or a sponsor's own list). Contributors submit entries through their
`progress-report-contributor` seat with an evidence id after every claim. The compiler assembles, checks numbers
against the burn report and deliverables, and sends the draft through the information review, principal approval and
`release-to-sponsor`.

## Exemplars

Exemplars are the organization's best past documents, listed by kind with a path, a tier and a quality mark. Seats
read them for structure, length and tone. They never copy sentences, never move content from one customer's exemplar
to another customer's document, and never read an exemplar above the draft's tier. An `avoid` exemplar is a
counter-example with its reason.

## Rules

1. One capability per signal; two ideas are two linked records.
2. A signal's capability sentence carries no codewords, customer names or controlled detail; detail stays in evidence.
3. Triage never raises maturity above what the evidence shows; a level without evidence is `claimed`.
4. Duplicates are linked, never deleted; repeated signals raise rank.
5. Rank by value and fit, then maturity, then age. Never by who raised it.
6. Signals and briefs cross a controlled boundary only as reviewed sanitized extracts.
7. A missed triage or decision SLA is escalated automatically; silence is not a decision.
8. Every layer of the fabric cites what it compiled. Numbers are copied, never recomputed or re-banded on the way up.
9. A red status stays red all the way up.
10. Asks in a brief come from the principal and are confirmed before the brief is held.
11. Length limits are hard: a brief that does not fit its format is cut, not shrunk in font.
12. Every claim in a progress report carries an evidence id; late contributor entries are listed as missing, not
    filled in by the compiler.
13. Release to a sponsor and sending outside are protected effects held for the named approver.
14. Exemplars are style only, never evidence, never verbatim, never across customers.

## Anti-patterns

- A "signals inbox" that is just email. Without the record fields and the SLA it becomes another queue nobody owns.
- Letting the brief drafter summarize from memory of last month. Every section is rebuilt from current sources.
- Asking a model to "make the report sound better". Tone comes from exemplars; content comes from evidence.

## References (public)

- NASA Systems Engineering Handbook (NASA/SP-2016-6105 Rev2), technical assessment and reporting.
- NASA Technology Readiness Level definitions.
- DoD Systems Engineering Guidebook (2022), technical reviews and program reporting.
- NIST AI RMF 1.0, MEASURE and MANAGE functions, for keeping model-drafted reports traceable to evidence.
