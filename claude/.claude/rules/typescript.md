---
applyTo: "**/*.{ts,tsx,js,jsx}"
description: "TypeScript and React rules covering types, patterns, and testing"
---

# TypeScript and React

## Types

- Never use `any`. If the type system is fighting you, the design is wrong — fix the design.
- Avoid `unknown` unless the shape genuinely cannot be known at compile time (e.g., a catch clause, a deserialization boundary). Narrow it if you can.
- Prefer narrow, specific types that make invalid states unrepresentable. A value that will always be present should not be optional. A string that can only be one of three values should be a union of those literals, not `string`.
- Create named type aliases even for simple types when the name conveys domain meaning. `type UserId = string` is better than a bare `string` when it distinguishes an identifier from any other string.
- Use discriminated unions for variant data. Prefer `{ kind: 'loading' } | { kind: 'ready'; data: T }` over `{ loading: boolean; data: T | null }`.
- Avoid `as` type assertions — prefer type guards, `satisfies`, or narrowing. Use `as` only when you know something the compiler cannot prove; leave a comment explaining why.

## Values and Nullability

- Validate and narrow at the boundary (API response, component prop entry point), then pass guaranteed non-optional values downstream. Inner code should not have to handle absence.
- Throw early when required data is missing. The first function that needs a value should fail loudly rather than passing `undefined` deeper.
- Use Zod at external boundaries (API responses, env vars, form inputs) for schema validation and type narrowing. Use `assert` functions for internal invariants where Zod would be overhead. Don't use both for the same layer — Zod at a boundary makes downstream assertions redundant.
- Use optional chaining for genuinely optional data. Don't use `?.` as control flow for values that should be present — strong types should eliminate most need for it.

## Functions and Control Flow

- Prefer small, named, pure arrow functions. Use concise body (`const format = (x: T) => x.name`) when it fits on one line.
- Prefer array methods (`map`, `filter`, `reduce`, `find`, `some`, `every`, `flatMap`) over `for` loops.
- Extract complex or multi-part conditions into named booleans that describe what is being checked. `if (isExpired || isOverLimit)` is better than evaluating the expressions inline.
- When a set of known cases maps to outcomes, prefer an object map of handlers over `if`/`switch` chains.
- Prefer `async/await` over `.then()` chains. Never mix the two in the same function. Callbacks are fine in their natural context (event listeners, stream handlers, etc.).

## React

- One exported component per file. Colocate hooks and helpers only if they are single-use for that component.
- Do not use `useEffect` for derived state. Compute inline or use `useMemo`.
- Prefer controlled components. Do not use refs for form state.
- Do not accept optional parameters for values known to exist. Assert at the call site rather than propagating optionality inward.
- Wrap component subtrees in `ErrorBoundary` anywhere a failure should be isolated — cards, panels, data-dependent sections, dialogs. Not just at the page level.
- Avoid `Record<string, unknown>` as a stand-in for a real interface. Define the shape.
- Avoid `useEffect` as an event handler or to sync state that can be computed.
- Avoid deep relative imports (`../../../`). If you find yourself writing them, that's a signal of missing structure.

## Testing

Unit tests cover pure functions, hooks in isolation, and single components without providers. Integration tests render a component tree with real providers (router, query client, theme) and exercise user flows.

- Do not mock state management, user interactions, or third-party components the component under test relies on.
- Do not add `eslint-disable` or `@ts-expect-error` suppressions in test files. If the types are wrong, fix them.
