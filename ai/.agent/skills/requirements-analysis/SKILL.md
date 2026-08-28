---
name: requirements-analysis
description: "The first step in planning a feature: understand what's being built, discover the code reality it touches, and flag early risk. Adapts to input maturity: pressure-test a comprehensive PRD (depth-first), shape a vague idea, or understand an existing project to extend. Produces a durable requirements doc as one file per project, create-or-revise. Use when the user says 'requirements', 'analyze this PRD', 'pressure-test the PRD', 'what does this feature need', 'start a new feature', or is figuring out what a piece of work involves. Scope-neutral: captures what the input says, does not decide what is in or out."
user-invocable: true
---

# Requirements Analysis

The first step in the feature pipeline. Understands what is being built, discovers the
existing code it would reuse or touch, and flags early risk. It adapts to whatever it
is handed: a comprehensive PRD to pressure-test, a vague idea to shape, or an existing
project to understand and extend. The output is a self-contained `requirements.md`.

It is deliberately high-level and quick. It makes the user informed enough to give a
better-than-vibes answer to whoever asked; the deep design work comes later. It is not
a business report.

## Principles

- **Collaborative by default.** Run this with the user, not for them: surface findings
  and options, and pause at the judgment calls for the user to steer. The decisions stay
  the user's; don't drive to a finished artifact on your own.
- **Understand first; everything downstream reads this.** Get the problem, the why, and
  the user outcome right before anything else.
- **Anchor on the user outcome.** What must exist for the user to accomplish their task
  is the yardstick for essential vs stretch. During investigation and conversation,
  probe "is this actually necessary for the user to do X," and surface what that turns
  up. Surface it; do not decide it.
- **Scope-neutral.** Capture what the input says, including what the PRD itself marks
  out-of-scope or leaves unfinished. Never decide what is in or out, or what should be
  deferred. That is a later, business call.
- **Discovery is about building blocks, not just "does X exist."** Find what already
  exists that could be reused or extended, what would be touched, and what must be built,
  and how delicate each is. The categories and the reuse/build framings below are
  starting points to prompt the search, not a fixed taxonomy to force findings into.
- **Stay high-level and quick.** Better than vibes, not a design. Deep investigation is
  the design step's job.
- **Ask, don't assume.** A few focused questions per round, building on the answers, plus
  the Why (is this needed) and Simpler (is there a smaller shape) checks against
  over-scoping.
- **Risk here is provisional.** Flag and rough-size it; it firms up once the design
  exists.

## Inputs

- **Whatever describes the feature, at whatever maturity:** a PRD (Confluence) and a
  Figma design (via the Figma MCP when present, or pasted images), a rough idea, or an
  existing project to extend. Ask for what is missing rather than guessing.
- **The target codebase for discovery** (work is `platform`; a personal repo otherwise).
  Take it from context or ask; investigate with VectorCode plus reading.
- **Any scope the user already knows** (PRD-marked exclusions, unfinished parts) as input.

## How it iterates

Not the design producers' candidate loop. This iterates by depth-first refinement:
decompose the input, dive into each piece, pressure-test it, and go deeper where it is
unclear or risky. Refinement rounds, not competing alternatives to cull.

## The artifact

One markdown file per project, `requirements.md`, in that project's folder in the notes
repo (`~/Documents/sync`). Work projects live under `1 - Work/10 - Projects/<project>/`,
personal under `0 - Personal/01 - Projects/<project>/`. The folder name is the project.
If `requirements.md` already exists, read it and update it in place rather than
rebuilding.

Structure:

    # <Feature> requirements

    ## Problem & user outcome
    <a basic summary of the project, the problem and why, and what the user must be able
    to accomplish. The emphasized section: the yardstick for essential vs stretch.>

    ## Moving pieces
    <the chunks of work the feature breaks into>

    ## Excluded / deferred
    <what the PRD marks out-of-scope or leaves unfinished; input only, not a decision;
    omit for personal>

    ## Constraints & quality attributes
    <the known product/business constraints; technical constraints surface in the designs>

    ## Success
    <the business-level outcome that means this worked>

    ## Discovery
    <existing code relevant to this: in-house libraries, data columns, FE components,
    services, existing implementations, shared utilities, and whatever else applies. For
    each, note how it relates (reuse, extend, touch, build new alongside it, leave alone)
    and how delicate it is. These categories are a starting point, not a fixed set.>

    ## Early risks
    <what is hard, delicate, or uncertain; a rough size each; whether it is
    architectable-around; known unknowns and likely unknown-unknowns>

    ## Open questions
    <gaps, ambiguities, and contradictions in the input, for product>

## The flow

Not a script; the shape of the work, kept high-level.

1. **Frame.** Read the input and detect its maturity (PRD, idea, or existing project).
   Ask for what is missing: the Figma design, the codebase to investigate, any scope the
   user already knows.
2. **Understand.** Establish the summary, the problem, and the user outcome. For a PRD,
   decompose it depth-first and pressure-test each piece for gaps, ambiguities, and
   contradictions (which become Open questions), probing whether each part is necessary
   for the user outcome. For an idea, shape it with the user via the Why and Simpler
   checks. For an existing project, understand the current thing and the addition.
3. **Discover.** Investigate the target codebase for existing code relevant to this and
   what it touches, surfacing findings for the user to confirm and add the history and
   delicacy the code cannot show.
4. **Flag early risk.** Where it is hard, delicate, or uncertain, with a rough size and
   whether it can be architected around.
5. **Capture the rest.** Moving pieces, first-pass constraints, success, and the
   excluded/deferred parts drawn from the input.
6. **Write.** Write or update `requirements.md` in the project folder.
