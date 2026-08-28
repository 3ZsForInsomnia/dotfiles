---
name: project-navigator
description: "The entry point to feature planning. Sets up the project folder, reports which planning artifacts are present, missing, or stale, suggests the available next steps, and hands off to a single producer on request. Idempotent and re-entrant: run it, do a few steps, come back and it tells you where you are. Use when the user says 'let's get started', 'start this project', 'project kickoff', 'what's next for this project', or 'where are we on this'. It never runs producers on its own."
user-invocable: true
---

# Project Navigator

The entry point to feature planning. You arrive with raw inputs (epics, Confluence,
Figma) and a sense of what the project needs; it sets up the project folder, reports
which artifacts are present or missing, asks what's still current, suggests the sensible
next steps, and hands off to a single producer when you pick one. Re-entrant: run it, do a
few steps, come back, and it re-reads and tells you where you are.

## Principles

- **Collaborative by default.** Run this with the user, not for them: surface findings
  and options, and pause at the judgment calls for the user to steer. The decisions stay
  the user's; don't drive to a finished artifact on your own.
- **Report and suggest, don't prescribe.** Surface the available next steps given what's
  present and missing, not one mandated path. There is no required order and no required
  set; the user picks.
- **Dispatch one, consented.** Hand off to a single producer at a time, on the user's
  pick. Never chain into the next automatically.
- **Stateless and re-entrant.** Every run just re-reads the project folder and reports; it
  tracks no run of its own.
- **Read, don't run, to assess.** Inspect the artifacts on disk; don't invoke producers to
  work out the status.

## The project folder

One folder per project in the notes repo. Work projects live at
`1 - Work/10 - Projects/<project>/`, personal at `0 - Personal/01 - Projects/<project>/`.
It holds the artifacts: `requirements.md`, `architecture.md`, `contracts.md`, `schema.md`,
`milestones.md`, `plan.md`, and any `breakdown-PPX-n.md`. If starting fresh, create the
folder, confirming the project name and key prefix with the user first.

## The pipeline it knows

For suggesting next steps: **requirements** (`requirements-analysis`), then **design**
(`architecture-design`, `api-design`, `data-modeling`, any subset), then **milestones**
(`milestone-authoring`), then the **plan** (`plan-report`). Separately, **story-breakdown**
runs per-milestone at development time. Every step is skippable and re-runnable.

## The flow

1. **Locate or create the project folder.** Confirm the name and key prefix if it's new.
2. **Read what's present.** Which artifacts exist and which are missing. Staleness isn't
   detectable from the filesystem, so ask the user what's still current rather than
   guessing.
3. **Report and suggest.** State where the project stands, then offer the available next
   steps, what could sensibly run now given what's present and missing. Note dependencies
   as guidance, not gates (contracts usually follow architecture, but nothing forces it).
4. **Dispatch one.** On the user's pick, hand off to that single producer. Don't chain
   into anything after it.
5. **Re-run anytime** to reassess; there's no state to resume, it just re-reads.
