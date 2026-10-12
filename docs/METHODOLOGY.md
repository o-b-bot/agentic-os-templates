# Systems Engineering First for Agentic Organizations

Status: draft
Owner: project maintainers

*A method for standing up, commissioning and operating an organization in which AI agents do
real engineering work under human authority.*

## Abstract

Organizations adopting AI agents usually start from the model: pick a capable model, give it tools,
and wire it into a chat surface or a code host. That approach produces impressive demonstrations and
fragile operations. Failures arrive silently (an empty result with exit code 0, a well-formed answer
to the wrong question, a review that approves everything) and authority leaks (an assistant that can
plan, build, review and merge its own work). This document describes an alternative that starts from
Systems Engineering. The agentic organization is treated as a system with stakeholders, requirements,
an architecture, interfaces, hazards and a verification plan. It is commissioned stage by stage
against observed evidence, and it is operated under explicit authority separation. The method is
packaged as open-source templates generated from one configuration file, so it can be repeated across
organizations of any size, from a single founder to a research directorate.

## 1. The problem

Three properties make agentic systems harder to field than conventional software.

**They report success while failing.** A model call that returns prose instead of the requested
structure can be recorded as a successful route. A test suite that imports stale build output passes.
A cache hit reports a green build for a tree it never built. A reviewer model that has no instruction
describes its input instead of reviewing it. None of these produce an error. The system has to be
designed so that silence is treated as failure until proven otherwise.

**Authority is easy to concentrate.** A single capable agent can be given the ability to capture a
request, plan the work, write the code, review the code, run the tests and merge. Each step looks
reasonable; together they produce an unbounded actor that grades its own exam. Separation of duties
is not a compliance formality here. It is the only mechanism that makes an agent's output checkable.

**Resources are heterogeneous and change weekly.** The same model family at the same size but a
different quantization behaves differently. A provider credential expires. A laptop sleeps. A new GPU
server arrives. A design that hard-codes "the model" or "the server" breaks every time the fleet
changes. A design that treats models, hosts and harnesses as replaceable routes bound to stable roles
survives.

Systems Engineering already has the vocabulary for all three: verification against requirements,
independence of verification from development, configuration management, hazard analysis and
technical performance measurement. The method applies that vocabulary twice.

## 2. Two Vs

The classic SE "V" decomposes needs into requirements and architecture on the left, implements at
the bottom, and integrates and verifies on the right, with each right-side level verifying the
matching left-side level. The method runs two of them.

### 2.1 The V of the OS itself

The agentic OS is a system of interest in its own right. Its left side states what it must do for
its principals ("an intent reaches a verified candidate with evidence bound to the exact revision";
"no protected effect occurs without a matching principal decision"; "a stalled stage shows a reason").
Its architecture allocates those requirements to organs, seats and planes. Its right side verifies
them with commissioning phases (section 4), and validates them with real principals carrying real
intents. The OS's own requirements live in a requirement set and are traced to evidence records the
same way a customer's requirements are.

Treating the OS as a system is what prevents the most expensive class of mistake: building
infrastructure that is mechanically real and substantively vacuous. A route that is "healthy" but
has never produced an accepted artifact, a reviewer that has never rejected anything, and a factory
that has never delivered a candidate a human would merge are all failures of the OS's right side,
and only show up if the OS has one.

### 2.2 The V the OS runs for the customer's systems

Once commissioned, the OS runs the V for the organization's own products: needs and ConOps, system
requirements, architecture and trades, interfaces, hazards, integration, verification and validation.
The Systems Engineering organization owns the left side and adjudication; factories implement at the
bottom; independent verifiers and disjoint reviewers populate the right side. The requirements
traceability matrix (RTM) links each requirement to its parents, its allocation and its evidence. The
verification cross-reference matrix (VCRM) states, for each requirement, the method (inspection,
analysis, demonstration or test), the stage at which it is verified and the evidence record that
closes it.

For cyber-physical, hardware and safety-relevant systems, the same organization adds hazard analysis
(STPA, FMEA, FTA, HAZOP), staged test (model-, software-, processor- and hardware-in-the-loop, then
field) and hardware artifacts (BOM, ICD, power, mass, thermal and EMI/EMC budgets). Security
engineering adds threat models, attack-surface analysis and, for agentic systems specifically, tool
allowlists, prompt-injection boundaries and model supply-chain review.

The two Vs share one evidence ledger and one decision record format, so a principal reads the same
kind of briefing whether the subject is the OS or a product.

## 3. Incremental activation

The second principle, after the two Vs, is that an agentic organization is activated in increments, and
every increment is smoke-tested before the next one opens. Configuration describes the whole intended
OS; the `rollout` section decides how much of it is live.

**Why.** A configuration for a research directorate can name dozens of principals, twenty SE
sub-organizations with four or more seats each, several factories and many workflows: hundreds of seats.
Activated at once, they produce hundreds of untested paths, failures that cannot be attributed to any one
change, and an operator who cannot tell plumbing faults from content faults. Activated one ecosystem at a
time, every failure has one recent cause.

**The waves.**

- **Wave 0, plumbing.** Nothing does work yet. The config validates; the inventory is observed rather
  than declared; each route the first ecosystem needs answers a health probe on the exact served model;
  the evidence ledger accepts a record; the host framework, if any, answers. Exit: every wave 0 smoke check
  has an evidence record.
- **Wave 1, one ecosystem.** One principal; a minimal Chief of Staff (intake, decision briefing,
  exception escalation); one SE sub-organization; one factory with one work cell; only that cell's tools.
  It carries **one first task**, a real and small intent, end to end: intake, SE package, principal
  decision, build, independent verification, adjudication, briefing.
- **Waves 2 to n.** Each adds one increment: a second principal, another sub-organization, a second work
  cell, the first cross-principal workflow, correspondence drafting, an integration. Each has its own
  first task that exercises the new increment.

**Smoke per increment.** Each wave lists smoke checks (`rollout.waves[].smoke`): a command with an
expected exit code, a required evidence record, or a manual observation. `aof smoke --wave N --run`
executes them and writes one evidence record per check. `aof gate --wave N` passes only when the wave's
exit criteria hold and every smoke id has evidence of the required class. Earlier waves' smoke checks
are re-run in every later wave, so a widening that breaks the first ecosystem is caught immediately.

**Loop until the stop rule.** Inside a wave, the operator runs the first task, fixes what fails through
the live-failure loop (section 4.10), and runs it again. The wave's `loopUntil` states when to stop
improving and widen, for example "three consecutive first-task runs pass every smoke check without a
manual fix". Widening before the stop rule holds moves an unsolved problem into a larger system.

**Relation to commissioning and the ladder.** Wave 0 corresponds to commissioning phases 0 to 4; wave 1
to phases 5 to 7 and the MVP rung; phase 8 and the Production rung are reached by running later waves at
volume. Waves and stages are separate axes: a program can be at the MVP stage with three waves active.

**Run on what exists.** Where the organization already operates a dynamically scalable agent or
engineering framework, the waves activate seats and cells *on* that framework (`rollout.hostFramework`).
Mature host capabilities are used as-is, partial ones are supplemented by template plumbing, absent ones
are supplied by it. A second scheduler beside a working one is never introduced.

### 3.1 The daily operating rhythm is commissioned from wave 1

An agentic organization that only runs when someone types into it is a tool, not an organization. The
method therefore commissions a **daily rhythm** alongside the first task, not after Production:

1. **Brief.** Each morning the principal reads one brief compiled from the OS's own state: what finished,
   what needs a decision, drafts and holds, failures and parked items, rollups. It has a reading-time
   budget; anything over it is a defect in the brief, not in the reader.
2. **Decide.** Every brief item carries the action that resolves it: approve, constrain, revise, reject,
   release a hold, approve a send, approve a work item. **The principal never has to leave the console to
   act.** A decision that requires opening mail, a document library or a board will be postponed, and a
   postponed decision stalls everything downstream of it.
3. **Batch.** What the decisions release runs in the next unattended window, within a budget. Protected
   effects never run unattended; they park and return as the next morning's decisions.

Wave 1 already carries a minimal version: one principal's brief, one console, the work ledger and the
audit journal, with smoke checks that the brief compiles, the ledger round-trips and the journal
verifies. Batch windows open in a later wave, only after the same work runs clean while someone watches.
Each later wave adds its principal's brief and console as part of its activation.

**Work lives in the OS, and shows up where people look.** The OS keeps its own work ledger as the source
of truth and projects it onto whatever boards the organization uses. An item appears on a principal's
board only when that principal approves it; engineering progress then keeps it current, filtered for
noise, and nothing is ever deleted. Engineering's own board may receive factory items automatically.
This keeps one truthful record without polluting anyone's system of record.

**Auditability is a first-class requirement.** It is specified, verified and gated like any other
requirement of the OS. Every action (intent, dispatch, model call, draft, hold, decision, board sync,
window start and end) is an event in an append-only, hash-chained journal that stores digests, not
content. Wave 0 verifies the chain; every later wave re-verifies it. Tamper-evidence comes from the chain,
not from keys, so it adds no key management to an internal tool.

**Two surfaces.** Deciders get a calm console; builders get a dense one. Both act through one contract,
so the renderer can climb from a static page (PoC) to a local web app (MVP) to a desktop application
without changing behavior, and the coding agent behind the engineering console is an adapter that can be
replaced with one configuration key.

## 4. Commissioning procedure

Commissioning takes a multi-stage, multi-host pipeline from "the code exists" to "it ran for real".
Each phase has an entry condition, a body of work, an exit condition and an artifact. Phases are not
skipped; when a phase fails, the work returns to the live-failure loop (section 4.10), not forward.

### 4.1 Phase 0: Survey

- **Entry:** a system claimed to work, or a stage that has never run live.
- **Work:** read live state from the deployed services, not from documents. Count workflows and the
  stage each one sits at; read the deployed source revision. Trace every stage to the component that
  moves it. Separate fixture paths from production paths; a mutually exclusive proof-harness switch
  looks like a gap but is not one.
- **Exit:** a stage table (stage → mover → evidence → blocker), a fleet table (node → measured state)
  and the one number that matters, for example "one workflow, stuck at stage 2 of 9 for two days".
- **Artifact:** the survey section of the commissioning plan, timestamped, with unverified items marked.

### 4.2 Phase 1: Land the train

- **Entry:** the fixes that commissioning depends on.
- **Work:** integrate them into one train branch; verify the exact head of the train; run hosted CI.
- **Exit:** a clean full verification at the exact train head and green hosted CI on the train.
  Several individually green changes do not make a green train.
- **Artifact:** evidence records bound to the train revision.

### 4.3 Phase 2: Bootstrap (human-only actions)

- **Entry:** prerequisites only a human can grant: a read-only deploy key, power and sleep policy on a
  host, a credential, a reviewer-model choice.
- **Work:** list them as one short ordered list (about ten minutes of human time) and ask early.
  Asking at the last phase loses days.
- **Exit:** a probe from the deployed host succeeds, for example a read-only repository listing.
- **Artifact:** the bootstrap checklist with each item's probe result.

### 4.4 Phase 3: Canary the weakest leg

- **Entry:** the stage measured as weakest.
- **Work:** probe the exact served model through the production gateway and validate the result with
  the production validator. Include a planted-defect input. A reviewer that accepts everything is
  mechanically real and substantively vacuous.
- **Exit:** the response is accepted by the validator, is not an echo of the input, and returns a
  revision request (not an accept) on the planted defect.
- **Artifact:** canary evidence records, one per probe, with the planted-defect result.

### 4.5 Phase 4: Deploy and qualify

- **Exit:** health is ready with no failures; the running source revision equals the target; the
  binding kind is professional, not demo-fixture; every expected work cell is observed.
- **Artifact:** a post-deploy observation record. "Status ready" alone is not an exit.

### 4.6 Phase 5: First real package

- **Work:** submit a new, small, tier-1 intent through the human-facing surface. Never re-run a stale
  workflow pinned to an old revision.
- **Exit:** the stage's artifact is accepted by its validator, produced by the deployed stack.

### 4.7 Phase 6: Stage the executors

- **Work:** re-stage and seed every execution cell. Pass a pinned known-good revision (expect exit 0
  and HEAD equal to the candidate) and a known-bad revision (expect the gate's own non-zero exit, not a
  plumbing error).
- **Exit:** both results as expected on every cell.

### 4.8 Phase 7: Commission

- **Work:** the principal records the decision through the official surface; the run continues to the
  terminal briefed state.
- **Exit:** the terminal state is reached and the candidate commit equals the verified commit. Pass or
  fail is written down stage by stage.
- **Artifact:** the commissioning record, citing every evidence id.

### 4.9 Phase 8: Usable

- **Work:** thirty or more journeys with per-stage success rates; a pre-registered planted-defect
  experiment; route health that counts semantic rejections, not only transport errors; persisted host
  fixes; a controlled restart test.
- **Why separate:** bundling "usable" into commissioning guarantees nobody ever hears "it worked".

### 4.10 The live-failure loop

Within phases 5 to 7: measure the failure on the host, write a small fix, merge fix branches onto the
integration tip in a new candidate branch, deploy that candidate, and run a new intent. In practice
almost every live failure in this loop is harness plumbing rather than engineering content: a model
asked to echo an identifier it could not reproduce exactly, a client timeout shorter than the slowest
downstream call, a configuration cap that crashed boot. The rule that follows is that the harness
derives and binds anything it already knows; the model is asked only for judgment.

### 4.11 Mapping to the maturity ladder

| Rung | Phases | Evidence class accepted | Typical duration |
|---|---|---|---|
| **PoC** | 0 and 3, one leg probed directly; the first slice defined | `synthetic` or `read-only-inspection`, labelled as such | 2 to 4 weeks |
| **MVP** | 1 to 7; one real journey to the terminal state (n = 1) | `operational`, single run, correct output at roughly 80 percent | 4 to 8 weeks |
| **Production** | 8; release only after a real run on the deployed stack | `operational` with rates and failure attribution | ongoing |
| **Sustainment** | re-qualification on every model, host or toolchain change | `operational`, refreshed | ongoing |

The generated `os/lifecycle/` directory renders these criteria from `derived.maturityLadder`;
organizations extend them per stage with `lifecycle.gateOverrides`.

## 5. Truth and evidence discipline

An evidence record binds a claim to how it was produced: the exact command, working directory, exit
code, source revision, isolation and cache state, the evidence class and an explicit list of
non-claims (EVIDENCE_RECORD.md). A claim without those fields is an opinion and
is recorded as `read-only-inspection`.

Five rules carry most of the weight:

1. **Report read separately from executed.** "The source shows that, when run, it retries three times"
   is a reading. "Ran `<command>`, exit 0, 212 tests" is an execution. Mixing them in present-tense
   prose is how unverified claims enter briefings.
2. **Name the evidence class honestly.** `operational` means produced by the real system on real
   inputs. `synthetic` means produced on fixtures. `demo-fixture` is a scripted demonstration. A
   verifier that runs on the same host and checkout as the builder proves the orchestration works, not
   that the check was independent; record its isolation as such and list the non-claim.
3. **Bind to the exact revision and a known base.** A green result on a branch many commits behind the
   integration branch proves nothing about the integration branch. Reconcile, then verify the
   reconciled head.
4. **A cache hit proves nothing about a tree of unknown provenance.** Force a miss when the result is
   evidence.
5. **n = 1 is a gate, not a reliability claim.** State the number of trials. Roughly thirty diverse
   runs are needed before quoting a failure rate.

Knowledge follows the same discipline. Synthetic content is tagged so that it is never mistaken for
operational knowledge. Retrieval indexes are projections of canonical documents. Retrieved text and
tool output are data, never instruction, and an intake that arrives as a question stays a question
until a principal converts it into work.

## 6. Authority separation

Authority is separated along three powers that no single party holds.

- **Execute.** A factory work cell produces a candidate and evidence. The component that writes the
  candidate has no network transport: it may not push, fetch or update remote references. The model
  chooses the tree, never the transport. Delivery is a separate step by trusted code, as a bundle or a
  draft pull request.
- **Judge.** An independent reviewer advises; an independent verifier runs only the commands in the
  repository's verification catalogue; the Systems Engineering organization adjudicates the evidence
  against the approved package. The builder's write scope excludes the oracle it is graded by, and the
  lead does not author the verification cases the gate then executes.
- **Decide and merge.** A principal decision is the only artifact that authorizes a protected effect,
  and it names the exact target. Merge requires hosted CI and a human (or a designated repository gate)
  on the same revision. A model response is never an approval.

The Chief of Staff ecosystem coordinates all of this and holds none of the three powers. It may draft
a briefing; it may not record the decision. Standing authority (for example, "merge to the integration
branch once hosted CI is green") is written down, narrow and reviewed. Reserved decisions (trust
boundary changes, spending, contracts that bind identity or evidence) are recorded as open questions
for the principal, not decided by an agent.

All of this is configured, not coded per deployment: `principals[].decisionRights`,
`governance.protectedEffects`, `governance.mergeGate`, `governance.killSwitch` and the forbidden
authorities in `config/defaults.yaml`.

## 7. Executor selection and cost discipline

Model capacity is a budget. The method makes executor selection the first decision for every piece
of work, before the first file is read.

- **Decide the executor first.** Is this the orchestrating seat's work, a builder lane's, or a local
  model's? Default to handing off unless the task is short, blocking and needs judgment.
- **Strong lanes build; the expensive seat adjudicates.** Capable, lower-cost models write code in real
  worktrees. The orchestrating seat writes briefs, reviews diffs, verifies and opens pull requests.
  Re-implementing lane output by hand defeats the purpose.
- **Local models get narrow work.** Health checks, intake classification, bounded lookups and
  non-authoritative first review. Frontier models are reserved for architecture, final review and
  high-risk changes.
- **Local first, by policy.** `resources.routingPolicy.localFirst` prefers a qualified local route even
  when a cloud route would rank higher on raw quality, within what the data tier allows.
- **Check the fleet before launching.** Confirm no other lane already owns the task. Duplicate solo work
  on a task a running lane holds is the most common waste.
- **Bound free tiers.** Free routed models are acceptable for bounded, non-blocking work, wrapped in a
  timeout; a paid model is never routed through a free channel, and a harness's auxiliary model is
  pinned as carefully as its main one.
- **Budgets are ceilings.** `resources.budgets` sets a monthly ceiling, a per-seat daily token ceiling
  and an alert threshold; the resource-cost-attention seat of each Chief of Staff watches them.

## 8. Anti-over-engineering

For internal tools the bar is correct output at roughly 80 percent, reached quickly and verified
honestly. The method keeps every check that stops wrong output and removes checks that only prove who
said something or when it expires.

| Keep | Remove (internal posture) |
|---|---|
| Typecheck, lint, tests on the exact head | Cryptographic signing and HMAC receipts on the live path |
| Evidence bound to command, exit code and revision | Attestation key pairs and rotation schedules |
| Content digests, allowed-path checks, lockfile drift checks | Validity windows and expiry dates on qualification or authority |
| Fences, epochs, independence bindings | Mandatory sandboxing as a precondition for a stage to run |
| Deny-by-default protected effects and the merge gate | Time-bomb linters |

Time bombs are defects: a generated configuration that ages out, or evidence that expires by wall
clock, breaks an idle system for no gain in correctness. Design passes tend to propose new
cryptography; strip it from the brief unless a principal asked for it. Removals are logged, so the
choice is reviewable. Organizations whose posture is `customer-facing` or `regulated` add the controls
their compliance baseline requires; the method does not forbid them, it refuses to add them by reflex
([ADR-0008](adr/ADR-0008-no-security-theater-for-internal-posture.md)).

A related discipline: record findings, and do not fix what was not asked for. An unrequested
improvement consumes the budget of the requested one.

## 9. Measurement

Technical performance measures (TPMs) make "is it working" a number. Each one is defined with its
measure, threshold and evidence class, and rolled up by the measurement sub-organization.

| TPM | Measure | Example threshold (MVP → Production) |
|---|---|---|
| Journey completion | Intents reaching the terminal briefed state ÷ intents submitted | n = 1 → ≥ 80 % over ≥ 30 runs |
| Stage success rate | Per stage: accepted artifacts ÷ attempts, counting semantic rejections | reported per stage → each stage ≥ 90 % |
| Intent-to-candidate time | Wall clock from intake to verified candidate | recorded → p50 within the first-slice success measure |
| Planted-defect catch rate | Planted defects rejected by review or verification ÷ planted | ≥ 1 of 1 → ≥ 95 % on a pre-registered set |
| False-accept rate | Candidates accepted then reverted or failing hosted CI ÷ accepted | tracked → ≤ 5 % |
| Evidence completeness | Gate claims with an operational record bound to revision ÷ gate claims | 100 % at every rung |
| Silent-failure count | Successes later found to be failures (exit 0, wrong content) | each one is an incident with a rule written |
| Cost per accepted candidate | Model spend and executor time ÷ accepted candidates | tracked → within budget ceiling |
| Principal attention | Decisions requested per week; items per briefing | ≤ 5 primary items per briefing |
| Stall visibility | Stalled matters with a recorded reason ÷ stalled matters | 100 % |

TPMs are evidence like anything else: each value cites the ledger records it was computed from.

## 10. Applying the method to a new organization

1. Fill one configuration file by interview (CONFIG_INTERVIEW.md).
2. Survey resources and fuse existing agentic solutions before building anything new.
3. Plan the rollout: wave 0 plumbing, wave 1 one ecosystem with one first task (one principal, one
   program, one repository, one factory, one intent), and the later waves.
4. Render the active waves, smoke-test them, commission through the phases above, and loop until the
   wave's stop rule holds.
5. Widen one wave at a time; climb the ladder only on evidence.

The repeatable service-line version of these steps, with roles and deliverables, is in
ENGAGEMENT_PLAYBOOK.md.

## 11. Limitations

The method does not make a weak model strong; it makes a weak result visible. It assumes the
organization can name accountable principals and is willing to have them record decisions. Its
production rung requires enough real work to compute rates, which a very small organization may take
months to accumulate. The evidence discipline adds reading time for reviewers; the trade is that
reviewers stop re-deriving what was run.

## References (public domain or openly published)

- NASA Systems Engineering Handbook, NASA/SP-2016-6105 Rev 2.
- NASA Procedural Requirements NPR 7123.1, Systems Engineering Processes and Requirements.
- NIST SP 800-160 Vol. 1 Rev. 1, Engineering Trustworthy Secure Systems; Vol. 2 Rev. 1, Developing
  Cyber-Resilient Systems.
- NIST SP 800-82 Rev. 3, Guide to Operational Technology Security.
- NIST AI 100-1, Artificial Intelligence Risk Management Framework (AI RMF 1.0).
- NIST SP 800-218, Secure Software Development Framework.
- Office of the Under Secretary of Defense for Research and Engineering, Systems Engineering
  Guidebook, 2022.
- MIL-STD-882E, Department of Defense Standard Practice: System Safety.
- OMG Systems Modeling Language (SysML) v2, public release and pilot implementation.
- Leveson and Thomas, STPA Handbook, 2018 (publicly available).
- OWASP Top 10 for Large Language Model Applications.
