---
paths:
  - "**/*{Context,Provider}.{ts,tsx}"
---

# React context

- Expose each context through a `useX` hook that throws a clear error when called outside its provider. Don't export the raw context for components to read with `useContext`.
- Memoize the provider's value (`useMemo`, with stable callbacks) so consumers don't re-render on every provider render.
- Don't put values that change often (input text, scroll position, timers) in context: every consumer re-renders on each change. Keep that state local, or use a store with selectors.
