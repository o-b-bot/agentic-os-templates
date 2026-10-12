# ADR-0010: Run on the host framework, never beside it

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

Larger organizations, research directorates in particular, often already operate a dynamically scalable
agent or engineering baseframework: it spawns agents, delegates to sub-agents, keeps a tool registry,
scales workers and has its own tiering. The template ships its own plumbing (supervisor, leases, routing,
ledger, protected-effect gate) for organizations that have none. Standing that plumbing up beside a
working framework would create two schedulers, two views of where a task is, and an organizational
contest between the template and the framework's owners. Discarding the template's contracts in favor of
the framework would lose authority separation and evidence discipline where the framework lacks them.

## Decision

- `rollout.hostFramework` names the framework (`existingSolutionId`), the `integrationMode` (`adopt`,
  `wrap`, `build-alongside`) and a maturity map over the capabilities the OS needs: dynamic-scaling,
  agent-spawning, sub-agent-delegation, tool-registry, tiering, evidence-ledger, protected-effects,
  model-routing, data-boundary, knowledge, scheduling, observability, independent-review,
  verification-harness.
- **Mature** capabilities are used as-is; the template supplies only role contracts and mappings.
  **Partial** capabilities are used and the gap is filled by template plumbing. **Absent** capabilities
  are supplied by template plumbing.
- The OS never stands up a second scheduler beside a working one.
- The template's contracts do not weaken on the host: forbidden authorities, independence groups,
  evidence bound to command and revision, deny-by-default protected effects. Wave 0 smoke checks prove
  each mapped capability.
- The host's vocabulary is kept verbatim; mappings are recorded in `hostFramework.notes` and rendered
  into `os/ecosystem/`.
- When the host matures a capability, the rating is raised with evidence and the corresponding template
  plumbing is retired.

## Consequences

- Positive: existing investment and owners are respected; one scheduler, one source of truth; the
  template adds what the host lacks instead of competing with what it has.
- Negative: mapping effort in Discovery; template behavior depends on host behavior for mature
  capabilities, so host changes need re-running smoke checks.
- Follow-up: fusion (ADR-0007) identifies the host candidate; the engagement playbook adds the
  capability map to Discovery deliverables.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Template plumbing beside the host framework | Two schedulers; lost tasks; organizational conflict |
| Replace the host framework with template plumbing | Discards proven capability; repeats work |
| Adopt the host wholesale and drop template contracts | Loses authority separation and evidence where the host lacks them |

## References

ADR-0007; ARCHITECTURE.md §6.
