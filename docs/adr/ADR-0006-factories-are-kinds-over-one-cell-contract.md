# ADR-0006: Factories are kinds over one work-cell contract

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

Software is the most mature domain for agentic production, but organizations also need schematics
reviewed, firmware built, documents and decks written, data pipelines changed, experiments planned and SE
artifacts produced. Building a separate framework for each domain multiplies governance surface and
evidence formats.

## Decision

- Every factory is a non-cognitive **supervisor** (admits work, grants leases, records state, recovers
  expired leases) plus **work cells** of four seats: lead, builder, reviewer, verifier, each with its own
  tool allowlist, route and independence group.
- `organs.factories.factories[].kind` selects the artifact set and verification catalogue: `swe`
  (reference), `ee`, `hardware`, `firmware`, `tech-writing`, `data`, `research`, `se-artifacts`, `custom`.
  Kind templates under `templates/factory/kinds/<kind>/` override per-factory files of the same name.
- The cell contract is the same for every kind: the builder never pushes and cannot edit its oracle; the
  verifier runs only catalogue commands (or the kind's equivalent checks) on the exact revision; evidence
  records use one schema; delivery is `local-branch`, `bundle` or `draft-pr`.
- SWE and firmware factories require repositories; artifact factories may work on a document store
  (`artifactStore`).

## Consequences

- Positive: one governance model, one evidence format, one commissioning procedure for every domain;
  adding a kind is adding templates, not a framework.
- Negative: some domains need verification that is not a shell command (for example a design-rule check
  or a review against a checklist); the kind must express it as a catalogue entry or an inspection with an
  honest evidence class.
- Follow-up: CONTRIBUTING.md documents how to add a kind.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| A separate framework per domain | Multiplies governance and evidence formats |
| Software-only factories | Leaves most of a research directorate's work outside the OS |
| A generic "agent does task" cell without fixed seats | Loses independence and the builder/verifier separation |

## References

ARCHITECTURE.md §3; ADR-0002.
