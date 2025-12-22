#!/usr/bin/env zsh

# Debug logging function (uses DEBUG_GPRUNE env var)
function _debug_log() {
  if [[ -n "$DEBUG_GPRUNE" ]]; then
    echo "[DEBUG PREVIEW] $*" >&2
  fi
}

# FZF Preview script for gprune
#
# This script generates a rich preview for a given pull request.
# It is designed to be called by the FZF command in the gprune workflow.
#
# Usage:
#   git-prune-preview.zsh <pr_number> <branch_name> <json_data>
#
# Arguments:
#   $1: The pull request number.
- #   $2: The local branch name associated with the PR.
#   $3: A JSON blob containing the pre-fetched data for all PRs.

# --- Input Validation ---
if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  echo "Usage: git-prune-preview.zsh <pr_number> <branch_name> <json_data>"
  exit 1
fi

local pr_number="$1"
local branch_name="$2"
local prs_json="$3"

_debug_log "Preview called with pr_number=$pr_number, branch=$branch_name"
_debug_log "prs_json length: ${#prs_json}"
_debug_log "First 200 chars of prs_json: ${prs_json:0:200}"

# --- Find the specific PR in the JSON blob ---
local pr_json
_debug_log "About to parse JSON with jq, looking for PR #$pr_number"

# Use --arg (string) instead of --argjson, then convert to number in jq
# This is more robust as it doesn't require the input to be valid JSON
pr_json=$(echo "$prs_json" | jq --arg pr_num "$pr_number" '.[] | select(.number == ($pr_num | tonumber))' 2>&1)
local jq_exit=$?
_debug_log "jq exit code: $jq_exit"
_debug_log "pr_json result: $pr_json"

if [[ -z "$pr_json" ]]; then
  _debug_log "Could not find PR #$pr_number in JSON data"
  echo "Could not find details for PR #$pr_number in the provided data."
  echo ""
  echo "Debug info:"
  echo "  PR number searched: $pr_number"
  echo "  JSON data length: ${#prs_json}"
  if [[ -n "$DEBUG_GPRUNE" ]]; then
    echo "  Raw JSON: $prs_json"
  fi
  exit 0
fi

# --- Extract Details using jq ---
local title author state body labels_str ci_status
title=$(echo "$pr_json" | jq -r '.title')
author=$(echo "$pr_json" | jq -r '.author.login')
state=$(echo "$pr_json" | jq -r '.state')
body=$(echo "$pr_json" | jq -r '.body')
# Format labels into a comma-separated string
labels_str=$(echo "$pr_json" | jq -r '.labels.nodes | map(.name) | join(", ")')
# Get the CI status from the nested structure
ci_status=$(echo "$pr_json" | jq -r '.statusCheckRollup.nodes[0].commit.statusCheckRollup.state // "NO_STATUS"')

# --- Build the Preview Output ---

# 1. The local branch name (the user's primary request)
echo "🌿 Local Branch: $branch_name"
echo "---------------------------------"

# 2. PR Title and Author
echo "Title:  $title"
echo "Author: $author"
echo "State:  $state"
echo "CI:     $ci_status"

# 3. Labels
if [[ -n "$labels_str" ]]; then
  echo "Labels: $labels_str"
fi

# 4. Separator and PR Body
echo "---------------------------------"
if [[ -n "$body" ]]; then
  # Use `fold` to wrap long lines for better readability in the preview window
  echo "$body" | fold -s -w 80
else
  echo "(No description provided)"
fi
