# ADR-0016: Validate SE artifacts with layered, property-matched checks that are proven able to fail, selected by artifact criticality

Status: proposed
Owner: project maintainers (sponsor decision pending on the per-work-type invariants, grill question Q2b)
Date: 2026-10-09

## Context

Factories execute what the Systems Engineering ecosystem hands them: requirement sets, work packages, architecture
decision records, interface specifications and verification plans. A defective artifact is executed with confidence,
for every work type (software, electrical, finance, program management, proposals, research), not only for
cyber-physical systems. The sponsor asked (grill register Q2, `docs/wargame/2026-10-09/GRILL_REGISTER.yaml`) whether
solver verdicts, model checkers, SME council agents with consensus, deterministic gates, an ensemble of all of them,
human flags or multiple validation loops are "best", while refusing to over-engineer every ecosystem. Today the
template has deterministic gates (`aof validate`, `aof trace`, the requirement lint), an executable SE validation
layer with the verdict rules (`docs/SE_VALIDATION.md`), judge calibration (`organs.systemsEngineering.seValidation.ai.judgeCalibration`)
and the rule that builder and reviewer are never the same route. It has no validation profile per artifact class, no
reviewer pool with a merge rule, no consumer readback and no bounded loop.

## Decision

Match each validation mechanism to the class of property it can decide, prove every checker able to fail on a
planted defect before its verdicts count, and select the depth with one configuration field per artifact class
(`validationProfile: standard | factory-bound | safety-critical`, proposed under `organs.systemsEngineering`).

1. **Deterministic gates, every class, always.** Schema validity, trace completeness, EARS and one-verb lint,
   acceptance criteria with a comparator and a threshold, every verification command resolves in the repository
   catalogue. Fail-closed; no model involved.
2. **Solver and model-checker verdicts only where an encoding exists.** Budgets and interface ranges (SMT), timed
   requirements (realizability), protocol properties of the OS itself such as "no protected effect without a decision
   record" (model checking). The seat proposes the encoding, an independent seat reviews it, the solver decides;
   `unknown` and `timeout` never pass. Each factory kind declares, next to its verification catalogue, the invariants
   its work packages must prove and the checker that proves each (per-work-type, never domain-specific).
3. **Independent multi-reviewer with a union-of-blocking rule, never a vote.** Two or three reviewer seats with
   different charters and, where possible, different routes return line-bound findings with severity and a proposed
   fix; a deterministic merger de-duplicates; any unresolved blocking finding fails the gate. Reviewers are calibrated
   on planted-defect artifacts and removed from the pool when they pass planted defects. Agreement among reviewers
   sharing a base model is not evidence; defects found are the signal. A jury-style aggregation is admissible only for
   judgment properties and only with route diversity (see the pending review of the multi-model jury literature,
   `docs/research/se-validation/09-…`).
4. **Consumer readback before dispatch.** The executing factory's lead agent restates the work package's acceptance
   criteria as catalogue commands and names the files it will touch; a field-level diff plus one reviewer pass gates
   the dispatch.
5. **Humans see exceptions only, as decisions.** Fails on gates they own, unknowns on required gates, reviewer
   disagreements the merger cannot resolve, and protected effects. Everything that passes flows to the Lead's batch
   decision at the review gate (Q1: internal requirements, the Lead accepts evidence, no external ceremony).
6. **Bounded loops.** Author → gates → review → readback, each loop with a maximum iteration count and a cost cap,
   every iteration audited; exceeding a cap flags the artifact to the owning principal.

Profiles: `standard` (deterministic gates + one reviewer) for everyday Chief of Staff artifacts; `factory-bound`
(adds the calibrated reviewer pool, the readback and the kind's declared invariants) for requirement sets, work
packages, ADRs and interface specifications; `safety-critical` (adds model checking or proof for the designated
property and a per-item human decision) for software control categories 1–2 and protected effects.

## Consequences

- Positive: validation cost follows criticality; proofs are spent only where encodings exist; reviewer rubber-stamping
  is detectable; factories receive packages they have already restated; humans read exceptions, not everything.
- Negative: planted-defect calibration sets must be authored and maintained per artifact class; the readback adds one
  model call per dispatch; three profiles are one more concept for the configuration interview.
- Follow-up: schema fields (`validationProfile`, per-kind `invariants[]`, reviewer pool and merge rule, loop caps);
  templates for the readback and the findings merger; smokes that plant a defect in each class; the sponsor's answer to
  Q2b (the invariant per work type) fills the kind declarations. Owner: schema spine (coordinator), then builder lanes.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Ensemble of every mechanism on every artifact | Cost and flag fatigue; correlated reviewers agree on the same errors; the Lead stops reading flags. |
| Majority vote among SME council agents | A vote converts correlated errors into confidence; the useful output of a reviewer is a defect, not a ballot. |
| Solver verdicts for everything | Most artifact properties have no encoding; forcing one produces vacuous proofs. |
| Human review of every artifact | Violates the sponsor's no-ceremony constraint (Q1) and does not scale past one ecosystem. |

## References

MIL-STD-882E (software control categories); NASA Systems Engineering Handbook (verification methods); NIST AI RMF
and SP 800-218 (independent review, evidence); `docs/SE_VALIDATION.md`; `docs/research/se-validation/02`, `04`;
grill register Q1, Q2; ADR-0002, ADR-0008, ADR-0015.
