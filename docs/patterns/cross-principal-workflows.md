# Pattern: cross-principal workflows

Status: draft
Owner: maintainers of this template package

## Problem

Much engineering work crosses people. A Director finishes a first pass on a proposal and needs
sections written by the Leads whose disciplines they touch. A Lead finishes a design and needs a
review from security. A factory delivers a candidate and the program owner needs a briefing. Done by
hand, this is a chain of messages, a ticket someone forgets to create, a draft that comes back in the
wrong format, and a deadline nobody tracked. Done by a naive agent, it is worse: the Director's
assistant writes the Lead's section in the Lead's name and posts it.

## The pattern

A **workflow** is a configured choreography in which an event in one Principal's world creates
tickets and reviewed drafts in another's, and routes the result back. It is declared in the config
under `workflows[]` with a trigger, ordered steps, and for each step an action, an actor seat, routing,
integration, artifact, protected effect, approvals, return target and deadline.

Five rules make it safe.

1. **Each Principal's staff acts only for that Principal.** The Director's Chief of Staff classifies,
   decomposes, opens draft tickets and assigns. It does not draft in the Lead's name. The Lead's Chief
   of Staff receives the work, and the Lead's Co-Engineer drafts it. Actors are written as
   `cos:<principal>/<seat>` or `coengineer:<principal>/<seat>`; `{assignee}` is resolved at run time.
2. **Routing by discipline is explicit.** `routeTo: [by-discipline]` resolves to every Principal
   whose disciplines include the item's discipline. Zero matches block the step; several matches
   produce a proposal the trigger owner confirms. It never picks someone "close enough".
3. **Draft-only by default.** Every step that sends, posts, publishes or changes a system of record is
   a protected effect unless the integration is write-enabled for drafts and the step only creates a
   draft. A protected step is held until the named Principal records a decision bound to the exact
   payload.
4. **Review and return are part of the workflow.** Drafts go to the assignee for review, feedback is
   merged with a disposition for every comment, and the result returns to the originating Principal's
   staff with references and digests.
5. **Workflows are staged.** `enabledAtStage` keeps a workflow dormant until the OS reaches that
   lifecycle stage. It is rendered, reviewed and readiness-checked, but its trigger is not armed.

## Reference definition

The reference workflow below follows a Director's first-pass document through decomposition,
discipline routing, drafting by each assignee's Co-Engineer, review, and return. Only the final
decision step carries a protected effect; ticket creation is draft-only because the task board
integration is write-enabled for draft-state tickets.

```yaml
workflows:
  - id: director-first-pass-to-tech-writing
    name: Director first pass to technical writing
    description: >-
      When the Director marks a document's first pass complete, split it by discipline, open draft
      tickets for the Leads or Principals whose disciplines match, have each assignee's Co-Engineer
      draft the section, review it with the assignee, and return the merged draft to the Director's
      Chief of Staff for a decision.
    trigger:
      kind: document-state-change
      source: doc-store                     # integration id of the document store
      condition: "document.status == first-pass-complete"
    dataTier: internal
    enabledAtStage: mvp
    steps:
      - id: classify-pass
        action: classify
        actor: "cos:director/intake-provenance"
        protectedEffect: null               # internal: intake record only
      - id: split-by-discipline
        action: decompose
        actor: "cos:director/portfolio-dependencies"
        protectedEffect: null               # internal: one item per discipline
      - id: open-tickets
        action: create-ticket
        actor: "cos:director/delegation-receipts"
        integration: task-board             # writeEnabled: true, writeScopes: [create-ticket-in-draft-state]
        artifact: "ticket (state: draft)"
        protectedEffect: null               # draft-only write
      - id: assign-owners
        action: assign
        actor: "cos:director/delegation-receipts"
        routeTo: [by-discipline]            # Leads / Principals whose disciplines match
        protectedEffect: null
      - id: draft-section
        action: draft-document
        actor: "coengineer:{assignee}/tech-writer"
        artifact: "docx draft from a Markdown master"
        deadlineHours: 48
        protectedEffect: null               # draft-only: never published by this step
      - id: assignee-review
        action: request-review
        actor: "cos:{assignee}/handoff-choreography"
        protectedEffect: null               # review inside the OS; no external post
      - id: fold-feedback
        action: merge-feedback
        actor: "coengineer:{assignee}/tech-writer"
        protectedEffect: null
      - id: return-to-director
        action: notify
        actor: "cos:{assignee}/handoff-choreography"
        returnTo: director                  # internal return to the Director's Chief of Staff
        protectedEffect: null
      - id: director-decides
        action: record-decision
        actor: "cos:director/decision-briefing"
        requiresApprovalFrom: [director]
        protectedEffect: publish            # held until the Director's decision record
```

For this to run, each assignee needs the `tech-writer` Co-Engineer seat and the
`handoff-choreography` Chief of Staff seat. The rendered runbook lists every eligible Principal and
any missing seats as a config warning, so the gap is visible before the trigger is armed.

## What the templates render

- `workflows/WORKFLOWS_OVERVIEW.md`: every workflow with trigger, step count, protected effects,
  approvals, stage and whether it is armed now, plus a sequence diagram per workflow.
- `workflows/<workflow-id>/RUNBOOK.md`: the trigger, discipline routing table, assignee readiness,
  each step with actor seat, routing, integration write mode, artifact, deadline and protected-effect
  handling, the review and return path, what is held for approval, and a failure-handling table.

## Lessons, stated as rules

1. **The trigger is observed content.** A document changing state starts a workflow; it never
   authorizes a protected step. Intake records it as candidate work with its source digest.
2. **Duplicate triggers are idempotent.** The same document revision (same source digest) does not
   start a second run.
3. **Delivery is not acceptance.** A ticket created or an envelope delivered does not mean the
   assignee accepted it. Each hop records a receipt, and each stage moves only on its own evidence.
4. **Stuck runs say why.** Missing seat, missing discipline match, integration refusal and deadline
   overrun each write a block event with a reason. A run that stops silently is a defect.
5. **Return references, not payloads.** The result goes back with artifact refs and digests so the
   receiving Chief of Staff's decision binds to exactly what was reviewed.
6. **A changed payload needs a new decision.** If anything is edited after the Director decides, the
   publish authorization is void.
7. **Configuration errors fail loudly at render time.** A seat named as an actor but not enabled, an
   unknown Principal in `routeTo`, or an integration that does not exist is shown as a warning in the
   runbook, not discovered during a live run.
8. **Retry with the same request.** A failed integration call is retried on a timer with the same
   request digest; a changed request gets a new transport id.

## Configuration

`workflows[]` in the config holds each definition. Integrations used by steps live in
`integrations[]`; set `writeEnabled: true` with draft-level `writeScopes` only where a draft-only write
is intended. Approvers must hold the relevant decision right in `principals[].decisionRights`, or the
protected step can never run.
