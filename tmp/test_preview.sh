#!/bin/zsh

# Test the preview logic with a sample line
pr_line="[MERGED] #123 Test PR (testuser) [2025-01-15] test-branch"

pr_number=$(echo "$pr_line" | sed 's/^\[MERGED\] \|^\[CLOSED\] //' | grep -o '#[0-9]\+' | head -1 | cut -c2-)

echo "Extracted PR number: $pr_number"

pr_info=$(gh pr view "$pr_number" --json number,title,state,author,mergedAt,createdAt,headRefName,body 2>&1)

echo "PR info response:"
echo "$pr_info"
echo ""

if [[ -z "$pr_info" ]]; then
  echo "Could not load PR #$pr_number"
  exit 0
fi

echo "Parsing with jq..."
title=$(echo "$pr_info" | jq -r '.title' 2>&1)
echo "Title: $title"

state=$(echo "$pr_info" | jq -r '.state' 2>&1)
echo "State: $state"

author=$(echo "$pr_info" | jq -r '.author.login' 2>&1)
echo "Author: $author"
