# Pattern: design system and consoles

Rendered files: `surfaces/DESIGN_SYSTEM_SPEC.md`, `surfaces/BRAND_INTAKE.md`, `surfaces/theme/tokens.json`,
`surfaces/theme/tokens.css`, `surfaces/theme/console.css`. Input: `surfaces.design` and `surfaces.consoles`.
Tooling: `aof design extract | tokens | check | preview`. End-to-end description: `docs/DESIGN_SYSTEM.md`.

A console is where a Principal spends attention. If it looks generic, people distrust it; if it is
cluttered, they stop reading it and go back to mail. The rules below are what makes the generated consoles
calm, legible and on-brand without a designer in the loop for the first version, and what a designer or a
coding agent must keep when building the MVP web console.

Rules 1–4 and 9–12 are measured by `aof design check` or by the preview tests. Rules 5–8 are layout
heuristics; they are written as defaults to keep, not laws to cite.

## The rules

1. **Decisions before everything.** On a calm console the order is fixed: the morning brief, then the
   decisions queue, then drafts, work items, rollups, calendar and threads. The headline of the brief counts
   the decisions ("Two decisions need you today."). A Principal who reads only the first screen has seen
   every decision waiting for them.

2. **One primary action per card.** Each decision card has exactly one filled accent button: the action
   the recommendation names (Approve, or Approve with constraints when the recommendation says so). The
   alternative approval is secondary (outlined). Request revision, Reject and Defer are tertiary text
   buttons, pushed to the far side. The preview test fails if a card carries two primary buttons.

3. **Show what approval causes.** Every decision card states the recommendation, the dissent (always,
   "None recorded" when there is none), what approving will cause, and the digest of the briefing the
   decision binds to. Evidence appears as `EV-<yyyymmdd>-<seq>` chips, never as a sentence claiming success.

4. **Never color alone.** Every status pill carries a word and a shape: a dot for neutral states, a
   diamond for warnings, a square for blocked or high severity. Coherence checks use ✓/✗ plus "passed" or
   "needs attention". Charts carry a legend or direct labels. Users with a color-vision deficiency, a
   grayscale printer or a forced-colors theme lose nothing.

5. **Brand for structure, accent for action.** About 60% of the page is neutral surface, about 30% is the
   brand primary (brand mark, links, selected filters, rules), and about 10% is the accent, used only for
   the primary action and for alerts. If the accent appears on everything, it stops pointing at anything.
   The 60-30-10 split is a heuristic from interior and graphic design practice; treat the numbers as
   proportions to aim for, not thresholds.

6. **Eye flow follows the console's job.** A Director console is a single column at reading measure: the
   eye runs down the left edge and stops at each heading, which is the F-pattern collapsed to one column. An
   engineering console uses a 12-column grid read as an F: filters across the top, the wide tables on the
   left two thirds, controls (decisions, holds, routes, batch windows, kill switch) on the right third,
   the audit tail full width at the bottom. These are reading-pattern heuristics from usability practice.

7. **Whitespace is structure.** Spacing comes from one scale (multiples of 8 px by default). Groups are
   separated by space first, by a hairline only when space is not enough, and by a box only when the group
   is an object (a card, a panel). Generous whitespace is what makes a calm console calm.

8. **Typographic contrast through size and weight, not color.** A modular scale (base × ratio^n, 1.25 by
   default) gives every step a job: the brief headline, the page title, card titles, body, meta lines,
   eyebrows. No more than two text families (heading and body) plus a monospace for ids, commands and
   evidence. Reading columns stop at the configured measure (45–90 characters, 72 by default).

9. **Numbers right-aligned, with tabular figures.** Every numeric column in a rollup, cell or evidence
   table is right-aligned with `font-variant-numeric: tabular-nums` so digits line up. Units go in the
   header. Trends are sparklines in the table row, not a separate chart.

10. **Contrast is computed, not eyeballed.** Every text/background pair the console uses is listed in the
    token file and checked: body text ≥ 4.5:1, large text ≥ 3:1, borders of controls and the focus ring
    ≥ 3:1 (WCAG 2.2 AA, success criteria 1.4.3 and 1.4.11). A brand color that fails is adjusted in
    lightness only, hue kept, and the adjustment is reported. `aof design check` exits 1 on any failure.

11. **Charts use the data-viz palette, in a fixed order.** The categorical palette is seeded from the
    brand primary and chosen so neighbouring slots stay apart under simulated protanopia and deuteranopia
    as well as normal vision; every slot is at least 3:1 against the surface. Series take slots in order and
    keep them when filters change. Status colors are reserved for status. Text in and around charts uses
    the text tokens, never the series color.

12. **Dark mode is designed, not inverted.** Dark surfaces keep the brand hue at low chroma; brand colors
    are lifted in lightness until they pass on the dark surface; every pair is checked again in dark.
    The page follows the operating system unless the Principal picks light or dark.

13. **Motion is a hint, never a show.** Transitions are 400 ms or less (180 ms by default) and disappear
    under `prefers-reduced-motion`. Nothing animates on load.

14. **Calm means a noise budget.** A calm console shows at most 7 items per panel with "N more" below. No
    logs, model text, token counts, route names or cell internals by default; they are one drill-down away.

15. **Destructive actions need a typed confirmation.** The kill switch sits alone in a danger panel. Its
    button stays disabled until the scope name is typed exactly. No destructive control sits next to a
    primary action.

16. **The console never sends the Principal elsewhere, and a static console never acts.** In the static
    PoC console every button reveals the exact `aof` command and a copy button; the page performs nothing.
    The MVP web console calls the same operations behind the same buttons.

## Adapting to the organization

The brand is read, proposed, confirmed, then applied, in that order (`surfaces/BRAND_INTAKE.md`).
`aof design extract` reads the public site (or a saved copy) without cookies, credentials or JavaScript,
ranks colors and fonts by frequency and role hints (custom-property names, `theme-color`, button rules),
and writes a proposal with evidence. A person confirms it. Tokens are rebuilt from the config; an
existing design system is consumed, extended in its own vocabulary, or sent a reviewed proposal, as
`designSystem.updatePolicy` says. Fonts are self-hosted or the system stack; no third-party CDN.

## Anti-patterns

- A dashboard of equal-weight tiles where the pending decision is one tile among twelve.
- Two filled buttons on a card ("Approve" and "Send"), or a red Reject button next to Approve.
- Status shown as a colored dot with no word.
- Brand gradients behind text, or the brand color used as body text on a tinted background.
- Numbers centered in table cells; mixed proportional digits in a column.
- A dark mode produced by inverting the light palette.
- A chart whose series colors are generated per render, so "Program A" changes color when a filter changes.
- Links that open the mail client or the board to "finish" an action the console should perform.

## Cockpit rules

A console is a cockpit a busy principal works from, not a document they scroll. Each principal gets their own platform
instance of a console template; these rules apply to every instance.

1. **What needs you first.** Today opens on the decisions only this principal can move, with why now, the
   recommendation and the primary action on the row. Everything else on the page serves that.
2. **One screen before any scroll.** At 1200 px and wider Today fits the window: three dock panes (about 50 / 28 / 22)
   under a 56 px top bar, every block with a fixed budget that ends in "+N more" instead of growing. 768–1199 px is
   two panes; below 768 px one reading column with a bottom tab bar. Breakpoints are viewport media queries.
3. **Decide where you read.** A decision row opens its full package (recommendation, dissent, what approval causes,
   evidence) in the reading or dock pane beside it, with the actions there; the principal never navigates away to decide.
   Two-pane pages keep the short list and the reading pane side by side; tables open the detail beside the table.
4. **Every figure names its source and freshness.** "ledger · 06:45", "finance export · 2 days". Source weather says how
   many sources answered.
5. **Never a bare zero.** A source that is not connected shows "not connected" (or a dash with that word), never 0, and
   the headline counts never include what nobody reported.
6. **A question stays a question.** The ask bar turns a question into a question for the Chief of Staff
   (`aof intent convert-question`); only "Convert to candidate intent" makes it work (`aof intent submit`).
7. **No config in a principal's view.** No YAML, Markdown source, model names, routes or cell internals on a
   principal's console; configuration is the engineer's instrument, filled by interview.
8. **Outcomes for deciders, machinery for engineers.** Director, Principal and Program Lead instances show decisions,
   program health, pipeline, inbox, meetings, reports and money (only with a finance scope); cells, routes, intents,
   SE packages, verification runs and evidence tails live on the engineering instances only.
9. **Instances are isolated.** No page, palette entry or link of one instance points into another; the "choose your
   platform" list is a separate launcher outside every instance.
10. **The consequence is on the button.** A protected effect opens a confirmation naming the target, the payload digest
    and the decision record that will be created; the primary button reads as the consequence ("Approve and send to
    Program leads").
11. **Static first, then served.** Every page is complete server-rendered HTML that reads with scripting off and opens
    from disk; the script only enhances (palette, focus, dock, sorting). `aof serve` adds the local API and nothing else.
12. **Print the Today page as the brief.** The print stylesheet turns Today into a one-page brief: the brief, the notes
    and the strips; controls and the Chief of Staff pane drop.
13. **The approved type and rhythm.** Mono small-caps eyebrows above every block, a serif headline with an italic second
    line, compact rows with status chips at the right edge, an 8 px rhythm; warm-ink dark and cream light themes with the
    same contrast floor.
