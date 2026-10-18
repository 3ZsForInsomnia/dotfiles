---
paths:
  - "**/*_test.go"
  - "**/*.{test,spec}.{ts,tsx,js,jsx}"
  - "**/test_*.py"
  - "**/*_test.py"
  - "**/*_spec.lua"
---

# Testing

- Unit tests exercise one unit with no external systems. Integration tests run a slice of the system through its real code and mock only what lies outside it (other services, third-party APIs, queues), as far out as possible: at the network layer rather than by stubbing a client. A database the code owns counts as inside; use a real or in-memory one rather than mocking queries.
- Weight toward integration tests: they give the most confidence per test because they exercise real code paths together. Use unit tests for pure logic with many cases, such as parsing, calculations, and state transitions.
- Test from the user's perspective. Don't assert on internal state, props, or implementation details.
- Tests may import production types, enums, and constants - reusing them keeps tests strongly typed.
- Never skip, delete, or comment out tests to make a suite pass.
- Never modify assertions to match wrong output.
- Never weaken mocks or broaden test setup to fix a failing test without understanding the failure.
- Extract reusable test helpers - setup, fixtures, mock factories, assertion helpers - as soon as a second test would benefit. Bias toward extraction, not speculation.
- Every test must be able to fail for a reason someone would care about. Tests that only check a mock was called, that a component renders, or that code runs without throwing usually don't; test what the caller or user actually gets.
- Tests must give the same result on every run and in any order. Inject the clock, random sources, and IDs instead of reading real time or randomness; never depend on another test's leftovers.
- When fixing a bug, write the test that reproduces it first and watch it fail, then fix. A test written after the fix may never have caught the bug.
- Build test data with factories that take overrides, not shared mutable fixtures that tests quietly depend on. Each test should show the data that matters to it.
