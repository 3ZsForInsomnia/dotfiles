#!/usr/bin/env zsh

# Development utility functions
# Reusable functions for development tools and project management

# Parse scripts from package.json
# Returns: script names, one per line
parsePackageJsonScripts() {
  [[ -f package.json ]] || return 1
  
  # Use jq if available, otherwise fallback to basic parsing
  if command -v jq >/dev/null 2>&1; then
    jq -r '.scripts | keys[]' package.json 2>/dev/null
  else
    # Basic parsing without jq
    grep -A 50 '"scripts"' package.json 2>/dev/null | \
      grep '^\s*"[^"]*"' | \
      sed 's/^\s*"//' | \
      sed 's/".*//' | \
      grep -v '^scripts$'
  fi
}
