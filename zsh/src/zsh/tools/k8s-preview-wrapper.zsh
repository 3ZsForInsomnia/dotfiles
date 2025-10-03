#!/usr/bin/env zsh

# Kubernetes FZF Preview Wrapper
# This script can be called by FZF to show pod previews

# Get the function name from the first argument
local preview_function="$1"
shift  # Remove function name from arguments

# Load the FZF helpers if not already loaded
if ! (( $+functions[$preview_function] )); then
  source "${0:h}/fzf-helpers.zsh"
fi

# Call the specified preview function with the remaining arguments
$preview_function "$@"