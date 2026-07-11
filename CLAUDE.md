# Dotfiles

Managed with GNU Stow: each top-level directory is a stow package whose contents
symlink into `$HOME` (e.g. `claude/.claude/` → `~/.claude/`). A file edited here is
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
