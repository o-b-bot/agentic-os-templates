# Pattern: information review

Rendered file: `security/INFORMATION_REVIEW.md` (when `organs.securityEngineering.informationReview.enabled`).
Related: `departments/<id>/DEPARTMENT.md`, `signals/CAPABILITY_SIGNALS.md`, the correspondence organ's holds.
Inputs: `organs.securityEngineering.informationReview`, `organization.dataBoundary.tiers`, `organization.departments`.

## The problem it solves

Agents move material. They draft mail, sync work items to boards, index documents into knowledge stores, assemble
proposals and briefs, and call models. Each of those is a moment where something that should stay inside a program,
a tier or a department can leave it. Data-tier routing already stops controlled material from reaching a route class
its tier does not allow; it does not stop a well-meaning draft from carrying a controlled paragraph to a wider
audience inside an allowed route.

Information review adds one check at the moments material moves: **flag, hold, and route to a human reviewer**. It is
a review-and-flag capability, not a classifier with authority.

## What it is not

It is not a classification or designation authority. The organization's security office remains authoritative, and
for controlled categories so does the designating agency. A reviewer's disposition here is a handling decision for
one move. A clean scan means no detector fired; it never means "approved for release".

## Where it fires

Configured triggers (`flagOn`): outbound drafts, cross-tier moves, cross-department moves, publication, proposal
submission, external send, board sync, knowledge indexing, and any model call to a route that is not local-only.

## How it detects

Detectors are deliberately plain and inspectable:

- marking banners and portion marks against the scheme's vocabulary (the public CUI Registry categories when the
  scheme is `cui`, or the organization's own list);
- keyword lists per category, maintained by the reviewers;
- personal-data patterns;
- export-control terms from the organization's own guidance;
- registered program names and codewords;
- optionally, a classifier model that runs **only on a local-only route**;
- human tags.

Detector lists can themselves be sensitive. They live with the reviewers at the highest tier they describe; seats see
match counts and span offsets, not the lists.

## The flag record

A flag references the artifact by digest and path, never copies it. It records the trigger, source and destination
tier or audience, suspected categories, detector hits as counts and span offsets, the reviewer, and the disposition:

| Disposition | Effect |
|---|---|
| release | the move proceeds unchanged |
| mark-and-release | required markings are added, then the move proceeds |
| redact | a redacted copy with a new digest moves; the original stays |
| sanitize-extract | only a de-identified extract moves |
| hold | nothing moves; the hold says what would change the answer |

With `holdUntilReviewed` on, a flagged artifact does not move until disposed: a held draft is not sent, a held sync
does not sync, a held model call does not leave the local route.

## Sanitized extracts and signals

The most useful disposition for a directorate is `sanitize-extract`. A capability discovered inside a restricted
program is often valuable elsewhere; the program's data, codewords, quantities and customers are not. The extract that
crosses is a de-identified signal: one capability sentence, kind, maturity band and owning program id. The source
artifact never crosses. In `human-approved` mode a seat drafts the extract and a reviewer approves it; in
`cleansing-system` mode the organization's existing cleansing system produces it and the OS records the output digest
without altering it.

## Departments and growth

Each department declares an information boundary: open, internal, controlled or isolated. Moves out of a controlled
department are `cross-department-move` events and pass review; an isolated department releases only sanitized
extracts. Adding a department with a controlled or isolated boundary means adding its reviewers here before its first
wave activates. The OS grows horizontally without loosening any existing boundary.

## Rules

1. Flag, hold, route to a human. The capability never disposes a flag by itself.
2. It is not a classification authority; the organization's security office is.
3. A clean scan is not an approval and is never reported as one.
4. Flags reference artifacts by digest; they never copy content, and detector hits are counts and offsets only.
5. The classifier detector runs only on a local-only route, whatever the artifact's tier.
6. Detector lists live with the reviewers at the tier they describe.
7. A reviewer never disposes a flag on an artifact they wrote; the other reviewer does, or it escalates.
8. With hold-until-reviewed on, nothing flagged moves before disposition, including model calls.
9. Across a boundary, only the sanitized extract moves; the source artifact stays.
10. Required markings are applied on every tier listed in `markingRequiredOnTiers` and every tier with `markingRequired`.
11. Every flag and disposition is an audit entry (digests only) and an evidence record when `auditEveryFlag` is on.
12. A new controlled or isolated department gets reviewers before its first wave.
13. No security theater: no signing, receipts or expiry schemes are added here. The checks that matter are the flag,
    the hold, the human disposition, and the audit entry.

## Configuration notes

- Fill `categories` with the organization's actual marking vocabulary; the profile placeholders are not authoritative.
- Name at least two reviewers so rule 7 can be satisfied.
- Enable `cross-department-move` in `flagOn` as soon as a second department exists.
- Start with `human-approved` sanitization; move to `cleansing-system` only when one already exists and is accredited
  by the organization's own process.

## References (public)

- U.S. National Archives, Controlled Unclassified Information Registry (category list and marking guidance).
- NIST SP 800-160 Vol. 1 Rev. 1, systems security engineering (protection needs and boundaries).
- OWASP Top 10 for LLM Applications, sensitive information disclosure.
- NIST AI RMF 1.0, GOVERN and MANAGE functions.
