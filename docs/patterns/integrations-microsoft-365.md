# Pattern: Microsoft 365 integration

Rendered files: `integrations/<id>/GRAPH_SETUP.md` (per Microsoft 365 integration),
`integrations/<id>/AZURE_DEVOPS.md` (for `product: azure-devops`), `integrations/<id>/ADAPTER.md`,
`integrations/INTEGRATIONS_OVERVIEW.md`.

## Why Microsoft Graph

Exchange mail, Outlook calendar, Teams, SharePoint / OneDrive and Planner sit behind one API, one app
registration and one consent model. One surface means one place to set least-privilege scopes, one token cache
per principal, and one adapter to review.

## Delegated identity

Use **delegated** permissions: every call runs as the signed-in principal and can see only what that person
can already see. Each action is attributable to them in the tenant's own audit log. App-only permissions would
give the OS tenant-wide reach no single person has; do not use them for mail, chat or documents.

## Draft-only

Before Production the OS creates drafts and staging items only:

- mail → a draft in the principal's Drafts folder;
- Teams → reply text in the OS correspondence queue (Graph has no chat drafts);
- Planner → a task in a staging bucket, unassigned to others;
- SharePoint / OneDrive → a document in a review library;
- Azure DevOps → a work item in its first state with a draft tag and evidence ids.

Scopes are the ceiling; the adapter's tool allowlist is the real limit (`Mail.ReadWrite` could delete mail —
the adapter exposes only "create draft" and "update own draft"). `Mail.Send` and the Teams send permissions are
not granted before Production.

## The "don't send yet" gate

Sending, posting, publishing, assigning work to another person, and moving a work item to an active state are
protected effects (`external-send`, `publish`). They need the principal's approval for the exact target (draft
id + recipients, task id + assignee). Before a draft is even offered, the correspondence organ's coherence
checks run across the linked thread, draft, task and document; any failure holds the draft with a reason.
Hold, don't send.

## Auto-ticketing choreography

The canonical cross-principal workflow:

1. A document in a SharePoint library changes state (e.g. "first pass complete" by a Director).
2. The Director's Chief of Staff classifies and decomposes it, and creates **draft** work items (Planner tasks
   in a staging bucket, or Azure DevOps work items in `New` with a draft tag), routed by discipline to Leads.
3. Each Lead's Chief of Staff picks up the item; the Lead's co-engineer drafts the response (document, mail,
   deck) into the review library or Drafts.
4. The Lead reviews and approves their own outputs; the Director's Chief of Staff merges the returns into one
   briefing for the Director.
5. Every step records evidence ids; every send, post or state change is a protected effect for the right
   principal.

## Open-source first

Prefer an open-source MCP server for Graph (verify the license, pin the version, allowlist tools) or a thin
self-written one. Generate documents with python-docx, python-pptx or pandoc. Vendor-hosted connectors are
used only if the customer already has them.
