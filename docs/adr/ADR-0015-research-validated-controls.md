# ADR-0015: Adopt research-validated controls for agents, AI components and board projections

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

A research pass ([patterns/research-validation.md](../patterns/research-validation.md)) checked the
template against 2025–2026 public practice. The core matched (deny-by-default protected effects,
incremental waves, digest-only audit, a registry framed as an AI-BOM). The gaps were in currency
(A2A moved to 1.0, MCP has a newer revision, the OpenTelemetry GenAI conventions are versioned), in
agentic rather than LLM threats, in AI-specific test and evaluation for AI *inside* customer systems,
in evaluation method, and in board-adapter edge cases. Nothing here was executed against a live API;
the confidence of each source is recorded in the report.

## Decision

Adopt the following controls as configuration and template behaviour. Each is a correctness or
accountability control, not a security ceremony; nothing here adds signing, key rotation or expiry
windows under the internal-tool posture ([ADR-0008](ADR-0008-no-security-theater-for-internal-posture.md)).

| Control | Config keys | Rendered in |
|---|---|---|
| OWASP agentic Top 10 coverage (ASI01–ASI10) beside the LLM list; provenanced memory writes, trace ids on inter-organ envelopes | `standardsBaseline: owasp-agentic-top-10`; `monitoring.alertOn` (`memory-write-unprovenanced`, `cascade-breaker-tripped`, `out-of-envelope-input`) | `governance/AGENT_ASSURANCE.md` |
| Circuit breakers for cascading failures | `operations.circuitBreakers[]` | `operations/OPERATIONS.md` |
| Acting identity and trace ids on every audit event; OTel GenAI mapping with a pinned version | `governance.audit.recordActingIdentity`, `linkTraceIds`; `monitoring.otelSemconvVersion`; `integrations[].actsAs` | `governance/AUDIT_JOURNAL.md`, `governance/PROTECTED_EFFECTS_POLICY.md` |
| AI incident record; every incident and missed planted defect becomes a regression case | `governance.incidents` | `governance/AUDIT_JOURNAL.md` |
| One key, one execution for protected effects | decision `dispatchIdempotencyKey` | `governance/PROTECTED_EFFECTS_POLICY.md` |
| Dataset cards before indexing | `organs.registry.requireDatasetCardBeforeIndexing`, `knowledge.stores[].datasetCardRef` | `knowledge/KNOWLEDGE_PLAN.md`, `ecosystem/RESOURCE_TOPOLOGY.md` |
| AI T&E plan per AI-enabled system on three levels (model, system integration, operational) | `programs[].systems[].containsAI`, `aiFunctions[]`, `cpsExtensions.aiTestAndEvaluation`; requirement `aiTestLevel` | `systems/<id>/AI_TE_PLAN.md`, VCRM |
| MIL-STD-882E software control category and level of rigor per AI function; STPA with the AI as a controller | `aiFunctions[].softwareControlCategory`, `severity`, `levelOfRigor`; `hazardAnalysis: stpa-with-ai-controller` | `systems/<id>/HAZARD_ANALYSIS_STPA.md` |
| Advisory-only AI placement by default; in-loop only by decision with SCC 1–2 rigor | `programs[].systems[].aiPlacement` | `AI_TE_PLAN.md`, hazard analysis |
| k trials and pass^k; calibrated judges only for gates; should-not-act tasks; MAST failure classes | `evaluation.suites[].trials`, `gateMetric`, `judgeCalibration`, `includeShouldNotActTasks`, `sources`; `evaluation.failureTaxonomy` | `systems-engineering/VV_PLAN.md`, `MEASUREMENT_AND_TPM.md` |
| Board adapters: tombstone, optimistic concurrency, create vs sync identity, rate budgets, transition maps, adapter-specific modes | `externalSync[].onExternalDelete`, `concurrency`, `createIdentity`, `syncIdentity`, `rateBudget`, `transitionMap`, `noiseFilter.digestTarget` | `work/WORK_LEDGER.md`, `work/EXTERNAL_BOARDS_POLICY.md`, console API contract |
| A2A 1.0 cards at `/.well-known/agent-card.json`, organ granularity, authenticated extended card; MCP revision pin with derived tool annotations | `interop.exposeAsA2A.{specVersion, wellKnownPath, extendedCardAuthenticated, cardSigning}`, `interop.exposeAsMCP.{protocolRevision, toolAnnotationsFromProtectedEffects}` | `docs/ARCHITECTURE.md` §12.1, coding-agent adapter |
| Brief effectiveness and cost TPMs | none (measured) | `MEASUREMENT_AND_TPM.md` (TPM-12 to TPM-17) |

Draft and preview sources (NIST COSAiS, the NCCoE agent-identity paper, the MCP registry, unreleased
protocol drafts) are **watch, not dependency** ([ADR-0003](ADR-0003-public-domain-standards-only.md)).

## Consequences

- Positive: the agentic risks a multi-organ OS is most exposed to (inter-agent communication, cascades,
  memory poisoning, rogue agents) have named controls; AI inside customer systems gets a T&E plan and a
  safety classification; evaluation claims stop resting on single runs or uncalibrated judges; board
  projection survives deletions, concurrent edits and rate limits.
- Negative: more configuration keys; the profile author must state SCC, severity and envelope for every
  AI function, and a rate budget for every board.
- Follow-up: re-check the OWASP agentic titles against OWASP's own page (taken from secondary
  summaries); re-check the A2A and MCP pins and the OTel semconv version at each release; promote
  draft-watch items only by a decided change.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Keep only the OWASP LLM Top 10 | Misses inter-agent communication and cascading failures, the two risks a multi-organ OS is most exposed to |
| Allow a bare model judge on wave-exit suites | Uncalibrated judges are unreliable; a gate would rest on an unmeasured grader |
| Turn on A2A card signing by default | Signing is ceremony for an internal OS ([ADR-0008](ADR-0008-no-security-theater-for-internal-posture.md)); it stays available under a regulated posture |
| Depend on draft overlays and preview registries now | Draft text moves; a gate built on it breaks silently |

## References

- OWASP Top 10 for Agentic Applications (2026): https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/ (CC BY-SA 4.0)
- NIST AI 600-1, Generative AI Profile: https://doi.org/10.6028/NIST.AI.600-1 (public domain)
- NIST SP 800-218A: https://csrc.nist.gov/pubs/sp/800/218/a/final (public domain)
- NIST COSAiS (draft-watch): https://csrc.nist.gov/projects/cosais
- NCCoE agent identity and authorization concept paper (draft-watch): https://www.nccoe.nist.gov/sites/default/files/2026-02/accelerating-the-adoption-of-software-and-ai-agent-identity-and-authorization-concept-paper.pdf
- CDAO T&E framework for AI-enabled capabilities: https://www.ai.mil/Latest/Blog/Article-Display/Article/3940283/cdao-test-and-evaluation-strategy-frameworks/
- CISA et al., Careful Adoption of Agentic AI Services (2026-05-01): https://content.govdelivery.com/accounts/USDHSCISA/bulletins/41544ff
- CISA et al., AI in OT principles (2025-12-03) and AI Data Security (2025): https://www.cisa.gov/ai
- MIL-STD-882E and JSSSEH, as summarised in https://dair.nps.edu/bitstream/123456789/4401/1/SYM-AM-21-094.pdf
- OpenTelemetry GenAI semantic conventions: https://github.com/open-telemetry/semantic-conventions-genai (Apache-2.0)
- MAST, Why Do Multi-Agent LLM Systems Fail?: https://arxiv.org/abs/2503.13657
- A2A specification: https://a2a-protocol.org/latest/specification/ (Apache-2.0)
- MCP specification 2025-11-25: https://modelcontextprotocol.io/specification/2025-11-25
- Board adapter limits (vendor documentation): Microsoft Graph Planner, Azure DevOps work item tracking and rate limits, Atlassian Jira rate limiting, GitHub REST and GraphQL rate limits — links in the research report, rows 23–25.
- Vendor material on evaluation (k trials, judge calibration, should-not-act tasks): https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
