# ADR-0014: Two surfaces, one contract, and a replaceable coding agent

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

Deciders and builders need opposite things. A Director wants a short list of decisions with the draft
inline and one button; every extra panel is a reason to stop reading. An engineering Lead wants intents,
SE packages, cells, evidence, routes and budget at once. A single interface serves neither. Separately,
the coding agent that engineers use changes every few months; an OS wired to one product's API has to be
rebuilt each time. And a principal who has to open mail, a document library and a board to act on a
brief item will stop using the brief.

## Decision

- `surfaces.consoles[]` declares consoles by `kind`: `director` (calm, decision-centric), `engineering`
  (dense), `generic` (one calm console for small teams). Each has an `audience`, `noiseLevel`, `panels`,
  `actions` and `inlineRendering`.
- **The principal never has to leave the console to act** (`externalToolsHidden: true`): drafts, decks,
  documents and diffs render inline; approve, approve-with-constraints, request revision, release a
  hold, approve a send and approve a work item happen in the console; the integration performs the
  action on approval.
- **One API contract** behind every console: the same state (`state/work-items`, `state/briefs`,
  `state/decisions`, `state/holds`, the audit journal, the evidence ledger) and the same CLI actions
  (`aof decide`, `aof hold release`, `aof work sync`). `aof console build` renders a console; `aof
  mcp-serve` exposes the same actions to agents.
- **Delivery ladder** (`delivery`): `static-html` (PoC: generated page plus CLI actions) → `local-web-app`
  (MVP) → `desktop-app`. Moving up the ladder changes the renderer, never the contract.
- **The coding agent is an adapter** (`surfaces.codingAgents`): `primary`, `alternates`, `adapter`
  (`mcp`, `cli`, `api`, `file-drop`) and a constant contract `lane-prompt-in-candidate-and-evidence-out`.
  The agent receives a lane prompt and returns a candidate plus evidence; it never pushes, merges or
  approves. Replacing it is one config key.

## Consequences

- Positive: each audience gets a surface it will use; nothing is lost between console versions; agent
  churn costs a config change and a smoke check, not a rewrite.
- Negative: two consoles to keep consistent; inline rendering of office formats needs open-source
  converters; the adapter contract limits agent-specific features.
- Follow-up: wave 1 activates one console; the Director console arrives with the Director's wave.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| One console for everyone | Too noisy for deciders, too thin for builders |
| Deep-link principals into mail, libraries and boards | They stop acting from the brief; actions bypass the audit journal |
| Build the OS inside one coding agent's extension API | Rebuilt on every agent change; vendor lock-in |

## References

ADR-0002; ADR-0005; ADR-0011; ADR-0012.
