# Architecture prompt: an agentic operating system for your organization

A single prompt for an architecture-capable coding agent. It asks for the architecture, design and principle-level
artifacts of an agentic operating system (a Chief of Staff per person, a systems engineering organization, factories by
work type, a human decision at every protected effect), tailored to your organization, using the design documents in
this folder as the reference.

Replace before pasting:

| Placeholder | Replace with |
|---|---|
| `<repo>` | The folder where you extracted these documents |
| `<organization>` | One paragraph on what differs from the reference directorate (people, roles, stack, compute, data sensitivity, integrations, constraints), or `as in the reference` |

What the agent produces for your organization is your organization's work; these documents are MIT-licensed
(see `LICENSE`).

```text
ROLE AND TASK
Act as principal architect. Produce the architecture, design and principle-level artifacts for an agentic AI operating system for the organization described under ORGANIZATION. Design first: write the artifacts below as files in this repository; only after they exist, use the organization's existing platform (if it has one) to scaffold a walking skeleton of exactly what the design calls for. Run on top of the existing platform and its scheduler; never build a second one.

REFERENCE MATERIAL (MIT-licensed design documents; adapt them to this environment, never copy them wholesale)
- <repo>/docs/ARCHITECTURE.md: the paradigm (Chief of Staff, systems engineering organization, factories) and its parts.
- <repo>/docs/OPERATING_PRINCIPLES.md: the rules every part follows. <repo>/docs/GLOSSARY.md: the terms.
- <repo>/docs/adr/: the architecture decisions and why; <repo>/docs/patterns/: the design of each part (Chief of Staff, systems engineering, factories, cross-person workflows, per-person ecosystems, Microsoft 365 integration, information review, resource topology, scheduling and routing, observability); <repo>/docs/METHODOLOGY.md: interview to first slice.
- <repo>/design/cps-research-directorate/README.md, ORG_CHART.md, ENTITLEMENTS.md: the reference organization, its people, roles and what each may see and do.
- <repo>/design/cps-research-directorate/compute-plane/: an example of the generated compute-plane design (narrative, Mermaid, SysML v2), produced from an example inventory; yours is generated from your surveyed environment.
Read these before designing. If something you need is not in them, say so under open questions and continue; never invent it.

ORGANIZATION
<organization>
Unless overridden above, the organization is the CPS research directorate in <repo>/design/cps-research-directorate/. Worked example (cps-research-directorate): a Director (calm console: outcomes and decisions only, no engineering internals, no build factory; decides budget, staffing, go/no-go and approvals); a Principal CPS Engineer (technical authority across both Leads, prototyping workbench, read-only portfolio finance, owns white papers and technical volumes); a Lead CPS Security / Agentic-AI Systems Engineer (dense engineering console; software, SE-artifact and agent-evaluation factories; accepts evidence); a Lead CPS Hardware Engineer (hardware/EE and firmware factories; lab, engineering-change and procurement requests). Each person gets their own platform instance, Chief of Staff and co-engineer; data crosses instances only through defined flows.

ORGANS (adapt, don't copy)
- Chief of Staff per person: intake, triage, its own small review council, morning brief within a reading-time budget, a "decisions needed" queue, correspondence drafted and held, never sent automatically.
- Systems Engineering organization with lead agents per sub-area: intent to requirements (checked with an SMT solver such as Z3), SysML v2 models checked by a parser, V&V criteria, ADRs and work packages; an independent review council critiques before a human approves.
- Factories by work type (for example software, firmware, hardware/EE, SE artifacts, technical writing, research, data, capability demos), each with a lead agent: an isolated work cell with a builder, a reviewer on a different model, a verifier that runs the repository's own checks, and a candidate plus evidence bound to that exact revision; never pushes, merges or sends.
- Canonical journey: intent > Chief of Staff > SE artifacts > human approval > work packages and ADRs > approval > factory > completion flows back factory > SE > Chief of Staff > brief.

END-TO-END USE CASES (each as actor, trigger, steps across organs, decisions, outputs, evidence, failure paths; one SysML v2 use case and one Mermaid sequence each)
- For every role in ORGANIZATION, its top workflows. For the worked example: Director: morning brief to recorded decisions; delegate a first pass and get it back; approve a proposal, report or budget change. Principal: triage an engineer's capability signal into an opportunity; own a white paper the Leads draft; review SE artifacts across both Leads; promote a prototype into a Lead's factory. Security/Agentic-AI Lead: intent to verified candidate commit; information review of outgoing material; agent evaluation, red-teaming and incident-to-eval-case. Hardware Lead: hardware and firmware work packages; lab, engineering-change and procurement requests. Shared: proposal capture end to end (signal, go/no-go, volumes drafted, assembled, reviewed, approved, submitted by a human); monthly progress report; upward brief; periods of performance and staffing.

AGENT PROTOCOL LAYER
Use A2A between agents and MCP for tools and data. If the organization already has an A2A or MCP implementation, it is the base (adopt, wrap or extend it, and replace nothing without an ADR). Every seat publishes an A2A agent card; agents delegate carrying the acting person's identity and one trace id end to end; every MCP write tool declares its protected effect so it routes to a human decision. Specify which interactions are A2A and which are MCP, version pinning, and how the implementation maps to the public specifications.

DISTRIBUTED INFERENCE AND NETWORKING (the compute plane under the organs)
- Nodes: GPU servers, Apple-silicon nodes and CPU executors, surveyed (GPU, VRAM, unified memory, CPU, RAM, disk), joining, draining and failing; a sleeping node or a VPN that captures the overlay range is a designed-for failure, not a surprise.
- Serving engines per hardware class (for example vLLM or llama.cpp on NVIDIA, MLX or llama.cpp on Apple silicon, llama.cpp on CPU): one OpenAI-compatible endpoint per model, bound only to loopback or the private network, each with its own key.
- A memory fit plan: which model lives on which GPU or node, quantization, context length, KV cache and parallel slots; no model silently falls back to CPU.
- An inference gateway: the single entry point; it authenticates the calling seat, enforces the data tier per route, routes by capability class, balances across replicas, applies deadlines, retries and circuit breakers, and records usage; nothing calls a node directly.
- Network and identity: a private overlay network, service identity (mTLS or per-route keys), no unauthenticated model port on any network.
- Model artifacts: model cards (license, provenance, quantization, measured speed and quality), weights cached per node with integrity checks, promotion card > canary > shadow > promote.
- Measurement: latency and throughput benchmarked per route on the real hardware; those numbers set the deadlines and the routing and drive capacity planning.
- Generated, not hand-drawn: the compute-plane design (deployment view, fit plan, gateway route table, gaps) is produced from the configuration plus the surveyed inventory of the real (brownfield) environment, and regenerated with a diff whenever the survey or configuration changes.

INTEGRATIONS AND DATA
- Office suite and boards (for example Microsoft 365 via Graph) with delegated identity and draft-only writes.
- The OS work ledger is the source of truth; an item reaches a leader's board only when that leader approves; progress then syncs there, edits flow back, nothing is deleted.
- Controlled information (for example CUI or export-controlled content) is flagged and held until a human clears it; only sanitized signals cross instances.
- Existing tools and agents are surveyed and each one adopted, wrapped, replaced, retired or run alongside.

COMPUTE AND MODELS
Local models first; route by capability class and data sensitivity; priority by role and deadline; reroute when a node leaves; model changes go card > canary > shadow > promote, never silently; deadlines per capability class are measured on the real route.

PRINCIPLES AND INVARIANTS
Humans make every protected decision (approve, merge, send, spend, publish); the OS never records a decision for a person. Append-only, hash-chained audit of every agent action, decision and tool call, storing digests rather than content. Every stopped step records why and what happens next. A check that verified nothing fails. Invalid model output is held, never guessed. Evidence states whether it is demo, inspection or operational. Kill switch and circuit breakers per seat.

OBSERVABILITY
OS-wide telemetry as OpenTelemetry GenAI spans; lineage ("where did this come from"); decision explanations ("why"); usage and cost accounting per person and program; capacity planning.

DELIVERABLES (files in this repository)
Principles and invariants; stakeholders and concerns per role; requirements with IDs; use-case catalogue per role; ADRs; a SysML v2 textual model (parts, ports and interfaces, actions, states, requirements, use cases, verification cases) that parses; Mermaid diagrams: context, components, one sequence per use case, cross-person flows, work-item and journey state machines; A2A/MCP interface specification; compute-plane deployment view (SysML v2 and Mermaid), memory fit plan and gateway interface specification, each regenerated from the surveyed environment; model routing and placement; data tiers, identity and permissions per role; threat model (agentic AI risks); failure modes; observability; V&V plan; PoC > MVP > production phases with exit evidence per phase; traceability matrix from requirements to use cases, design and verification; assumptions and open questions. Never invent facts about the environment: mark every assumption, and flag every place the environment differs from the reference.
```
