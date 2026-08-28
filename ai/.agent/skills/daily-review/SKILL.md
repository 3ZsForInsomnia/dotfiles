---
name: daily-review
description: "End-of-workday review routine. Reconciles what was planned this morning against what actually happened, updates the track where the day changed it, captures loops so nothing needs reconstructing tomorrow, and closes the day's log entry. Work only (the personal review is separate). Use when the user says 'daily review', 'review my day', 'end of day', 'wrap up my day', 'eod review', or 'how did today go'. Reads Sunsama and the daily log; the reflection and the decisions stay the user's."
user-invocable: true
---

# Daily Review

The end-of-workday routine. Reconciles the day: what got planned this morning
versus what actually happened, what that means for the track, and what needs to be
ready to act on tomorrow. Work only; the personal review is separate.

This is **not a shortened weekly review.** It looks at what was pertinent today and
how the day's work fits the larger plan. The weekly review is a different lens (the
week's arc and patterns); this one is the day. It is also **selective**: it does not
account for every task every day, only what actually mattered.

Like daily planning, this skill **operates** the plan. It surfaces what changed and
records the user's calls; it does not author or revise milestones inline.

## Principles (these override any urge to be thorough or helpful)

- **Reconcile, don't re-plan.** The job is to see the day clearly and capture what
  follows from it. Deciding what tomorrow looks like is planning's job, not this.
- **Encode the user's judgment; don't defer to AI.** Surface the gap between planned
  and actual and the signals behind it. The user draws the conclusions. This is what
  they'd do without AI, mechanized.
- **The reflection is the user's.** Why goals slipped, what ran long and why: the
  user writes that. Help them think it through; do not write it for them.
- **The milestone check is always present but always light.** A quick pass over
  whether today's results moved milestone health, most days silent or one line.
  Never a ritual. Never manufacture panic.
- **Capture so nothing evaporates.** Anything today opened that needs a future action
  or conversation gets captured now, ready for tomorrow's planning, not left in the
  user's head overnight.
- **Skippable.** A day can go unreviewed. Don't force the flow.

## Inputs

**Sunsama is the source of truth**, same as planning. Jira is fine to query when it
adds detail (a ticket's status, a transition), but it is never the surface.

- **The daily log's planned half** (`~/Documents/sync/daily-log.md`, this morning's
  entry). This is the fixed record of what was committed to today. It matters because
  live Sunsama keeps no change history: if a task got pushed to tomorrow during the
  day, Sunsama no longer shows it was ever on today. The log is how you know what the
  morning actually planned.
- **Sunsama's current state for today** for what actually happened: which tasks are
  done, which aren't, and the actual times where the user set them (a task estimated
  at 1h that took 3h is a signal). Compare this against the log's planned half.
- **The track (`W/Milestones`)** for the milestone check, plus the project's
  `milestones.md` for the relevant milestones' estimates, risk levels, and cut-candidates.
  Work only here, so `P/Milestones` is out of scope (the personal review handles personal).
- **The last few days of daily notes** (notes repo, `~/Documents/sync`), as ambient
  context: what loops were already open, what the week has been like. Not 1:1 with
  tasks. Today's note is usually already in the buffer. Daily notes live at
  `9 - Resources/94 - Old activity notes/<YYYY>/<YYYY-Qn>/<YYYY-MM>/<YYYY-Www>/<YYYY-MM-DD-Weekday>.md`;
  derive year, quarter, month, ISO week, and weekday from the date.

## The daily log

The same single file daily planning writes (`~/Documents/sync/daily-log.md`), one
entry per day. Planning opened today's entry with the planned half this morning; this
skill **closes the same entry** by filling its Actual section. Do not start a new
entry for the day and do not reformat past entries. **Match the format already in the
file.** The Actual section records what got done, what slipped and by roughly how
much, and a terse why where it's worth keeping. It is context for the AI, not a report
for the user, so keep it short.

A confirmed milestone miss is recorded as a `- miss [PREFIX-n]: <reason>` line inside the
day's entry (see step 3). Its presence is the watchlist signal later runs read; the
day it sits on is the day the issue showed, so no separate date is stored. A recovery
may optionally be noted as `- recovered [PREFIX-n]`; nothing needs clearing, since markers
age out of the read window on their own.

## Writes

Two write targets, same as planning plus the log:

- **Sunsama `create_task`**, confirmed first, for a genuinely new follow-up the review
  turns up (a check-in, a loop to close, a "revise milestone X"). If it serves a
  milestone, name it `[PREFIX-n]: ...`. The skill does not move tasks into days, set
  priorities, or timebox.
- **The daily log** (`daily-log.md`): fill today's Actual section.
- **The daily note is not a default write target.** The AI may *offer* to add the
  planned-vs-actual delta summary and its causes to today's daily note, but writes it
  only on an explicit yes. The reflection itself is always the user's to write.

Milestone/story status changes the user decides on are theirs to make; where a Jira
or Sunsama update is warranted, confirm and do it, but the call is the user's.

## The flow

The shape of a session, not a script to read out. Keep **the user's** time short; you
can do deeper legwork (querying Jira, scanning the log, cross-referencing notes) as
long as what you hand back stays light. It is selective by design: surface what
mattered today, not a line-by-line audit.

### 1. Start: watchlist and context

Read roughly the last two weeks of entries in the daily log
(`~/Documents/sync/daily-log.md`) and note any milestone carrying `miss [PREFIX-n]`
markers in that window. Treat them as a watchlist: a nudge toward where to look
harder, not a conclusion; repeated markers across days weigh more than one. The log
path is absolute, so this doesn't depend on the working directory. Then read this
morning's planned half of today's entry and the last few days of notes for context.

### 2. Planned versus actual

Compare the log's planned half against Sunsama's current state for today. Surface the
gap, not every row: what got done, what slipped, and where actual time ran well past
the estimate. Where something slipped or overran, that's the material for the
reflection in step 5, so note the what and hold the why for the user. Whether today's
work rippled beyond what the plan accounts for (a task that grew, a dependency that
surfaced) is the useful signal here.

### 3. Update the track

A light pass over whether today's results moved milestone health, scoped to
`W/Milestones` and to what today actually touched. This is the same nudge-not-revision
shape as daily planning: you gather high-level data (a story that closed, a milestone
whose remaining work just grew, a due date that today made tighter), the **user** makes
the on-track call. Where a status change follows (a Jira story done, a Sunsama task
updated), confirm and apply it. If a milestone is genuinely off, hand off to the
milestone skill or note it to pick up later; never revise milestones here.

**Record a confirmed miss.** When the user confirms a milestone is genuinely off, or is
on the fence (default to recording), add a `- miss [PREFIX-n]: <one-line reason>` marker to
today's daily-log entry when you close it in step 6. Never record on your suspicion
alone. Nothing needs clearing later: markers age out of the two-week window on their
own, and a recovered milestone simply stops collecting them.

### 4. Capture outbound loops

Anything today opened that needs a future action or conversation gets captured now, so
it's ready for tomorrow's planning instead of reconstructed from memory: someone's work
to check on tomorrow, a thing to raise at an upcoming sync, a follow-up a meeting left
open. Actionable items become a Sunsama `create_task` (confirm first). Context that
isn't itself a task, the AI surfaces for the user to jot if they want it; the AI does
not write it into the daily note. A loop need not map to an existing Jira or Sunsama
item; often it comes from a note or a ticket comment.

### 5. Reflection

Prompt the user for the why behind the day: what got in the way, what ran long and why,
whether the misses point at something (a bad estimate, an interruption pattern, scope
that was off). **The user writes this** into today's daily note; talk it through with
them, do not author it. Most of the value of the review is here, not in the mechanics.

You may **offer** to add the planned-vs-actual delta summary and its causes to the
daily note as well, but only write it on an explicit yes; the user may prefer to save
their own version or leave it in the log alone.

### 6. Close the log entry

Fill today's Actual section in the daily log (see **The daily log**), matching the
file's existing format: what got done, what slipped and by roughly how much, a terse
why where it's worth keeping, plus any `- miss [PREFIX-n]:` markers confirmed in step 3.
That closes the day. The planned-versus-actual trail it leaves is what lets the miss
signals in future planning and reviews mean something.

