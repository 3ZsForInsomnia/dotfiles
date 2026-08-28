---
name: daily-planning
description: "Morning planning routine that decides what to do today to move deadlines: 'what do I do today to make X happen by day Y'. Combines personal and professional work (the one routine that does). Use when the user says 'daily planning', 'plan my day', 'morning planning', 'what should I do today', or starts their day. Reads Sunsama (the source of truth) and recent daily notes, runs a light milestone health check, and surfaces a prioritized, deadline-aware plan the user commits to. Proposes; the user decides."
user-invocable: true
---

# Daily Planning

The morning routine. Decides what to do **today** to keep deadlines moving:
"what do I do today to make X happen by day Y." It is the one routine that
combines personal and professional work; every other review keeps them separate.

This skill **operates** the plan; it does not author it. It surfaces candidates
and structure and runs a light check against the existing milestones. The
decisions stay the user's.

## Principles (these override any urge to be thorough or helpful)

- **Encode the user's judgment; don't defer to AI.** Surface candidates and
  structure. The user picks. This is what they'd do without AI, mechanized, not
  an AI deciding their day.
- **Anti-prescriptive.** Talk it through. Ask, don't run a fixed script. There is
  no mandatory template the plan must fill.
- **Operate, don't author.** Run against the current milestones and *sanity-check*
  them. Creating or revising milestones is a separate skill; hand off to it, never
  do it inline.
- **The milestone check is always present but always light.** A quick pass, most
  days silent or one line. Never a 20-minute milestone ritual. Never manufacture
  panic that the track is out of sync.
- **Skippable.** If there's no track to plan against, or the user wants to skip,
  that's fine. Don't force the flow.

## Inputs

**Sunsama is the source of truth and the thing we plan against.** The user
hand-enters what matters from Jira into Sunsama with a due date; that manual step
is deliberate: it's where they decide a thing matters and by when. So don't mine
Jira for work the user didn't choose to track. **Jira is fine to query when it
adds something** (ticket detail, current status); it's just not the planning
surface.

- **The track: `W/Milestones` (work) and `P/Milestones` (personal) backlog
  folders.** These hold the milestones, each with a due date where one exists. They
  come back in the same backlog read; the folder marks them as milestones, never
  as tasks to bring into a day.
- **Milestone ↔ task link: a title prefix.** Sunsama has no native parent/child,
  so the link lives in the **task title**: each milestone owns a short key, and
  every task serving it is named `[key]: task name` (e.g. `[pay]: wire up refund
  endpoint`). Find a milestone's tasks with `search_tasks("[key]")`. The milestone
  task in the folder defines the key; there's no separate registry. Tasks without
  a `[key]:` prefix are simply unaffiliated; not everything belongs to a milestone.
  The link is in titles only; never read it from task notes.
- **All Sunsama tasks:** backlog and anything already scheduled. Use
  `search_tasks` to find a specific one.
- **The last few days of daily notes** (notes repo, `~/Documents/sync`), the
  *reasoning layer*: commentary, why a check-in is needed, why a milestone feels
  off. They are dumping grounds, **not** 1:1 with Sunsama tasks; treat them as
  ambient context, never map them task-by-task. Today's note is usually already in
  the buffer. Daily notes live at
  `9 - Resources/94 - Old activity notes/<YYYY>/<YYYY-Qn>/<YYYY-MM>/<YYYY-Www>/<YYYY-MM-DD-Weekday>.md`;
  derive year, quarter, month, ISO week, and weekday from the date.
- **Calendar free blocks:** read-only context for how much time today actually
  holds. Never written to.

## Creating tasks

The skill's only Sunsama write is `create_task`. Create one when planning turns up
a real new commitment that isn't already in Sunsama: a check-in, a "revise
milestone X" task, a follow-up. Confirm the title and details with the user first.
Most mornings this doesn't happen at all. If the new task serves a milestone, name
it `[key]: ...`.

The skill never moves tasks into a day, sets priorities, or timeboxes to the
calendar. It surfaces the plan; the user acts on it in Sunsama.

## The daily log

A single file at the notes-repo root (`~/Documents/sync/daily-log.md`), one entry
per day, shared with the daily-review skill. It exists because live Sunsama keeps
no change history: once a task moves off today, nothing records it was ever planned,
so planned-vs-actual needs its own durable trail.

Planning writes the **planned half** of today's entry; daily review closes the same
entry with the actual half at end of day. **Match the format of the existing entries
in the file**; don't reshape it day to day. Only when creating the file fresh, use
this shape:

    <!-- Daily planning/review log. One entry per day. Planning writes Planned; review writes Actual. Do not reformat past entries. -->

    ## YYYY-MM-DD
    ### Planned
    - [work] [key]: task name (~estimate)
    - [personal] task name (~estimate)
    ### Actual
    _(daily review fills this)_

Terse by design: context for the AI, not a report for the user. It records what was
committed to, not a schedule. The path is absolute, so writes don't depend on the
working directory.

A confirmed milestone miss is recorded as a `- miss [key]: <reason>` line inside the
day's entry (see the milestone check). Its presence is the watchlist signal later
runs read; the day it sits on is the day the issue showed, so no separate "since"
date is needed. A recovery may optionally be noted as `- recovered [key]`, but
nothing needs clearing: markers age out of the read window on their own.

## The flow

This is the shape of a session, not a script to read out. Keep **the user's** time
to 15–20 minutes, but that's their attention, not your processing. You can do deep
work (querying Jira, scanning histories, cross-referencing notes) as long as what
you hand back stays light and digested.

### 1. Is Sunsama current?

Ask once, up front: is there anything from Jira or yesterday not yet entered? The
plan is only as good as what's in Sunsama, and entering it is the user's call;
don't verify or backfill it yourself. Wait for the go-ahead, then proceed.

### 2. Milestone check

Read `W/Milestones` and `P/Milestones` (both; this spans personal and professional)
with their due dates. **You can't pronounce a milestone on-track or off**: only the
user can, since they hold context you don't. But you *can* gather real, high-level
data to inform that call, which is the whole reason this runs here instead of the
user eyeballing it and going on feel.

**Start with the watchlist.** Read roughly the last two weeks of entries in the daily
log (`~/Documents/sync/daily-log.md`) and note any milestone carrying `miss [key]`
markers in that window. Treat them as a *watchlist*: a nudge toward where to look
harder, not something immediately actionable and not a conclusion. A milestone that
has slipped recently earns a closer look even when today's snapshot looks fine;
today's live data still decides what you actually report. Repeated markers across
days weigh more than one. The log path is absolute, so this read doesn't depend on
the working directory.

Then do the legwork, scoped to what matters now: milestones near their due dates,
plus anything the watchlist flags. Don't analyze everything every morning:

- **Work milestones:** query Jira for the epic/story's subtasks and transition
  history (Sunsama has neither). Surface data-backed smells: a breakdown that's
  sparse relative to the milestone's size and how soon it's due; work that hasn't
  transitioned in a while.
- **Personal milestones:** Sunsama is the complete picture here; read the `[key]:`
  tasks and their estimates for the same sparseness/coverage read.
- **Both, cheap:** deadline proximity, collisions (two due the same week), and
  notes-silence (a soon-due milestone the last few days' notes haven't touched).

Hand back a light digest: a couple of lines pointing at the one or two milestones
worth a look, with the data behind each (e.g. "`[pay]`: epic due in 8 days, only 3
subtasks and nothing moved since the 18th"). The user decides whether any of it
matters. Most mornings nothing needs action. If one's off, hand off to the milestone
skill or note it to skip; never revise milestones here.

**Record a confirmed miss.** When the user confirms a milestone is genuinely off, or
is on the fence (default to recording), add a `- miss [key]: <one-line reason>`
marker to today's daily-log entry. Never record on your suspicion alone. Nothing
needs clearing later: markers age out of the two-week read window on their own, and a
recovered milestone simply stops collecting them. This record is always a soft
supplementary nudge, never an override of today's data or the user's call.

### 3. Surface today's plan

Pull the candidates from Sunsama: personal and professional together, the one
routine that combines them. Reason over them:

- **Deadlines first.** Due dates drive order; `backlogHorizon` ("in the next two
  weeks" … "someday") is a soft "sooner first" tiebreaker when an explicit date is
  missing. No hard cutoff; nearer things just rank higher.
- **Against the day's shape.** Use the calendar's free blocks and today's rhythm
  (early start, mid-day gym) for how much actually fits, as context, not a
  schedule you write.
- **Tie work to the track.** Where a candidate is named `[key]: ...`, note which
  milestone it moves, so priority reflects what's actually due.

Present a prioritized, deadline-aware plan and talk it through. Surface candidates
and structure; the user picks what today is. Don't hand back a rigid hour-by-hour
schedule.

### 4. Capture anything genuinely new

If the conversation turns up a concrete new commitment that isn't in Sunsama,
create it per **Creating tasks** above, confirming first. Usually nothing.

### 5. Open today's log entry

Once the plan is settled, write its **planned half** to the daily log (see **The
daily log**). One entry, terse, matching the file's existing format; leave Actual
empty for daily review to complete. Then you're done; the user works the plan in
Sunsama.
