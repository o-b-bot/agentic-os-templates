# Pattern: the Workbench (agentic development environment)

Rendered files: `surfaces/workbench/WORKBENCH.md`, `surfaces/<instance-id>/WORKBENCH_SPEC.md`, and the
`pages/workbench.html` area of each enabled console instance. Input: `surfaces.workbench` and
`surfaces.consoles[].workbench`. Code: `src/aof/workbench.py`. End-to-end description: `docs/WORKBENCH.md`.

An engineer's platform is not complete without the place where the work is done. If that place is a separate IDE or
a desktop coding agent, the work leaves the OS: edits are not bound to what was reviewed, the agent holds credentials
it should not, and the evidence has to be reconstructed afterwards. The Workbench keeps the work inside the platform
and keeps every effect that matters where a decision can govern it. The rules below are what a coding agent or a
designer must keep when extending it.

Rules 1–3, 5, 7, 8 and 10 are enforced by code and checked by `tests/test_workbench.py` and the `workbench` smoke;
rules 4, 6 and 9 by the absence of routes; rules 11 and 12 by `aof validate`.

## The rules

1. **Files open from the real worktree.** The explorer lists the files of a git worktree of a repository the
   principal is entitled to; the editor reads them from disk. When no checkout is readable on the host, the Workbench
   shows the fixture repository and says so on every pane. It never shows a cached or invented copy as the real one.

2. **Save only under a digest precondition.** A save sends `If-Match: <digest of what was read>`. No header, or a
   digest that no longer matches the file, is a 412 and nothing is written. A new file needs `If-Match: absent-file`.
   Saves are confined to the instance's repositories (no `..`, no absolute paths, never under `.git`) and audited
   with the before and after digests.

3. **A diff is reviewed into a batch, never approved from the editor.** The diff is the candidate worktree (including
   uncommitted and untracked files) against the merge base with its base branch, side by side. A line note goes into
   the review batch; the batch composes into text for whoever does the work. There is no approve button in the
   Workbench.

4. **The terminal is a protected effect.** A read-only lane runs without a decision: `git status | log | diff | show |
   blame` without writing options (`--output`, `--ext-diff`, `-c`, …), and the catalogue's read-only commands. No shell
   is involved, so operators (`;`, `|`, `&&`, `>`) are refused. Everything else is refused with the decision it needs.

5. **Tasks run from the catalogue, not from a prompt.** The task panel lists the repository's verification catalogue.
   Tests, lint and typecheck (and git status / log / diff) run when served; build, e2e, custom and scans need a
   decision. A run is not evidence: the verifier records evidence bound to command, exit code and revision.

6. **The agent never pushes.** The coding agent of record runs as an agent session in the lane worktree, through its
   adapter (MCP to `aof mcp-serve` by default). Its tool calls are shown and audited. It has no route to push, merge,
   open a pull request or change credentials; prevent that with credentials and worktree scope, not instructions.

7. **One writer per path set.** A worktree belongs to one lane. Creating a worktree that exists is refused; an agent
   session that is already running cannot be started twice.

8. **Worktree reset and force do not exist.** Create, archive and clean are preview-bound: the preview names the exact
   git command and its digest, and only that preview applies. Archive refuses a worktree with uncommitted changes;
   there is no force to override it. Reset, `clean --force` and force anything have no route and no button.

9. **Forge identity is observed, never used from the IDE.** The Workbench never fetches, pushes, opens a pull request
   on a forge, approves or merges. The repository remote is shown as text; credentials stay with the configured
   integration and its guarded workflow.

10. **A draft PR is assembled from evidence.** The lane review builds the body from the work item, its acceptance
    criteria, the evidence records, the files changed, the review batch, what was not verified, and the rollback note.
    Served, it is written to the instance's state with an audit event. Opening it is a protected effect: the
    confirmation names the target, the body's digest and the decision record the command creates.

11. **Monaco is vendored or absent, never fetched.** Static pages use the built-in viewer and highlighter. Served, the
    editor loads Monaco only from a local vendored copy (`vendor/monaco/min/vs` or `AOF_MONACO_DIR`); otherwise a plain
    editor with the same save path. No page references a CDN.

12. **Engineers' platforms carry the Workbench.** A director or program-lead console that enables it fails
    `aof validate`. Features must be a subset of `surfaces.workbench.features`; the terminal needs
    `surfaces.workbench.terminal.enabled`; the agent must resolve to a known coding agent.

13. **One screen, static first.** At 1440 × 900 the Workbench fills the screen under the top bar and only panes
    scroll. Opened as a file, every pane is readable without scripting and nothing runs or is sent.

## Anti-patterns

- A "Push" or "Merge" button "for convenience". Approval and merge belong to the repository's review and CI.
- Saving the editor buffer over whatever is on disk. Two writers then silently lose each other's work.
- A pseudo-terminal that passes any line to a shell with a deny-list. A deny-list is always one alias short.
- Treating a green task run in the Workbench as evidence. Evidence is the verifier's record on the candidate revision.
- Loading an editor from a CDN on an internal tool. It is an external request on every page view and an unreviewed
  dependency.
