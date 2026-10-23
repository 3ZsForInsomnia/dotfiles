---
paths:
  - "**/*.{sh,bash,zsh}"
  - "**/.zshrc"
  - "**/.zprofile"
  - "**/.zshenv"
---

# Shell

- Use shell for short glue that mostly runs other commands. Switch to Python or Node (Lua is an option outside work) once a script parses structured data beyond a `jq` one-liner, branches on more than a couple of conditions, or outgrows a screen.
- Avoid subshells where state matters. Variables set inside `( )`, a command substitution, or a piped `while read` loop are lost in bash (zsh keeps the last pipeline stage in the current shell, so the same code behaves differently between them). Use process substitution (`done < <(cmd)`) or restructure instead.
- `local x=$(cmd)` and `export x=$(cmd)` hide `cmd`'s exit status. Declare first, then assign.
- Start bash scripts with `set -euo pipefail`, and remember `-e` doesn't fire inside conditions (`if`, `&&`, `||`) or in functions called from them.
- In zsh, a glob that matches nothing is an error by default (`no matches found`). Use the `(N)` qualifier where no match is valid (`for f in *.log(N)`).
- Run `shellcheck` on sh and bash scripts before calling them done.
- Give a script a `-h`/`--help` when it takes arguments or flags, changes state, or has edge cases a caller needs to know. Say what it does and how to call it. Short glue with no inputs doesn't need one.
- In zsh, don't use special parameter names as variables. Lowercase `path` is tied to `PATH`, so `for path in ...` replaces the command search path and later commands fail with "command not found". The same goes for `fpath`, `cdpath`, `manpath`, `status` (read-only), and `argv`.
