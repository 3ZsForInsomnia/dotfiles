  source "$ZSH_CONFIG_DIR/utils/git-pr-utils.zsh"

### Debug Toggle
# Uncomment the line below to enable debug logging
# DEBUG_GPRUNE=1

function _debug_log() {
  if [[ -n "$DEBUG_GPRUNE" ]]; then
    echo "[DEBUG] $*" >&2
  fi
}

### Main Pruning Commands

function gprune() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gprune"
    echo "Prune local branches for merged PRs (daily cleanup)"
    echo ""
    echo "Process:"
    echo "1. Find local branches with merged PRs"
    echo "2. FZF selection with PR preview"
    echo "3. Confirmation before deletion"
    echo "4. Option to edit selection or cancel"
    return 0
  fi

  echo "Fetching PR data for local branches..."
  _debug_log "Calling _get_merged_closed_prs_with_local_branches_json"
  local prs_json
  prs_json=$(_get_merged_closed_prs_with_local_branches_json)
  _debug_log "Raw prs_json output:"
  _debug_log "$prs_json"
  _debug_log "prs_json length: ${#prs_json}"

  if [[ -z "$prs_json" || "$prs_json" == "[]" ]]; then
    _debug_log "prs_json is empty or []"
    echo "No local branches found for merged or closed PRs."
    return 0
  fi
  _debug_log "prs_json is valid, proceeding to interactive workflow"

  _interactive_prune_workflow "$prs_json"
}

function gprunepr() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gprunepr <pr-number>"
    echo "Prune branch for specific PR (any status)"
    echo ""
    echo "Examples:"
    echo "  gprunepr 123    # Delete branch for PR #123"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: PR number required"
    return 1
  fi

  local pr_number="$1"

  # Get PR info
  local pr_json
  pr_json=$(gh pr view "$pr_number" --json number,title,state,headRefName,author,mergedAt 2>/dev/null)

  if [[ -z "$pr_json" ]]; then
    echo "Error: PR #$pr_number not found"
    return 1
  fi

  local branch=$(echo "$pr_json" | jq -r '.headRefName')
  local title=$(echo "$pr_json" | jq -r '.title')
  local state=$(echo "$pr_json" | jq -r '.state')
  local author=$(echo "$pr_json" | jq -r '.author.login')

  # Check if branch exists locally
  if ! git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
    echo "Branch '$branch' for PR #$pr_number not found locally"
    return 1
  fi

  # Show PR info and confirm
  echo "PR #$pr_number: $title"
  echo "Author: $author"
  echo "State: $state"
  echo "Branch: $branch"
  echo ""
  echo "Delete local branch '$branch'? (y/N)"
  read -r response

  if [[ "$response" =~ ^[Yy]$ ]]; then
    if git branch -D "$branch"; then
      echo "Deleted branch: $branch"
    else
      echo "Failed to delete branch: $branch"
      return 1
    fi
  else
    echo "Cancelled."
  fi
}

### Helper Functions

function _get_prs_with_local_branches() {
  # This function is deprecated and is kept here for reference during the refactor.
  # The new logic is in `zsh/src/zsh/utils/git-pr-utils.zsh`.
  #
  # Get both merged and closed PRs that have local branches
  # Get all PRs (merged and closed, but not open)
  # Using jq to combine and deduplicate by PR number
  gh pr list --state all --json number,title,headRefName,author,mergedAt,createdAt,state --limit 500 2>/dev/null |
    jq -r '.[] | select(.state == "MERGED" or .state == "CLOSED") | select(.headRefName != null) | @json' |
    while IFS= read -r pr_json; do
      local branch=$(echo "$pr_json" | jq -r '.headRefName')
      # Check if branch exists locally and isn't main
      if [[ "$branch" != "$GIT_MAIN_BRANCH" ]] && git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
        echo "$pr_json"
      fi
    done
}

function _format_pr_for_fzf() {
  local pr_json="$1"

  local number=$(echo "$pr_json" | jq -r '.number')
  local title=$(echo "$pr_json" | jq -r '.title')
  local author=$(echo "$pr_json" | jq -r '.author.login')
  local branch=$(echo "$pr_json" | jq -r '.headRefName')
  local state=$(echo "$pr_json" | jq -r '.state')
  local merged_at=$(echo "$pr_json" | jq -r '.mergedAt // .createdAt')

  # Format date
  local date_formatted=""
  if [[ "$merged_at" != "null" ]]; then
    # macOS date format
    date_formatted=$(echo "$merged_at" | cut -d'T' -f1)
  fi

  # Add state prefix
  local state_prefix=""
  if [[ "$state" == "MERGED" ]]; then
    state_prefix="[MERGED] "
  elif [[ "$state" == "CLOSED" ]]; then
    state_prefix="[CLOSED] "
  fi

  printf "%s#%d %s (%s) [%s] %s\n" "$state_prefix" "$number" "$title" "$author" "$date_formatted" "$branch"
}

function _interactive_prune_workflow() {
  local prs_json="$1"
  _debug_log "_interactive_prune_workflow called with prs_json length: ${#prs_json}"
  _debug_log "First 200 chars of prs_json: ${prs_json:0:200}"
  local preview_script_path="$ZSH_CONFIG_DIR/previews/git-prune-preview.zsh"

  # Make sure the preview script is executable
  if [[ ! -x "$preview_script_path" ]]; then
    chmod +x "$preview_script_path"
  fi

  while true; do
    # Format PRs for FZF using the rich JSON data
    local fzf_options=()
      # Use jq to parse the JSON array and format each PR
      local formatted_list
      _debug_log "About to parse prs_json with jq"
      _debug_log "prs_json being passed to jq: $prs_json"
      formatted_list=$(echo "$prs_json" | jq -r '.[] | 
        "\(if .state == "MERGED" then "[MERGED]" else "[CLOSED]" end) #\(.number) \(.title) (\(.author.login)) [\(.mergedAt // .createdAt | split("T")[0])] \(.headRefName)"
      ' 2>&1)
      local jq_exit_code=$?
      _debug_log "jq exit code: $jq_exit_code"
      _debug_log "formatted_list output: $formatted_list"

      if [[ -z "$formatted_list" ]]; then
        _debug_log "formatted_list is empty after jq parsing"
        echo "No PRs available for pruning."
        return 0
      fi
      _debug_log "formatted_list has content, proceeding to fzf"

    echo "Found $(echo "$formatted_list" | wc -l | tr -d ' ') local branch(es) for merged/closed PRs"

    # FZF selection
    local selected
    selected=$(echo "$formatted_list" |
      fzf --multi \
        --reverse \
        --preview="$preview_script_path {2} {NF} '$prs_json'" \
        --preview-window="right:60%" \
        --bind="ctrl-a:select-all" \
        --bind="ctrl-d:deselect-all" \
        --header="Tab=select, Ctrl-A=select all, Ctrl-D=deselect all, Enter=confirm, Esc=cancel")

    if [[ -z "$selected" ]]; then
      echo "Cancelled."
      return 0
    fi

    # Extract branches to delete
    local branches_to_delete=()
    while IFS= read -r line; do
      if [[ -n "$line" ]]; then
        # Extract the branch name - it's the last space-separated field
        local branch=$(echo "$line" | awk '{print $NF}')
        branches_to_delete+=("$branch")
      fi
    done <<<"$selected"

    if [[ ${#branches_to_delete[@]} -eq 0 ]]; then
      continue
    fi

    # Show confirmation
    echo ""
    echo "Selected ${#branches_to_delete[@]} branch(es) for deletion:"
    printf '  %s\n' "${branches_to_delete[@]}"
    echo ""
    echo "Delete these branches? (y/N/e)"
    echo "  y - Yes, delete all selected branches"
    echo "  N - No, cancel completely"
    echo "  e - Edit selection (back to FZF)"

    read -r response
    case "$response" in
    [Yy])
      echo ""
      echo "Deleting branches..."
      local deleted_count=0
      for branch in "${branches_to_delete[@]}"; do
        if git branch -D "$branch" 2>/dev/null; then
          echo "✅ Deleted: $branch"
          ((deleted_count++))
        else
          echo "❌ Failed to delete: $branch"
        fi
      done
      echo ""
      echo "Deleted $deleted_count of ${#branches_to_delete[@]} branches."
      return 0
      ;;
    [Ee])
      echo "Returning to selection..."
      continue
      ;;
    *)
      echo "Cancelled."
      return 0
      ;;
    esac
  done
}
