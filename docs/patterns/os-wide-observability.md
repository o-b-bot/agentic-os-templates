# Pattern: OS-wide observability

Rendered files: `observability/TELEMETRY_PLAN.md`, `LINEAGE.md`, `DECISION_EXPLANATIONS.md`, `USAGE_ACCOUNTING.md`,
`ANALYTICS_REPORTS.md`, `OS_AUDIT_AND_ANALYSIS.md`; related `governance/AUDIT_JOURNAL.md`. Input: the top-level
`observability` section of the config. Overview of how the pieces fit: `docs/OBSERVABILITY.md`.

## The idea

Most agent tooling audits *agents*: what one agent read, called and produced. An agentic OS needs more, because most of
what goes wrong happens between and around agents — a job placed on the wrong node, a route that changed under a running
journey, a decision taken on a brief built from a withdrawn source, a restricted trace exported to a shared backend, a
board sync that overwrote a human's edit. None of those appear in a per-agent log.

OS-wide observability makes **every organ, every system type, every decision and every data path** observable,
attributable and explainable, with five instruments that answer five different questions:

| Instrument | Question | Property that matters |
|---|---|---|
| Audit journal | what happened, for whom, on what basis | append-only, hash-chained, complete |
| Telemetry | how long, how much, where | cheap, sampled where safe, standard names |
| Lineage | from where | a graph, written as work happens |
| Decision explanations | why | bound by digest to the decision record |
| Usage accounting and analytics | how much, charged to whom, what next | attributable to principal, program and period |

They join on one key: the journey's `traceId`. A reader can move from a decision to its explanation, from the
explanation to its sources (lineage), from a source to the spans that read it (telemetry), and from any span to the
journal event it wrote.

## Standards, used as references

- **OpenTelemetry GenAI semantic conventions** (Apache-2.0) for span and metric names: `invoke_workflow` for a
  journey, `invoke_agent` for a seat, `execute_tool` for a tool, `plan` for planning, inference spans for model calls,
  `gen_ai.agent.id` = seat id and `gen_ai.agent.version` = charter digest. The conventions are still in Development
  status, so the version is pinned in config and a bump is a change request.
- **W3C PROV** as the vocabulary for lineage (entity, activity, agent; used, wasGeneratedBy, wasDerivedFrom).
- **OpenLineage** (Apache-2.0) as an optional export for batch pipelines, if the organization already runs a compatible
  open-source backend.
- **NIST AI RMF**: the MEASURE function (are the right things measured and acted on) and the GOVERN function (are
  roles, decision rights and accountability exercised) frame the stage-gate audit.
- **MAST** ("Why Do Multi-Agent LLM Systems Fail?", 2025) as the failure taxonomy for parked and failed journeys:
  specification and design, inter-agent misalignment, task verification — plus two operational classes,
  external dependency and budget.

No proprietary observability service is assumed. The default backend is JSON Lines files on the node that produced
them; an OpenTelemetry Collector is the next step.

## Rules

1. **Observe the OS, not just the agents.** Coverage includes scheduling, routing, node lifecycle, model swaps, board
   sync, drafts, holds, breakers, kill switch and configuration changes. The audit lists every organ and marks any whose
   events are not covered.
2. **Digests, not content.** Prompts, completions, documents and mail bodies are never written to telemetry or lineage;
   their digests are. Content stays where it already lives, under its own access rules.
3. **Telemetry inherits the data tier.** Every span carries the tier of the data it touched. A trace about restricted
   data is restricted data, and stays on a backend inside that tier. Roll-ups are classified at the highest tier they
   contain.
4. **One trace id per journey.** The journal, telemetry, lineage and explanations all carry it. A record without it is a
   defect.
5. **Standard names first, custom names namespaced.** Use the pinned GenAI conventions where they fit; put work item,
   decision, evidence, program, period, tier, route, node, pool and queue ids under an `aof.` namespace. Never overload a
   standard attribute (for example a conversation id) with an OS id.
6. **Every match records its rationale.** The router's reasons are telemetry; the decision explanation cites the match
   ids, so a principal can see which model and route produced each part of a brief.
7. **Explanations are written before the decision, not after.** The brief carries inputs, options, recommendation,
   dissent, rationale and evidence; the decision adds the human outcome. The explanation is bound by digest; a
   correction is a new decision.
8. **Lineage is a graph written as work happens.** Every read is a `used` edge and every output a `wasGeneratedBy` edge.
   Reconstructing provenance from transcripts afterwards is guesswork.
9. **Every row is attributable.** Usage carries principal, program and period of performance. What cannot be attributed
   is reported as unattributed — never spread across everyone.
10. **Idle capacity is not a user's cost.** With a per-node-hour model, idle time is reported as unallocated capacity, so
    utilization reports are honest and expansion decisions see the real headroom.
11. **Every report answers a named question for a named reader and informs a named decision.** A report nobody acts on
    is removed.
12. **Forecasts are labelled inferred and show their method.** They are never presented as observed.
13. **Classify failures with a fixed taxonomy.** Parked journeys, holds and findings carry a failure class, so trends say
    *why* work fails.
14. **Observability never acts.** Reports and alerts inform decisions; they never trigger a protected effect, a route
    change or a model promotion by themselves.
15. **A telemetry gap never erases an audit event; an audit gap is an incident.** The journal is the record of truth; the
    rest are views that can be rebuilt or resampled.

## What each audience gets

- **Principals** read decision explanations and lineage answers for their own decisions and outputs, and the reports
  listed for them: cost, decision latency, adoption, expansion.
- **The OS owner** reads coverage, capacity, queue waits, failovers and the monthly OS audit.
- **The systems engineering lead** reads route quality, model comparisons and lineage summaries, and decides model
  promotions.
- **Security engineering**, when enabled, reads data-path checks and tier violations alongside agent security
  monitoring.

## Lessons from the reference implementation

- Status that collapsed "configured" and "working" into one word ("ready") hid a downgraded run mode after an upgrade.
  Separate truth labels (observed, inferred, reported) carry into every report here.
- A reviewer that omitted part of its required output did so silently, and nothing downstream noticed. Coverage gaps
  are therefore rendered loudly (missing events per organ, unrecorded lineage sources, unattributed usage), never left
  as blank cells.
- Reports that described code in the present tense were read as claims that it had run. Every number here says whether
  it was observed or inferred, and cites the period and source it came from.

## How to adopt

1. Keep the defaults: `jsonl-files`, digests only, default coverage, lineage at artifact granularity, explanations on.
2. Pin the semantic-conventions version before MVP.
3. List every system type the OS touches in `usageAccounting.systemTypes`.
4. Turn on the weekly `capacity-plan`, `queue-wait-times` and `route-quality` reports first; add the rest when someone
   is named to act on them.
5. Move to an OpenTelemetry Collector when there is more than one node, with one backend per restricted tier.
