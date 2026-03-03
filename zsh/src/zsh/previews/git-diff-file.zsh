#!/usr/bin/env zsh

# Git diff file preview for FZF
# Shows diff for a single file between two refs
# Usage: git-diff-file.zsh <ref1> <ref2> <filepath>

source "${0:h}/_helpers.zsh"

local ref1="$1"
local ref2="$2"
local file="$3"

if [[ -z "$file" ]]; then
  echo "No file selected"
  exit 1
fi

_preview_header "📄" "File: $file"
_preview_kv "🔄 Changes" "$ref1 → $ref2"
echo ""

# Show diff stats
local stats
stats=$(git diff --stat "$ref1".."$ref2" -- "$file" 2>/dev/null)
if [[ -n "$stats" ]]; then
  _preview_header "📊" "$stats"
  echo ""
fi

# Show the diff, with delta if available
_preview_header "🔍" "Diff:"
if _preview_has_cmd delta; then
  git diff --color=always "$ref1".."$ref2" -- "$file" 2>/dev/null | delta
else
  git diff --color=always "$ref1".."$ref2" -- "$file" 2>/dev/null
fi
