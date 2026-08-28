---
name: milestone-authoring
description: "Turn a feature's requirements and design into an epic-level plan of action: the milestones, their sequencing, rough effort in hours, risk, and cut-candidates. Coarse decomposition, not tickets. Produces a durable milestones doc as one file per project, create-or-revise. Use when the user says 'author milestones', 'plan milestones', 'milestones for this project', 'break the work into milestones', or 'how should we sequence this'. Reads requirements and the design artifacts; does not write to Sunsama."
user-invocable: true
---

# Milestone Authoring

Turns a feature's requirements and design into an epic-level plan of action: the
milestones, how they sequence, roughly how much engineering each needs, how risky it
is, and what could be cut. This is coarse decomposition. Breaking a milestone into
assignable tickets is a separate skill, run later at development time.

The output is a self-contained `milestones.md`. This skill **manages** the milestone
numbering on the user's behalf and never writes to Sunsama; the user creates the
Sunsama milestone entries when ready, optionally with help.

## Principles

- **Collaborative by default.** Run this with the user, not for them: surface findings
  and options, and pause at the judgment calls for the user to steer. The decisions stay
  the user's; don't drive to a finished artifact on your own.
- **Coarse, not tickets.** Milestones are epic-level goals, not assignable work items.
  Enough to sequence, estimate, and decide scope against; no more.
- **Slice by user outcome; foundational work is just-in-time.** An **outcome** milestone
  delivers a user-facing capability and is a cuttable unit. A **foundational** milestone
  is groundwork (data model, shared infra, refactors), placed just before the capability
  that needs it, not batched up front. Only truly-universal groundwork sequences first.
- **Estimate in hours with a risk band, not points.** See Estimation.
- **Cut-candidates key off the user outcome.** Flag what could be deferred without
  breaking the user outcome. A foundational milestone inherits cuttability from what it
  unblocks, so cuts cascade down the dependency chain.
- **No dates; propose bandwidth.** The skill proposes engineering effort. Dates are the
  user's, they hold the calendar and the external deadlines.
- **Manage the numbering, don't own it.** Maintain the key scheme as a convenience; the
  user can create or override keys by hand.

## How it iterates

By refinement, not compete-and-cull: propose a grouping and sequencing, then refine it
with the user. Milestone boundaries are a judgment call, so this is a conversation, not
a one-shot.

## Inputs

- **`requirements.md`** (the moving pieces, the user outcome, the early risks) and the
  **design artifacts** (`architecture.md`, `contracts.md`, `schema.md`) for what the work
  is and how complex it is.
- **The existing `milestones.md`**, when revising; it is also the numbering registry.
- **The user**, for the boundary judgment and the base-hours estimates.

## Estimation

Hours with a risk-scaled band, computed by formula so there's no false precision:

- **likely** = the base hours agreed with the user.
- **best** = likely × (1 − x); **worst** = likely × (1 + 2x). The 2x encodes the fact
  that engineering runs over more often than it runs early.
- **risk sets x** (tunable): low 10%, medium 20%, high 40%.
- **round each result by size:** 10h or less to the nearest 1; 10 to 40h to the nearest
  5; over 40h to the nearest 10.
- A genuinely unknowable item gets **"spike needed to estimate"** instead of a made-up
  base, which ties back to the early-risk unknowns.

The sum of the likely estimates across milestones is the project's engineering-bandwidth
figure for the leadership conversation.

## Milestone keys

- Each milestone is keyed **`PREFIX-n`**: a per-project prefix (proposed from the project
  name, confirmed with the user once) plus an incrementing number.
- The skill reads `milestones.md` for the highest number and assigns the next; the user
  can override.
- The type shows in the entry title as **`(O)`** (outcome) or **`(F)`** (foundational).
- When the user later sets up Sunsama, tasks serving a milestone are named
  `[PREFIX-n]: ...`, and the shared prefix groups a project's milestones together.

## The artifact

One markdown file per project, `milestones.md`, in that project's folder in the notes
repo (`~/Documents/sync`). Work projects live under `1 - Work/10 - Projects/<project>/`,
personal under `0 - Personal/01 - Projects/<project>/`. The folder name is the project.
If `milestones.md` already exists, read it and update it in place rather than rebuilding.

Structure:

    # <Project> milestones

    ## PREFIX-n (O): <name>
    - **Goal:** what this delivers (a user capability, or the groundwork it unblocks)
    - **Scope:** a few lines on the shape of the work, enough to grasp it, not tickets
    - **Estimate:** best / likely / worst h   (risk: low | med | high)
    - **Key risks / unknowns:** what's behind the risk level (delicate area, unknown, spike-needed)
    - **Cut candidate:** yes/no + why
    - **Depends on:** PREFIX-m, ...
    - **Covers:** requirements moving-pieces / design areas

## The flow

Not a script; the shape of the work, done with the user.

1. **Frame.** Read `requirements.md` and the design artifacts. Establish or confirm the
   project prefix.
2. **Decompose.** Propose the milestone grouping: outcome slices for user capabilities,
   foundational milestones for groundwork placed just before the capability that needs it,
   sequenced by dependency. Refine it with the user.
3. **Size and risk.** For each milestone, agree a base-hours likely with the user, set the
   risk level, and compute best/worst via the formula.
4. **Flag cut-candidates.** Which outcome milestones could defer without breaking the user
   outcome, cascading to the foundational work they unblock.
5. **Write.** Assign the `PREFIX-n` keys and write or update `milestones.md`. Never touch
   Sunsama.
