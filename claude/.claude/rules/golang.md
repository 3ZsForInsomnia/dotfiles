---
paths:
  - "**/*.go"
---

# Go

## Style

- Prefer `any` over `interface{}`.
- Pass `golangci-lint` with no new issues introduced.

## Testing

Unit tests don't touch external systems. Integration tests verify behavior against real dependencies (database, etc.) and must mock everything outside the service under test (external HTTP clients, queues, third-party APIs).

- Prefer a mix weighted toward unit tests. Every endpoint must have integration test coverage.
- Default to table-driven tests for unit tests. Use `t.Run` subtests to group cases.
- Use external test packages (`package foo_test`) to test the public interface. Use internal packages only when private functions need direct testing.
- Extract reusable test helpers — setup, fixtures, request builders, assertion helpers — as soon as a second test would benefit.
