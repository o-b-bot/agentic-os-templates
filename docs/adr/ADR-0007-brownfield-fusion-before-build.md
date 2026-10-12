# ADR-0007: Fuse existing agentic solutions before building new ones

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

Organizations adopting this template already run agentic tools: coding assistants, review bots, internal
retrieval services, automation platforms, lab-built multi-agent frameworks, local model servers. Ignoring
them wastes proven capability and alienates their owners; replacing them by default repeats work. Yet
adopting them uncritically imports tools that do not emit evidence, respect data tiers or honor
authority separation.

## Decision

- Discovery inventories existing solutions (`aof survey` plus interviews) into `existingSolutions[]`
  before any new organ is built.
- Each solution is described in its own vocabulary (`tiering`), mapped to template organs (`mapsTo`),
  and given a decision: `adopt`, `wrap` (MCP or A2A adapter), `replace`, `retire`, `build-alongside` or
  `undecided`.
- Capability claims need an `evidenceRef`; otherwise they are inspection-class at best.
- The organ contract does not change because the implementation is borrowed: a wrapped solution must meet
  the seat's forbidden authorities, data tier and evidence requirements, and its `improvementPlan` says
  how.
- Owners of existing solutions participate in the decision; `build-alongside` is the default when unsure.

## Consequences

- Positive: faster time to first slice; existing investment and owners are respected; the OS integrates
  rather than competes.
- Negative: wrapped tools may lag the contract until their improvement plans land; fusion takes Discovery time.
- Follow-up: quarterly review of `build-alongside` items.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Greenfield build, ignore existing tools | Wastes proven capability; creates organizational resistance |
| Adopt everything as-is | Imports tools that break evidence, tier or authority rules |
| Mandate replacement by template organs | Repeats work and discards domain-specific strengths |

## References

ARCHITECTURE.md §5; ENGAGEMENT_PLAYBOOK.md §4.
