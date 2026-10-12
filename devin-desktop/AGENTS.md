# Instructions for the coding agent in this workspace

This workspace designs an agentic operating system for our organization. The people here decide; you draft.

- `reference/` is read-only MIT-licensed reference material. Adapt it to this environment; never copy it wholesale.
  Keep `reference/LICENSE` with it.
- Design first. Write the architecture and design artifacts under `docs/architecture/` (diagrams under
  `docs/architecture/diagrams/`) and the SysML v2 model under `models/` before any code. Scaffold only what the
  approved design calls for, and only on the organization's existing platform.
- Never invent facts about this environment. Mark every assumption, list open questions, and flag every place this
  environment differs from the reference.
- Humans make every protected decision: approve, merge, send, spend, publish. You never record a decision for anyone.
- SysML v2 files must parse (use the OMG SysML v2 Pilot Implementation when available, and say when you could not run
  it). Mermaid diagrams must render in the Markdown preview: one statement per line, quoted labels, no `;` inside
  messages.
- Work in the phase you are asked for and stop at its end with a summary of what you wrote, what you assumed, and what
  you could not verify.
