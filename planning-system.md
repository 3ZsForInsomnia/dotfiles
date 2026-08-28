# Planning & Review System: build roadmap

A multi-conversation effort to build the tech-lead planning/review loop and its
supporting skills. This is the **build spec**: what we're creating and its status.

## Context

Started from informal notes: a chat with Claude on the web, not an official doc:
`~/Documents/sync/1 - Work/15 - Proposals/team-lead-retro-mpx.md`. We don't rewrite
what's already there, but we can add to it (e.g. a decisions section). This roadmap
is the implementation side of the same thinking.

## Design principles

- **Planning and review are different processes; daily and weekly are different
  lenses, not zoom levels of one thing.** Daily review = what's pertinent today and
  how the work done fits the larger picture. Weekly review = the week's arc and
  patterns. A daily review is not a shortened weekly review.
- **Personal + professional are combined only in daily *planning* (morning).** The
  reviews stay separate: a work review (end of workday, work-only) and a personal
  review (pre-sleep, personal-only); same split at the weekly level.
- **Routines assume the track exists; no branching.** Each routine reviews against
  the current milestones and includes one checkpoint: *are the milestones still in
  good shape?* If not, hand off to the create/update-milestones skill, or skip. No
  dual execution paths.
- **Operate the plan vs. author the plan are separate.** Routines run the plan and
  only sanity-check milestones. Creating/revising milestones is its own ad-hoc task:
  it may *swap* a routine slot when the track isn't set up, but never takes one over.
- **Encode my judgment; don't defer to AI.** AI surfaces candidates and structure;
  the decisions stay mine. This is what I'd do without AI, mechanized.
- **Anti-prescriptive.** Questions bank / talk-it-through, not fixed scripts.
- **Sessions are skippable.** Can't review against an undefined track, so skipping is
  fine; routines don't need to handle the no-track case gracefully.
- **Deep-review selection is mechanical** (rotation / least-recently-reviewed / risk
  criteria); final pick mine.

## Artifact type: skills

Built as skills, not prompts. Built fresh, not adapted from the existing prompts.

## Milestone model (resolved while building daily planning)

Shared infrastructure the routines and the author-the-plan skills all build on.

- **Sunsama is the source of truth and the planning surface.** Jira is queried only
  when it adds detail (breakdown, transition history); never the planning surface.
  The user's hand-entry of Jira items into Sunsama with a due date is the deliberate
  judgment gate; we never mine Jira for work the user didn't choose to track.
- **The track = two backlog folders: `W/Milestones` (work) and `P/Milestones`
  (personal).** Each milestone is a task in its folder with a due date where one
  exists; the folder marks it as a milestone, never a task to bring into a day.
- **Milestone ↔ task link is a title prefix.** Each milestone owns a key `PREFIX-n`
  (per-project prefix + number, managed by milestone authoring); tasks serving it are
  named `[PREFIX-n]: task name`, found via `search_tasks`, and the shared prefix groups a
  project's milestones. Titles only, never task notes. Untagged tasks are unaffiliated.
- **No hierarchy inside Sunsama** (it has none; subtasks are just checklists).
  Work references Jira's epic→story→subtask; personal caps at milestone + `[key]:`
  tasks. A big personal goal becomes several sibling milestones, not nested ones.
- **On-track is the user's call, not the AI's.** The AI gathers data and surfaces
  signals (deadline proximity, sparseness vs. size/proximity, transition staleness,
  collisions, notes-silence); the user judges. Depth of AI analysis is free; the
  15–20 min budget is the user's attention, not AI processing.
- **Miss watchlist.** No separate memory store. A confirmed milestone miss is written
  as a `miss [key]` marker inside that day's daily-log entry; routines read the last
  ~2 weeks of the log at start and surface milestones with recent markers as a soft
  watchlist. Self-bounding (the window, not history) and self-pruning (markers age
  out; recovery just stops adding them). The log path is absolute, so it works from
  anywhere. Superseded the earlier project-scoped-memory design.

## Daily log (resolved while designing daily review)

Shared infrastructure between daily planning and daily review (weekly review may
read it too). Exists because live Sunsama shows no change history: once a task
moves off today, there's no record it was ever planned, so planned-vs-actual needs
a durable trail of its own.

- **One file, one entry per day, at the notes-repo root** (`~/Documents/sync/`).
- **Written in two halves by the two routines:** daily planning opens the entry with
  the *planned* half (morning); daily review closes it with the *actual* half. No
  separate before/after files or entries; one row that starts partial and gets
  completed.
- **A defined, stable pattern** so the format doesn't drift across days. Machine-first
  (it's context for the AI, not a report for me) but kept somewhat human-readable.
- **Read back:** the last few days as needed. This log does much of the
  miss-detection lifting for both routines.
- **Miss markers.** A confirmed milestone miss is a `- miss [key]: reason` line inside
  the day's entry; a rolling ~2-week read of these is the miss watchlist (see Milestone
  model). The day the marker sits on is the day the issue showed, so no separate date
  is stored.
- **Vectorized.** Living in the notes repo, every entry is committed and indexed by
  VectorCode, so the log is semantically queryable later like the rest of the notes.
  Keep entries clean and self-descriptive.

## The routine loop

All built fresh. **Daily planning and daily review are built** (`daily-planning`,
`daily-review`); weekly planning/review and the author-the-plan skills are next.

### Daily planning: ✅ built (`daily-planning`)
- **When:** morning, before anyone else is online (early start, mid-day gym)
- **Scope:** personal + professional together, the one routine that combines them
- **Purpose:** decide what to do today to move deadlines: "what do I do today to make X happen by day Y"
- **Reads:** Sunsama (source of truth); the last few days of daily notes (ambient reasoning-layer context, not 1:1 with tasks); calendar free blocks (read-only). Jira only when it adds detail.
- **Produces:** a prioritized, deadline-aware plan surfaced for the user to act on, *not* a schedule, and it does not reshuffle Sunsama. Due date drives order; `backlogHorizon` is a soft "sooner-first" tiebreaker.
- **Milestone check:** always present, always light. Log-window watchlist read at start; AI gathers high-level data and surfaces a digest; the user makes the on-track call; confirmed misses written as log markers. If a milestone's off, hand to the milestone skill or skip; never revise here.
- **Writes:** `create_task` only, confirmed first, for genuinely new commitments (check-in, milestone-revision, follow-up). Never move-to-day, set-priority, or timebox.
- **Log:** opens the day's daily-log entry with the planned half; review closes it. *(Done.)*

### Work daily review: ✅ built (`daily-review`)
- **When:** end of workday. Work only.
- **Purpose:** what's pertinent today and how the day's work fits the larger plan. *Not* a shortened weekly review. Selective; doesn't cover everything every day.
- **At start:** read the log-window miss watchlist (last ~2 weeks), same as daily planning.
- **Reads:** Sunsama for planned-vs-actual (live Sunsama shows no change history, so it can't reconstruct what moved; the daily log fills that gap); this morning's planned half of the daily log; the last few days of daily notes.
- **Produces:**
  - milestone/epic/story updates where the day changed things;
  - a light milestone sanity-check (same shape as daily planning: nudge, not revision; hand off if genuinely off);
  - **outbound-loop capture**: anything that opened a loop or needs a future conversation becomes a Sunsama `create_task`; non-task context is surfaced for the user to jot, not written to the daily note;
  - the completed daily-log entry (the actual half), including any `miss [key]` markers.
- **Reflection is the user's:** they write the why into the daily note; the AI talks it through and may *offer* to add the delta summary to the note, writing only on an explicit yes.
- **Not here:** code review (pushed to weekly at most; see note); milestone revision (sanity-check only).

### Personal daily review
- **When:** pre-sleep. Personal only. Separate from the work review.
- **Priority:** lower than the work routines, but not deferred.
- **Purpose:** review the personal day; track physical activity, meal prep, reading, hobbies, diet (content carried over from the existing personal prompt, rebuilt fresh).
- **To design:** most of it

### Weekly planning
- **When:** weekly; *slot TBD (Monday-ish)*
- **Purpose:** set the week against the sprint's open epics
- **Reads / Produces / To design:** *TBD*

### Work weekly review
- **When:** Friday, end of week
- **Purpose:** the week's arc and patterns, a distinct lens from the daily review
- **Decided behavior:** loop-closure triage-to-zero (the deep pass); a short daily review folded in first, since Friday is also a work day
- **Reads / Produces / To design:** *TBD*

### Personal weekly review
- **When:** weekly. Personal only.
- **Purpose:** review the personal week (activity patterns / counts)
- **To design:** most of it

## Author-the-plan: the feature pipeline

Run ad hoc, not routines. Takes a feature from first understanding to a plan higher-ups
can decide on. **Every skill is agnostic**; work-specific details (Jira, teams, milestone
conventions, PRD/Confluence/Figma as the input source) live in the work or repo
`.claude/` layer, not in the skills, so there are no work/personal skill splits. **Every
skill is iterable, skippable, and redoable**; selective redo (redo data model + contracts,
then re-run only what follows) comes from independent create-or-revise artifacts, not an
orchestrator.

**The planning pipeline:**
1. **Requirements** (early, quick). Sense-check the requirements, discover the code
   reality, flag early risk. One skill, adapting to input maturity: a comprehensive PRD to
   pressure-test (depth-first), a vague idea to shape, or an existing project to understand
   and extend. Output: `requirements.md`. Makes the user informed enough to give a
   better-than-vibes answer; not itself a business report.
2. **Design** (extensible). Architecture, contracts, data model, and whatever else a
   feature needs. Each reads requirements and the code. Any subset skippable (no DB change,
   skip the data model) or re-runnable.
3. **Milestones** (coarse decomposition). Group the work into epic-level milestones:
   outcome (a cuttable user capability) and foundational (groundwork, placed just-in-time),
   sequenced by dependency. Each carries an hours estimate (best/likely/worst via a risk
   band), a risk level, and a cut-candidate flag. Output: `milestones.md`. No dates (the
   user owns those); no Sunsama writes (the user sets those up when ready).
4. **Plan / report** (last, work-only in use). Turn the risk-annotated milestones into one
   plan for eng leadership, product, and business to decide scope, with scope pushback
   built in. Scope is their call, not the user's; a business cut loops back to re-run
   milestones. The only stage with no personal use.

**Breakdown is not a planning stage.** Breaking a milestone into assignable tickets happens
later, per-milestone, at development time, so it sits outside this pipeline. Execution-time
and recurring; still to build.

**Entry point (stage 0).** A kickoff/navigator: "here are my epics/Confluence/Figma, this
project needs x/y/z, let's get started." It reports which artifacts are present, missing, or
stale and dispatches a single producer on request. Idempotent and re-entrant (run it, do a
few, come back). Distinct from the plan/report, same no-orchestration safeguards (gap-check,
single consented dispatch, no auto-chaining, stateless).

**Early vs late risk:** stage 1 identifies and rough-sizes risk (what is risky); stage 4
translates it (what that risk means for scope and the business). The two sit on opposite
sides of estimation, which is why the report is last.

**Artifact conventions (shared):**
- One markdown file per artifact type, per project, in the notes repo. Work projects at
  `1 - Work/10 - Projects/<project>/`, personal at `0 - Personal/01 - Projects/<project>/`.
  The folder name is the project; no index file.
- Create-or-revise: re-runs update in place.
- Iterative-ready: design producers use a candidate loop (explore approaches, compare,
  converge, keep the culled as alternatives); requirements and milestones iterate by
  refinement, not compete-and-cull.
- The collaborative opener is the first principle in every skill (surface and pause at the
  judgment calls; the user steers and decides).
- Diagrams use the shared `mermaid-diagrams` skill.
- Each artifact stands on its own, not tailored to a consumer.

**Build status:**
- **Requirements** ✅ `requirements-analysis`. `requirements.md`. Adapts to input maturity;
  problem/user-outcome emphasis, moving pieces, discovery (reuse/touch/build-new), early
  risk, open questions. Scope-neutral. Kept the questioning cadence and Why/Simpler from
  `requirements-clarity`, dropped its scoring and do-everything template.
- **Data model** ✅ `data-modeling`. `schema.md`. Postgres-first; normalize from the domain,
  integrity as constraints, index/denormalize from usage, avoid jsonb. Fresh
  (`database-schema-designer` dropped as bloat).
- **Architecture** ✅ `architecture-design`. `architecture.md`. Container/component forward
  design; candidate loop; decisions with rejected alternatives. `c4-architecture` left
  standalone; `sys-arch-docs` judgment informed it.
- **Contracts** ✅ `api-design`. `contracts.md`. REST/RPC/events, HTTP semantics, error and
  cross-cutting shape, idempotency, sync/async. Adapted from the `api-design` prompt,
  narrowed to interfaces.
- **Milestone authoring** ✅ `milestone-authoring`. `milestones.md`. Outcome/foundational
  split, `PREFIX-n` keys it manages, hours estimate (best/likely/worst, risk band low 10 /
  med 20 / high 40 percent, size-tiered rounding), cut-candidates. Doc only, no Sunsama.
- **Plan / report** ✅ `plan-report`. `plan.md`. Synthesizes requirements, designs, and
  milestones into a leadership/business-facing plan for scope decisions; technical milestones
  kept visible, shared-groundwork vs capability grouping from the dependency graph, risk in
  business terms, bandwidth not dates, scope prepared not decided.
- **Kickoff / navigator** to build (stage 0). The entry point above.
- **Breakdown** to build, execution-time (not a planning stage). Draws on `stories.lua`'s
  durable breakdown doc and gap/spike/state-coverage judgment, not its dev-driven workflow.
  Ticket-ready, no acceptance criteria.

Dropped from scope: `gepetto` (monolithic, rebuild-not-revise), `arch-review` (a review
partner, kept as a general skill).

## Meeting-note processing

Needs to happen **at review time** (a sub-step of a review) **and impromptu** (right
after a meeting). To design/verify. Existing candidates to evaluate (not vouched):
`note-filing`, `meetings`.

## Deferred

Sprint / month sessions: each a single combined **end-of-period review → next-period
planning**. After the core loop lands.

## Open questions

Daily planning is built (see **Milestone model** and the routine loop). The items
below remain open.

- **The milestones / "track"**: *operate-side resolved* (see Milestone model). Still
  open: how milestones get authored and maintained, and enforcing that each carries
  dates + sub-estimates so there's something concrete to assess. Owned by the weekly
  and milestone-creation/revision skills, not daily.
- **Each skill's design**: purpose specifics, inputs, outputs (the TBDs in each stub).
- **Weekly planning slot**: which calendar block (Monday-ish).
- **Friday time budget**: short daily review + weekly review in ~1 hr; watch for crowding.
- **Implementation plan**: the synthesizer + front-door skill (gap-check, single-dispatch, RFC synthesis) once the producers are done.
- **Work breakdown**: product-driven entry point (review product's draft vs. propose one); how much survives from `stories.lua`.
- **Personal artifact location**: where personal project artifacts live (work is `1 - Work/10 - Projects/`).
- **Meeting-note processing**: design/verify (see its section).
