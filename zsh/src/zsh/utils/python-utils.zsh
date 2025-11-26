#!/usr/bin/env zsh

# Python utility functions
# Reusable functions for Python development tools

# Get available pyenv versions
# Returns: version names, one per line
getPyenvVersions() {
  if ! command -v pyenv >/dev/null 2>&1; then
    return 1
  fi
  
  pyenv versions --bare 2>/dev/null
}

# Get current pyenv version
# Returns: current version name
getPyenvCurrentVersion() {
  if ! command -v pyenv >/dev/null 2>&1; then
    return 1
  fi
  
  pyenv version-name 2>/dev/null
}
