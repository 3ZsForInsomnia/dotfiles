---
paths:
  - "**/*.go"
---

# Go

## Style

- Prefer `any` over `interface{}`.
- Pass `golangci-lint` with no new issues introduced.
- Lightly functional, within idiomatic Go: small named functions, pure where practical, and returning new values rather than mutating arguments. Use the standard `slices` and `maps` packages; don't introduce generic map/filter helper libraries.
- Set a deadline on every outbound call, and decide up front whether the caller degrades or fails when the dependency is down.

## Testing

Unit tests don't touch external systems. Integration tests verify behavior against real dependencies (database, etc.) and must mock everything outside the service under test (external HTTP clients, queues, third-party APIs).

- Prefer a mix weighted toward unit tests. Every endpoint must have integration test coverage.
- Default to table-driven tests for unit tests. Use `t.Run` subtests to group cases.
- Use external test packages (`package foo_test`) to test the public interface. Use internal packages only when private functions need direct testing.
- Call `t.Parallel()` at the top of tests that are safe to run concurrently (no shared mutable state, no global side effects).
