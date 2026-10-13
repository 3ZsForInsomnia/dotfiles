---
paths:
  - "**/*.{ts,tsx,js,jsx}"
---

# TypeScript and React

## Types

- Never use `any`. If the type system is fighting you, the design is wrong — fix the design.
- Avoid `unknown` unless the shape genuinely cannot be known at compile time (e.g., a catch clause, a deserialization boundary). Narrow it if you can.
- A string that can only be one of three values should be a union of those literals, not `string`.
- Avoid `Record<string, unknown>` as a stand-in for a real interface. Define the shape.
- Create named type aliases even for simple types when the name conveys domain meaning. `type UserId = string` is better than a bare `string`. When confusing one identifier with another would be a real bug, brand it (`type UserId = string & { readonly __brand: "UserId" }`) and create values through a single constructor at the boundary.
- Use discriminated unions whenever data has distinct states or variants. Prefer `{ kind: 'loading' } | { kind: 'ready'; data: T }` over `{ loading: boolean; data: T | null }`, and handle them with an exhaustive `switch` ending in a `never` check, so a new variant fails to compile until it's handled.
- Use the rest of the type toolbox where it makes types more precise: `as const` objects instead of enums, `satisfies` to check a value's shape without widening it, template literal types for structured strings.
- Mark data you don't mutate `readonly` — `readonly` fields and `readonly T[]` make immutability checkable rather than conventional.
- Avoid `as` type assertions — prefer type guards, `satisfies`, or narrowing. Use `as` only when you know something the compiler cannot prove; leave a comment explaining why.

## Values and Nullability

- Use Zod at external boundaries (API responses, env vars, form inputs) for schema validation and type narrowing. Use `assert` functions for internal invariants where Zod would be overhead. Don't use both for the same layer — Zod at a boundary makes downstream assertions redundant.
- Don't accept optional parameters for values known to exist. Narrow or assert at the boundary and pass required values inward; `enabled: !!param` and early returns of `undefined` are optionality leaking inward.
- Narrow loosely typed values by type (`typeof id === "number"`), not against `undefined` — a `null` passes `!== undefined`.
- Use optional chaining for genuinely optional data. Don't use `?.` as control flow for values that should be present — strong types should eliminate most need for it.

## Functional Style

- Lean further into functional style than feels necessary: it's the default you deviate from with a reason.
- Use `const` arrow functions, with a concise body (`const format = (x: T) => x.name`) when it fits on one line. Use `function` declarations only where a framework requires them or for overload signatures.
- Never mutate function arguments or props. Build new objects and arrays with spreads and transformations.
- Build arrays, objects, and `Map`s from a transformation — `map`, `filter`, `flatMap`, `reduce`, `Object.fromEntries`, `new Map(entries)` — rather than by mutating an accumulator. Never build an array by pushing inside `forEach` or `for...of`. A plain loop is right when you're not accumulating: side effects, or an early exit.
- When a set of known cases maps to outcomes, look up a handler in an object map rather than chaining `if`/`switch`.
- Prefer `async/await` over `.then()` chains. Never mix the two in the same function. Callbacks are fine in their natural context (event listeners, stream handlers, etc.).
- Run independent async work concurrently with `Promise.all` rather than sequential `await`s. Await in sequence only when each step needs the previous result.
- Annotate caught errors as `unknown` (`catch (error: unknown)`) and narrow them.

## React

- React is declarative UI; write it that way. Express variation through components, props, and lookups — a map from state to component, a boundary component wrapping a subtree — rather than branching and imperative steps inside render.
- One exported component per file. Colocate hooks and helpers only if they are single-use for that component.
- Use `useEffect` only to synchronize with something outside React (subscriptions, timers, imperative browser APIs). Don't use it for derived state — compute that during render — or to respond to events — do that in the handler — or to sync one piece of state from another. Use `useMemo` and `useCallback` for what they're for (expensive computations, referential identity something depends on), not by reflex.
- Prefer controlled components. Do not use refs for form state.
- Wrap component subtrees in `ErrorBoundary` anywhere a failure should be isolated — cards, panels, data-dependent sections, dialogs. Not just at the page level.
- Avoid deep relative imports (`../../../`). If you find yourself writing them, that's a signal of missing structure.

## Testing

Unit tests cover pure functions, hooks in isolation, and single components without providers. Integration tests render a component tree with real providers (router, query client, theme) and exercise user flows.

- Mock API calls at the network layer (MSW) in integration tests.
- Components should expose their own test helpers for queries and interactions, covering what tests actually need. Treat this as a strong default; skipping helpers is a deliberate exception. Every component has a `data-testid` on its root element.
- Query through component helpers first, then `data-testid`, then role/label/text queries for the cases where neither fits.
- Render once per `describe` (in `beforeEach` or at describe scope) when tests differ only in mock data. Re-rendering expensive components such as data grids in every test makes suites slow.
- Do not mock state management, user interactions, or third-party components the component under test relies on.
- Do not add `eslint-disable` or `@ts-expect-error` suppressions in test files. If the types are wrong, fix them.
