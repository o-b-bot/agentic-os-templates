# ADR-0003: Cite public-domain and openly published standards only

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

The SE organization's charters, artifact templates and gate criteria reference standards. Several
widely used SE handbooks and process standards are copyrighted and sold; quoting or closely paraphrasing
them in an MIT-licensed repository would create license exposure for every adopter, and requiring them
would make the method unusable by organizations that do not hold copies.

## Decision

- The standards baseline (`organs.systemsEngineering.standardsBaseline`) enumerates only public-domain or
  openly published references: NASA SE Handbook and NPR 7123.1, NIST SP 800-160 Vol. 1 and 2, NIST SP
  800-82, NIST AI RMF, NIST SSDF, DoD SE Guidebook 2022, MIL-STD-882 and MIL-STD-961, FAA SE manual, GAO
  technology readiness guide, the SysML v2 public release, public STPA guidance, the OWASP LLM Top 10, or
  `custom`. v0.3 adds NIST AI 600-1, NIST SP 800-218A, the OWASP Top 10 for Agentic Applications, the
  CDAO AI T&E framework, the joint CISA/NSA guidance on AI in OT, agentic AI adoption and AI data
  security, MIL-STD-882E and the JSSSEH, the GAO TRA guide, the OpenTelemetry GenAI conventions, the
  MAST failure taxonomy, and the A2A and MCP specifications ([ADR-0015](ADR-0015-research-validated-controls.md)).
- **Draft documents are cited as watch, never as dependency.** A draft, preview or development-status
  publication (for example the NIST COSAiS overlays and the NCCoE agent-identity concept paper, whose
  baseline ids end in `-watch`) may inform a placeholder mapping, but no control, requirement, gate or
  rendered rule depends on its text. It is promoted only when its publisher marks it final, by a decided
  change. A development-status specification that the OS must use (the OpenTelemetry GenAI conventions)
  is pinned to an exact version instead.
- Vendor material (engineering blogs, vendor API documentation) may inform a rule and is cited in the
  decision that adopts it, but is never baselined as authority. A freely downloadable but copyrighted
  document (the STPA Handbook) is cited, never copied.
- Templates cite these by name and section where useful and do not reproduce long passages.
- Paid standards are never quoted, paraphrased or required. An organization that holds them may map
  its own processes in its private overlay.

## Consequences

- Positive: any organization can adopt without purchases; no license exposure upstream.
- Negative: some vocabulary is phrased independently rather than in the most familiar paid wording.
- Follow-up: the de-identification and review checklist in CONTRIBUTING.md includes this rule.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Quote the most widely used paid SE handbook | License exposure; excludes organizations without a copy |
| Cite no standards | Loses the shared vocabulary that makes the method credible to SE practitioners |
| Paraphrase paid standards closely | Still derivative; same exposure |

## References

The public references listed above.
