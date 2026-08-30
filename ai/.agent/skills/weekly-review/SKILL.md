---
name: weekly-review
description: "The Friday end-of-workday review, combined personal and professional. Three things: it closes Friday as its own end-of-workday review, it reviews the week's arc across work and personal projects (planned-vs-actual, milestone progress), and it reviews the personal habits/health week (patterns, gaps vs targets). The week lens, arc and patterns, not day-by-day. Use when the user says 'weekly review', 'review my week', 'end of week review', 'friday review', or 'how did the week go'. Trusts the filled daily notes and weekly tracking table; asks about gaps rather than reconstructing."
user-invocable: true
---

# Weekly Review

The Friday end-of-workday review, combined personal and professional. It does three things: closes Friday as its own end-of-workday review, reviews the week's arc across work and personal projects, and reviews the personal habits/health week. It works at the week lens, the arc and the patterns, not day-by-day; the daily routines handled the days.

It trusts the filled daily notes and weekly tracking table, and asks about anything that looks like a gap rather than reconstructing the week from scratch.

## Principles

- **The reflection and the calls are the user's.** Surface the arc, the patterns, and the data; the user draws the conclusions and writes any reflection.
- **Week lens, not day-by-day.** The arc and the patterns across the week, not a rerun of each day.
- **Trust the filled notes and tracking.** Ask about anything that looks like a gap rather than re-deriving the week.
- **Honest accountability, and help to do better.** Where the week fell short, name it and help work out how to make next week more likely to go well, not just note the miss.

## Inputs

**Sunsama is the source of truth**; Jira is queried only for progress detail. The daily notes and the weekly tracking table are trusted as filled.

- **The daily log** (`~/Documents/sync/daily-log.md`), the week's planned-vs-actual record across the days, for work and personal projects. One entry per day with a Planned half (set that morning) and an Actual half (set at each end-of-workday review); a milestone slip shows as a `- miss [PREFIX-n]: <reason>` line. Friday's Actual half is filled as part of this review (step 1). The path is absolute.
- **The track: `W/Milestones` (work) and `P/Milestones` (personal) backlog folders in Sunsama**, and their `milestones.md` docs (one per project, in the project folder under `~/Documents/sync`: work under `1 - Work/10 - Projects/<project>/`, personal under `0 - Personal/01 - Projects/<project>/`), for milestone progress across the week. Each milestone owns a key `PREFIX-n`, and every task serving it is named `[PREFIX-n]: task name`.
- **The weekly note's tracking table** (habits and health, filled by the user), for the personal-week review. It holds the tracked habits and metrics as daily rows, including weekly-cadence habits with Nx/week targets (learning/projects time, workouts, etc.). Read the list from the table, not from memory; it changes over time. Weekly notes live at `9 - Resources/94 - Old activity notes/<YYYY>/<YYYY-Qn>/<YYYY-MM>/<YYYY-Www>/<YYYY-Www>.md`.
- **The week's daily notes** (notes repo), for reflections, context, and open loops. Daily notes live at `.../<YYYY-Www>/<YYYY-MM-DD-Weekday>.md` under the same tree.
- **Jira**, only for progress detail on work milestones (subtasks, transition history).

## Writes

Friday's Actual half in the daily log (step 1), the same as any end-of-workday review. The week's reflection is the user's own; the skill surfaces the arc and prompts it, but does not write it.

## The flow

The shape of a session, not a script. Work at the week lens; the daily routines already covered the days.

### 1. Friday's end-of-workday review

Before the week lens, close Friday itself. Fill the Actual half of Friday's daily-log entry the same way an end-of-workday review does: against the Planned half, what got done and what slipped, terse, matching the existing entries. Record any confirmed milestone slip as a `- miss [PREFIX-n]: <reason>` line. Then note Friday's open loops so Monday can pick them up.

### 2. The week's arc

Step back to the week across work and personal projects. Read the week's daily log (planned-vs-actual) and the milestone progress (the `[PREFIX-n]:` tasks and `milestones.md`), and surface the arc: what moved, what stalled, where planned and actual diverged and why. Query Jira for progress detail on work milestones where it sharpens the picture. Hand back the shape of the week; the user draws the conclusions. Where a milestone is off, hand to `milestone-authoring`; never revise here.

### 3. The personal week

Walk the weekly tracking table for the habits/health week. Compare the weekly-cadence habits against their Nx/week targets (a 4x/week habit hit twice is a gap), and surface patterns and correlations across the days (sleep against energy, workouts against mood). Name the gaps honestly and, where the week fell short, help work out what would make next week more likely to land. The reflection is the user's; prompt it and leave the writing to them.
