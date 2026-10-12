# Pattern: factories (supervisor + work cells)

Status: draft
Owner: Factory organ maintainers

This note explains the factory pattern the templates under `templates/factory/` render, and the rules
learned from running it end to end on real repositories in the reference implementation. The rendered
files (`factories/FACTORIES_OVERVIEW.md`, `WORK_CELL_CONTRACT.md`, each `<factory-id>/FACTORY.md` and the
role charters) are the operational contract; this note is the reasoning behind them.

## The pattern in one page

A **factory** is a governed work-production capability. A program owns the authority; the factory supplies
execution capacity. It has two parts.

- The **supervisor** is deterministic code. It admits work items, grants leases with path fences, journals
  every command as an idempotent entry, recovers expired leases, and enforces budgets and the kill switch.
  It makes no domain judgment and never mints an approval or an evidence record.
- A **work cell** takes one leased item and produces one candidate. It is a team of four seats: the
  **lead** bounds the work (allowed paths, requirement ids, the verification entries), the **builder**
  proposes a change, the **reviewer** reads it independently, and the **verifier** runs the admitted
  catalogue against the exact candidate head. Machines and model runtimes are routes a seat binds to for
  the length of a lease; they are replaceable.

Models only **propose**: a patch, a review. Trusted harness code applies, commits, runs commands and records
evidence. Humans sit at the two ends: a principal approves the work package, and a human reviewer decides
on the delivered draft. Between the ends the factory can run lights-out.

Three powers are never held by one party:

1. **Execute**: the builder plus the harness runner, in a disposable worktree.
2. **Judge**: an independent reviewer (advice), an independent verifier (real commands), and an adjudicator
   outside the cell that returns only `inadmissible`, `needs-evidence`, `rejected` or `draft-pr-ready`.
3. **Merge**: hosted CI on the exact head plus required human review on the forge.

The executor can never push. The model chooses the tree, never the transport. Delivery is done by trusted
publisher code that may only push a ticket branch and open a draft PR (or produce a git bundle); it refuses
`mark-ready`, `approve`, `merge`, `deploy` and `release` before making any transport call.

SWE is the reference kind. Electrical, hardware, firmware, technical-writing, data, research and
systems-engineering-artifact factories reuse the same cell and contract. Only three things change per kind:
the artifact set, the verification equivalents (ERC/DRC and simulation, style lint and link check, schema
validation and reproducible runs, `aof trace`), and the delivery unit (draft PR or a draft version in a
document library). Each kind's deltas are in `templates/factory/kinds/<kind>/KIND_NOTES.md.j2`.

## The cell loop

Verification sits **inside** the repair loop. Each attempt runs builder, reviewer, runner, verifier. A
reviewer `reject`, an apply failure or a verifier `fail` becomes evidence for the next attempt. Only when
the attempt budget is spent does the item end `attempts-exhausted`, truthfully, with the full repair trail.
A winning attempt produces a candidate record bound to its head, an evidence bundle, an adjudication and a
briefing. `draft-pr-ready` is not done: done is a hosted-CI-green draft PR on the exact head with an
independent reviewer.

## What we keep and what we refuse to add

The correctness floor stays at every security posture: typecheck and tests on the exact head, a
frozen-lockfile install and drift check, evidence bound to command, working directory, exit code and
revision, changed paths inside allowed paths, independent review, fences and independence bindings,
deny-by-default protected effects.

For an internal tool we refuse controls that only prove who said something or when it expires:
signatures, HMAC receipts, key rotation, expiry windows, mandatory sandboxes, and clean-clone runs on a
separate machine as a blocking gate. Plain-process verification recorded as `isolation: none` is honest,
admissible evidence. A customer-facing or regulated posture adds controls only when the compliance baseline
names them, each traced to a requirement. The rule is "correct output at 80%": keep every check that stops
wrong output; never add a signature, receipt or sandbox just to make a stage pass.

## Rules learned from live runs

Each rule below was paid for by a stalled or wrong run.

**Builder context and patch format**

1. **Give the builder the real repository.** A builder given only an objective invents files and context
   lines. The harness builds a ranked, line-numbered excerpt pack from the exact base, within the admitted
   scope, plus the file index and paired tests.
2. **The harness owns every value it already knows.** Ids, digests, labels, counts, branch names, file
   headers and the verification command are bound by the harness. Never ask a small model to echo a
   machine string.
3. **Recount hunk headers deterministically.** Wrong counts are noise, not a defect; recount them the way
   `git apply --recount` does.
4. **New-file patches need explicit markers.** Derive `+` or `-` from an empty side, supply missing
   `---/+++` headers, and refuse a `create` on a path that already exists, naming the colliding file.
5. **Prefer search/replace edits to hand-written diffs for modifications.** Models copy blocks reliably and
   count lines badly. The harness derives the diff from the base text.
6. **Re-anchor tolerantly, then show real lines.** Allow small gaps between anchors. On failure return
   git's stderr plus the real numbered lines around each hunk tried.
7. **Name the actual problem in repair hints.** "create on an existing path: use modify or pick a new name"
   repairs; "re-anchor" does not.
8. **Apply, command and shape failures are repairable evidence**, not terminal errors, until the bounded
   budget runs out.
9. **A command outside the builder's grant is a correction, not a dead run.** Keep true prohibitions
   (network, push) as hard denials.
10. **Require a test that reaches the change through its public entry point.** Without one, unreachable
    code passes the suite.

**Review and verification**

11. **Verify inside the repair loop.** A verifier rejection must feed back to the builder. Verifying after
    the loop makes every failure terminal.
12. **Bind the verifier's catalogue to the lead's declared scope, and fail a run that executed nothing.**
    A workspace filter that matches no package, a missing script or "no tests collected" fails even with
    exit 0.
13. **Media types are not paths.** Strings like `application/json` emptied a scope and its catalogue. Fail
    closed on an empty catalogue.
14. **`changes-required` is advisory; `reject` is repair evidence.** The verifier that runs the tests is the
    judge. The harness derives the verdict word and flattens object-shaped findings.
15. **An invalid review must not feed a vacuous gate.** Gates run on an empty admitted set produce false
    defects that burn the revision budget.
16. **Read a contradictory review by its structured acts.** A review that endorses every criterion and the
    whole scope but asks for revision is an accept with its P1 carried as an advisory.
17. **A cache hit proves nothing about a tree of unknown provenance.** Force a miss for evidence and record
    the cache state.
18. **Reviewer family differs from builder family, and allocation is by capability.** A same-family
    reviewer drifted into speculative verdicts; safety and security review once landed on the smallest
    model because of catalogue position.

**Budgets, leases and transport**

19. **Repair attempts need strictly higher fences.** Close prior leases first, or attempt 2 can never be
    leased.
20. **Per-invocation and per-program budgets are different numbers.** Size the program ceiling for every
    admitted retry and revision; a cumulative cap equal to the per-call cap made every repair unreachable.
21. **The caller's deadline is the only deadline.** A hidden fixed transport timeout silently dropped every
    build longer than five minutes. A dispatch must outlive the build it waits for.
22. **Structured output is repaired deterministically, not retried.** A temperature-0 retry repeats the
    same bytes. Strip one fence, re-escape strings, normalize known slips; shape faults consume the
    correction budget.
23. **Prefill to stop echo, and never end a JSON contract on an open container.** Small models copy the
    template from the user message; an assistant prefill that opens the output object cut output by about
    80%. Put a scalar field last.
24. **Quarantine dead profiles.** A failing provider profile is removed from rotation with a reason and
    re-admitted only after a fresh health check; round-robining it forever looks like "needs re-keying".

**Contracts and delivery**

25. **Every contract change needs cross-service tests on the real path.** One service's exact-key
    validator refused another's new optional field for weeks because unit tests used fakes. Never merge two
    branches that touch one function without CI on the combination.
26. **Accept namespaced reason codes across service boundaries**, or the revision path dies silently.
27. **Log every refusal with its code at each boundary.** Several live stalls were workflows sitting with
    "no reason".
28. **The executor never pushes; trusted code delivers from revisions it observed itself**, never from
    revisions parsed out of model output.
29. **Honest unsandboxed evidence must be adjudicable.** A gate that requires sandbox fields rejects every
    plain-process run.
30. **Lost responses reconcile, they never duplicate.** A create whose response was lost resolves to the
    existing PR; what cannot be reconciled is `outcome-unknown`, never success.

## Commissioning, briefly

A factory is commissioned when two held-out work packages from different change classes each reach a
hosted-CI-green draft PR, a seeded defect is found and repaired on a new head, an impossible package
exhausts truthfully, the abuse suite (unrelated path, missing test, secret, debug junk, self-review, open
P0/P1) blocks publication, publisher idempotency holds under a dropped response, and protected-effect
attempts are refused with zero transport calls. All of it is recorded as `EV-<yyyymmdd>-<seq>` evidence of
the class the stage requires. Fixture runs prove the harness, not the factory.

## Where to start

Commission one factory on one repository for one real intent (`lifecycle.firstSlice`). Fill that
repository's `verificationCatalogue` with the exact commands CI already runs, and run each one by hand on
the integration branch before any change, so later failures are attributable. Add cells, reviewers and
kinds only after the first slice delivers.
