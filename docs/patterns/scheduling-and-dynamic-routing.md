# Pattern: scheduling, dynamic routing and model hot-swap

Rendered files: `ecosystem/SCHEDULING_AND_PLACEMENT.md`, `ecosystem/DYNAMIC_ROUTING_AND_FAILOVER.md`,
`ecosystem/MODEL_HOT_SWAP.md`, `ecosystem/NODE_LIFECYCLE.md`. Inputs: `resources.scheduling` and
`resources.dynamicRouting` in the config; node `status`/`pool`/`dedicatedTo`/`capacity` and route
`health`/`priority`/`modelVersion`/`lifecycle` in the inventory (`schema/inventory.schema.json`). Related:
`docs/patterns/resource-topology.md` (what exists and how far it is proven) and `ecosystem/ROUTING_POLICY.md`
(what is eligible).

## The idea

Three questions are easy to blur and must stay separate:

1. **Eligibility** — may this route serve this work at all? Data tier, capability class, minimum model class,
   qualification, budget, reviewer independence. Answered by the routing policy, before anything else.
2. **Matching** — among eligible routes on nodes that are online *right now*, which one wins? Answered at request
   time by the dynamic router, which writes down why.
3. **Placement and order** — when several jobs want the same capacity, which runs first and where? Answered by the
   scheduler: pools, queues, a priority policy, preemption, fairness and reservations.

Keeping them apart is what lets a small organization start with one GPU workstation and a shared queue, add dedicated
machines for restricted work as they arrive, introduce a second GPU node, and swap in a better model every few weeks —
without editing anything but two config sections and the inventory.

## Placement strategies

- **Dedicated**: persistent nodes pinned to a principal, organ or factory. Right for restricted data tiers that must stay
  on one person's machine, or for a use that must never wait. Costs idle capacity.
- **Shared pool**: one scheduled pool with priority queues. Right for few nodes and many uses. Costs waiting under load.
- **Hybrid**: dedicated pools for named uses, a shared pool for the rest. The honest default when the organization has
  not decided yet, which is most of them.

The strategy is a config value, not an architecture. Switching it changes pools and queues; it never changes data-tier
rules, and journeys already running finish where they started.

## Request-time matching

Matching runs hard constraints first (data tier, capability class, model class, context window, tool use, structured
output, qualification), excluding any route that fails one and recording which criterion excluded it. Survivors are
scored on preferences (queue depth, latency, cost, locality, canary recency). The winner, every candidate's scores and a
one-sentence reason are written as a **match-rationale record** with an id that travels with the journey and appears in
any decision explanation that used the output.

Once a journey has a route, it keeps it (stickiness per journey) unless the route fails. Reproducibility of one journey
beats a marginally better score halfway through.

## Failover

A node that misses its heartbeats is offline. Its journeys stop at the last checkpoint, matching runs again without the
failed node, and if the new route uses a different model the journey **replans** from the checkpoint and records that
the model changed. Attempts are bounded; after that the work queues or parks for a human with a failure class. A
protected effect is never moved: its approval was bound to a route, a model and evidence, and a different route needs a
new approval.

**Heartbeat does not revive a node.** A node in `offline` or `unknown` status does not return to `online` by receiving
a heartbeat. The node must complete the join checklist (`aof node join <id>`) — survey, health check, canary, licence
gate and tier attestation — before it is live again. `join` is earned; `heartbeat` only sustains a node that has
already joined. A declared-but-never-joined node stays at `last heartbeat: never` and is not counted as pool capacity.

## Model hot-swap

A new model is a **candidate route**: model card, licence gate, canary, shadow (a sample of live requests mirrored to
it, compared to the incumbent on the same inputs by digest and validator outcome only), evaluation with pass^k, then
promotion by a principal decision unless the organization has chosen automatic promotion on a clean eval pass. The
incumbent is retired, not deleted, so rollback is a state change. Rollback fires on eval regression, quarantine, a
breaker trip or a principal's order.

## Rules

1. **Eligibility before matching, matching before scheduling.** The scheduler orders only what the router may use, and
   the router only chooses among what the policy allows. No layer widens another's answer.
2. **Match at request time, pin per journey.** Routes are chosen against the nodes online now, then held for the rest of
   the journey unless they fail.
3. **Every match records its rationale.** Candidates, per-criterion scores, the winner and why. No rationale, no
   dispatch.
4. **A protected effect waiting on a human outranks everything.** Unblocking an approved merge or send comes before any
   other work.
5. **A human waiting outranks batch.** Interactive requests beat batch work of the same class; a reservation never
   blocks a person.
6. **Checkpoint before preempt; never preempt verification, a protected effect, or a waiting human.** An interrupted
   verification proves nothing; a half-executed effect is worse than none.
7. **Protected effects are never auto-rerouted.** They park on failure and need re-approval on a new route.
8. **A changed model means a replan, recorded.** Resuming another model's plan mid-journey produces work nobody can
   reproduce or review.
9. **Join is earned, not declared.** Survey, health, canary, licence gate and tier attestation, each with evidence,
   before a node takes work. A flapping node re-earns it.
10. **No silent promotion.** Every change of the active route for a capability class is a decision record and a
    telemetry event; shadow outputs are compared, never delivered.
11. **Keep the previous versions installed.** Rollback that needs a download is not a rollback.
12. **Dedicated means dedicated.** An empty dedicated pool queues its principal's restricted work; it never borrows the
    shared pool "to keep things moving".
13. **Starvation is fixed visibly.** A job that waited too long is promoted one class with a record, never silently.
14. **Config flags must agree.** A queue marked preemptible whose class is not preemptible is a configuration defect;
    the rendered file says so.

## Lessons from the reference implementation

- The only capable reviewer route lived on a laptop that slept on battery with the lid closed; every journey that
  needed it stalled. The offline rule, the drain procedure and the capacity plan's "first bottleneck" section exist so
  a single point of capability is visible before it fails.
- A client library's fixed transport timeout silently overrode a longer class deadline. Long work therefore runs as
  detached jobs with idempotent ids, which is also what makes checkpoint, preempt and resume possible.
- Observations recorded once at boot became time bombs. Heartbeats and re-qualification exist so node and route state
  is re-observed at admission, not trusted from yesterday.

## How to adopt

1. Start with `placementStrategy: shared-pool`, one pool, the default queues and the default priority basis.
2. Turn on telemetry for `route-match`, `batch-run` and `node-join-leave`, and read `queue-wait-times` for two weeks.
3. Add dedicated pools only for restricted tiers or for a measured wait problem; move to `hybrid`.
4. Leave `autoPromoteOn: never` until the evaluation suites have caught at least one regression on their own.
