---
applyTo: "**"
description: "Universal coding rules that apply to all languages and projects"
---

# All Code

## Philosophy

- Prefer functional programming: small composable functions, pipelines, immutability, data transformations. Reach for OOP only when the domain genuinely calls for it.
- Explicit over implicit.
- Code should read like English. Use descriptive names, named conditions, and named helper functions. Extract multi-part conditionals into named booleans — a reader should understand intent without mentally evaluating subexpressions.
- Functions under 20 lines; max 3 levels of nesting; use early returns to reduce nesting.
- Reuse existing code. Check what exists in the project before writing something new.
- Write code that's easy to delete. New functionality should be isolated enough to remove without cascading changes.
- Prefer well-known design patterns when they fit — strategy over growing switch statements, dependency injection for testability, declarative over stateful and imperative. Don't force patterns where they don't belong.

## Types

Prefer narrow, specific types. Types should encode what is actually possible at a given point in the program — avoid optionality and union with null/undefined/nil when the data is known to exist. Make invalid states unrepresentable.

## Values and Errors

- Validate all external inputs at system boundaries. Everything past the entry point can be trusted.
- Don't swallow errors silently — rethrow, surface to the user, or log. Silence is never acceptable.
- Use structured logging. Never include sensitive data, PII, or secrets in log output.

## Code Style

- Extract values to named constants when they are non-obvious or appear more than once. A bare `7` with no context is a magic number; `0` in an array index is not.
- Suppressions (eslint-disable, @ts-expect-error, nolint, etc.) require a comment explaining why, and are a last resort — not a shortcut for bad types or a workaround for a fixable issue.

## Testing

- Test from the user's perspective. Don't assert on internal state, props, or implementation details.
- Test files must be self-contained. Don't import constants, types, or enums from production code — use literals or local definitions instead.
- Never skip, delete, or comment out tests to make a suite pass.
- Never modify assertions to match wrong output.
- Never weaken mocks or broaden test setup to fix a failing test without understanding the failure.
- Extract reusable test helpers — setup, fixtures, mock factories, assertion helpers — as soon as a second test would benefit. Bias toward extraction, not speculation.
- Write coverage as you write code. Don't run coverage tooling retroactively to chase a number.

## Git and PRs

- Use Conventional Commits when committing: `type(scope): description`. Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.
- PR descriptions must be complete. Delete sections that don't apply rather than writing "N/A".
