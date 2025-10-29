#!/usr/bin/env zsh

# Git branch preview for FZF
# Usage: git-branch.zsh <branch-name>

source "${0:h}/_helpers.zsh"

local branch="$1"

if [[ -z "$branch" ]]; then
  echo "❌ No branch specified"
  exit 1
fi

# Clean branch name
branch=$(_preview_clean_branch "$branch")

# Check if branch exists locally
if ! git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
  # Try as remote branch
  if ! git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null; then
    echo "❌ Branch not found: $branch"
    exit 1
  fi
  branch="origin/$branch"
fi

_preview_header "🌿" "Branch: $branch"
echo ""

# Show divergence from main/master
local main_branch=$(_preview_get_main_branch)
local ahead_behind
ahead_behind=$(git rev-list --left-right --count "$main_branch"..."$branch" 2>/dev/null || echo "0	0")
local behind=$(echo "$ahead_behind" | cut -f1)
local ahead=$(echo "$ahead_behind" | cut -f2)

if [[ "$ahead" -gt 0 || "$behind" -gt 0 ]]; then
  _preview_kv "📈 Divergence" "$ahead commits ahead, $behind commits behind $main_branch"
  echo ""
fi

# Show recent commits
_preview_header "📋" "Recent commits:"
git log --oneline --graph --color=always --date=short \
  --pretty="format:%C(auto)%cd %h%d %s %C(blue)<%an>%C(reset)" \
  "$branch" -10
