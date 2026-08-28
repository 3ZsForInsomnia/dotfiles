---
name: api-design
description: "Design or revise the interfaces between components and services (REST, RPC, events, webhooks): resources and operations, payload shapes, HTTP semantics, error behavior, and evolvability. Explores one or more candidate contract shapes and converges on one. Produces a durable contracts doc as one file per project, create-or-revise. Use when the user says 'API design', 'design the API', 'contract design', 'endpoint design', 'service interface', 'REST or RPC', or 'payload shape'. Owns interfaces and payloads; hands system structure to architecture and data storage to data-model."
user-invocable: true
---

# API and Contract Design

Designs the interfaces between components and services and captures them as a durable
artifact: the contracts, their payloads, their failure behavior, and the reasoning
behind them. Covers REST, RPC, events, and webhooks. The output is a self-contained
`contracts.md` that stands on its own as a complete, correct set of interface
definitions.

This is an **artifact producer**. Any interaction diagrams (sequence flows) are
written with the `mermaid-diagrams` skill; this skill does not carry its own syntax.

## Principles

- **Collaborative by default.** Run this with the user, not for them: surface findings
  and options, and pause at the judgment calls for the user to steer. The decisions stay
  the user's; don't drive to a finished artifact on your own.
- **Ask before you design.** Get the existing architecture, the data relationships,
  the consumers, and the constraints before proposing an interface.
- **Resource-oriented and normalized.** Design clean resource and operation
  interfaces with consistent resource shapes and no duplication across endpoints.
  Avoid bucket endpoints that return everything a screen happens to need.
- **Correct REST semantics.** The right HTTP method and status for each operation:
  GET reads, POST creates, PUT fully replaces, PATCH partially updates, DELETE
  removes. Be explicit about collection and array behavior (PUT replaces the whole
  collection, PATCH merges) and say which. Use query params for filtering,
  pagination, and sorting.
- **Idempotency by default.** Make operations safely retryable: PUT and DELETE
  idempotent, an idempotency key for a POST where a retry could double-write.
- **Choose the mechanism per interface.** REST for client-to-server, RPC for
  server-to-server, as defaults; events or webhooks where a push or decoupled flow
  fits. The set is open (GraphQL or others) when the consumer's needs call for it,
  chosen deliberately. Decide sync vs async per operation (return now vs job or
  callback) and make it explicit.
- **Define the failure shape, not just the happy path.** Error responses and
  behavior, auth and authorization, and edge and error states are part of the
  contract, not an afterthought.
- **Design the payload from the consumer in.** Consider the types it forces, client
  generation, and what the consumer actually needs. Keep the model consistent across
  every interface that exposes it.
- **Design for change.** Ask how the interface will evolve and what makes it cheap to
  extend. Favor clarity and evolvability over cleverness; push back on a shape that is
  convenient now but will calcify or leak.
- **Own interfaces, hand off structure and storage.** Interface and payload design
  here; system structure hands off to `architecture-design`, table design to
  `data-modeling`. Never design components or tables here.

## The candidate loop

The skill is ready to explore more than one candidate contract shape, though a
session may only ever work one. The shape is flexible: refine a single candidate; or
build one, refine it, build another, then compare; or sketch several up front and
cull. Do not force a shape.

- **Each candidate** is an interface or payload shape plus a short description of its
  tradeoffs, for the consumer and for evolution.
- **Compare, when more than one is live,** on four dimensions: fit to the consumer's
  needs, clarity, evolvability, and consistency with the rest of the model.
- **Converge on one.** The culled candidates carry forward as the alternatives
  considered in the decision record.

## Inputs

- The project's requirements and discovery artifact, and its `architecture.md`: the
  components and boundaries that need interfaces, plus the consumers and constraints.
- The existing `contracts.md`, when revising.

## The artifact

One markdown file per project, `contracts.md`, in that project's folder in the notes
repo (`~/Documents/sync`). Work projects live under
`1 - Work/10 - Projects/<project>/`; a project elsewhere writes to its own folder.
The folder name is the project. If `contracts.md` already exists, read it and update
it in place rather than rebuilding.

Structure:

    # <Project> contracts

    ## Overview
    <the set of interfaces: each with mechanism, direction, consumer, sync/async>

    ## <Interface name>
    - operations: method + resource/path (REST), service.method (RPC), or event name
    - request / response payload shapes (fields and types)
    - errors: failure responses and behavior
    - cross-cutting: auth, pagination/filtering, idempotency where relevant

    ## Key decisions
    <mechanism choices, REST/normalization decisions, alternatives considered and why not>

    ## Handoffs
    <data shapes this implies (to data-modeling); structure it implies (to architecture-design)>

## The flow

Not a script; the shape of the work. Keep it lean.

1. **Frame.** Read the requirements, discovery, and architecture artifacts; pull the
   interfaces the design needs, their consumers, and the constraints. Ask for any that
   are missing.
2. **Explore candidates.** Propose one or more contract shapes per interface, describe
   each one's tradeoffs, and diagram an interaction flow with `mermaid-diagrams` where
   it clarifies.
3. **Compare and converge.** Weigh the live candidates on consumer fit, clarity,
   evolvability, and consistency; converge on one; keep the rest as alternatives.
4. **Define the whole contract.** For the chosen shape, pin the methods and statuses,
   payloads, error behavior, and the cross-cutting concerns (auth, pagination,
   idempotency, sync vs async).
5. **Hand off.** Note the data shapes and structure the design implies, pointing to
   the data-model and architecture skills.
6. **Write.** Write or update `contracts.md` in the project folder.
