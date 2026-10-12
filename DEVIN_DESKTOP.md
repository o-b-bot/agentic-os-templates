# Using these documents with Devin Desktop

Step by step, on the organization's machine. What Devin writes belongs to the organization; this repository stays
MIT-licensed reference material.

## 1. Make the workspace

Create a new repository owned by the organization (for example `cps-agentic-os-architecture`) and open it in
Devin Desktop.

## 2. Bring in the reference

In the workspace folder:

```bash
git clone https://github.com/o-b-bot/agentic-os-templates.git reference
```

Without git, ask Devin to download this repository's files into `reference/`, keeping the folder layout.

## 3. Give Devin its rules

```bash
cp reference/devin-desktop/AGENTS.md AGENTS.md
```

If your version of Devin Desktop keeps rules or knowledge somewhere else, paste the same text there.

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

When this repository is updated (for example the compute-plane design):

```bash
git -C reference pull
```
