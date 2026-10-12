# Pattern: finance and periods of performance

Rendered files: `finance/FINANCE_ORGAN.md`, `finance/BURN_RATE_REPORT_FORMAT.md`, `finance/HIRING_BRIEF_FORMAT.md`,
`finance/FUNDING_SCENARIOS.md`, and `programs/<program-id>/finance/POP_AND_BURN.md` for every program that declares
periods of performance.
Inputs: `organs.finance`, `programs[].periodsOfPerformance`, `programs[].staffingPlan`, `programs[].commercialization`.
Seats: the finance organ's own seats, plus the co-engineer seats `burn-rate-analyst` and `staffing-planner`.

## The problem it solves

A research or engineering organization funded by contracts, grants and internal R&D runs on periods of performance
(PoPs): a base period, options, phases, follow-on awards. Each has a start, an end, a ceiling, an obligated amount and
a number of people it pays for. Most of the trouble a director sees in finance is not arithmetic; it is timing. A PoP
ends before its successor is awarded. A role is needed in January but nobody started the hire in October. Spend runs
ahead of plan for three months before anyone notices, because the numbers live in a finance system the engineering
side reads once a quarter.

The finance organ exists to make timing visible early. It reads exports, computes a small number of measures per PoP
and per program, and surfaces the decisions those measures imply, while the people holding the decision rights still
have time to act.

## What it does and does not do

The organ **reads and computes**. It has no write path to the finance system, it never moves, obligates or commits
money, and it never hires. `purchase` and `hire-or-contract` stay protected effects held by principals.

Ingestion is file-based on purpose. Somebody, or a scheduled export job the finance team owns, drops CSV, XLSX or PDF
exports into the drop path. The organ hashes each file before opening it, parses it, maps its columns to a canonical
row with a configured column map, and writes every row with its provenance: file digest, sheet or page, row or table
index. Rows it cannot map are quarantined, never guessed. Totals per file must reconcile with accepted plus quarantined
rows, or the window is blocked.

From canonical rows it computes, per PoP and per program, per window (monthly or quarterly):

- burn in the window and plan versus actual, alerting above the configured percent of plan;
- cumulative spend against obligated and ceiling;
- average burn over the last three windows and runway in months, alerting below the configured threshold or when
  runway is shorter than the time left in the PoP;
- transition gaps between a PoP and its successor when the successor is not yet awarded;
- planned staff against funded FTE per PoP.

Hiring needs (`open`, `planned-hire` or `at-risk` rows in the staffing plan) are surfaced a configured lead time ahead
of the date they are needed, as a one-page hiring brief for the decision holder. Funding scenarios (baseline,
successor late by N months, option not exercised, reduced obligation, new award, hiring delayed) are produced as
labelled what-if views, never as forecasts of record.

## The PoP timeline

`POP_AND_BURN.md` renders a quarter-by-quarter table for each program: one row per PoP, filled cells where the PoP
runs, a distinct mark for proposed periods and for quarters where two PoPs overlap. Overlaps are normal (a base period
running into its first option) and matter for one reason: spend in an overlap must be attributed to exactly one PoP
per row. Ingestion quarantines ambiguous rows instead of splitting them by guess.

The same file lists staffing per PoP with gaps both ways (planned beyond funding, funded but not planned), the
program's hiring needs, and its commercialization track and readiness gate. The burn section links the latest burn
report's evidence id; the file itself holds no numbers.

## Where numbers go

Program leads see their own programs. The decision holder sees the department. Upward briefs and progress reports
take **aggregates** (burn percent band, runway band, transition gaps), never raw rows, and only after the information
review when it is enabled. Every downstream use cites the burn report's evidence id.

## Rules

1. The finance system of record stays authoritative. The organ never writes to it and never "corrects" a source number;
   discrepancies go to the source owner.
2. Hash before parse. A file whose digest was already ingested is skipped and logged.
3. No guessed columns. An unmapped column is kept verbatim; a row missing a required field is quarantined.
4. Reconcile or block. A window whose totals do not reconcile is not reported.
5. Every number carries its source rows. A number with no digest and row is removed from the report, not softened.
6. Flags first, worst first, each naming measure, threshold, value and rows. No adjectives such as "healthy".
7. A value of zero in ceiling or obligated means "not yet entered"; runway is not computed until it is.
8. Spend in a PoP overlap belongs to one PoP per row; ambiguous rows are quarantined.
9. Hiring needs surface a full lead time ahead. A brief for a role funded by a merely `proposed` PoP is marked `contingent`.
10. Hiring briefs are position briefs: no candidate names, no personal data, no outreach. The decision is
    `hire-or-contract`, executed by the decision holder outside the OS.
11. Scenarios are labelled `SCENARIO`, list every assumption, and never change the plan, the staffing plan or a PoP.
12. Finance outputs live at the finance organ's data tier and use only route classes that tier allows; briefs below
    that tier get aggregates.
13. Burn reports are `read-only-inspection` evidence: they read exports and run no verification command, and say so.

## Configuration notes

- Set `organs.finance.ingestion.columnMap` to match the real export headers before the first window; until then every
  row is quarantined, which is the correct failure.
- Set `hiringSupport.decisionHolder`; without it the top of the escalation chain receives hiring briefs.
- Put `fteFunded`, `ceiling` and `obligated` on PoPs as soon as they are known; the staffing gap and runway measures
  depend on them.
- `commercialization.readinessGate` should name evidence ("TRL 6 with hardware-in-the-loop evidence"), not a feeling.

## Anti-patterns

- Pulling live from the finance system with a service account "to save a step". It adds a credential and a write
  risk for no gain in timeliness that a scheduled export does not already give.
- Letting a model "estimate" a missing month. A missing month is a quarantine and a question.
- Reporting runway against ceiling instead of obligated. Ceiling is permission, not money.

## References (public)

- NASA Systems Engineering Handbook (NASA/SP-2016-6105 Rev2), technical planning and resource estimation.
- DoD Systems Engineering Guidebook (2022), program planning and technical measurement.
- NASA Technology Readiness Level definitions, used by the commercialization readiness gate.
