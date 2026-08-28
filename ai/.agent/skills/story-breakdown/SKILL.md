---
name: story-breakdown
description: "Execution-time step: break one milestone into assignable stories for development, with technical detail but no acceptance criteria (product's). Reviews the live code (earlier milestones may have changed it) alongside the design artifacts. Produces a durable per-milestone breakdown doc and creates tickets in the tracker on request. Use when the user says 'break down this milestone', 'story breakdown', 'write the stories', 'break into tickets', or names a milestone to break down (e.g. 'PPX-3 breakdown'). Stories capped at ~7-8 days; split anything bigger."
user-invocable: true
---

# Story Breakdown

The execution-time step. Takes one milestone and breaks it into assignable stories for
development. It runs when the milestone is actually being worked, so it reviews the
current code, not just the design plan, since earlier milestones may already have changed
reality. The output is a self-contained `breakdown-PPX-n.md`, one per milestone, and it
can create the tickets in the tracker on request.

## Principles

- **Collaborative by default.** Run this with the user, not for them: surface findings
  and options, and pause at the judgment calls for the user to steer. The decisions stay
  the user's; don't drive to a finished artifact on your own.
- **Review the live code, not just the plan.** Reconcile the milestone's design against
  what's actually in the codebase now. Earlier milestones may have built some of it,
  changed adjacent code, or moved an interface; some planned work may already exist, some
  may need adjusting.
- **Stories, not acceptance criteria.** Give each story the technical detail a developer
  needs (endpoints, schema, components, dependencies); leave acceptance criteria to
  product.
- **Cap stories at ~7-8 days; split anything bigger.** Flag an oversize story rather than
  letting it hide work.
- **Cover the gaps.** Hunt for missing states (loading, error, empty, success), edge and
  error cases, integration points, and genuine unknowns that need a spike.
- **Sequence by dependency.** Backend before frontend, migrations before features, and so
  on; note the ordering.
- **Create tickets only on request.** The doc is the working surface; pushing stories to
  the tracker is a confirmed, on-request action.

## Inputs

- **The milestone**, from `milestones.md`: its goal, scope, estimate, risks, and
  dependencies.
- **The design artifacts** (`architecture.md`, `contracts.md`, `schema.md`) for the
  technical detail the stories carry.
- **The live code**, the target codebase, for current reality since earlier milestones may
  have changed it. Investigate with VectorCode plus reading.
- **The existing `breakdown-PPX-n.md`**, when revising; it also records which tickets are
  already created.
- **The user.**

## How it iterates

By refinement, not compete-and-cull: decompose, review against the code, fill the gaps,
and refine with the user. Create-or-revise.

## The artifact

One markdown file per milestone, `breakdown-PPX-n.md`, in the project's folder in the notes
repo (`~/Documents/sync`). Work projects live under `1 - Work/10 - Projects/<project>/`,
personal under `0 - Personal/01 - Projects/<project>/`. If the file already exists, read it
and update it in place rather than rebuilding.

Structure:

    # PPX-n breakdown: <milestone name>

    ## Context
    <the milestone's goal; what the live-code review found: already built, changed since the
    design, or still missing>

    ## <story title>
    - **What:** the work
    - **Technical detail:** endpoints / schema / components / dependencies, from the designs and code
    - **Depends on:** other stories
    - **Size:** rough (split if > ~7-8 days); mark a spike as a spike

    ## <story title>
    ...

    ## Sequencing
    <the order and dependency notes across the stories>

    ## Created tickets
    <tracker IDs once created, so re-runs update rather than duplicate>

## Creating tickets

Only on request, and confirmed first. Create each story as a ticket in the project's
tracker (Jira via `acli` at work, Sunsama for personal); the tracker and its specifics come
from the environment, not this skill. Record the created IDs in the Created tickets section
so a later run updates them instead of making duplicates. No acceptance criteria; product
adds those in the tracker.

## The flow

Not a script; the shape of the work, done with the user.

1. **Frame.** Read the milestone from `milestones.md` and the design artifacts. Identify the
   target codebase.
2. **Review reality.** Check the live code for what the milestone touches: what already
   exists, what changed since the design, what's still missing. Reconcile plan against
   reality.
3. **Decompose.** Break the milestone into stories capped at ~7-8 days, each with technical
   detail from the designs and the code. Split anything bigger; mark spikes for genuine
   unknowns.
4. **Cover gaps.** Missing states, edge and error cases, integration points, dependencies,
   and sequencing.
5. **Write.** Write or update `breakdown-PPX-n.md`.
6. **Create tickets on request.** Push the stories to the tracker and record the IDs.
