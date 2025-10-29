#!/usr/bin/env zsh

# Shared helper functions for FZF previews
# Source this file in preview scripts that need common utilities

# Get the main/master branch name for the repository
function _preview_get_main_branch() {
  git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main"
}

# Format section header with emoji
function _preview_header() {
  local emoji="$1"
  local text="$2"
  echo "${emoji} ${text}"
}

# Format key-value pair
function _preview_kv() {
  local key="$1"
  local value="$2"
  echo "${key}: ${value}"
}

# Check if command exists
function _preview_has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# Clean branch name (remove markers, prefixes)
function _preview_clean_branch() {
  local branch="$1"
  echo "$branch" | sed 's/^[* ]*//' | sed 's/^origin\///' | xargs
}
