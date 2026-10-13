---
name: weekly-planning
description: "The Sunday planning routine. Sets the week against the open milestones: which must advance this week to stay on track, and what the week's goals are. Combines personal and professional; works at the week's shape, not individual days. Helps the user decide the week's goals; the user writes them. Use when the user says 'weekly planning', 'plan my week', 'plan the week', or 'what should I focus on this week'. Reads Sunsama (the source of truth) and the project milestones; queries Jira only for progress detail."
user-invocable: true
---

# Weekly Planning

The weekly (Sunday) routine. Sets the week against the open milestones: which have to advance this week to stay on track, and what the week's goals are. It combines personal and professional, and works at the week's shape, not individual days; the daily routines handle the days.

Like daily planning, it operates the plan against the existing milestones; it does not author them. It helps the user think through the week's goals; the user writes them.

## Principles

- **The user writes the goals.** Help think them through, weigh what has to move against what the week actually holds, but the user writes the week's goals themselves.
- **Week lens, not a day plan.** Set the week's shape and which milestones advance; don't schedule individual days.
- **Operate, don't author.** Gather data on the milestones and sanity-check them. Creating or revising a milestone is `milestone-authoring`'s job; hand off, never do it inline.
- **Combined.** Personal and professional together.
- **Anti-prescriptive and collaborative.** Talk it through; surface the data and the options, the user decides.

## Inputs

**Sunsama is the source of truth and the thing we plan against.** Jira is queried only for progress detail (subtasks, transition history), never as the planning surface.

- **The track: `W/Milestones` (work) and `P/Milestones` (personal) backlog folders in Sunsama.** These hold the milestones, each with a due date where one exists. The folder marks them as milestones, not as tasks to schedule into the week.
- **Milestone ↔ task link: a title prefix.** Sunsama has no native parent/child, so the link lives in the task title: each milestone owns a key `PREFIX-n` (a per-project prefix plus a number, set by milestone authoring), and every task serving it is named `[PREFIX-n]: task name` (e.g. `[PPX-3]: wire up refund endpoint`). Find a milestone's tasks with `search_tasks("[PPX-3]")`, or a whole project's with the shared prefix. Tasks without a `[PREFIX-n]:` prefix are unaffiliated.
- **`milestones.md`, the project's milestone doc.** One per project, in the project's folder in the notes repo (`~/Documents/sync`): work projects under `1 - Work/10 - Projects/<project>/`, personal under `0 - Personal/01 - Projects/<project>/`. It holds the estimates, risk levels, and cut-candidates behind the milestones, richer than Sunsama carries. Read the milestones in play; not every project has one.
- **The daily log** (`~/Documents/sync/daily-log.md`), for the miss watchlist. A confirmed milestone slip is recorded there as a `- miss [PREFIX-n]: <reason>` line on the day it showed; reading roughly the last two weeks of these is the watchlist. The path is absolute, so the read doesn't depend on the working directory.
- **The week's calendar**, read-only, for how much the week actually holds: the known commitments (a meeting-heavy day, karate, standing blocks) against open time. Never written to.
- **Recent daily notes** (notes repo), the reasoning layer: commentary on why a milestone feels off, why a check-in is needed. Ambient context, not mapped task-by-task. Daily notes live at `9 - Resources/94 - Old activity notes/<YYYY>/<YYYY-Qn>/<YYYY-MM>/<YYYY-Www>/<YYYY-MM-DD-Weekday>.md`.
- **Jira**, only for progress detail on work milestones (subtasks, transition history).

## Creating tasks

The only Sunsama write is `create_task`, confirmed first, for a genuinely new commitment the week turns up (a check-in, a milestone-revision task, a follow-up). If it serves a milestone, name it `[PREFIX-n]: ...`. The skill never moves tasks into days, sets priorities, or timeboxes; it surfaces the week's shape and the user acts on it in Sunsama.

## The flow

The shape of a session, not a script. Keep the user's time reasonable; you can do deeper legwork as long as what you hand back stays digested.

### 1. Milestone check

Read `W/Milestones` and `P/Milestones` with their due dates, and the `milestones.md` for the projects in play, scoped to the milestones due soon and anything the miss watchlist flags. Start with the watchlist: read roughly the last two weeks of the daily log and note milestones carrying `miss [PREFIX-n]` markers; treat them as where to look harder, not a conclusion.

You can't pronounce a milestone on- or off-track; the user holds context you don't. What you can do is gather the signals that warrant a closer look and hand them back:

- **Sparse breakdown for the size and deadline:** a milestone due soon with few `[PREFIX-n]:` tasks or subtasks relative to its scope.
- **Stalled:** work that hasn't transitioned in a while (Jira, for work milestones).
- **Deadline pressure:** due this week or next; two milestones colliding in the same week.
- **Notes-silence:** a soon-due milestone the recent daily notes haven't touched.

Query Jira for progress detail on work milestones where it informs the call. Hand back a short digest pointing at the one or two worth attention, with the data behind each. The user makes the on-track call. If one is genuinely off, hand to `milestone-authoring`; never revise here. Record a confirmed slip as a `- miss [PREFIX-n]: <reason>` line in the daily log.

### 2. Shape the week

Against how much the week actually holds (the calendar) and the milestones that need to advance, help the user think through the week's goals, personal and professional together: what needs to move, what's realistic, what to hold. Surface the tradeoffs and options; the user writes the goals.

### 3. Capture anything genuinely new

If the conversation turns up a concrete new commitment that isn't in Sunsama, create it per **Creating tasks**, confirming first. Then the user works the week in Sunsama.
