# Pattern: truthful resource topology

Rendered files: `ecosystem/RESOURCE_TOPOLOGY.md`, `ROUTING_POLICY.md`, `routing-policy.yaml`,
`QUALIFICATION_LADDER.md`, `SURVEY_REPORT.md`, `GROWTH_PLAN.md`. Inputs: `resources` in the config and the
inventory (`schema/inventory.schema.json`) written by `aof survey`.

## The idea

"We have it" is never one fact. Keep separate objects for each layer between a piece of work and the hardware
that runs it — node, provider, model, route — and give each its own state. Work is dispatched only to a
**route**: capability class → provider → model → node.

A route has four separate states: **available** (it answered a probe), **configured** (a route binds it to a
capability class), **qualified** (it passed the qualification level its class requires and is not
quarantined), **commissioned** (a real intent ran through it under the gates and was verified). Every fact
carries a truth label: observed, reported, inferred, stale, conflict, unavailable, unknown. A rollup may never
silently upgrade a lower label.

## Rules (lessons from the reference implementation)

1. **Claim is not declaration.** The adapter declares the identity it actually used (provider, model, node);
   the route claims one. Refuse on any mismatch, and store the declaration. A run once credited a paid cloud
   provider for work a free local model did, because both adapters echoed the route's claim.
2. **Bind every set into a digest.** If a policy digest covers a list (hosts, routes), hash the list, not one
   scalar from it; otherwise members can be added unsigned.
3. **Producer and consumer share one function.** The code that writes a structure and the code that reads it
   import the same normalization; a generator emitting a list while a reader compared a scalar refused every
   route on the second node.
4. **Never drop a capability to get green.** Removing the second node to pass was the wrong fix; the real fix
   was small.
5. **A topology change at the same source revision is a migration.** State keyed by revision collides; detect
   and supersede it, do not crash-loop.
6. **Upgrades carry the mode forward.** After every upgrade assert the run mode (real vs demo fixture), the
   observed work-cell count and the running revision — not just "healthy".
7. **Observations expire.** Re-probe at admission, never once at boot; preserved timestamps become time bombs.
8. **A single point of capability is a fleet risk.** If every capable reviewer lives on a laptop that sleeps,
   measure the fallback before relying on it.
9. **Fixed transport timeouts override your budget.** Check every layer's timeout; run long work as detached,
   idempotent jobs.
10. **Explicit credential order.** Round-robin over a dead profile retries it forever; quarantine instead.
11. **Pin all model slots to the allowed cost class**, including auxiliary models for titles and compaction.
12. **Silent zero output: read the tool's own log** before trusting folklore.
13. **Unreferenced capacity is a defect.** Cross-check running models against routes that reference them.
14. **Canonical id is not served alias.** Record both; spell-check both.
15. **Generation is not observation.** Only a real authenticated status call writes an observation time.
16. **Network triage.** "Overlay ping works but SSH to every node times out" usually means a second VPN has
    captured the overlay's address range — not a fleet outage. Address nodes by id, never by IP.
17. **Instructions are part of the route.** Qualification includes the exact prompt and output contract; a
    model given bare data with no task is not qualified.
18. **Refusals are specific.** "Unavailable" everywhere hides "plan incomplete"; refusal codes are stable and
    specific.
19. **Accounts and cloud cells stay uncommissioned until used under gates.** Spend ceilings, loopback-only
    inference and auto-stop prevent speculative bills.

## The survey

`aof survey` is read-only: it probes well-known metadata endpoints, parses MCP client configs, reads A2A agent
cards, walks repositories, and records secrets by name only. It never sends prompts to paid endpoints. Its
output is discovery, not fitness: every route starts at qualification `none`. Findings such as an
unauthenticated model listener on a shared network block commissioning until resolved.

## Posture

`resources.posture` sets defaults: **abundant** (large local models for every seat, more parallel cells,
cloud optional), **moderate**, **constrained** (one cell, small models, strict budgets). Posture never relaxes
qualification or the data boundary.
