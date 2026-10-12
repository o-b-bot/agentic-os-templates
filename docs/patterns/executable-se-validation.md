# Pattern: executable SE validation

Status: draft
Owner: maintainers of `templates/systems-engineering/`

**Problem.** An SE organization run partly by model-backed seats can write "verified by analysis" with nothing behind
it. Formal output looks authoritative, so the temptation is greatest exactly where the risk is.

**Pattern.** Separate four roles and bind each to evidence:

1. **Propose.** A seat writes the encoding (typed constraints, a TLA+ spec, a harness, a GSN module) as an artifact
   with a digest.
2. **Review.** A different seat checks the encoding against the statement and runs a mutation probe: negate one
   constraint and confirm the solver now reports a conflict.
3. **Decide.** A pinned tool produces the verdict, in a container or in-process. The verdict comes only from the tool's
   output, parsed by a deterministic adapter.
4. **Record.** One receipt and one evidence record per check: tool, image digest, input digests, verdict, bound,
   counterexample. Gates read the latest record per check.

**Closed verdicts.** `proved | bounded-pass | fail | unknown | timeout | skipped`. Bounds are part of the claim.
Inconclusive is never green, and a check that cannot run keeps its gate blocked with a named reason.

**A checker must be able to fail.** Every checker ships with a planted-defect pair (`aof formal smoke`). A checker that
cannot catch its planted defect is a rubber stamp and fails the smoke.

**Fallbacks may find, never prove.** When the authority (for example the SysML v2 pilot) cannot run, a weaker
in-process extraction may still report defects, but its clean result is `unknown`.

**Live assurance.** The assurance case is generated from requirements, hazards, threats, results and the ledger.
Doubts become generated counter-goals (defeaters) that only new evidence or a recorded decision can clear.

**Open-source first.** Every default tool is open source. Non-commercial tools (nuXmv, UPPAAL) and source-available
ones (BSL) never enter default images. GPL tools run as separate processes.

References: NASA SE Handbook (SP-2016-6105), NASA-HDBK-1009A, NASA-STD-7009B (model credibility), MIL-STD-882E
(software criticality), NIST AI RMF (MEASURE), SysML v2 release, OWASP Top 10 for LLM Applications. Cite by section.
