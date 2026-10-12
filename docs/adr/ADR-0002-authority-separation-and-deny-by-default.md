# ADR-0002: Separate execute, judge and decide; deny protected effects by default

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

A capable agent can be wired to capture a request, plan, build, review, test and merge. Each step looks
reasonable; together they create an actor that grades its own exam. In the reference implementation,
independence was laundered in subtle ways: a gate executed verification cases authored by the lead it
was checking; a builder's writable paths included the test it was graded by; reviewer omissions were
silently filtered. Separately, effects such as sending mail or merging were at risk of being inferred
from UI actions or model output.

## Decision

- Three powers are never held by one party: **execute** (factory work cell), **judge** (independent
  reviewer, independent verifier, SE adjudication) and **decide/merge** (principal decision; hosted CI
  plus human review).
- The executor may not push, fetch or update remote references (`executorMayPush: false`); delivery is a
  separate publisher limited to pushing a branch and opening a draft pull request.
- Every effect in `governance.protectedEffects` is denied unless a decision record from a principal
  holding that decision right authorizes the exact target. `governance.defaultPosture` admits only
  `deny`.
- No protected effect is inferred from a UI action, model output or silence. A model response is never
  an approval (`governance.mergeGate.modelResponseIsNeverApproval`).
- Chief of Staff ecosystems hold none of the three powers; their forbidden authorities are defaults in
  `config/defaults.yaml`.
- Reviewer omission is loud: a missing required concern yields a `constrain` finding.

## Consequences

- Positive: every output has a checker that did not produce it; authority is auditable from config.
- Negative: more seats and routes; a principal must record decisions, which takes attention.
- Follow-up: kill-switch owners and escalation chain configured per organization.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| One trusted super-agent with broad permissions | Unbounded authority; self-verification |
| Allow-by-default with a block list | Misses new effect kinds; fails open |
| Model-based approval ("a stronger model approves") | Model output proves a call happened, not that a decision was made |
| Executor pushes directly to keep things simple | The model would choose the transport and remote identity |

## References

NIST SP 800-160 Vol. 1 (separation of privilege, least privilege); OWASP LLM Top 10 (excessive agency);
ADR-0008.
