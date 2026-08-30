#!/bin/sh
# Auto-commit the notes vault. Runs unattended from cron.
# Username/machine-agnostic: relies on $HOME, no hardcoded paths.
set -eu

REPO="$HOME/Documents/sync"
# cron runs with a bare PATH; make sure git is found (Homebrew on macOS, system elsewhere).
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

cd "$REPO"

# Nothing to commit? Exit quietly.
[ -n "$(git status --porcelain)" ] || exit 0

git add -A
git commit -q -m "vault backup: $(date '+%Y-%m-%d %H:%M:%S')"
