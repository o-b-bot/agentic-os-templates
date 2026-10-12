# ADR-0017: Make factories cloneable kinds over one lifted, working runtime; the first working factory is the SWE factory lifted from the reference implementation

Status: proposed
Owner: project maintainers
Date: 2026-10-09

## Context

Every principal gets a Chief of Staff ecosystem and a Systems Engineering ecosystem that adapt to the role; the
factories behind them differ by work type. ADR-0006 already states that factories are kinds over one cell contract,
and ADR-0014 and design note §16 established the rule "re-implement patterns, lift the author's own tools" when the
Workbench was ported. Today the cell contract exists only as rendered templates and synthetic smokes; nothing runs
(`docs/ARCHITECTURE.md` §14 describes the path; the self-test's evidence class is `synthetic`). The sponsor's prior
platform ("the reference implementation") has working TypeScript packages for the work graph, the lease kernel and its
persistence, model routing, the factory supervisor, staffed orchestration, and SWE work-cell code (context bundle,
candidate bundle, work-cell verifier, outbox dispatcher, patch contract, completion verifier, an independent code
reviewer). The sponsor also decided that the runtime uses its own TypeScript A2A, MCP and ACP implementations and takes
no agent framework as a dependency.

## Decision

Lift the reference implementation's factory runtime into this repository as `@aof/*` packages (branch
`lift/factory-runtime-raw`: six packages plus `packages/swe-cells-raw`, scope renamed, de-identified, relicensed MIT by
the author), wire them beside the ported Workbench, and expose them to the Python CLI as `aof factory dispatch | status |
verify`. The SWE factory is the first working kind. Every other kind (finance, program management, electrical,
firmware, proposal writing, research, technical writing, data, DevSecOps, prototyping, capability demo) is a clone of
the same cell contract with a different verification catalogue, declared provable invariants (ADR-0016), tool
allowlist and charters; no kind re-implements the runtime. Third-party frameworks and the harness-engineering
literature inform patterns only.

## Consequences

- Positive: one runtime to verify; a new role's factory set is configuration plus a catalogue, not code; the dogfood
  proof (one intent through the SWE factory three times without a manual patch) exercises the same runtime every
  kind will use.
- Negative: the lift carries the reference's assumptions (PostgreSQL-backed persistence in places, fleet concepts)
  that must be made optional; mechanically renamed tests need repair; the TypeScript runtime and the Python CLI are two
  processes to deploy.
- Follow-up: SWE-2 lift lanes L1–L3 (`docs/wargame/2026-10-09/lanes/external/SWE2_LIFT_LANES.md`); per-kind
  invariant declarations in the schema; the connectors lift (the reference's A2A transport and council answering
  party) in a later lane; `aof deploy` units for the runtime.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Re-implement a work-cell runtime from patterns in Python | The Workbench rebuild was rejected for the same reason: it would not be the author's proven tool; months of re-discovery. |
| Adopt an open agent framework as the runtime | Sponsor constraint: own protocol implementations, no framework dependencies; frameworks are pattern sources. |
| One runtime per factory kind | Multiplies verification and deployment; contradicts ADR-0006. |

## References

ADR-0006, ADR-0014, design notes §16; `docs/ARCHITECTURE.md` §12 and §14; `docs/research/swe-factories/` (in
progress); grill register Q2 constraints.
