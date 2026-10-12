# Operating Principles

Status: draft
Owner: project maintainers

These rules govern how operators, AI assistants and generated seats work inside an Agentic OS. Each
one exists because something went wrong without it in the reference implementation. Each is stated as
a rule followed by its one-line reason. Rendered seat charters cite them by number (`OP-<n>`).

Related: [METHODOLOGY.md](METHODOLOGY.md) explains the method; [GLOSSARY.md](GLOSSARY.md) defines terms.

## A. Truth and evidence

| # | Rule | Why |
|---|---|---|
| OP-1 | Report what you read separately from what you executed. | Present-tense prose about code reads as a claim that it was run. |
| OP-2 | Bind every claim to a command, an exit code and a revision. | Without them a green claim is an assertion, not evidence. |
| OP-3 | A cache hit proves nothing about a tree of unknown provenance; force a miss for evidence. | A cached "pass" can belong to a different tree. |
| OP-4 | Get the concrete failing data before changing anything; a green re-run is a hypothesis. | Skipped diagnoses were wrong guesses every time. |
| OP-5 | Assume silence is failure until proven otherwise. | Empty results with exit 0, prose journaled as success and swallowed push errors all looked fine. |
| OP-6 | Validate with the real validator, never by eye. | Having the right keys is not being valid; the validator's exact-key list drifts from the type. |
| OP-7 | Pin the toolchain as well as the tree before attributing a failure. | A newer local runtime emitting a different report format looked like a regression. |
| OP-8 | Check the base before trusting a green (`git rev-list --count HEAD..origin/<integration>`). | Tests against a stale base prove nothing about the integration branch. |
| OP-9 | Never take lane output on faith; check each load-bearing claim against the exact line. | Builder and reviewer models confidently get details wrong. |
| OP-10 | Test the exact served model through the exact production path. | Same family, same size, different quantization behaved completely differently. |
| OP-11 | Name the evidence class honestly, including isolation and non-claims. | A same-host verifier proves orchestration, not independence. |
| OP-12 | n = 1 is a gate, not a reliability claim; say how many trials. | About 30 diverse runs are needed before quoting a rate. |

## B. Authority separation

| # | Rule | Why |
|---|---|---|
| OP-13 | The executor never pushes; the candidate leaves by bundle or a separate publisher. | The model chooses the tree, never the transport. |
| OP-14 | The reviewer never merges, and the builder never grades its own exam. | A builder that can edit its oracle, or a lead that writes the cases the gate runs, launders independence. |
| OP-15 | A model response is never an approval. | Model output only proves a call happened. |
| OP-16 | The merge gate is hosted CI plus a human on the same revision; never merge red, never push to protected branches, never force-push. | Everything upstream of the gate is advisory. |
| OP-17 | Never record a decision on a principal's behalf. | Only an explicit principal action, for that item, is a decision. |
| OP-18 | Standing authority is written down and narrow. | Unwritten authority widens silently. |
| OP-19 | Reserved decisions (trust boundaries, spending, identity or evidence contracts) are recorded as open questions. | They belong to the principal, not to whoever is holding the keyboard. |
| OP-20 | Every protected effect is denied by default and never inferred from a UI action, model output or silence. | Inference is how unauthorized effects happen. |

## C. Delivery discipline

| # | Rule | Why |
|---|---|---|
| OP-21 | Branch every ticket from the latest integration branch; reconcile before declaring ready. | Work on an old base solves problems already solved differently. |
| OP-22 | Push immediately, then after every green checkpoint. | Work survives context limits, spend limits and crashed sessions. |
| OP-23 | Reconcile, then re-verify the exact head. | Green on a pre-merge head does not count; green changes do not make a green train. |
| OP-24 | Open a draft pull request with ticket, summary, evidence, risks and rollback. | A pull request is a review request, not proof of quality. |
| OP-25 | Do not release until the tree has run on real hardware on the deployed stack. | Hosted CI never boots the real service with generated config. |
| OP-26 | Fix tests by inverting their assertions to the new contract, never by deleting them. | Properties that still hold stay tested. |
| OP-27 | Boot-test candidates on the real host. | A configuration cap that crashed boot passed every unit test. |

## D. Executor selection and cost

| # | Rule | Why |
|---|---|---|
| OP-28 | Decide the executor first, every time. | The expensive seat doing lane work is the largest avoidable cost. |
| OP-29 | Strong lanes build; the expensive seat adjudicates, reviews, verifies and opens pull requests. | Re-implementing lane output by hand defeats the purpose. |
| OP-30 | Local models get narrow work and first-pass review; frontier models get design, security and final review. | Capability should match risk. |
| OP-31 | Check the fleet and the collision map before launching. | Two seats once each solved, solo, a task a running lane already held. |
| OP-32 | Use free-tier models only for bounded, non-blocking work, behind a timeout; never route a paid model through a free channel. | Free routes return empty or hang; hidden paid sub-models fail silently. |

## E. Anti-over-engineering (internal posture)

| # | Rule | Why |
|---|---|---|
| OP-33 | For internal tools, correct output at about 80 percent is the bar. | Ceremony delays the first real run, which is where defects are found. |
| OP-34 | Keep what checks correctness; remove what only checks ceremony, and log each removal. | Typecheck and tests stop wrong output; signatures and expiry windows do not. |
| OP-35 | Time bombs are defects. | Configuration or evidence that expires by wall clock breaks an idle system. |
| OP-36 | Strip new keys, receipts and cryptography from design briefs unless a principal asked for them. | Design passes add cryptography by reflex. |
| OP-37 | Record findings; do not fix what was not asked for. | Unrequested work spends the requested work's budget. |

## F. Commissioning

| # | Rule | Why |
|---|---|---|
| OP-38 | "Commissioned" is earned by a journey, not set by a flag. | Flipping a literal manufactures a green. |
| OP-39 | A deploy is done only when the running service reports the target revision, professional binding and expected work cells. | "Ready" was reported while running fixtures with zero cells. |
| OP-40 | Demo-fixture mode and professional mode must differ loudly. | A silent downgrade looked identical to success. |
| OP-41 | Generating a config is not observing a host; record an observation only after a real probe exits 0. | Declared state was mistaken for measured state. |
| OP-42 | Fix the reviewer before the deploy, and the deploy before the journey. | Deploying a known failure turns it into a live incident. |

## G. Handoff hygiene

| # | Rule | Why |
|---|---|---|
| OP-43 | Every handoff names what it supersedes and what in older handoffs still holds. | Readers otherwise act on stale instructions. |
| OP-44 | State is verified with a timestamp, and unverified state is labelled. | Unlabelled state is read as fact. |
| OP-45 | Include the "first fifteen minutes" commands verbatim. | The next operator rebuilds awareness without interpretation. |
| OP-46 | Write down your own failures in a "do not repeat" section. | Resuming a stale transcript without checking its date cost a full turn. |
| OP-47 | Persist lane outputs outside session scratch space. | One restart wiped every lane file from a session. |

## H. Incremental activation

| # | Rule | Why |
|---|---|---|
| OP-48 | Activate one ecosystem first: wave 0 plumbing, then one principal, minimal Chief of Staff, one SE sub-organization, one factory with one cell. | Hundreds of seats switched on at once give hundreds of untested paths and no attributable failure. |
| OP-49 | Every increment carries one first task end to end and has smoke checks that write evidence. | An increment without a task and checks has not been shown to work. |
| OP-50 | Loop inside a wave until its stop rule holds, then widen by one increment. | Widening early moves an unsolved problem into a larger system. |
| OP-51 | Re-run earlier waves' smoke checks in every later wave. | Widening can break the first ecosystem silently. |
| OP-52 | Run on the host framework where one works; never stand up a second scheduler beside it. | Two schedulers are two sources of truth for where a task is. |

## I. Daily operation, work ledger, audit and surfaces

| # | Rule | Why |
|---|---|---|
| OP-53 | Keep every OS work item in the OS work ledger first; boards are projections of it. | Work written straight into boards left no single record of what the OS was asked to do. |
| OP-54 | Boards are projections of the ledger: created on approval, kept current automatically, never deleted, never noisy. An item appears on a board a principal manages only when that principal (or the named approver) approves it; only mapped fields are pushed, batched, outside quiet hours, capped per day, notes as a digest. | Unapproved machine tasks in a Director's own board are noise; a read-only board made the work invisible and forced retyping. |
| OP-55 | Only engineering's own board may auto-create items (`autoCreateFor`); never a principal's. | Auto-creation is fine where the team expects machine items and wrong where one person curates the list. |
| OP-56 | Every OS action is an audit event in the hash-chained journal: intent, dispatch, model and tool call, draft, hold, decision, board sync, window start and end. | An action with no event cannot be reconstructed after an incident. |
| OP-57 | The journal stores digests and paths, never prompt, draft or document text. | Copying content into the journal moves it outside its data tier. |
| OP-58 | Run `aof audit verify` in every wave's smoke checks and before any incident review. | A broken chain found late cannot be attributed to a change. |
| OP-59 | Protected effects wait for a human, even overnight; batch windows park them for the morning brief. | Unattended work is safe only if nothing irreversible happens unattended. |
| OP-60 | A failure in a batch window parks with a reason; retry at most once. | Overnight retry loops burned budget and hid the cause until morning. |
| OP-61 | The brief is the daily contract: it fits its reading-time budget and every item carries the action that resolves it. | A brief that runs long or only informs is skimmed, and decisions slip a day each time. |
| OP-62 | The principal never has to leave the console to act; drafts render inline and the integration performs the approved action. | Every hop to mail, a library or a board is a postponed decision and an action outside the journal. |
| OP-63 | Calm for deciders, dense for builders: never give a Director the engineering console's panels. | One console for both is too noisy for one audience and too thin for the other. |
| OP-64 | The coding agent is a replaceable adapter: lane prompt in, candidate plus evidence out; it never pushes, merges or approves. Change it with one config key and re-run wave 1's smoke checks. | Wiring the OS to one agent's API meant a rebuild every time the agent changed. |

Templates: HANDOFF_TEMPLATE.md, LANE_PROMPT_TEMPLATE.md,
EVIDENCE_RECORD.md.

## J. Research-validated controls (v0.3)

These rules come from checking the template against current public practice
([patterns/research-validation.md](patterns/research-validation.md),
[ADR-0015](adr/ADR-0015-research-validated-controls.md)), not from a failure in the reference
implementation. The "why" names the source of the evidence.

| # | Rule | Why |
|---|---|---|
| OP-65 | **A bare model judge never gates.** A suite that gates a wave or a protected effect uses deterministic checks, human grading, or a model judge calibrated against a human sample with a recorded agreement rate; grade outcomes, not tool-call sequences. | Uncalibrated model judges are unreliable graders; evaluation practice and the MAST annotator study both calibrate against humans. |
| OP-66 | **Run k trials and gate on pass^k** for seats that feed protected effects; report pass@1 beside it. | One green run hides nondeterminism; n = 1 is a gate, not a rate. |
| OP-67 | **Advisory by default, in-loop by decision.** AI inside a customer system is `advisory-only` unless a decision record moves it, and in-loop needs software control category 1–2 with its full level of rigor; AI stays outside OT control loops. | The joint CISA/NSA AI-in-OT principles and MIL-STD-882E both put the burden on the claim of control, not on the advisory. |
| OP-68 | **Boards: tombstone, never re-create.** When a human deletes, moves or closes a board item, record it as gone and stop syncing it. | "Never delete" without a tombstone rule re-creates items people removed on purpose. |
| OP-69 | **Create under the approver, sync under the app.** Board items are created with the approving principal's delegated identity at approval time; unattended pushes use an app or workload identity; both are recorded. | A delegated session is not available overnight, and an unrecorded credential cannot be audited. |
| OP-70 | **Trip the breaker, don't push through.** When a seat, route, factory or journey keeps failing, stop dispatching downstream of it and park with the reason. | Cascading failures (OWASP agentic ASI08) turn one bad seat into many confident wrong artifacts. |
| OP-71 | **Every incident becomes a test.** Each AI incident and each missed planted defect becomes a golden-task regression case before the incident closes. | A failure that is not encoded as a case recurs silently after the next model or prompt change. |
| OP-72 | **Simplest workflow that passes evals; raise the tier with a recorded reason.** Small kinds stay on `tier-1`; reviewer pools and council minimums are added only when an eval or incident shows the simpler workflow fails. | Joint agentic-AI guidance and vendor practice both favour the simplest workflow that passes; extra stages add cost and failure modes. |
| OP-73 | **Draft documents are watched, never depended on.** A draft or preview standard (COSAiS overlays, the agent-identity concept paper, preview registries, unreleased protocol drafts) may inform a placeholder; no gate depends on it. Pin released versions. | Drafts change; a gate built on draft text breaks when the text moves (ADR-0003). |
| OP-74 | **Dataset card before indexing.** No corpus is indexed and no fine-tune set used until its dataset card records source, tier, provenance, synthetic share and refresh date. | Memory and context poisoning (ASI06) and the joint AI data-security guidance both start from unknown provenance. |

## Anti-patterns and the rules that prevent them

| # | Anti-pattern | Rule |
|---|---|---|
| AP-1 | Built and "verified" a fix on a branch far behind the integration branch, which had already solved the problem differently | Check staleness before building; tests count only on the reconciled exact head (OP-8, OP-23) |
| AP-2 | Treated a fixture-only switch as a production gap and wired it, taking a service down | Trace the production path in code before "fixing" a flag; mutually exclusive harness switches are not gaps (OP-4) |
| AP-3 | A synthesis model got a bare data blob with no instruction, described it in prose, and was journaled as success | Put role, task and output contract in the system message; count semantic rejections in route health (OP-5) |
| AP-4 | Proposed forcing a JSON grammar to "fix" prose output | Never make a wrong answer illegible; a grammar yields valid JSON describing the input (OP-5, OP-6) |
| AP-5 | Reviewer omissions under a "constrain" verdict silently deleted the lead's items | Omission fails loudly; prefer exact-partition checks to silent filters (OP-5) |
| AP-6 | The gate ran cases authored by the lead, and the builder's allowed paths included its own test | Separate exam authorship from execution; the builder's write scope excludes its oracle (OP-14) |
| AP-7 | An upgrade silently downgraded to demo-fixture mode with zero work cells while reporting ready | Post-deploy checks assert binding kind, work cells and source revision (OP-39, OP-40) |
| AP-8 | A small model was asked to echo digests, ids and counts; it got them subtly wrong | The harness derives and binds what it already knows; repair punctuation deterministically; never end a model-facing JSON contract on an open array |
| AP-9 | The expensive seat solved, solo, a task a running lane already held | Check the fleet and collision map first; decide the executor first (OP-28, OP-31) |
| AP-10 | A builder's local "all pass" hid failures because tests imported stale build output | Briefs mandate build before test; an independent clean-clone verification catches the rest (OP-9) |
| AP-11 | Lanes died of transcript overflow reading whole files | Context-hygiene preamble; micro-briefs of about 40 tool calls; resume on a fresh session |
| AP-12 | A rolled-back upgrade left new code running with old config and crash-looped | Upgrade code and config atomically; on rollback, reset and rerun at once (OP-27) |
| AP-13 | Deleted test assertions after a behavior change | Invert assertions to the new contract (OP-26) |
| AP-14 | Trimmed a reviewer's input but kept the "inspected digest" | Never attest to inspecting something the model did not see; that is fabricated evidence (OP-11) |
| AP-15 | Hours spent on expiry windows, a time-bomb linter and rotation for an internal tool | Correct output at about 80 percent; keep correctness checks, log removals (OP-33 to OP-35) |
| AP-16 | Identifier hashes were presented as artifact digests | Digests hash observations (weights, served model listing) or are labelled as identifiers (OP-11) |
| AP-17 | A client library's fixed timeout cut long synchronous calls without an error | Make long work asynchronous with an idempotent job id, or set and test every transport timeout (OP-5) |
| AP-18 | A credential profile that kept failing was round-robined forever | Quarantine a failing profile (`neverRetryDeadProfile`); when the same remedy is applied repeatedly, find what recreates the state |
| AP-19 | A handoff workflow created draft tasks directly in a Director's personal board | Create work items in the ledger; project onto a principal's board only on approval (OP-53, OP-54) |
| AP-20 | The principal's board was then made read-only, so OS progress had to be retyped by hand | After approval, sync mapped fields automatically with a noise filter (OP-54) |
| AP-21 | A Director had to open mail and a document library to approve a reply the brief described | Render drafts inline and act through the console (OP-62) |
