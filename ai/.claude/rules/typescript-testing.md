---
paths:
  - "**/*.{test,spec}.{ts,tsx,js,jsx}"
---

# TypeScript and React testing

Unit tests cover pure functions, hooks in isolation, and single components without providers. Integration tests render a component tree with real providers (router, query client, theme) and exercise user flows.

- Mock API calls at the network layer (MSW) in integration tests. Configure MSW with `onUnhandledRequest: "error"` and reset handlers after each test, so a request a test forgot to mock fails loudly instead of passing by accident.
- Drive interactions with `userEvent`, not `fireEvent`. It fires the full sequence a real user produces (focus, keydown, input, click), so tests catch bugs `fireEvent` skips.
- Wait for async UI with `findBy*` or `waitFor` on the expected result. Never use fixed sleeps, and keep `waitFor` callbacks free of side effects.
- Query through the component's own test helpers first, then `data-testid`, then role/label/text queries for the cases where neither fits.
- Test hooks that need providers with `renderHook` and a `wrapper` that supplies them, not by building a test component around the hook.
- Render once per `describe` (in `beforeEach` or at describe scope) when tests differ only in mock data. Re-rendering expensive components such as data grids in every test makes suites slow.
- Do not mock state management, user interactions, or third-party components the component under test relies on.
- Do not add `eslint-disable` or `@ts-expect-error` suppressions in test files. If the types are wrong, fix them.
