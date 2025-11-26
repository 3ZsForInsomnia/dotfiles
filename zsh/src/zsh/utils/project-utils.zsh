#!/usr/bin/env zsh

# Project utility functions
# Reusable functions for finding and working with project roots

# Find project root directories
# Searches upward from current directory for common project markers
# Returns: absolute path to project root, or empty if not found
findProjectRoot() {
  local search_dir="${1:-.}"
  local current_dir="$(cd "$search_dir" 2>/dev/null && pwd)"
  
  while [[ -n "$current_dir" && "$current_dir" != "/" ]]; do
    # Check for various project markers
    if [[ -d "$current_dir/.git" ]] || \
       [[ -f "$current_dir/package.json" ]] || \
       [[ -f "$current_dir/Cargo.toml" ]] || \
       [[ -f "$current_dir/go.mod" ]] || \
       [[ -f "$current_dir/pyproject.toml" ]] || \
       [[ -f "$current_dir/setup.py" ]] || \
       [[ -f "$current_dir/pom.xml" ]] || \
       [[ -f "$current_dir/build.gradle" ]] || \
       [[ -f "$current_dir/Makefile" ]]; then
      echo "$current_dir"
      return 0
    fi
    current_dir="$(dirname "$current_dir")"
  done
  
  return 1
}
