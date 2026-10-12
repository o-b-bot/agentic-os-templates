# Pattern: the Systems Engineering organization

Status: draft
Owner: maintainers of `templates/systems-engineering/`

## Problem

An agentic OS that turns intents straight into code skips the work that makes engineering
reviewable: what the stakeholder needed, which requirement a change satisfies, how it will be
verified, and who independently checked it. Model output then looks finished while nobody can
say what "finished" meant. The Systems Engineering (SE) organization is the organ that keeps
that discipline, with model-backed seats that are bound by contracts and checked by an
independent reviewer.

## The pattern

- **One SE principal seat** owns a catalogue of up to twenty **sub-organizations**
  (`organs.systemsEngineering.subOrganizations`). Each sub-organization owns a family of
  artifact kinds and a named gate.
- **Every sub-organization has four mandatory seats**: `intake`, `domain-lead`,
  `artifact-custodian`, `independent-reviewer`. Optional artifact specialists are created per
  artifact family when a work program needs them, never per artifact. A sub-organization with
  no qualified reviewer route is not operational.
- **Seats are role contracts; routes fill them.** A seat names a capability class
  (`se-synthesis`, `se-review`), never a model. A route fills the seat only after it qualifies.
  The contract never bends to fit a route.
- **Work tiers keep plans small.** Tier-1 is a single lead in one sub-organization. Tier-2 adds
  a reviewer and a custodian (the schema default, `defaultWorkTier`). Tier-3, the full council
  of every enabled sub-organization, needs a human-mediated lane.
- **Incremental activation.** The first rollout wave activates one sub-organization (normally
  `requirements-rtm-change`) plus `independent-verification` for one principal's first task.
  Every later wave widens only after the previous wave's exit criteria pass with evidence.
- **The flow is a state machine.** The states are intent, analysis, route plan, synthesis,
  package compile, council review, principal decision, execution, execution adjudication and
  briefing. Any transition that is not listed is refused, and every refusal has a typed code.
- **Authority stays separate.** SE proposes, compiles and adjudicates. The Chief of Staff
  briefs. The human principal decides. The factory builds, and its executor never pushes.
  Hosted CI plus human review is the merge gate. A model response is never an approval.

The rendered files are `systems-engineering/SE_ORGANIZATION.md`, `THE_V.md`,
`REVIEW_AND_COUNCIL_CONTRACT.md`, `REQUIREMENTS_STANDARD.md`, `VV_PLAN.md`, the
configuration, lifecycle, risk, measurement, standards and modeling plans, and one charter per
enabled sub-organization. Each program also gets ConOps, needs, requirements, architecture,
interface, integration, VCRM, technical-review and status files. Each system gets a definition
and the guarded cyber-physical and agentic extensions: STPA, FMEA, security and resilience,
MIL/SIL/PIL/HIL test stages, hardware artifacts, and agentic assurance.

## Two directions

### The V of the OS

The OS is itself a system under development, and it runs its own V. Its requirement set is
`examples/requirements.agentic-os-self.yaml` (set `AOS`): stakeholder needs at the top, then
functional, performance, interface, security, data, lifecycle and verification requirements.
Each requirement is allocated to an organ or seat and carries a verification method and
falsifiable acceptance criteria. The OS's PoC → MVP → Production → Sustainment ladder is its
right leg. A stage is promoted only by a principal decision that cites evidence for every exit
criterion, at the evidence class the stage requires. Model routes are configuration items:
each records a license and a weights digest, and a changed served model must re-qualify.
The OS's own technical performance measures live in `MEASUREMENT_AND_TPM.md`. Examples are
intent-to-verified-candidate time, planted-defect catch rate and cost per accepted change.

Dogfooding is the test of the templates. If the OS cannot keep its own requirement set
traced and verified, it has no business doing it for a customer.

### The V the OS runs for the customer's systems

For each program and system in the configuration, the SE organization produces the left leg:
stakeholder needs, ConOps, requirements, architecture, interfaces and design. Factories
implement. SE then adjudicates the right leg from evidence it inspects itself: unit,
integration, verification, validation and operational. Technical reviews from
`reporting.technicalReviews` (MCR, SRR, SDR, PDR, CDR, TRR, ORR) sit on the V as council
reviews over a technical review package. Each review maps to a workflow milestone and
establishes a baseline. Cyber-physical systems add hazard analysis (STPA following public
STPA guidance, with MIL-STD-882E severity and probability), FMEA, NIST SP 800-160 v2
resiliency analysis and SP 800-82 OT security. They also add test stages from model-in-the-loop
to field, where every stage that moves hardware needs a `hardware-actuation` decision. Agentic
systems add an evaluation suite, a red-team plan keyed to the OWASP Top 10 for LLM
Applications, and least-capability tool tables.

References are public-domain or openly licensed: the NASA SE Handbook (SP-2016-6105),
NPR 7123.1, NIST SP 800-160 v1/v2, NIST SP 800-82, the NIST AI RMF, the DoD SE Guidebook
(2022), MIL-STD-882E, the SysML v2 release and public STPA guidance. Templates cite them by
name and section and never reproduce their text.

## Rules (lessons from the reference implementation)

1. **Give the synthesis prompt an explicit role, task and output schema.** A model handed a
   bare JSON blob correctly *describes* the blob. JSON mode does not fix this. It produces
   valid JSON that still only describes the input, which is a false green.
2. **Select the lead/reviewer pair per request, by target sub-organization.** One global pair
   composed from the first sub-organization's routes silently removes per-organization
   independence and capability tiers.
3. **Stop reviewer echo in decoding, not by shrinking the contract.** Use a prefill or a
   schema-constrained grammar. Reviewers copy the lead from the user message even after keys
   are removed from the system contract.
4. **Never end a model-facing JSON contract on an open array or object.** Syntax slips happen
   at the last open collection, not at truncation. Put a scalar (`notes`) last.
5. **Name enum values explicitly.** Without the list in the prompt, models answer "approved"
   when the contract says `accept`.
6. **Do not make models copy digests or labels they could get wrong.** The harness injects or
   verifies `inspectedLeadDigest` and binds short V&V labels (`V1`, `V2`) to case digests.
   Never trim the reviewed artifact from the reviewer's input.
7. **Compute readiness from a live probe at admission, never from a deploy-time
   timestamp.** A stored health window turns into a time bomb on the first idle restart.
8. **Check `finish_reason` and token usage before you design a retry.**
9. **A retry may fix syntax only.** Allow one informed retry that carries the parser error, on
   the byte-identical request. A retry that changes the verdict is a second review.
10. **Derive scope from the repository's engineering boundary**, not from the file list of
    one canary ticket.
11. **Default to a small, scoped team, and make "incomplete plan" an explicit error.** A full
    lifecycle team routed onto a handful of routes never completes. It also fails with
    sentinels that look like broken routes.
12. **Under request-revision, do not run quality gates on the empty admitted set.** Vacuous
    gaps feed the next revision until the budget runs out.
13. **Failed V&V is repairable.** Keep the same package and decision, and spend a bounded
    repair budget (`verification.repairBudget`, default three rounds). Only integrity failures are rejections.
14. **Read the consumer code before cutting a contract field.** The "unused" `accepted*Ids`
    lists were the admission filter. Cutting them makes the gate fail-open or fail-empty.
15. **Capable reviewers need hosts that stay up.** In high-assurance sub-organizations, pick
    the reviewer by capability tier first, then the lead. Assert capability and independence in
    the same test. Never let one host carry all capable review.
16. **Commissioning is shown by a completed journey, and n = 1 is a gate, not a rate.** C0 is
    a live accepted package with no echo and a rejected planted defect. C1 is the full
    principal path to `briefed` with a draft PR at the verified head. Quote failure rates only
    after about 30 diverse runs. Tool grants that exist only as labels are not controls.

Two further rules follow from these:

- **Omission is loud.** Every admission filter emits `unreviewed-*` and `reviewer-unknown-*`
  gaps under every disposition that admits anything. A dropped item is the typical failure of a
  weak reviewer, so silently deleting it discards the hardest content.
- **Constrain only narrows.** A constrain that widens scope is refused as
  `scope-broadened`. A constrain that does not intersect the lead's scope is a revision request
  that admits nothing, never a crash.

## Anti-patterns

- Adding signing, receipts, key rotation, expiry windows or sandboxes to an internal tool in the
  name of security. Keep what checks correctness: typecheck, tests, evidence bound to command,
  exit code and revision, independent review, and deny-by-default protected effects.
- Promoting synthetic or demo-fixture evidence to operational.
- Letting a third-party modeling tool or a home-grown parser own semantic truth.
- Recording a decision on a principal's behalf, or presenting a council outcome as one.
