# ADR-0008: No security theater for the internal-tool posture

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

Design passes for agentic systems tend to add cryptographic signing, HMAC receipts, attestation keys,
rotation schedules, validity windows and mandatory sandboxes. In the reference implementation these
additions delayed the first real run by weeks, introduced time bombs (generated configuration and
evidence that aged out and broke an idle system), and caught no wrong output. The checks that did catch
wrong output were typecheck, tests, evidence bound to command and revision, independent review and
deny-by-default effects.

## Decision

- `governance.securityPosture` has three values: `internal-tool`, `customer-facing`, `regulated`.
- Under `internal-tool`, templates and the CLI add **no** signing, HMAC receipts, attestation key pairs,
  key rotation, expiry windows on qualification or authority, time-bomb linters, or sandbox mandates as
  a precondition for a stage to run.
- Under every posture, the OS keeps what checks correctness: typecheck, lint and tests on the exact head;
  evidence bound to command, exit code and revision; content digests and allowed-path checks; fences,
  epochs and independence bindings; deny-by-default protected effects; the merge gate.
- `customer-facing` and `regulated` organizations add the controls their compliance baseline requires,
  in their overlay, with a stated requirement for each.
- Removing a ceremony check is logged so the choice is reviewable.

## Consequences

- Positive: the first slice runs in weeks rather than months; no idle-system time bombs; reviewers focus
  on checks that stop wrong output.
- Negative: an internal deployment is not suitable for exposure to untrusted parties without moving to a
  stricter posture.
- Follow-up: SECURITY.md states what the project does and does not claim.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Secure-by-maximum defaults everywhere | Ceremony without correctness gain; time bombs; delayed first run |
| No posture setting, leave it to each team | Teams add ceremony by reflex in design passes |
| Remove correctness checks as well to go faster | Wrong output is the actual risk |

## References

NIST SP 800-218 SSDF (verify third-party and own software through testing); OPERATING_PRINCIPLES.md
OP-33 to OP-36.
