---
name: plan-report
description: "The last planning step: synthesize a project's requirements, designs, and milestones into one plan for eng leadership, product, and business to decide scope, with scope pushback built in. Keeps the technical milestones visible; adds the why, the scope and cut-candidates, the risks in business terms, and the engineering-bandwidth ask. Produces a durable plan doc as one file per project, create-or-revise. Use when the user says 'plan report', 'project plan', 'plan for leadership', 'pull it together for product', or 'what do we tell the higher-ups'. Work-only in use; it prepares the scope decision, it does not make it."
user-invocable: true
---

# Plan / Report

The last planning step. Synthesizes the project's artifacts (requirements, the designs,
and milestones) into one plan for eng leadership, product, and business to decide scope.
It keeps the technical milestones visible and adds the layer that makes it a decision
doc: the why, the scope and cut-candidates, the risks in business terms, and the
engineering-bandwidth ask.

The output is a self-contained `plan.md`. It is work-only in use, since personal projects
have no business deciders.

## Principles

- **Collaborative by default.** Run this with the user, not for them: surface findings
  and options, and pause at the judgment calls for the user to steer. The decisions stay
  the user's; don't drive to a finished artifact on your own.
- **Synthesize, don't re-derive.** Read the existing artifacts and pull them together;
  don't redo the design or re-investigate the code. If an artifact is missing (or the user
  flags one as stale), say so and decide with the user whether to run its producer first.
- **Check coverage.** Confirm every requirement and moving-piece is addressed by at least
  one milestone, sanely; flag any gap. It's the last chance to catch a requirement no
  milestone covers.
- **Keep the technical milestones visible.** Organize for readability (shared groundwork,
  then capabilities), but show the actual milestones, so both technical and non-technical
  readers grasp the structure and see where the risk sits. The organization is the
  explanation.
- **Prepare the scope decision; don't make it.** Surface each capability's cost, risk, and
  whether it is necessary for the user outcome, as the material for product and business to
  decide and for the user to push back on. Scope is their call.
- **Translate risk into business impact.** "This is risky" becomes "if X is wrong, it
  costs Y or delays Z."
- **Bandwidth, not dates.** Sum the milestone effort into the engineering ask; dates stay
  the user's.

## Inputs

- **The project's artifacts:** `requirements.md`, the designs (`architecture.md`,
  `contracts.md`, `schema.md`), and `milestones.md`, which is the spine: the milestones,
  estimates, risks, cut-candidates, and the dependency graph.
- **The existing `plan.md`**, when revising.

Shared vs capability-specific grouping is read straight off the milestone dependency graph:
a `(F)` milestone that 2+ `(O)` milestones depend on is shared groundwork; a `(F)` milestone
only one `(O)` depends on belongs to that capability.

## How it iterates

By refinement: assemble a draft, then work the framing and the scope pushback with the
user until it says what they need it to say. Create-or-revise.

## The artifact

One markdown file per project, `plan.md`, in that project's folder in the notes repo
(`~/Documents/sync`). Work projects live under `1 - Work/10 - Projects/<project>/`. The
folder name is the project. If `plan.md` already exists, read it and update it in place
rather than rebuilding.

Structure:

    # <Project> plan

    ## Summary
    <what and why in plain terms, from the requirements' problem and user outcome, plus the
    organizing logic so readers grasp the structure>

    ## Shared groundwork
    <foundational milestones 2+ capabilities depend on; done first, then the dependents
    parallelize. each: PPX-n (F), what it unblocks, effort, risk>

    ## The plan
    <capabilities, sequenced. each is its outcome milestone plus the foundational work only
    it needs, milestones kept visible with their PPX-n keys, effort, and risk. what each
    delivers toward the user outcome>

    ## Scope & cut-candidates
    <per capability: essential vs deferrable, with cost and risk. shared groundwork recovers
    its cost only if all its dependents are cut. the material for the scope conversation and
    the user's pushback>

    ## Risks
    <the key risks in business-impact terms: what it means for cost, timeline, or the outcome
    if each goes wrong>

    ## Bandwidth
    <total engineering effort (sum of the likely estimates) with the best/worst spread. the
    ask; no dates>

    ## Decisions needed
    <what product and business must decide: scope cuts, priorities, the open questions from
    requirements>

## The flow

Not a script; the shape of the work, done with the user.

1. **Gather.** Read `requirements.md`, the designs, and `milestones.md`. If a needed
   artifact is missing (or the user says one is stale), flag it and decide with the user
   whether to run its producer first.
2. **Group.** From the milestone dependency graph, separate shared groundwork (foundational,
   2+ dependents) from the capability groups (each outcome milestone plus its own
   foundational work).
3. **Frame.** Write the summary (what, why, and the organizing logic) and translate the
   milestones' risks into business impact.
4. **Scope.** For each capability, lay out cost, risk, and necessity to the user outcome,
   and mark the cut-candidates. Work the pushback with the user; don't decide scope.
5. **Bandwidth.** Sum the effort into the ask.
6. **Write.** Write or update `plan.md`.
