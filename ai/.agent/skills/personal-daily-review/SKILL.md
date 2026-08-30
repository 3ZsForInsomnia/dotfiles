---
name: personal-daily-review
description: "Evening personal reflection. Reviews the day as a whole against the morning's intention (the mountain), checks whether the day's tracked habits and health happened, records them into the weekly table, and helps kickstart journaling. Personal only, separate from the work daily review, though it takes how the work day went as context. Use when the user says 'personal review', 'evening review', 'reflect on my day', 'how was my day', or 'help me journal'. The reflection and the decisions stay the user's."
user-invocable: true
---

# Personal Daily Review

The evening personal reflection. It reviews the day as a whole against the morning's
intention (the mountain), checks whether the day's tracked habits and health actually
happened, and helps get the user's journaling started. Personal only, and separate from
the work `daily-review`, though it takes how the work day went as ambient context for the
whole-day view.

## Principles

- **Prompt the reflection; the user writes it.** Some of the evening journaling is just
  the user's own time. This skill helps get it started and asks good questions; it does not
  write the reflection for them.
- **Personal only.** The work day is ambient context for the whole-day view; this skill
  reviews the personal day.
- **Honest accountability, and help to do better.** When the user is avoiding or making
  excuses, name it and push them to follow through. But it's not only naming misses: help
  them work out *how* to do better, what got in the way, and what small change would make
  tomorrow easier.
- **Read the habit list from the template, not from memory.** The tracked habits and
  metrics live in the weekly note's tracking table; use whatever is there. Don't assume a
  fixed list, it changes over time.
- **Capture fresh.** Record the day's habit and health data now, while it's accurate, so
  the weekly pattern-finding isn't reconstructed from week-old memory.

## Inputs

- **Today's daily note**, including the **mountain** (intention, gratitudes,
  anticipations, emotions, and other thoughts) set that morning.
- **The day's habit and health data**: activities done, and metrics like sleep score,
  steps, and water (from Samsung Health), as the user has logged or provides them.
- **The weekly note's tracking table** for the list of tracked habits/metrics and where
  the day's row goes. Weekly notes live at
  `9 - Resources/94 - Old activity notes/<YYYY>/<YYYY-Qn>/<YYYY-MM>/<YYYY-Www>/<YYYY-Www>.md`.
- **Recent daily notes** for context.
- **How the work day went**, as ambient context (from the user).

## Writes

The weekly habit table is the only thing the skill writes: fill today's row from the day's
habit and health data, or prompt the user to if they'd rather. The reflection itself is
the user's, in their own note; the skill helps start it but does not write it.

## The flow

Not a script; the shape of the evening, kept light and reflective.

1. **Read in.** Today's daily note (the mountain and the day's data) and the weekly
   tracking table (for the current habit and metric list). Note it if the mountain wasn't
   filled; it should have been set that morning.
2. **Intention.** Review whether the day's intention held: did the day go the way the
   morning meant it to, and if not, what pulled it off course.
3. **Habits and health.** Walk the tracked habits and metrics, record today's row in the
   weekly table, and flag misses honestly. When something was missed, work out with the
   user how to make it more likely tomorrow, not just note that it didn't happen.
4. **The day as a whole.** Ask about the day beyond the checklist: what stood out, what
   went well, where the user dodged something they meant to do. Push, but constructively.
5. **Kickstart the journaling.** Offer a reflection question and help the user get their
   evening writing started, then leave the rest to them.
