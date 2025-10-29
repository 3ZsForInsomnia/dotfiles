#!/usr/bin/env zsh

# File/directory preview for FZF
# Usage: file.zsh <path>

source "${0:h}/_helpers.zsh"

local file="$1"

if [[ -z "$file" ]]; then
  echo "❌ No file specified"
  exit 1
fi

if [[ ! -e "$file" ]]; then
  echo "❌ File not found: $file"
  exit 1
fi

if [[ -d "$file" ]]; then
  # Directory preview
  _preview_header "📁" "Directory: $file"
  echo ""
  
  if _preview_has_cmd eza; then
    eza -la --icons --git --color=always "$file" 2>/dev/null
  else
    ls -la "$file"
  fi
  
elif [[ -f "$file" ]]; then
  # File preview
  _preview_header "📄" "File: $file"
  
  # Show git status if in git repo
  if git rev-parse --git-dir >/dev/null 2>&1; then
    local git_status
    git_status=$(git status --porcelain "$file" 2>/dev/null)
    if [[ -n "$git_status" ]]; then
      echo "🔄 Git: $git_status"
    fi
  fi
  
  echo ""
  
  # Show file content with syntax highlighting
  if _preview_has_cmd bat; then
    bat --style=numbers --color=always --line-range :500 "$file" 2>/dev/null
  else
    head -500 "$file"
  fi
  
else
  echo "❓ Unknown item type: $file"
  exit 1
fi
