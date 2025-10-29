#!/usr/bin/env zsh

# Git commit preview for FZF
# Usage: git-commit.zsh <commit-hash>

source "${0:h}/_helpers.zsh"

local commit="$1"

if [[ -z "$commit" ]]; then
  echo "❌ No commit specified"
  exit 1
fi

# Validate commit hash
if ! git rev-parse --verify "$commit" >/dev/null 2>&1; then
  echo "❌ Invalid commit: $commit"
  exit 1
fi

# Show commit summary
_preview_header "📝" "$(git log -1 --format='%s' "$commit")"
echo ""

# Author and date
_preview_kv "👤 Author" "$(git log -1 --format='%an <%ae>' "$commit")"
_preview_kv "📅 Date" "$(git log -1 --format='%cd' --date=relative "$commit")"
_preview_kv "🔗 Hash" "$(git log -1 --format='%H' "$commit")"
echo ""

# Change statistics
_preview_header "📊" "Changes:"
git show --stat --format="" "$commit"
echo ""

# Show diff with delta if available
_preview_header "🔍" "Diff:"
if _preview_has_cmd delta; then
  git show --color=always "$commit" | delta
else
  git show --color=always "$commit"
fi
