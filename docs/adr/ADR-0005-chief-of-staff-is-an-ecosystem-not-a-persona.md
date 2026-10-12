# ADR-0005: The Chief of Staff is an ecosystem of seats, not a persona

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

The natural first design for an executive assistant agent is one persona with a name, a voice and broad
tool access. That design serializes every matter through one agent, concentrates authority (capture,
plan, delegate, brief and check itself), cannot be independently checked, and loses state when the model
or host changes. Personas also obscure what the system can do: users relate to the character rather than
to the capabilities and limits.

## Decision

- Each principal is served by a Chief of Staff **ecosystem**: a set of staff seats
  (`principals[].chiefOfStaff.seats`) such as intake-provenance, decision-briefing, delegation-receipts,
  continuity-resumption, resource-cost-attention and exception-escalation.
- Each seat is a role contract with an explicit non-authority ("You may NEVER" before "You do"). Models,
  hosts and harnesses are replaceable routes bound to seats.
- Exception and escalation work is done by a seat independent of the seats it watches; domain
  verification comes from outside the Chief of Staff entirely.
- Matter state lives in a durable journal, not in model memory; resumption from a chat transcript is not
  allowed.
- Display names are role names (`chiefOfStaff.displayName`), not personas. Templates never introduce a
  persona.

## Consequences

- Positive: matters proceed concurrently; every privilege is small and auditable; losing a route does
  not lose state or widen authority.
- Negative: more moving parts than a single assistant; principals must learn which seat does what.
- Follow-up: the per-principal README in `os/principals/<id>/chief-of-staff/` explains seats in plain terms.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| One named persona assistant per principal | Serializes work, concentrates authority, self-checks |
| One shared assistant for the whole organization | Mixes principals' contexts and decision rights |
| Purely human chief of staff with tools | Does not scale to the volume of agentic work to coordinate |

## References

ARCHITECTURE.md §3; ADR-0002.
