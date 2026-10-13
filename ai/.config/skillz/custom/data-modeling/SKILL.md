---
name: data-modeling
description: "Design or revise a relational (Postgres-first) data model: entities, relationships, normalization, integrity constraints, and indexes. Produces a durable schema doc (a Mermaid ER diagram plus rationale) as one file per project, create-or-revise. Use when the user says 'data model', 'design a schema', 'database schema', 'ER diagram', 'model the data', 'normalize this', or is planning how data is stored for a feature or project. Opinionated: normalize from the domain, encode integrity as constraints, index for real usage, avoid jsonb as a dumping ground."
user-invocable: true
---

# Data Modeling

Designs or revises a relational data model and captures it as a durable artifact: a
Mermaid ER diagram plus the reasoning behind it. Postgres-first; the principles carry
to any relational database. The output is a self-contained `schema.md` that stands on
its own as a complete, correct data-model document.

This is an **artifact producer**. The ER diagram is written with the
`mermaid-diagrams` skill; this skill does not carry its own diagram syntax.

## Principles

- **Collaborative by default.** Run this with the user, not for them: surface findings
  and options, and pause at the judgment calls for the user to steer. The decisions stay
  the user's; don't drive to a finished artifact on your own.
- **Normalize from the domain (aim for 3NF).** Model entities from their functional
  dependencies, what determines what. Denormalize later and deliberately, if at all.
- **Encode integrity in the database.** NOT NULL, foreign keys, unique, and check
  constraints make invalid states unrepresentable at the data layer, not just in app
  code. Prefer a schema that physically cannot hold bad data.
- **Index for real usage.** Index every foreign key, plus the columns real queries
  filter, join, or sort on; prefer composite indexes that match actual predicates in
  order. Every index carries write cost, so index for the queries you actually run.
  When usage isn't known yet, index the obvious (primary keys, foreign keys, uniques)
  and mark the rest pending.
- **Denormalize only with a written reason** tied to a specific hot read path.
- **Avoid jsonb as a dumping ground.** Prefer real columns and relations. Reach for
  jsonb only for genuinely dynamic, sparse, or rarely-queried data, and flag it when
  you do. Same posture toward EAV, catch-all key/value tables, and over-generic
  "flexible" designs.
- **Pick correct types.** `timestamptz` over `timestamp`, `numeric` for money, native
  enums or lookup tables over free-text status, a deliberate primary-key choice
  (`bigint` identity vs `uuid`).
- **Design for safe migration.** Prefer additive, backward-compatible changes. Call
  out any change that needs a backfill, an exclusive lock, or cross-service
  coordination.

## Conventions (defaults, override only with reason)

- **Timestamps on every table:** `created_at`, `updated_at`, `deleted_at`, all
  `timestamptz`. Deletes are soft (set `deleted_at`) unless there's a stated reason
  for a hard delete.
- **Naming:** plural, `snake_case` table names; `snake_case` columns.

## The candidate loop

The skill is ready to explore more than one candidate model, though a session may only
ever work one. The shape is flexible: refine a single model; or build one, refine it,
build another, then compare; or sketch several up front and cull. Do not force a shape.

- **Each candidate** is a model (entities, keys, relationships) plus a short note on
  its tradeoffs.
- **Compare, when more than one is live,** on four dimensions: fit to the domain,
  integrity, evolvability, and operational cost (query and migration).
- **Converge on one.** The culled candidates carry forward as the alternatives
  considered in the decisions and rationale.

## Inputs

- **The project's requirements and discovery artifact** (`requirements.md`): the domain
  entities and relationships, and the existing data the discovery surfaced (current tables,
  columns, what's reused vs built new). Design on top of it rather than re-investigating.
- **The design artifacts, when present** (`architecture.md` for which components own what
  data and the service boundaries; `contracts.md` for the payload shapes that imply stored
  data). The design producers can run in any order, so treat these as available-if-present.
- **The existing `schema.md`**, when revising.
- **Expected access patterns, from the user:** the real queries, hot read paths, write
  volume, and scale. Indexing and any denormalization key off these, and the artifacts
  don't capture them.

## The artifact

One markdown file per project, `schema.md`, in that project's folder in the notes
repo (`~/Documents/sync`). Work projects live under
`1 - Work/10 - Projects/<project>/`, personal under `0 - Personal/01 - Projects/<project>/`.
The folder name is the project. If `schema.md` already exists, read it and update it
in place rather than rebuilding.

Structure:

    # <Project> data model

    ## Entities
    <per entity: purpose, key attributes, primary key>

    ## ER diagram
    ```mermaid
    erDiagram
      ...
    ```

    ## Integrity constraints
    <notable NOT NULL / FK / unique / check decisions>

    ## Indexes
    - table(columns): the query or join it serves

    ## Decisions & rationale
    <denormalization and why, any jsonb use and why, type and key choices, open questions>

    ## Migration notes
    <backfills, locks, or coordination a change requires; omit if none>

## The flow

Not a script; the shape of the work. Keep it lean.

1. **Model the domain.** Entities, attributes, relationships, and functional
   dependencies. Normalize to 3NF. Add the standard timestamp columns to every table.
2. **Add integrity.** NOT NULL, foreign keys, unique, and check constraints so the
   schema can't hold invalid data; choose types deliberately.
3. **Index, and denormalize if warranted.** Index foreign keys and the columns real
   queries touch. When usage is unknown, index the obvious and mark the rest pending.
4. **Draw and write.** Render the ER diagram with `mermaid-diagrams`, capture the
   reasoning in the prose sections, and write or update `schema.md` in the project
   folder.
