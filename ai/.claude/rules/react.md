---
paths:
  - "**/*.{tsx,jsx}"
  - "**/use*.{ts,tsx}"
---

# React

- React is declarative UI; write it that way. Express variation through components, props, and lookups - a map from state to component, a boundary component wrapping a subtree - rather than branching and imperative steps inside render.
- One exported component per file. Colocate hooks and helpers only if they are single-use for that component.
- Extract a custom hook when stateful logic (state, effects, queries) is used by more than one component, or when pulling it out makes the component significantly smaller and lets it read as a short list of named steps. Keep it inline when it's a single piece of state or short and used once.
- Use `useEffect` only to synchronize with something outside React (subscriptions, timers, imperative browser APIs). Don't use it for derived state - compute that during render - or to respond to events - do that in the handler - or to sync one piece of state from another. Use `useMemo` and `useCallback` for what they're for (expensive computations, referential identity something depends on), not by reflex.
- Prefer controlled components. Do not use refs for form state.
- Wrap component subtrees in `ErrorBoundary` anywhere a failure should be isolated - cards, panels, data-dependent sections, dialogs. Not just at the page level.
- Components expose their own test helpers for queries and interactions, covering what tests actually need. Treat this as a strong default; skipping helpers is a deliberate exception. Every component has a `data-testid` on its root element.
