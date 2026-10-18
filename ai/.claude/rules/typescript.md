---
paths:
  - "**/*.{ts,tsx,js,jsx}"
---

# TypeScript

## Types

- Never use `any`. If the type system is fighting you, the design is wrong - fix the design.
- Avoid `unknown` unless the shape genuinely cannot be known at compile time (e.g., a catch clause, a deserialization boundary). Narrow it if you can.
- A string that can only be one of three values should be a union of those literals, not `string`.
- Avoid `Record<string, unknown>` as a stand-in for a real interface. Define the shape.
- Create named type aliases even for simple types when the name conveys domain meaning. `type UserId = string` is better than a bare `string`. When confusing one identifier with another would be a real bug, brand it (`type UserId = string & { readonly __brand: "UserId" }`) and create values through a single constructor at the boundary.
- Use discriminated unions whenever data has distinct states or variants. Prefer `{ kind: 'loading' } | { kind: 'ready'; data: T }` over `{ loading: boolean; data: T | null }`, and handle them with an exhaustive `switch` ending in a `never` check, so a new variant fails to compile until it's handled.
- Use the rest of the type toolbox where it makes types more precise: `as const` objects instead of enums, `satisfies` to check a value's shape without widening it, template literal types for structured strings.
- Mark data you don't mutate `readonly` - `readonly` fields and `readonly T[]` make immutability checkable rather than conventional.
- Avoid `as` type assertions - prefer type guards, `satisfies`, or narrowing. Use `as` only when you know something the compiler cannot prove; leave a comment explaining why.
- Annotate return types wherever TypeScript can't infer them precisely: when inference would widen a literal union to `string`, include an unintended `undefined`, or fall back to `any`.

## Values and Nullability

- Use Zod at external boundaries (API responses, env vars, form inputs) for schema validation and type narrowing. Use `assert` functions for internal invariants where Zod would be overhead. Don't use both for the same layer - Zod at a boundary makes downstream assertions redundant.
- Don't accept optional parameters for values known to exist. Narrow or assert at the boundary and pass required values inward; `enabled: !!param` and early returns of `undefined` are optionality leaking inward.
- Narrow loosely typed values by type (`typeof id === "number"`), not against `undefined` - a `null` passes `!== undefined`.
- Use optional chaining for genuinely optional data. Don't use `?.` as control flow for values that should be present - strong types should eliminate most need for it.

## Functional Style

- Lean further into functional style than feels necessary: it's the default you deviate from with a reason.
- Use `const` arrow functions, with a concise body (`const format = (x: T) => x.name`) when it fits on one line. Use `function` declarations only where a framework requires them or for overload signatures.
- Never mutate function arguments or props. Build new objects and arrays with spreads and transformations.
- Build arrays, objects, and `Map`s from a transformation - `map`, `filter`, `flatMap`, `reduce`, `Object.fromEntries`, `new Map(entries)` - rather than by mutating an accumulator. Never build an array by pushing inside `forEach` or `for...of`. A plain loop is right when you're not accumulating: side effects, or an early exit.
- When a set of known cases maps to outcomes, look up a handler in an object map rather than chaining `if`/`switch`.
- Prefer `async/await` over `.then()` chains. Never mix the two in the same function. Callbacks are fine in their natural context (event listeners, stream handlers, etc.).
- Run independent async work concurrently with `Promise.all` rather than sequential `await`s. Await in sequence only when each step needs the previous result.
- Annotate caught errors as `unknown` (`catch (error: unknown)`) and narrow them.

## Modules

- Avoid deep relative imports (`../../../`). If you find yourself writing them, that's a signal of missing structure.
