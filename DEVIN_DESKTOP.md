# Using these documents with Devin Desktop

Step by step, on the organization's machine. What Devin writes belongs to the organization; this repository stays
MIT-licensed reference material.

## 1. Make the workspace

Create a new repository owned by the organization (for example `cps-agentic-os-architecture`) and open it in
Devin Desktop.

## 2. Bring in the reference (download or copy; no git needed)

Make a folder `reference/` in the workspace and save these files into it, keeping the same sub-folders. On each page use
**Download raw file** (top right of the file), or copy the text into a new file of the same name:

- [`ARCHITECTURE_PROMPT.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/ARCHITECTURE_PROMPT.md)
- [`LICENSE`](https://github.com/o-b-bot/agentic-os-templates/blob/main/LICENSE)
- [`docs/ARCHITECTURE.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/docs/ARCHITECTURE.md)
- [`docs/OPERATING_PRINCIPLES.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/docs/OPERATING_PRINCIPLES.md)
- [`docs/GLOSSARY.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/docs/GLOSSARY.md)
- [`docs/METHODOLOGY.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/docs/METHODOLOGY.md)
- [`design/cps-research-directorate/README.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/design/cps-research-directorate/README.md)
- [`design/cps-research-directorate/ORG_CHART.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/design/cps-research-directorate/ORG_CHART.md)
- [`design/cps-research-directorate/ENTITLEMENTS.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/design/cps-research-directorate/ENTITLEMENTS.md)
- [`design/cps-research-directorate/compute-plane/COMPUTE_PLANE.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/design/cps-research-directorate/compute-plane/COMPUTE_PLANE.md)
- [`design/cps-research-directorate/compute-plane/DIAGRAM.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/design/cps-research-directorate/compute-plane/DIAGRAM.md)

The architecture decision records (`docs/adr/`) and design patterns (`docs/patterns/`) are optional extra reading; add
the ones Devin asks for.

## 3. Give Devin its rules

Open [`devin-desktop/AGENTS.md`](https://github.com/o-b-bot/agentic-os-templates/blob/main/devin-desktop/AGENTS.md), copy its text into a new file `AGENTS.md` at the
workspace root (or paste it into the app's rules or knowledge, if your version keeps them there).

## 4. Prepare the prompt

Open `reference/ARCHITECTURE_PROMPT.md` and copy the text block. Replace:

- `<repo>` with `reference`
- `<organization>` with your real details, for example:

  > As in the reference, except: [who the people are, e.g. Director, Principal CPS Engineer, Lead CPS Security /
  > Agentic-AI Systems Engineer, Lead CPS Hardware Engineer; no program leads]. Our in-house A2A/MCP implementation is
  > [where it lives]. The existing platform is [name and stack]. Compute is [N] Apple-silicon workstations as primary
  > capacity, with remote GPU servers for burst. Office suite: [e.g. Microsoft 365]. Data: [e.g. CUI and
  > export-controlled content present]. Constraints: [anything else].

## 5. Run it in phases

Send each message, review what Devin wrote, then send the next. Answer its questions before Phase 2.

**Phase 1: plan and questions.** Paste the filled prompt, then add:

```text
Phase 1 only. Read reference/ as AGENTS.md and the prompt describe. Write docs/architecture/00-plan.md: the artifacts you will produce, their order, and every open question you need answered before designing. Write no other file.
```

**Phase 2: foundations.**

```text
Answers to your open questions: [your answers]. Phase 2: write the principles and invariants, stakeholders and concerns per role, the use-case catalogue per person (actor, trigger, steps across organs, decisions, outputs, evidence, failure paths), and the requirements with IDs, under docs/architecture/. Stop and list what you assumed.
```

**Phase 3: models and diagrams.**

```text
Phase 3: write the SysML v2 textual model under models/ (parts, ports and interfaces, actions, states, requirements, use cases, verification cases) and the Mermaid diagrams under docs/architecture/diagrams/: context, components, one sequence per use case, cross-person flows, work-item and journey state machines. Parse the SysML with the SysML v2 Pilot Implementation if it is available; list anything you could not verify.
```

**Phase 4: the rest of the design.**

```text
Phase 4: write the A2A/MCP interface specification, the compute-plane design (primary and burst pools, memory fit plan, gateway route table, gaps; start from reference/design/cps-research-directorate/compute-plane/), data tiers, identity and permissions per role, the threat model, failure modes, observability, the V&V plan, PoC > MVP > production phases with exit evidence, and the traceability matrix from requirements to use cases, design and verification. End with the remaining assumptions and open questions.
```

**Later, only after the design is reviewed and approved:** ask for a walking skeleton on the existing platform,
limited to what the design calls for.

## 6. Check the results

- Mermaid diagrams render in the Markdown preview.
- The SysML v2 model parses (OMG SysML v2 Pilot Implementation, open source).
- Every requirement traces to a use case, a design element and a verification case.
- Assumptions and open questions are listed, not hidden.

## 7. Keep the reference current

When a file here is updated (for example the compute-plane design), download that file again over the old one.
