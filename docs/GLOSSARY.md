# Glossary

Status: draft
Owner: project maintainers

Terms used across the templates, schemas and documentation, in alphabetical order. Config keys are
given where a term maps to one.

| Term | Definition |
|---|---|
| **A2A** | Agent2Agent protocol (version 1.0; not compatible with 0.3). Agents publish an *agent card* at `/.well-known/agent-card.json` (legacy 0.x: `agent.json`) and exchange tasks whose states map onto the ledger and decisions. An `adapter` and `interfaces` value. |
| **Activation status** | Whether a configured item is live: `active` (its wave is at or below `rollout.currentWave`), `planned` (a later wave), `unscheduled` (in no wave) or `all-active` (no waves defined). Shown on each rendered file's `Activation:` line. |
| **Adjudication** | The Systems Engineering organization's decision on whether delivered evidence satisfies the approved package. Outcomes are accepted, rejected or requires-revision; a model's prose is never the adjudication. |
| **Adopt / wrap / replace / retire / build-alongside** | Fusion decisions for an existing solution. `existingSolutions[].decision`. See *fusion*. |
| **Agent card** | A2A 1.0 discovery document served at `/.well-known/agent-card.json`: name, description, version, `supportedInterfaces[]` (url, protocol binding, protocol version), capabilities, input/output modes and `skills[]`. The OS publishes one card per organ or factory, with seats as skills (`interop.exposeAsA2A`). The legacy 0.x path `agent.json` is read only as a survey fallback. |
| **Anti-pattern** | An observed failure mode with the rule that prevents it. Listed as AP-n in [OPERATING_PRINCIPLES.md](OPERATING_PRINCIPLES.md). |
| **Artifact custodian** | SE seat that keeps append-only, exact-revision custody of artifacts and baselines for one sub-organization. |
| **Audit event** | One record in the audit journal: event kind, actor seat, principal, timestamp, input digests and related `WI-*`, `DEC-*`, `EV-*` ids. Every OS action is one. `governance.audit.eventKinds`. |
| **Audit journal** | The append-only, hash-chained log of audit events, storing digests and paths rather than content ([ADR-0012](adr/ADR-0012-append-only-audit-journal-with-digests.md)). `governance.audit`, default `state/audit/journal.jsonl`; `aof audit append|verify|tail|query`. |
| **Authority epoch** | The current version of policy and decision rights. Work carries the epoch it was approved under; only one epoch is accepted at a time. |
| **Auto-create source** | A source (`factory`, `se-organization`, `workflow`, `manual`, `import`) whose work items are created on a board without per-item approval. Only on a team's own board, never on a principal-managed one. `externalSync[].autoCreateFor`. |
| **Baseline** | A reviewed, frozen set of artifacts (for example the stakeholder-requirements baseline). Changes go through change control. |
| **Batch window** | A scheduled period of unattended work with allowed work kinds, factories, data tiers, parallelism and a token budget; protected effects park until the morning. `operations.batchWindows[]` ([ADR-0013](adr/ADR-0013-unattended-batch-windows-park-protected-effects.md)). |
| **Binding kind** | Whether a deployed stack is wired to real executors (`professional`) or to scripted fixtures (`demo-fixture`). Checked after every deploy. |
| **Board adapter** | The connector that projects the work ledger onto one board family: `planner-graph`, `azure-devops-workitems`, `github-issues`, `github-projects`, `gitlab-issues`, `gitea-issues`, `jira`, `trello`, `outbox`, `none`. `externalSync[].boardAdapter`. |
| **Briefing** | A Chief of Staff document for a principal: what changed, what needs them, why now, what is recommended, what happens if nothing is done. At most five primary items. A *decision briefing* precedes a decision; a *final briefing* reports a delivered result. |
| **Builder** | Work-cell seat that produces the candidate in a worktree. Never pushes; cannot edit its own oracle. |
| **Bundle** | A git bundle (`^base..candidate`) used to deliver a candidate without forge credentials. A `deliveryMode`. |
| **Canary** | A qualification level: a route has produced validator-accepted output on a real probe, including a planted-defect case. |
| **Candidate** | The commit or artifact a work cell produces for one work item. Intermediate evidence; not done. |
| **Capability class** | A kind of work routed as a unit (health-check, intake-classification, se-synthesis, se-review, code-build, code-review, architecture-and-final-review). `resources.routingPolicy.capabilityClasses`. |
| **Chief of Staff ecosystem** | A staffed coordination organization serving one principal: intake, context, decisions, delegation, continuity, cost attention, escalation. Not a persona and not a single assistant ([ADR-0005](adr/ADR-0005-chief-of-staff-is-an-ecosystem-not-a-persona.md)). `principals[].chiefOfStaff`. |
| **Circuit breaker** | A cascade control (`operations.circuitBreakers[]`): when a seat, route, factory or journey repeats failures (consecutive failures or a rejection rate within a window), dispatch downstream of it stops and affected items park with the reason. Reset follows `resetRequires`. Closes OWASP agentic ASI08. |
| **Coding-agent adapter** | The replaceable link between the OS and whichever coding agent engineers use: lane prompt in, candidate plus evidence out; never pushes, merges or approves. `surfaces.codingAgents` ([ADR-0014](adr/ADR-0014-two-surfaces-and-a-replaceable-coding-agent.md)). |
| **Coherence check** | A test a correspondence draft must pass before it is offered for sending (thread correlation, unanswered questions, missing attachment, wrong audience for tier, commitment without decision, stale facts, tone and length, unowned action items). |
| **Co-engineer** | A principal's personal AI engineering ecosystem: discipline seats that do work *with* the person. `principals[].coEngineer`. |
| **Collision map** | In a lane prompt, the list of other live lanes, the paths they hold and expected shared hunks. |
| **Commissioning** | Taking a pipeline from "code exists" to "it ran for real" through phases 0 to 8 ([METHODOLOGY.md](METHODOLOGY.md) §4). Earned by a journey, never set by a flag. |
| **Console** | A surface where principals read their brief and act without leaving it. Kinds: **director** (calm, decision-centric), **engineering** (dense: intents, SE packages, cells, evidence, routes), **generic** (one calm console for a small team). `surfaces.consoles[]`; `aof console build`. |
| **Correspondence organ** | Drafts mail, chat replies, documents and decks; correlates threads; holds incomplete drafts. `organs.correspondence`. |
| **Council review** | Review of an SE package by several reviewers, with dissent recorded, bound to the exact package digest. |
| **Create-on-approval-then-sync** | Board mode: an item appears on the board when the approver approves the work item, then its mapped fields are kept current automatically. The mode for principal-managed boards. `externalSync[].mode`. |
| **Data boundary** | The policy that decides where a model may process each class of data. `organization.dataBoundary`. |
| **Data tier** | One level of the data boundary, in the customer's vocabulary, with allowed route classes, network egress, retention and marking. `dataBoundary.tiers[]`. |
| **Dataset card** | Registry record for a RAG corpus or fine-tune set: source, data tier, provenance, synthetic share, refresh date and owner. Required before indexing (`organs.registry.requireDatasetCardBeforeIndexing`); a store points to it with `knowledge.stores[].datasetCardRef`. |
| **Decision record** | The only artifact that authorizes a protected effect. Made by a principal, never by a seat. Id `DEC-<yyyymmdd>-<seq>`. `schema/decision.schema.json`. |
| **Decision rights** | Protected effects a principal may approve personally; anything else escalates. `principals[].decisionRights`. |
| **Deny-by-default** | No protected effect happens unless an exact decision authorizes it. `governance.defaultPosture: deny`. |
| **Delivery mode** | How a candidate leaves the factory: `local-branch`, `bundle` or `draft-pr`. |
| **Director** | A principal who leads a directorate or organization; typically the sponsor, top of the escalation chain and a consumer of rollups rather than a user of build factories. |
| **Domain lead** | SE seat that performs bounded domain analysis and cross-organization synthesis. |
| **Draft PR** | A pull request opened as draft by a publisher, bound to the exact head. A review request; never implies merge. |
| **Entitlements** | Which shared organs and factories a principal may use. `principals[].entitlements`. |
| **Evidence class** | How a claim was produced: `operational` (real system, real inputs), `synthetic` (fixtures), `demo-fixture` (scripted), `read-only-inspection` (read, not run). |
| **Evidence ledger** | Append-only store of evidence records. `evidence.ledgerPath`. |
| **Evidence record** | One claim bound to command, working directory, exit code, revision, isolation, cache state and non-claims. Id `EV-<yyyymmdd>-<seq>`. [EVIDENCE_RECORD.md](EVIDENCE_RECORD.md). |
| **Executor** | Whoever does a piece of work: the orchestrating seat, a builder lane or a local model. Also the node where work cells run (`executorNode`). |
| **Existing solution** | A brownfield agentic tool already in use. `existingSolutions[]`. |
| **Extended agent card** | The authenticated A2A card that carries internal detail (seat list, routes) kept out of the public card (`interop.exposeAsA2A.extendedCardAuthenticated`). |
| **External board mode** | How the ledger relates to one board: `read-only` (import as context), `create-on-approval-then-sync`, or `two-way` (plus board edits flow back). `externalSync[].mode`, `defaultExternalMode`. |
| **Factory** | A governed work-production capability: a non-cognitive supervisor plus work cells. Kinds: swe, ee, hardware, firmware, tech-writing, data, research, se-artifacts, custom. |
| **Failure class** | The fixed category a parked or failed journey is filed under (`organs.evaluation.failureTaxonomy`, default MAST): specification-and-design, inter-agent-misalignment or task-verification. Lets rollups say *why* journeys fail. |
| **Fence** | A monotonic number on a work attempt. A successor attempt gets a higher fence; only the winning fence is admitted. |
| **First task** | The one concrete task a wave must carry end to end before the next wave opens. `rollout.waves[].firstTask`. Wave 1's first task is normally the first-slice intent. |
| **First slice** | The PoC scope: one principal, one program, one repository, one factory, one intent. `lifecycle.firstSlice`. |
| **Forbidden authority** | An authority a seat or organ may never exercise regardless of model output, such as approve-as-principal or merge. |
| **Frontier-cloud** | The largest model class, served by a cloud provider. Reserved for architecture, final review and high-risk work. |
| **Fusion** | Comparing each existing solution with the template organs and deciding adopt, wrap, replace, retire or build-alongside, before building anything new. |
| **Growth plan** | Ordered steps for adding resources, each naming what it unlocks. `resources.growthPlan`. |
| **Hash chain** | Each audit event carries the digest of the previous event, so an edit, deletion or reordering is detectable with `aof audit verify`. Tamper-evidence of the record, not authentication; no keys. `governance.audit.journal.hashChained`. |
| **Host framework** | An organization's existing, dynamically scalable agent or engineering framework that the OS runs on, not beside. Each needed capability is rated mature, partial or absent. `rollout.hostFramework`. |
| **Hold / hold reason** | A correspondence draft or journey stage that cannot proceed records why (failed coherence check, missing decision, unavailable worker). A stall without a reason is a defect. A correspondence hold ("hold, don't send yet") is released only by a principal naming an approving decision: `aof hold new|list|release`, `state/holds/`. |
| **Independence group** | A label that keeps correlated actors apart: builder and reviewer differ; verifier is uncorrelated with lead, builder and reviewer. |
| **Independent reviewer** | Reviewer seat constrained to a disjoint concern, assigned by capability, never by list position. |
| **Intake** | Recording an input as an untrusted intake record before anything acts on it. Also the SE seat that receives typed requests. |
| **Integration branch** | The protected branch tickets branch from and merge into. `repositories[].integrationBranch`. |
| **Intent** | A principal's natural-language request for work, converted from a question by an explicit act. |
| **Inventory** | What `aof survey` found: nodes, providers, routes, repositories. `schema/inventory.schema.json`. |
| **Journey** | The ordered stages an intent passes, from submission to the briefed terminal state. `organs.chiefOfStaff.journeyStages`. |
| **Judge calibration** | Agreement between a model judge and human graders on a sample (`judgeCalibration.sampleRate`, `minAgreement`, defaults 0.1 and 0.8). Only a calibrated judge (`model-judge-with-human-sample`) may support a gate; a bare model judge never gates. |
| **Kill switch** | The ability of named principals to stop all factories, one factory, a work cell, a Chief of Staff or routing. `governance.killSwitch`. |
| **Lane** | A bounded unit of delegated work run by one model session with exclusive paths and a self-contained prompt. [LANE_PROMPT_TEMPLATE.md](LANE_PROMPT_TEMPLATE.md). |
| **Lead (factory seat)** | Work-cell seat that plans the work item. Does not author the cases the gate executes. |
| **Lead (principal)** | A principal who leads a discipline or program. Usually the first-slice principal. |
| **Lease** | Time-bounded assignment of one work item to one work cell by the supervisor. |
| **Level of rigor (LOR)** | The MIL-STD-882E set of software safety tasks required for a software function, set by its software criticality index (SCC × severity). Recorded per AI function as `levelOfRigor` (`lor-1` … `lor-4`, `none`). |
| **Live-failure loop** | Measure on the host → small fix → new candidate branch on the integration tip → deploy → new intent. |
| **Maturity ladder** | PoC → MVP → Production → Sustainment, with exit criteria per rung. `derived.maturityLadder`, `lifecycle.gateOverrides`. |
| **MCP** | Model Context Protocol: a standard for exposing tools and resources to models. Preferred adapter where an open-source server exists. The OS pins a revision (`interop.exposeAsMCP.protocolRevision`, default `2025-11-25`) and derives tool annotations from the protected-effect register. |
| **Model class** | Vendor-neutral size class: `tiny-local`, `small-local`, `medium-local`, `large-local`, `frontier-cloud`. |
| **Morning brief** | The daily contract between the OS and a principal: compiled after the batch window from state, within a reading-time budget and item cap, every item carrying its action. `principals[].chiefOfStaff.morningBrief`; `aof brief build`; output `state/briefs/<principal>/<date>.{yaml,md}`. |
| **Noise filter** | What keeps a projected board calm: batching (`batchMinutes`), quiet hours, a per-item daily push cap, and notes as a daily digest or never. `externalSync[].noiseFilter`. |
| **Non-claim** | What an evidence record explicitly does not establish. `nonClaims[]`. |
| **Operator** | The human (with an AI assistant) who runs the CLI, commissions and writes evidence. |
| **Organ** | A major functional part of the OS: Chief of Staff, co-engineers, Systems Engineering, factories, correspondence, plus optional hardware and security engineering. |
| **Outbox** | A board adapter (and a state folder, `state/outbox/<integration>/`) holding JSON change requests for a connector the organization already runs, when no named adapter fits. The OS never calls that system itself. |
| **Overlay** | The customer's own repository holding their config, inventory, private templates and rendered OS. |
| **Parked** | The state of a protected effect or failed task inside a batch window: not executed, recorded with its reason, and returned in the next morning brief with its action ready. |
| **pass^k (pass-hat-k)** | Evaluation metric: a task counts as passed only if all k trials pass (`suites[].trials`, `gateMetric: pass-hat-k`). Reported beside pass@1 (a single trial); gating suites use pass^k because single runs hide nondeterminism. |
| **Planted defect** | A deliberately defective input used to prove a reviewer or verifier can reject. |
| **Plane** | A logical layer: constitutional, non-cognitive coordination, cognitive, knowledge, execution. |
| **Posture (resources)** | `constrained`, `moderate` or `abundant`. Sets default model classes and parallelism. |
| **Posture (security)** | `internal-tool`, `customer-facing` or `regulated`. `governance.securityPosture`. |
| **Principal** | A human who holds decision authority. Served by a Chief of Staff ecosystem. `principals[]`. |
| **Principal-managed board** | A board, calendar or library one principal curates personally. Items are created there only on that principal's (or the named approver's) approval; afterwards progress syncs automatically; nothing is ever deleted. `integrations[].principalManaged`. |
| **Program** | A portfolio, product or project that owns repositories and systems and reports status. `programs[]`. |
| **Projection** | A derived index (vector, graph) over canonical documents. Never the source of truth. `projectionOnly`. |
| **Projection (board)** | A board's view of the work ledger, kept current by its adapter. The ledger stays the source of truth ([ADR-0011](adr/ADR-0011-os-owned-work-ledger-not-external-boards.md)). |
| **Protected effect** | An action with consequences outside the OS: merge, deploy, external-send, purchase, credential-mutation, infrastructure-mutation, data-export, production-data-access, hardware-actuation, publish, hire-or-contract, policy-change. |
| **Provenance header** | The comment at the top of every generated file naming its template; a reminder not to hand-edit. |
| **Publisher** | Trusted code outside the work cell that delivers a candidate (push branch, open draft PR). Refuses mark-ready, approve, merge, deploy, release. |
| **Qualification** | Proof a route can do its capability class: `none`, `health-check`, `canary`, `benchmark`. On the exact served model. |
| **Quarantine** | Taking a failing route or provider profile out of rotation with a reason. |
| **Quiet hours** | Per-principal hours with no notifications; drafts, updates and board pushes that respect them wait for the brief. `operations.quietHours[]`. |
| **Reviewer (factory seat)** | Work-cell seat that gives advisory review of the candidate. Never merges. |
| **Route** | A binding of a capability class to a provider, model, runtime and node. The only thing work is dispatched to. |
| **Route class** | Where a route runs: `local-only`, `private-network`, `private-cloud`, `public-cloud`. Checked against data tiers. |
| **RTM** | Requirements traceability matrix: each requirement with parents, allocation, verification method and evidence. Built by `aof trace` from requirement sets. |
| **Seat** | A role contract (what it does, what it may never do, its tools) filled by a qualified route. Seats are stable; models are replaceable. |
| **SE organization** | The Systems Engineering organ: sub-organizations of intake, domain-lead, artifact-custodian and independent-reviewer seats running the V. |
| **SE package** | The SE organization's output for an intent: requirements, architecture, interfaces, hazards, V&V plan, scope, rollback, recommendation, unknowns. |
| **Smoke check** | A check attached to a wave (`command` with expected exit code, required `evidence`, or `manual` observation) run by `aof smoke --wave N --run`; each writes an evidence record. `rollout.waves[].smoke`. |
| **Software control category (SCC)** | MIL-STD-882E classification of how much control software has over a hazard: autonomous (1), semi-autonomous (2), redundant fault-tolerant (3), influential (4), no safety impact (5). Every agent seat defaults to influential; a higher category is an explicit decision (`programs[].systems[].aiFunctions[].softwareControlCategory`). |
| **Standing authority** | Written, narrow permission to perform a protected effect under stated conditions without a per-item decision. |
| **Sub-organization** | One SE domain (for example requirements-rtm-change, safety-hazard). `organs.systemsEngineering.subOrganizations`. |
| **Stop rule** | A wave's plain-language condition for ending the improve loop and widening. `rollout.waves[].loopUntil`. |
| **Supervisor** | Non-cognitive factory coordinator: admits work, grants leases, recovers expired leases. Makes no domain judgment. |
| **Sustainment** | Ladder rung after Production: re-qualification and refresh as models, hosts and repositories change. |
| **Tombstone** | The board rule for an item a human deleted, moved or closed: the ledger records `externalState: gone`, sync stops for that item, the brief says so once, and the OS never re-creates it (`externalSync[].onExternalDelete: tombstone`). Requirement ids are tombstoned in the same spirit: never reused. |
| **TPM** | Technical performance measure: a quantified indicator with threshold and evidence ([METHODOLOGY.md](METHODOLOGY.md) §9). |
| **Train** | One branch integrating several fixes, verified at its exact head. |
| **Two Vs** | The V of the OS itself and the V the OS runs for the customer's systems. |
| **Two-way** | Board mode: created and updated by the OS, and edits on the board flow back into the ledger under a conflict policy. Typical for engineering's own board. `externalSync[].mode`, `.pullChanges`, `.conflictPolicy`. |
| **VCRM** | Verification cross-reference matrix: per requirement, the verification method, stage and closing evidence record. |
| **Verification catalogue** | The exact commands a verifier may run for a repository. Anything else is refused. `repositories[].verificationCatalogue`. |
| **Verification method** | `inspection`, `analysis`, `demonstration` or `test`. |
| **Verifier** | Work-cell seat that runs catalogue commands on the exact head and writes evidence. Uncorrelated with lead, builder and reviewer. |
| **Wave** | One increment of activation in `rollout.waves[]`: what it activates, its first task, smoke checks, exit criteria and stop rule. Wave 0 is plumbing; wave 1 is one ecosystem. |
| **Work cell** | A team of seats (lead, builder, reviewer, verifier) that takes one leased work item and produces one candidate. |
| **Work item** | One unit of OS work in the ledger, id `WI-<yyyymmdd>-<seq>`, with principal, assignee, status, data tier, history and links to decisions and evidence. `aof work new|list|update|import|sync|selftest`. |
| **Work ledger** | The OS-owned store of work items and the source of truth for all OS work; boards are projections of it. `organs.workManagement.ledger`, default `state/work-items`. |
| **Work-program revision** | The version of an approved plan. Monotonic; exactly one is accepted. |
| **Workflow** | Cross-principal choreography triggered by an event, with steps executed by named seats and protected steps gated by named approvers. `workflows[]`. |
| **Worktree** | An isolated checkout for one lane or work cell. Existing checkouts are never disturbed. |
