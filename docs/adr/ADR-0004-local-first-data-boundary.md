# ADR-0004: Route by data tier, local first

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

Research, defense-adjacent and regulated organizations hold information that may not leave a machine or
network. Even ordinary businesses have internal data they would rather not send to public APIs. At the
same time, the largest models are usually cloud-hosted, and local resources range from one laptop to a
large GPU fleet. Without an explicit policy, routing is decided by whichever tool a seat happens to call.

## Decision

- `organization.dataBoundary` defines tiers in the organization's own vocabulary; each tier lists the
  route classes allowed to process it (`local-only`, `private-network`, `private-cloud`, `public-cloud`),
  whether data may leave the network, retention and marking.
- Programs, repositories, integrations, knowledge stores, workflows and existing solutions each carry a
  `dataTier`; anything unlabelled takes `defaultTier`.
- Routing is local-first (`resources.routingPolicy.localFirst`): a qualified local route is preferred even
  when a cloud route would rank higher, and only routes whose class the tier allows are eligible.
- Model servers bind to loopback and are reached through an authenticated tunnel or gateway; an
  unauthenticated model port is never exposed to a LAN or overlay network.
- Private principal context is never copied wholesale into shared prompts, indexes or provider context.

## Consequences

- Positive: the most important policy for sensitive customers is explicit and enforced in one place;
  local investment pays off directly.
- Negative: restricted programs may get smaller models and slower results; the growth plan must address it.
- Follow-up: route lists reviewed at each gate; the resource-cost-attention seat watches tier-driven gaps.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Cloud-first with a deny list of sensitive repositories | Fails open on anything not listed |
| Local-only everywhere | Needlessly weak for public and internal work where cloud is acceptable |
| Per-seat ad hoc model choice | No single place to audit where data went |

## References

NIST SP 800-160 Vol. 1; NIST AI RMF (map and manage functions); OWASP LLM Top 10 (sensitive information
disclosure).
