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
