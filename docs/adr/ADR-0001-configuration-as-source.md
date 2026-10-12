# ADR-0001: Treat configuration as source and generation as the build

Status: accepted
Owner: project maintainers
Date: 2026-10-08

## Context

An Agentic OS consists of hundreds of documents: charters for every seat of every principal, SE
sub-organization charters, factory role contracts, routing tables, governance matrices, RTM and VCRM
skeletons, workflow definitions and integration adapters. Written by hand, they drift: a principal's
decision rights change in one charter and not in the governance matrix; a renamed repository survives
in three seat prompts. Organizations also need to keep their own content private while benefiting from
upstream improvements to the templates.

## Decision

- One file, `agentic-os.yaml`, validated against `schema/agentic-os.schema.json`, is the only
  hand-edited source of an organization's OS. Defaults (`config/defaults.yaml`) and kind overlays
  (`config/kinds/<kind>.yaml`) merge under it.
- `aof render` is the build. It writes `os/` and a `MANIFEST.yaml` with each file's template and
  sha256. `aof plan` shows the path-level diff before overwriting.
- Generated files carry a provenance header and are never hand-edited. A needed change goes into the
  config, or into the template upstream.
- Customer-private content (config, inventory, private templates, rendered output, evidence) lives in
  the customer's overlay repository. The template repository holds none.
- Anything a template needs that is not in the config is computed in the renderer's `derived` context,
  with a test, never inside a template (TEMPLATE_CONTEXT.md).

## Consequences

- Positive: a change to one fact propagates everywhere; output is reviewable as a diff; two renders are
  comparable by manifest digest; templates improve for everyone.
- Negative: an organization that wants a one-off edit must express it in config or an overlay template;
  the schema must grow deliberately.
- Follow-up: schema changes go through review with a migration note; CI renders every profile.

## Alternatives rejected

| Alternative | Why rejected |
|---|---|
| Hand-maintained document set per organization | Drifts within weeks; not repeatable across organizations |
| Generate once, then edit by hand | Edits are lost on the next render or block all future renders |
| Store organization content in forks of the template repository | Leaks customer content toward upstream; merges become painful |
| A database-backed configuration service | Adds infrastructure for no correctness gain at this scale; files diff and review well |

## References

ARCHITECTURE.md §4; NASA SE Handbook (configuration management).
