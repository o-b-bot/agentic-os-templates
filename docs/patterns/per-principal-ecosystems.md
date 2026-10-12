# Pattern: per-principal ecosystems and collaborations

Rendered files: `ecosystems/ECOSYSTEMS.md`, `ecosystems/COLLABORATIONS.md`,
`ecosystems/collaborations/<id>/RUNBOOK.md`, and per principal `principals/<id>/ecosystem/ECOSYSTEM.md`,
`AGENT_ROSTER.md`, `COLLABORATIONS.md`, `AGENT_CARD.json` and `leads/<agent>/LEAD_CHARTER.md`.
Inputs: `ecosystemTemplates[]`, `principals[].ecosystem`, `collaborations[]`,
`organs.factories.factories[].accessRoles`, `interop.ecosystemHandoffs`, `resources.scheduling`.
Commands: `aof validate`, `aof render`, `aof handoff send | ack | return | list`, `aof registry list --agents`,
`aof selftest --only ecosystems,collaborations`.

## The idea

Every principal's platform runs its own stack. A Director, a Principal engineer, a Lead and a Program Lead each get
the same shape, sized to the role:

```
Chief of Staff lead  ─ staff seats (intake, decision briefing, status rollup, ...)
  └─ SE lead (portfolio | program | system | component)
       ├─ sub-organization lead ─ intake · domain-lead · artifact-custodian · independent-reviewer
       └─ factory leads ─ work cells of lead · builder · reviewer · verifier
co-engineer seats (work WITH the person)      capture seats (opportunities, sections, color teams)
```

A lead agent sits at every level. Leads coordinate; they never hold a decision right. The instance id is
`eco--<principal-id>`; seat ids are `cos:<p>/lead`, `se:<p>/lead`, `se:<p>/<sub-org>/lead`,
`factory:<factory-id>/lead`, and the existing `cos:`, `co:` and `factory:` seat ids below them. Seat cards use the
same ids, so `aof registry list --agents` shows which agents are carded.

The stack follows the systems-engineering structure in the NASA SE Handbook and the DoD SE Guidebook: a
technical-management function directs the engineering functions, and verification is independent of the producer.

## Choosing the template

1. `principals[].ecosystem.template` names it; `overrides` deep-merge over it (lists replace) and the result is
   re-validated against `$defs.ecosystemTemplate`.
2. With no template named, the role is inferred: no `reportsTo` and no co-engineer → `director`;
   `entitlements.seOrganization: lead` with an owned factory → `lead-engineer`; `lead` without one → `principal`;
   owns programs and submits intents → `program-lead`; otherwise `engineer`.
3. The first configured template with that role kind wins; else a built-in fallback (`default-director`,
   `default-principal`, `default-lead-engineer`, `default-program-lead`, `default-engineer`). Built-ins own no
   factories: they dispatch to every organization factory the principal holds an access role on, and take finance
   from the principal's console scope, so they are consistent on any configuration.

## Own versus shared factories

An **own** factory is an instance inside this ecosystem: `fac--<principal>--<kind>`, with its lead agent and
`workCells` cells, repositories and artifact store from the spec or from the principal's programs. Use it when the
principal's discipline is the factory's discipline (a security Lead's SWE, agentic-AI-engineering and DevSecOps
factories; a hardware Lead's EE, firmware and hardware factories).

A **shared** factory is an organization factory the ecosystem dispatches to. It resolves to the factory of that kind
on which the principal holds the strongest access role (`approve` > `dispatch` > `contribute` > `review` >
`consume`). Access is `accessRoles` first, then program ownership (`approve`), then `sharedWith` (`dispatch`). No
access role → a configuration error that names the fix. A Director's ecosystem normally owns no build factory; a
template giving one an own `swe`, `ee`, `hardware`, `firmware`, `data`, `agentic-ai-engineering`, `devsecops` or
`prototyping` factory produces a warning.

## Routing and roll-up

- Queues: the template's list, else every queue whose priority class the role uses (Director p0–p1; Principal and
  Program Lead p0–p2; Lead and operator p0–p3; engineer p1–p3) plus queues that name the principal in `serves`.
- Pools: the template's list (else the pools of those queues, minus pools dedicated to other principals), plus the
  principal's dedicated pool(s). A template that names another principal's dedicated pool warns.
- Roll-up resolves through `reportsTo`: `statusTo` and `escalationsTo` become a principal id or none;
  `receivesFrom` becomes direct reports, every descendant, or nobody. Roll-up carries status and escalations up and
  questions down. It never carries authority.

## Collaborations

A collaboration is one artifact kind produced on one shared factory by several ecosystems: owner, contributors,
reviewers, approver and consumers, joined by a chain of handoffs (`from` role → `to` role, `when`, `via`, `slaHours`,
`returnTo`, `protectedEffect`). `aof handoff send` writes a handoff record (`schema/handoff.schema.json`), a ledger
work item assigned to the receiver with `source.ref: handoff:<id>`, and when `via` is `a2a` or `both` an A2A task
request file in `state/outbox/a2a/<target-instance>/` addressed to the receiver's rendered agent card. Nothing goes
over the network; a transport picks the file up. `ack` moves the receiver's work item to in-progress; `return`
closes it and opens one for the `returnTo` role. `list` expires anything past its SLA, writes a high-severity alert
event, and both principals' briefs show it under failures-and-parked.

Role and access must agree: owner needs dispatch or approve; contributor needs contribute, dispatch or approve;
reviewer needs review or approve; approver needs approve, or the decision right for every protected effect the
chain hands it. Mismatches warn with the exact `accessRoles` key to set. A handoff that carries a protected effect
requires the approver to hold that right (an error otherwise), and only delivers the package to the approver's desk.

## Rules

1. One ecosystem instance per principal. Two principals never share a Chief of Staff or an SE lead.
2. Every level has a lead agent, and every lead charter puts "You may NEVER" before "You do".
3. Leads coordinate and prepare; principals decide. No lead, seat or cell holds a protected effect.
4. No agent reviews or verifies its own output; evidence is an `EV-<yyyymmdd>-<seq>` record bound to command, exit
   code and revision, never a model's statement.
5. Reach another ecosystem only through a collaboration handoff or a rollup; never write into its state.
6. Use a shared factory only through an access role on it. A template listing one without access fails validation.
7. Own build factories belong in the ecosystems of the people who own that discipline; Directors dispatch.
8. Roll-up is status and escalation. A parent asks; the child's principal decides.
9. Every handoff has an SLA; a breach is visible (alert event and brief item) the same day.
10. A handoff carrying a protected effect needs an approver who holds that decision right, and it executes nothing.
11. The template's finance setting and the console's finance scope agree, or validation fails.
12. Run `aof selftest --only ecosystems,collaborations` after every change to templates, access roles or chains:
    it drives a synthetic artifact through every chain in a temporary state.

## Activation

Ecosystems activate with their principal in `rollout.waves`. Start with one ecosystem and its plumbing; add its own
factories at one cell each; add collaborations at the stage named in `enabledAtStage`. `ECOSYSTEM.md` lists the
activation of the instance, its SE sub-organizations and its shared factories wave by wave.

## What this pattern deliberately leaves out

No signing, receipts or expiry windows on handoffs: the checks that matter are the ledger record, the audit chain,
the SLA and independent review. No live A2A transport in the template: the outbox file is the contract, and an
operator wires the transport (an open-source A2A server first).
