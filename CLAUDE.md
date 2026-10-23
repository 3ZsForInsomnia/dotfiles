# Dotfiles

Managed with GNU Stow: each top-level directory is a stow package whose contents
symlink into `$HOME` (e.g. `ai/.claude/` → `~/.claude/`). A file edited here is
read from its stowed location at runtime, not from this repo.

## Secrets

Secret files are backed up to a separate private `secrets` repo (sibling of this
one, at `~/src/secrets`) by the `mksecret` script (`zsh/.local/bin/mksecret`). A
`post-commit` hook here runs `mksecret sync` after each dotfiles commit, which
refreshes every tracked secret into the secrets repo, then commits and pushes it
there. It copies files — it does not symlink them back (`restore` is a manual
new-machine step).

How it maps:

- Tree secrets — files under this repo (`secrets/<path>` ← `$DOTFILES/<path>`).
  When tracked, `mksecret` auto-adds them to this repo's `.gitignore`, and
  `mksecret check` audits that every tree secret is gitignored. So tracked secrets
  should already be excluded here — though it's not foolproof, so still never
  introduce secret material into tracked files.
- External secrets — files under `$HOME` outside this repo
  (`secrets/_external/<path>` ← `$HOME/<path>`).
- Excludes — add gitignore patterns to `secrets/.gitignore` (e.g. `*.jsonl` to
  skip Claude session transcripts).

`mksecret` (see `mksecret -h`) is the source of truth for this behavior; consult it
rather than duplicating its logic here.

## MCP servers

`neovim/.config/nvim/lua/config/codecompanion/mcp.lua` decides which MCP servers
each CodeCompanion (ACP) session gets, based on the repo Neovim was opened in.
Most run through the Docker MCP gateway, which lists their tools at session
start but only runs a server's container during a tool call. A few run directly
because a container can't do their job: `nx` (its native core is installed for
macOS only), `playwright-extension` and `webmcp` (talk to the real browser), and
`figma` (the gateway only accepts https remotes).

Gateway config lives in `docker/` next to `mcp.lua`:

- `catalog.yaml`: servers that aren't in Docker's catalog. The gateway only reads
  catalogs from `~/.docker/mcp/catalogs/` and rejects symlinks, so after editing
  it, a `<name>/Dockerfile`, or a `dbhub/<project>.toml`, run `mcp-catalog-sync`:
  it installs the catalog and builds the `local/<name>-mcp` images.
- `tools.yaml`: per-server tool allowlists. The gateway reads it from dotfiles
  directly, so it needs no sync. A server it doesn't list exposes every tool.

Gotchas:

- Approvals follow one rule: reads are auto-approved, and anything that writes,
  deletes, or runs arbitrary code asks. The deliberate exception is Playwright
  navigation and interaction (clicks, typing, forms), auto-approved so browser
  checks don't need a prompt per step. The rules are in
  `ai/.claude/settings.json`, where gateway tools are named
  `mcp__docker-gateway__<tool>`.
- Secrets are in `docker pass`; set one with `docker mcp secret set <name>`,
  piping the value on stdin. Containers reach services on this Mac through
  `host.docker.internal`, so a connection string pointing at `localhost` needs
  that host instead.
- OAuth servers (e.g. `atlassian-remote`) need a one-time sign-in from Docker
  Desktop's MCP Toolkit UI; `docker mcp oauth authorize` alone can't set them up.
- The gateway only mounts host folders it's told to allow (the env var on the
  gateway entry in `mcp.lua`) and refuses any path containing `.config`.
- `DOCKER_CONFIG` must stay unset: Docker Desktop keeps its CLI plugins and MCP
  state in `~/.docker`.
