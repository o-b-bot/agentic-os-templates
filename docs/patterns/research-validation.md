# Research validation: the template against current public practice (2025–2026)

Status: research lane output, 2026-10-08. Scope: README, docs/ARCHITECTURE.md, docs/DESIGN_NOTES.md,
schema/agentic-os.schema.json (top-level sections, `organs.securityEngineering`, `organs.evaluation`,
`organs.registry`, `interop`, `organs.workManagement`), the CPS research-directorate profile README, and
`templates/governance/AGENT_ASSURANCE.md.j2`. Only recommendations that would **change** the template
are listed. "Read" means I read the source page or its search excerpt; nothing was executed against any
live API. Where only secondary coverage was reachable, confidence is lowered and the row says so.

What the template already does well (and practice agrees with): deny-by-default protected effects,
waves that grow autonomy one ecosystem at a time (matches the joint CISA/NSA/Five Eyes "start with
low-risk tasks, expand incrementally" advice), digests-not-content audit (matches OpenTelemetry GenAI's
opt-in content capture), a model/seat registry framed as an AI-BOM, `agentTelemetry: otel-genai`,
planted-defect probes, and an eval harness with `runOn` triggers. The gaps are mostly in currency
(spec versions moved), in the agentic (not LLM) threat list, in AI-specific T&E artifacts, and in
board-adapter edge cases.

## (a) Recommendations

| # | Topic | Recommendation | What it changes in the template | Conf. | Source(s) and status |
|---|---|---|---|---|---|
| 1 | Interop / A2A | Target A2A **1.0** (released; 0.3 is incompatible). Render cards with the 1.0 required fields: `name`, `description`, `version`, `supportedInterfaces[]` (`url`, `protocolBinding`, `protocolVersion`), `capabilities`, `defaultInputModes`, `defaultOutputModes`, `skills[]` (`id`, `name`, `description`, `tags`); optional `provider`, `documentationUrl`, `securitySchemes`, `securityRequirements`, `signatures`, `iconUrl`. | Add the missing `templates/interop/agent-cards/<name>.json.j2` (documented in `docs/TEMPLATE_CONTEXT.md` but not present in `templates/`); add `interop.exposeAsA2A.protocolVersion` (default `"1.0"`); add an agent-card JSON schema under `schema/` and validate rendered cards in CI. | high | https://a2a-protocol.org/latest/specification/ (spec, Linux Foundation / Agentic AI Foundation project, Apache-2.0 repo) |
| 2 | Interop / A2A | Discovery path is `/.well-known/agent-card.json`. Probe it **first** in `aof survey`; keep `agent.json` only as a legacy fallback and record which one answered. | `src/aof/survey/a2a.py` `PATHS` order; `docs/ARCHITECTURE.md` §5 and `docs/GLOSSARY.md` "A2A" (both still say `agent.json`); inventory field `a2aCardPath`/`a2aProtocolVersion`. | high | same spec §8.2 |
| 3 | Interop / A2A | Expose **one card per organ (or factory)**, with seats as `skills[]`, not one card per seat. Never publish a skill whose effect is protected; put internal detail (seat list, routes) in the authenticated **extended agent card** (`capabilities.extendedAgentCard`). | Remove `seat` from `interop.exposeAsA2A.granularity` enum (or mark it "testing only"); add `interop.exposeAsA2A.extendedCard: true`; render a skill per seat with `tags` = disciplines. | med | A2A spec §3.1.11, §4.4.5; practice inference |
| 4 | Interop / A2A | Replace `authMode: none-local|bearer|oidc` with A2A/OpenAPI-style `securitySchemes` (`http` bearer, `oauth2`, `openIdConnect`, `mutualTLS`, `apiKey`) so cards are machine-readable. Card **signing** (JWS + RFC 8785) stays optional and off under `securityPosture: internal-tool`, on under `regulated`. | `interop.exposeAsA2A.securitySchemes[]`, `interop.exposeAsA2A.signCards` (default false; posture overlay sets true). Consistent with ADR-0008. | med | A2A spec §4.4.1, §8.4 |
| 5 | Interop / A2A ↔ ledger | Map A2A task states onto ledger/decision states: `TASK_STATE_INPUT_REQUIRED` and `TASK_STATE_AUTH_REQUIRED` → a decision request or hold in the brief; `REJECTED` → `cancelled` with reason; `FAILED` → parked. An inbound A2A task never creates a principal-board item without approval. | `schema/work-item.schema.json` gains `externalTaskRef {protocol, taskId, state}`; status map table in `docs/patterns/work-ledger-and-audit.md`. | high | A2A spec §4.1.3 |
| 6 | Interop / MCP | Pin MCP protocol revision **2025-11-25**; treat the newer stateless draft as not-yet-released. For `aof mcp-serve`, publish tool **annotations** (`readOnlyHint`, `destructiveHint`, `idempotentHint`, `openWorldHint`) and derive them from the protected-effect register; any tool touching a protected effect only *requests* the effect (creates a pending decision). Use MCP **elicitation** for "needs principal input" and experimental **Tasks** for long-running calls only behind a flag. | `interop.exposeAsMCP.protocolRevision`, `.tools[]` become objects `{id, annotations, protectedEffect?}`; `interop.exposeAsMCP.experimentalTasks: false`. | high (revision) / med (annotation mapping) | https://modelcontextprotocol.io/specification/2025-11-25 and /changelog (open spec) |
| 7 | Interop / MCP auth | For any non-stdio MCP server the OS exposes or consumes: OAuth 2.1 resource-server model with RFC 9728 protected-resource metadata, incremental scope consent; never token passthrough. Local stdio stays unauthenticated. | `integrations[].authMode` add `oauth-resource-server`; `templates/integrations/` setup guides; survey records whether a server advertises protected-resource metadata. | med | MCP 2025-11-25 changelog (SEP-835, SEP-991) |
| 8 | Interop / registry | Do not depend on the official MCP Registry (still preview, API v1 not GA). Survey may *read* `server.json` metadata, but a registry listing is never evidence of safety or license; vetting stays with the brownfield `decision` + `evidenceRef`. | One line in `docs/patterns/resource-topology.md` and the fusion doc; `existingSolutions[].interfaces` may cite a `serverJsonRef`. | med | https://modelcontextprotocol.io/community/registry/charter |
| 9 | Governance | Add the **OWASP Top 10 for Agentic Applications (2026), ASI01–ASI10** as a second coverage table beside the LLM Top 10 in `AGENT_ASSURANCE.md.j2`. Gaps it exposes: ASI07 inter-agent communication (SE↔factory↔CoS envelopes are unauthenticated by design), ASI08 cascading failures, ASI06 memory/context poisoning of co-engineer working notes, ASI10 rogue agents. | New table in `templates/governance/AGENT_ASSURANCE.md.j2`; `standardsBaseline` id (see c); `organs.securityEngineering.monitoring.alertOn` add `cascade-breaker-tripped`, `memory-write-unprovenanced`. | high (list exists) / med (titles from secondary summaries) | https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/ (CC BY-SA 4.0 site licence) |
| 10 | Governance / cascades | Add a **cascade breaker**: if N consecutive stage outputs in one journey are rejected, or a seat's rejection rate crosses a threshold within a window, stop dispatching downstream of that seat and park with reason. This is the missing control for ASI08 and the joint guidance's "structural risk". | `operations.circuitBreakers[] {scope: seat|route|factory, trip: {consecutiveFailures, rejectionRate, windowMinutes}, action: park-and-report}`; brief section `failures-and-parked` lists trips. | med | OWASP ASI08; CISA et al. "Careful Adoption of Agentic AI Services" (2026-05-01) https://content.govdelivery.com/accounts/USDHSCISA/bulletins/41544ff (US gov, public) |
| 11 | Governance / identity | Record **which credential** performed each external action: `onBehalfOf` principal plus `credentialKind` (`delegated-user`, `app`, `workload`) and the seat. Prefer a distinct workload identity per organ for reads; delegated user identity only for the approved write. This is where NIST's agent-identity work and ASI03 point. | `schema/audit-event.schema.json` add `credentialKind`, `onBehalfOf`; `integrations[]` add `actsAs: delegated|app|workload`. | med | NCCoE draft concept paper (Feb 2026) https://www.nccoe.nist.gov/sites/default/files/2026-02/accelerating-the-adoption-of-software-and-ai-agent-identity-and-authorization-concept-paper.pdf (US gov, draft) |
| 12 | Governance / incidents | Add an **AI incident record** (what happened, seat, route/model digest, protected effect involved, detection source, containment, kill-switch use) and a rule that every incident and every planted-defect miss becomes a golden-task regression case. | `schema/incident.schema.json`; `governance.incidentProcess` gains `aiIncidentRecord: true` and `incidentToEvalCase: true`; `organs.evaluation.suites[].sources` includes `incidents`. | med | NIST AI 600-1 (GAI profile, "incident disclosure" actions) https://doi.org/10.6028/NIST.AI.600-1 (public domain); OWASP agentic list |
| 13 | Governance / data | Add **dataset cards** to the registry for every RAG corpus or fine-tune set (source, tier, provenance, synthetic share, refresh date); registry currently names model and seat cards only. | `organs.registry.requireDatasetCardBeforeIndexing: true`; `knowledge.stores[].datasetCardRef`. | med | CISA/NSA et al. "AI Data Security" (2025) via https://www.cisa.gov/ai (US gov); NIST SP 800-218A data-provenance tasks https://csrc.nist.gov/pubs/sp/800/218/a/final |
| 14 | Governance / watch | Track NIST **COSAiS** SP 800-53 overlays (single-agent and multi-agent overlays still in development as of 2026). Add a placeholder mapping, not a dependency. | `standardsBaseline` id `nist-cosais` marked `status: draft-watch`; `docs/adr/ADR-0003` note that draft documents are cited as "watch". | high (status) | https://csrc.nist.gov/projects/cosais (US gov) |
| 15 | SE / T&E | Add an **AI component T&E plan** per AI-enabled system, structured on the CDAO T&E framework's three levels (model, system integration, operational) and its six "thinking about" areas (performance, test methods, data, models, context, documentation). Today `AGENTIC_SYSTEM_ASSURANCE.md.j2` covers the OS's own agents, not AI inside the customer's systems. | New `templates/systems-engineering/per-system/AI_TE_PLAN.md.j2`, rendered when `programs[].systems[].containsAI: true` (new key). VCRM rows get method `ai-model-test`, `ai-integration-test`, `ai-operational-test`. | high | CDAO T&E Framework (Apr 2024, cleared for public release) https://www.ai.mil/Latest/Blog/Article-Display/Article/3940283/cdao-test-and-evaluation-strategy-frameworks/ |
| 16 | SE / hazards | For AI functions in safety-significant systems, record the MIL-STD-882E **Software Control Category** (autonomous → influential) and derive the **Software Criticality Index** / level of rigor. Default every agent seat to SCC 4 "influential" (advisory, human decides) and make any higher SCC an explicit decision. | `programs[].systems[].aiFunctions[] {id, scc, severity, swci, levelOfRigor}`; hazard log template column; `cpsExtensions.hazardAnalysis` adds `stpa-with-ai-controller`. | high (882E method) / med (AI application) | MIL-STD-882E w/Change 1 (DoD, public release); JSSSEH (DoD, public release) — via https://dair.nps.edu/bitstream/123456789/4401/1/SYM-AM-21-094.pdf |
| 17 | SE / CPS | Encode the joint "AI in OT" principle: models sit **outside** the control/safety loop and receive sanitized OT data; any AI output that reaches an actuator path is a protected effect with a human approver. | `cpsExtensions.aiPlacement: advisory-only|supervised|in-loop` (default `advisory-only`; `in-loop` requires a DEC and SCC ≤ 2 rigor); hazard template row. | high | "Principles for the Secure Integration of AI in OT" (CISA/NSA et al., 2025-12-03) https://www.hstoday.us/subject-matter-areas/cybersecurity/cisa-and-partners-issue-joint-guide-to-advance-secure-integration-of-artificial-intelligence-in-operational-technology/ (secondary; original is US gov public) |
| 18 | SE / operating envelope | Each AI component states its **operating envelope** (input distribution, data tiers, languages, task classes it was evaluated on) and a runtime check that flags out-of-envelope inputs; drift re-runs the suite. | `organs.registry` model/seat card gains `evaluatedEnvelope`; `organs.evaluation.suites[].runOn` add `envelope-drift`. | med | CDAO framework ("thinking about context/data"); NIST AI RMF MEASURE 2.x (public domain) |
| 19 | Evaluation | Run each golden task **k times** and gate on **pass^k** (all k succeed) for seats that feed protected effects; report pass@1 as well. Single-run pass rates hide nondeterminism. | `organs.evaluation.suites[] add trials (default 3) and gateMetric: pass-at-1|pass-hat-k`; TPM table. | med | Anthropic engineering, "Demystifying evals for AI agents" https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents (vendor material) |
| 20 | Evaluation | **Judge policy**: `model-judge` must not be allowed alone for any suite that gates a wave or a protected effect; require `model-judge-with-human-sample` with a recorded agreement rate (e.g. ≥ 0.8 on a ≥ 10 % sample) and grade **outcomes** (final state), not tool-call sequences. Include "should-not-act" tasks. | Schema rule: `judge: model-judge` invalid when `runOn` contains `before-wave-exit`; add `judgeCalibration {sampleRate, minAgreement}`; suite template requires negative tasks. | med | Same vendor source; MAST paper's validated LLM annotator (kappa reported) https://arxiv.org/abs/2503.13657 (arXiv preprint, open access; licence not checked) |
| 21 | Observability | Pin the OTel GenAI semconv version (still **Development** status) and define the mapping: `gen_ai.agent.id` = seat id, `gen_ai.agent.version` = charter digest, `invoke_workflow` = journey, `plan`/`invoke_agent`/`execute_tool` spans; WI/DEC/EV ids as custom attributes (do **not** fake `gen_ai.conversation.id`). Content attributes stay off, consistent with `content-digests-only`. Audit events carry `trace_id` so the journal and traces join. | `organs.securityEngineering.monitoring.otelSemconvVersion`; `schema/audit-event.schema.json` add `traceId`, `spanId`; mapping table in `docs/ARCHITECTURE.md` §9. | high | https://github.com/open-telemetry/semantic-conventions-genai (docs/gen-ai/gen-ai-agent-spans.md) (Apache-2.0) |
| 22 | Operations / failure taxonomy | Classify every parked/failed journey with a fixed **failure taxonomy** (specification/design, inter-agent misalignment, task verification) so TPMs can say *why* journeys fail, not just how often. | `schema/hold.schema.json` / park record add `failureClass`; brief and rollup group by it. | med | MAST, "Why Do Multi-Agent LLM Systems Fail?" (NeurIPS 2025 D&B) https://arxiv.org/abs/2503.13657 |
| 23 | Work projection / all boards | "Never delete" needs a **tombstone rule**: when the external item is deleted, moved or closed by a human (404/410, moved plan/project), record `externalState: gone` and stop syncing; never re-create. Plus mandatory optimistic concurrency per adapter: Planner `If-Match` etag (re-GET on 412), Azure DevOps JSON Patch `test /rev`, Jira transitions; 429 → honour `Retry-After`. | `externalSync[]` add `onExternalDelete: tombstone` (const), `concurrency: etag|rev-test|none`; adapter contract doc. | high | Planner update https://learn.microsoft.com/en-us/graph/api/plannertask-update ; ADO WIT REST https://learn.microsoft.com/en-us/rest/api/azure/devops/wit ; ADO limits https://learn.microsoft.com/en-us/azure/devops/integrate/concepts/rate-limits (vendor docs) |
| 24 | Work projection / Planner + Jira | Planner: Graph reaches **basic plans only** (premium plans live in Dataverse) — `two-way` on a premium plan silently fails; and Planner has no task-comment endpoint, so "notes digest" must go to task details/description (separate etag). Jira: status changes go through **transitions**, so `statusMap` must target transition names/ids; OAuth (3LO) apps are on **points-based hourly quotas** since 2026-03-02 (API tokens exempt). | `externalSync[].target` for planner adds `planType: basic` (validator rejects premium); `statusMap` for jira → `transitionMap`; `noiseFilter.digestTarget: comment|description`; adapter docs. | high (premium, transitions, quotas) / med (comment endpoint) | https://learn.microsoft.com/graph/api/resources/planner-overview ; https://developer.atlassian.com/cloud/jira/platform/rate-limiting (vendor docs) |
| 25 | Work projection / identity + limits | Separate **create identity** (principal's delegated token at approval time, in the console) from **sync identity** (app or service principal), since overnight sync cannot rely on a live delegated session; document blast radius (Graph `Tasks.ReadWrite.All` is tenant-wide). Budget writes: ADO 200 TSTU/5-min and a 10,000-revision cap per work item via REST; GitHub 80 content-creating requests/min, 500/h, GraphQL mutations 5 secondary points; Projects v2 is GraphQL-only. | `externalSync[] add createIdentity: delegated, syncIdentity: app|delegated`; `noiseFilter.maxPushesPerItemPerDay` default derived so lifetime revisions stay far below 10k; a per-adapter `rateBudget`. | high | ADO limits (above); GitHub https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api and https://docs.github.com/en/graphql/overview/rate-limits-and-query-limits-for-the-graphql-api (vendor docs) |

Notes on the remaining topics where no table row was justified:
- **Durable workflows / HITL.** The template already has checkpoint/resume, fences and parked effects.
  Current practice (MCP Tasks, A2A `input-required`, durable-execution engines) agrees; the only change
  is the state mapping in rows 5 and 6 and an idempotency key on every protected-effect dispatch, which
  the "one protected-effect state per exact target" invariant already implies — make it an explicit
  field (`dispatchIdempotencyKey`) in `schema/decision.schema.json`.
- **Cost attribution.** `gen_ai.usage.input_tokens/output_tokens` on spans, rolled up by seat and by
  `WI-*`, gives "cost per accepted change" without a new subsystem. Add the rollup to the TPM template.
- **Executive surface (topic 5).** I found no rigorous public study of reading-time budgets for
  executive briefs. The usable evidence is from clinical decision support: uninformative alerts behave
  like false alarms and erode response to the informative ones (BMC Med Inform Decis Mak 2017,
  https://pmc.ncbi.nlm.nih.gov/articles/PMC5387195/, open access). That supports the calm console and
  `maxItems`, but the template should present `readingTimeMinutes` as a configurable budget, not a
  research-backed number, and measure it: add TPMs `brief-items-acted-on-rate`, `decision-latency`,
  `items-deferred-twice`. Low confidence beyond that; keep it short.

## (b) Where current practice contradicts the template, or it over-engineers

1. **Stale A2A assumptions.** Survey probes `agent.json` first and the glossary calls it the common
   path; 1.0 uses `agent-card.json` with `supportedInterfaces`. A seat-granularity card option
   invites hundreds of cards — practice is one card per agent service with skills.
2. **`model-judge` alone is accepted as a gate.** Current evaluation practice treats an uncalibrated
   LLM judge as unreliable; the schema permits it on wave-exit suites.
3. **Only the LLM Top 10 is mapped.** The agentic list (Dec 2025) splits "excessive agency" into goal
   hijack, tool misuse, unexpected code execution and rogue agents, and adds inter-agent communication
   and cascading failures — the two risks a multi-organ OS is most exposed to.
4. **`two-way` sync is offered generically.** Planner premium cannot be reached at all, Jira status
   cannot be set directly, GitHub Projects v2 is GraphQL-only. The mode list should be adapter-specific
   (validator: which modes each adapter supports).
5. **"Delegated identity for every action" (Director console) vs overnight sync.** Delegated tokens
   are not a sound basis for unattended pushes; split create/sync identity (row 25).
6. **Over-engineering risk: reviewer pools and council minimums for tier-1 work** are fine as config,
   but the joint agentic guidance and vendor practice both favour the simplest workflow that passes
   evals; keep `defaultWorkTier: tier-1` for small kinds (solo-founder, small-business) and require a
   recorded reason to raise it.
7. **Over-engineering risk: hash-chained audit with `retentionDays` per principal** is reasonable;
   adding signing would be theatre under `internal-tool` — current practice does not require it.
   The template is right here; do not let A2A card signing pull signing into the internal posture.
8. **NIST AI RMF is treated as stable.** It is, but NIST AI 600-1 (the GAI profile) is the
   operational companion with concrete actions; citing only the 1.0 core under-specifies controls.

## (c) Public-domain / openly licensed references to add to `standardsBaseline`

Extend the enum (and give each a status: `final` or `draft-watch`). Paid standards text excluded.

| Proposed id | Reference | Licence / status |
|---|---|---|
| `nist-ai-600-1` | NIST AI 600-1, AI RMF Generative AI Profile (2024) | US gov, public domain; final |
| `nist-sp-800-218a` | SSDF Community Profile for Generative AI and Dual-Use Foundation Models (Jul 2024) | public domain; final |
| `nist-ai-100-2` | NIST AI 100-2 E2025, Adversarial ML taxonomy | public domain; final |
| `nist-cosais` | SP 800-53 Control Overlays for Securing AI Systems (agent overlays) | public domain; draft-watch |
| `nccoe-agent-identity` | NCCoE concept paper, software and AI agent identity and authorization (Feb 2026) | public domain; draft-watch |
| `owasp-agentic-top-10-2026` | OWASP Top 10 for Agentic Applications (ASI01–ASI10) | CC BY-SA 4.0; final |
| `mitre-atlas` | MITRE ATLAS adversarial-AI tactics and techniques | open data (Apache-2.0 data repo; verify on adoption); living |
| `cisa-agentic-ai-adoption-2026` | "Careful Adoption of Agentic AI Services" (CISA, NSA, ACSC, NCSC-UK, CCCS, NCSC-NZ, 2026-05-01) | US gov public; final |
| `cisa-ai-in-ot-2025` | "Principles for the Secure Integration of AI in OT" (2025-12-03) | US gov public; final |
| `cisa-ai-data-security-2025` | "AI Data Security: Best Practices…" (2025) | US gov public; final |
| `cdao-ai-te-framework` | CDAO T&E Framework for AI-enabled capabilities (model, SI, OT&E; Apr 2024) | DoD, cleared for public release |
| `dod-jsssseh` | Joint Software Systems Safety Engineering Handbook (companion to MIL-STD-882E) | DoD, public release |
| `nasa-swehb` | NASA-HDBK-2203 Software Engineering Handbook (supports NPR 7150.2D, NASA-STD-8739.8B) | NASA, public |
| `nasa-std-8739-8` | NASA-STD-8739.8B Software Assurance and Software Safety | NASA, public |
| `a2a-spec-1-0` | A2A Protocol 1.0 | Apache-2.0 (Linux Foundation / AAIF); final |
| `mcp-2025-11-25` | Model Context Protocol, revision 2025-11-25 | open licence; final |
| `otel-genai-semconv` | OpenTelemetry GenAI semantic conventions | Apache-2.0; development status |

Keep `stpa-public-guidance` but note the STPA Handbook is free to download, not openly licensed —
cite it, do not copy text from it.

Not found / not verified: a NASA AI/ML appendix to the SE Handbook (searches returned nothing specific);
an AI-specific chapter of the JSSSEH (referenced in DoD briefings, not located); the full ASI01–ASI10
titles from OWASP's own page (titles above come from multiple consistent secondary summaries).

## Summary

1. The template's core (deny-by-default, waves, digest audit, registry-as-AI-BOM) matches 2025–2026 practice.
2. A2A moved to 1.0: new card shape (`supportedInterfaces`), `/.well-known/agent-card.json`, extended cards, optional JWS signing.
3. The agent-card template referenced in TEMPLATE_CONTEXT is missing; add it plus a card schema and CI check.
4. Pin MCP 2025-11-25; derive tool annotations from the protected-effect register; do not rely on the preview registry.
5. Add the OWASP Agentic Top 10 coverage table; it exposes cascade, inter-agent and memory-poisoning gaps.
6. Add a cascade breaker, credential-kind in audit events, an AI incident record that feeds evals, and dataset cards.
7. For customer systems, add an AI T&E plan (CDAO three levels), 882E SCC/SwCI per AI function, and advisory-only AI placement in OT.
8. Evals: k trials with pass^k, calibrated judges only for gating suites, outcome grading, negative tasks, MAST failure classes.
9. Pin the OTel GenAI semconv version (still Development) with a seat/journey mapping; join audit and traces via trace ids.
10. Board adapters need tombstones, etag/rev concurrency, transition maps, split create/sync identity, rate budgets; Planner premium is unreachable.


> Update 2026-10-09: MCP revision 2026-07-28 has since been published (stateless transport, `server/discover`, looser tool schemas). The template now tests conformance against both the pinned 2025-11-25 revision and the newest published one, and promotes the pin only after both pass (see `seValidation.ai.conformance`). Source: docs/research/se-validation/04.
