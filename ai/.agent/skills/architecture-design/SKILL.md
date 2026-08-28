---
name: architecture-design
description: "Design or revise the architecture of a feature or change at the container and component level, within an existing system. Explores one or more candidate approaches, diagrams them, and converges on one, capturing the decision and the rejected alternatives. Produces a durable architecture doc (Mermaid diagrams plus reasoning) as one file per project, create-or-revise. Use when the user says 'design the architecture', 'how should this be structured', 'architect this', 'component design', 'service design', or is planning the shape of a feature before building it. Owns structure and decisions; hands interface and data detail to the contracts and data-model skills."
user-invocable: true
---

# Architecture Design

Designs the shape of a feature or change and captures it as a durable artifact:
container and component diagrams plus the reasoning behind them. This is forward
design, not documentation of existing code. The output is a self-contained
`architecture.md` that stands on its own as a complete, correct design.

This is an **artifact producer**. Diagrams are written with the `mermaid-diagrams`
skill (C4 container and component, and sequence for a flow); this skill does not
carry its own diagram syntax.

## Principles

- **Collaborative by default.** Run this with the user, not for them: surface findings
  and options, and pause at the judgment calls for the user to steer. The decisions stay
  the user's; don't drive to a finished artifact on your own.
- **Design within the existing system, at the container and component level.** Work
  on top of what already exists. The system level above is for the rare change that
  stands up a new service; the code level below is finer than this artifact needs.
  Deployment and dynamic views are available when a change genuinely calls for one,
  not by default.
- **Ask before you design.** Get the constraints and the quality attributes that
  actually drive this piece, scale, latency, consistency, security and compliance,
  team boundaries, before proposing structure.
- **Pick mechanisms and patterns deliberately, and record what you rejected.** Name
  the communication mechanism (synchronous call, event, queue, webhook) and the
  pattern, say why it fits, and keep the approaches you ruled out. The rejected
  candidates are the decision rationale.
- **Stop at the altitude that guides implementation and supports an estimate.**
  Container and component structure, mechanisms, and key decisions. Not an exhaustive
  low-level design.
- **Own structure, hand off detail.** When the design implies an interface, name it
  and hand off to the contracts skill; when it implies data, hand off to
  `data-modeling`. Never design contracts or tables here.

## The candidate loop

The skill is ready to explore more than one candidate architecture, though a session
may only ever work one. The shape is flexible: refine a single candidate; or build
one, refine it, build another, then compare; or sketch several up front and cull. Do
not force a shape.

- **Each candidate** is a container or component diagram plus a short description of
  its mechanisms and its tradeoffs.
- **Compare, when more than one is live,** on four dimensions: fit to constraints,
  complexity, evolvability, and risk or cost of change.
- **Converge on one.** The culled candidates carry forward as the alternatives
  considered in the decision record.

## Inputs

- The project's requirements and discovery artifact: the what and why, the
  constraints, and what already exists. Design on top of it rather than
  re-investigating the codebase.
- The existing `architecture.md`, when revising.

## The artifact

One markdown file per project, `architecture.md`, in that project's folder in the
notes repo (`~/Documents/sync`). Work projects live under
`1 - Work/10 - Projects/<project>/`; a project elsewhere writes to its own folder.
The folder name is the project. If `architecture.md` already exists, read it and
update it in place rather than rebuilding.

Structure:

    # <Project> architecture

    ## Context and constraints
    <the quality attributes that actually drive this piece>

    ## Approach
    <container and component diagrams (via mermaid-diagrams); prose on mechanisms and patterns>

    ## Key decisions
    <each: the decision, why it fits, the alternatives considered and why not>

    ## Data flow
    <optional: a sequence or dynamic diagram for a complex flow>

    ## Risks and open questions

    ## Handoffs
    <interfaces this implies (to the contracts skill); data this implies (to data-modeling)>

## The flow

Not a script; the shape of the work. Keep it lean.

1. **Frame.** Read the requirements and discovery artifact; pull the constraints and
   the quality attributes that drive this piece. Ask for any that are missing.
2. **Explore candidates.** Propose one or more approaches at the container and
   component level, diagram each with `mermaid-diagrams`, and describe each one's
   mechanisms and tradeoffs.
3. **Compare and converge.** Weigh the live candidates on fit, complexity,
   evolvability, and risk; converge on one; keep the rest as alternatives considered.
4. **Record decisions.** Capture the chosen approach, the key decisions with their
   rejected alternatives, and the risks and open questions.
5. **Hand off.** Note the interfaces and data the design implies, pointing to the
   contracts and data-model skills.
6. **Write.** Write or update `architecture.md` in the project folder.
