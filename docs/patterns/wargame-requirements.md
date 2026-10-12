# Pattern: war-game requirements elicitation

Status: draft
Owner: project maintainers

## Problem

Requirements for agentic systems are usually written from feature conversations: what should it
do, what should the screen show, which model should it use. Interviews and workshops are good at
the nominal path because the nominal path is what stakeholders imagine when asked. They are poor
at the paths that hurt: the third day of an outage, the confident wrong answer, the instruction
hidden in a document the agent reads, the new hire who does not know the workaround, the budget cut
that removes the reviewer. Those paths turn into incidents, and incidents turn into requirements
after the fact, at the most expensive point in the lifecycle.

Agentic AI makes this worse. A component that drafts, ranks, decides or acts introduces failure
modes that no stakeholder has lived with yet: it can be manipulated by its inputs, it can be
fluently wrong, and it can take an action faster than anyone can check it. Nobody volunteers those
in an interview because nobody has experienced them.

## Why adversarial play finds what interviews miss

A war-game replaces the question "what do you need?" with a situation and an opponent. Stakeholder
seats (operator, maintainer, sponsor, security officer, end user) and adversary seats (attacker,
degraded network, schedule compression, budget cut, misbehaving model, prompt injector) take turns
acting on the concept inside a scenario. Three mechanisms make it work:

1. **Consequences are concrete.** A move is one action in one situation, so its consequence can be
   reasoned about. "The tablet is offline for 72 hours" makes storage limits, out-of-order uploads
   and stale data visible in a way that "it should work offline" never does.
2. **Opponents are motivated.** An adversary seat has a means and a motive and is rewarded for
   breaking the concept. It asks the questions a friendly reviewer politely skips.
3. **Every move must yield something.** The move format forces each turn to end in a need, a
   constraint or a fear, and a candidate artifact. Discussion that does not produce a candidate is
   visibly unproductive.

The same idea underlies established public practice: hazard analysis (MIL-STD-882E) asks what
conditions lead to harm; STPA asks how unsafe control actions arise from the control structure;
NIST SP 800-160 Vol. 2 frames cyber resiliency around an adversary who will get in; the OWASP Top
10 for LLM Applications catalogues how model-backed components are manipulated. A war-game puts
those questions in the mouths of seats at the table, early, before there is a design to defend.

## The move format

Every move is logged in five parts:

```text
SITUATION    what is true right now, in the scenario
ACTOR MOVE   what this seat does (one action)
CONSEQUENCE  what the system and the people experience
WE NOW...    NEED <capability> | CONSTRAIN <limit> | FEAR <bad outcome>
CANDIDATE    requirement | hazard | threat | acceptance criterion | open question | assumption
```

Moves get ids (`M<round>.<nn>`) and candidates cite them, so every requirement that survives can
be traced back to the move that produced it. That trace is what lets a reviewer later ask "why does
this requirement exist?" and get an answer that is not "someone thought so".

Rounds follow a deliberate escalation. Round 1 is a normal day: it yields needs and main functions.
Round 2 is the worst plausible day: a fault, peak load and an adversary move together; it yields
hazards, threats and degraded modes. Round 3 is change a year later: new staff, a policy change, a
supplier change; it yields lifecycle and maintainability requirements and constraints. Further
rounds chase whatever the previous one exposed but did not resolve.

## Convergence

A game needs a stop rule, or it becomes a meeting. The default rule is: **stop when a round adds
fewer than 10% new stakeholder needs and no new P0 hazard**, or at the configured round limit.
New needs are counted against the distinct needs known before the round; round 1 never converges.
Hazards are scored P0 (catastrophic) to P3 (negligible) after the MIL-STD-882E severity categories.

Reaching the limit without converging is a legitimate, recorded outcome (`converged: false`). It
tells the owner that the concept is still moving and that baselining now would freeze an
incomplete picture. In the worked example in the engineering pack, the second round added 25% new
needs; the plan records non-convergence and schedules a third round before baselining.

## How hazards and threats fall out

Hazards come mostly from stressor seats (degraded network, hostile environment, misbehaving model)
and from persona seats under pressure. A hazard candidate names a cause, a consequence and a
severity. Threats come from actor seats (attacker, prompt injector, insider) and name the actor,
the means, the asset and the impact. Consolidation enforces one rule that makes them useful: every
P0 or P1 hazard and every threat must be mitigated by at least one candidate requirement, and the
requirement records the hazard id. Unmitigated items block baselining.

For agentic components, two adversaries do most of the work. The **misbehaving model** produces
fluent, confident, wrong output; playing it usually forces a decision about what the model may
decide versus merely draft, and a requirement that irreversible actions wait for a human. The
**prompt injector** puts instructions inside data the agent reads; playing it forces the
requirement that untrusted content is data, never instructions, with a test made of planted inputs.
In the worked example these two moves produced the architecture decision "deterministic rules
decide whether a reading is flagged; the model only drafts the note", which made the flagging logic
verifiable by an ordinary unit test.

## Where AI helps and where it must not

An AI assistant is a good seat-filler: it plays absent personas and every adversary tirelessly, and
it keeps the log in the required format. It must not hold the seat of a human approver who is in
the room, and nothing it produces in the game is a fact: needs from AI-played seats are confirmed
with a real holder of that role before baselining. The game produces candidates; verification
happens much later, with evidence records that name a command, an exit code and a revision.

## Ten rules

1. **Log moves, not opinions.** A preference becomes a move with a consequence, or nothing.
2. **One action per move.** Split compound moves; they hide two consequences.
3. **Adversaries need means and motive.** An omnipotent adversary produces fear, not requirements.
4. **Humans hold the seats with authority.** The AI plays absent seats only.
5. **Always play the worst day.** A game with only a normal-day round has not started.
6. **Play the model as an adversary** whenever a component decides, drafts, ranks or acts.
7. **Every candidate cites a move id.** Untraceable candidates are dropped at consolidation.
8. **Every P0/P1 hazard and every threat gets a mitigating requirement**, or blocks the baseline.
9. **Respect the stop rule, and record non-convergence honestly.**
10. **Nothing in the game is verified.** Candidates become requirements; requirements become
    verified only with evidence bound to command, exit code and revision.

## In this repository

- Configuration: `organs.systemsEngineering.elicitation` (methods, war-game seats, rounds,
  outputs, convergence rule) in `schema/agentic-os.schema.json`.
- Rendered plans: `templates/systems-engineering/elicitation/WARGAME_PLAN.md.j2` and
  `ELICITATION_PLAN.md.j2`.
- Standalone use with any AI platform: `engineering-pack/01_WARGAME/` (facilitator guide, setup,
  round and consolidation prompts, log template, worked example).

## References

NASA Systems Engineering Handbook (SP-2016-6105 Rev 2), sections 4.1–4.2; MIL-STD-882E, System
Safety; public STPA guidance; NIST SP 800-160 Vol. 1 and Vol. 2; NIST AI RMF 1.0; OWASP Top 10 for
LLM Applications; DoD Systems Engineering Guidebook (2022).
