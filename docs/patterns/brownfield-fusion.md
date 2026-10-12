# Pattern: brownfield fusion

Rendered file: `ecosystem/FUSION_PLAN.md` (and `HOST_FRAMEWORK_FIT.md` when `rollout.hostFramework` is set).
Input: `existingSolutions[]`. Vocabulary: `ecosystem/CAPABILITY_CATALOGUE.md`.

Most organizations already have agents, assistants, automations, co-engineer tools or a whole agent platform
that people rely on. The OS fuses with them; it does not bulldoze them.

## Decision procedure

For each existing solution:

1. **Inventory it.** Name, kind, owner, users, its own maturity vocabulary (verbatim), interfaces, data tier.
   Ask its users, and check `SURVEY_REPORT.md` §5 for agent configs on disk.
2. **Match capabilities.** Express what it does in the capability catalogue's ids (seats, SE sub-organizations,
   factory kinds, capability classes). Claims are `reported` until an evidence record backs them.
3. **Compare with the template organ** that would do the same job on: output quality on the same inputs,
   governance (can it be denied a protected effect?), evidence (does it record command, revision, exit code?),
   interfaces (A2A / MCP / CLI / UI-only), data-tier fit.
4. **Decide**, and record the decision with its reason:

| Decision | When |
|---|---|
| **adopt** | It does the job at least as well and can live under OS governance as-is. |
| **wrap** | It does the job well but needs the OS's governance around it; expose it through an A2A or MCP adapter. A wrapper may remove powers (strip a push credential), never add them. |
| **build-alongside** | Unclear which is better; run both on the same inputs through one stage gate, then decide on evidence. |
| **replace** | The template organ is better on evidence; cut over after the organ passes its gate. |
| **retire** | Its job is no longer needed or is absorbed elsewhere; stop after its users confirm. |
| **undecided** | Not yet assessed. It is not wired into the OS. |

5. **Map it** (`mapsTo`) to organs, seats or factories: `factory:<id>/builder`, `chief-of-staff:<seat>`,
   `co-engineer:<seat>`, `systems-engineering:<sub-org>`, `knowledge:<store>`, `routing:<class>`.
6. **Plan improvements** for this instance (`improvementPlan`), smallest first.

## Per-role mapping

Each principal gets a "what you keep, what changes" section. Nothing a person uses changes without them being
told what replaces it and when. Adopted and wrapped tools stay in their hands.

## Transition

- Rule zero: never break something people rely on to make the new thing look clean.
- Build-alongside and replace run both paths through a full stage gate; output from the old path is `reported`
  until verified by the OS.
- A host agent framework that already schedules and spawns agents is the platform the OS runs **on** — never
  build a second scheduler beside a working one. The template contributes contracts (charters, gates,
  evidence, routing policy) and fills only the gaps the host lacks.
- Activation follows the rollout waves: a solution mapped to a planned factory or seat is not wired until that
  wave opens.

## Interface adapters

Prefer, in order: the solution's own A2A endpoint; its own MCP server; an existing open-source wrapper; a thin
new MCP (tools) or A2A (agent) wrapper over its REST / CLI / file interface. A UI-only tool cannot be wrapped
headlessly; it can only be a human-mediated lane with a receipt.
