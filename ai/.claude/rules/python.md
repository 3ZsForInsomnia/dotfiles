---
paths:
  - "**/*.py"
---

# Python

- Type-hint every function signature. Use frozen dataclasses for structured values instead of dicts passed around by key.
- Prefer the standard library. Scripts meant to run directly (on PATH, via `#!/usr/bin/env python3`) use no third-party packages, so they run without a virtualenv.
- Call commands with `subprocess.run([...], check=True)` and a list of arguments, never `shell=True` with interpolated values.
