---
paths:
  - "**/*_test.go"
---

# Go testing

- Every endpoint has integration test coverage, individually or as part of a group of endpoints.
- Default to table-driven tests for unit tests. Use `t.Run` subtests to group cases.
- Use external test packages (`package foo_test`) to test the public interface. Use internal packages only when private functions need direct testing.
- Call `t.Parallel()` at the top of tests that are safe to run concurrently (no shared mutable state, no global side effects).
