#!/usr/bin/env zsh

# FZF Preview script for gprune
#
# Usage:
#   git-prune-preview.zsh <pr_number> <branch_name> <json_tmpfile>
#
# Arguments:
#   $1: The pull request number (e.g. "#123" from fzf — the # is stripped).
#   $2: The local branch name associated with the PR.
#   $3: Path to a temp file containing the JSON blob of all PRs.

function _gprune_preview_debug_log() {
  if [[ -n "$DEBUG_GPRUNE" ]]; then
    echo "[DEBUG PREVIEW] $*" >&2
  fi
}

# --- Input Validation ---
if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  echo "Usage: git-prune-preview.zsh <pr_number> <branch_name> <json_tmpfile>"
  exit 1
fi

local pr_number="$1"
local branch_name="$2"
local json_tmpfile="$3"

# Strip leading # from fzf field extraction (e.g. "#123" -> "123")
pr_number="${pr_number#\#}"

_gprune_preview_debug_log "Preview called with pr_number=$pr_number, branch=$branch_name, file=$json_tmpfile"

if [[ ! -f "$json_tmpfile" ]]; then
  echo "Error: JSON data file not found: $json_tmpfile"
  exit 1
fi

local prs_json
prs_json=$(< "$json_tmpfile")

# --- Find the specific PR in the JSON blob ---
local pr_json
pr_json=$(echo "$prs_json" | jq --arg pr_num "$pr_number" '.[] | select(.number == ($pr_num | tonumber))' 2>&1)
local jq_exit=$?
_gprune_preview_debug_log "jq exit code: $jq_exit"

if [[ -z "$pr_json" ]]; then
  echo "Could not find details for PR #$pr_number in the provided data."
  exit 0
fi

# --- Extract Details ---
local title author state body labels_str ci_status
title=$(echo "$pr_json" | jq -r '.title')
author=$(echo "$pr_json" | jq -r '.author.login')
state=$(echo "$pr_json" | jq -r '.state')
body=$(echo "$pr_json" | jq -r '.body')
labels_str=$(echo "$pr_json" | jq -r '.labels.nodes | map(.name) | join(", ")')
ci_status=$(echo "$pr_json" | jq -r '.statusCheckRollup.nodes[0].commit.statusCheckRollup.state // "NO_STATUS"')

# --- Build the Preview Output ---
echo "🌿 Local Branch: $branch_name"
echo "---------------------------------"
echo "Title:  $title"
echo "Author: $author"
echo "State:  $state"
echo "CI:     $ci_status"

if [[ -n "$labels_str" ]]; then
  echo "Labels: $labels_str"
fi

echo "---------------------------------"
if [[ -n "$body" ]]; then
  echo "$body" | fold -s -w 80
else
  echo "(No description provided)"
fi
