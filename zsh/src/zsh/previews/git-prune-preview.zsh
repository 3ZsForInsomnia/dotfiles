#!/usr/bin/env zsh

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

# --- Find the specific PR in the JSON blob ---
local pr_json
pr_json=$(echo "$prs_json" | jq --argjson pr_number "$pr_number" '.[] | select(.number == $pr_number)')

if [[ -z "$pr_json" ]]; then
  echo "Could not find details for PR #$pr_number in the provided data."
  exit 0
fi

# --- Extract Details using jq ---
local title author state body labels_str status
title=$(echo "$pr_json" | jq -r '.title')
author=$(echo "$pr_json" | jq -r '.author.login')
state=$(echo "$pr_json" | jq -r '.state')
body=$(echo "$pr_json" | jq -r '.body')
# Format labels into a comma-separated string
labels_str=$(echo "$pr_json" | jq -r '.labels.nodes | map(.name) | join(", ")')
# Get the CI status from the nested structure
status=$(echo "$pr_json" | jq -r '.statusCheckRollup.nodes[0].commit.statusCheckRollup.state // "NO_STATUS"')

# --- Build the Preview Output ---

# 1. The local branch name (the user's primary request)
echo "🌿 Local Branch: $branch_name"
echo "---------------------------------"

# 2. PR Title and Author
echo "Title:  $title"
echo "Author: $author"
echo "State:  $state"
echo "CI:     $status"

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
