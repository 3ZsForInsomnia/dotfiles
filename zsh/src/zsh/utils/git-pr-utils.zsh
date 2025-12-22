# This script is responsible for fetching pull request data from GitHub
# for local branches that have been merged or closed.

# It uses a single, efficient GraphQL query to minimize API calls.

function _debug_log() {
  if [[ -n "$DEBUG_GPRUNE" ]]; then
    echo "[DEBUG] $*" >&2
  fi
}

function _get_merged_closed_prs_with_local_branches_json() {
  # 1. Get the current repository owner and name
  local repo

  _debug_log "Getting repository info"
  repo=$(gh repo view --json owner,name --jq '.owner.login + "/" + .name' 2>/dev/null)
  _debug_log "Repository: $repo"

  if [[ -z "$repo" ]]; then
    echo "Error: Could not determine GitHub repository." >&2
    return 1
  fi

  # 2. Get all local branches, excluding the main branch
  local local_branches
  _debug_log "Getting local branches (excluding $GIT_MAIN_BRANCH)"
  # Use rg with -I (--no-filename) and -N (--no-line-number) to prevent prefixes
  local_branches=(${(f)"$(git for-each-ref --format='%(refname:short)' refs/heads/ | rg -I -N -v "^($GIT_MAIN_BRANCH)$")"})
  _debug_log "Found ${#local_branches[@]} local branches: ${local_branches[*]}"

  if [[ ${#local_branches[@]} -eq 0 ]]; then
    echo "[]"
    return 0
  fi

  # 3. Dynamically construct the GraphQL query with an alias for each branch
  _debug_log "Constructing GraphQL query for ${#local_branches[@]} branches"
  local graphql_query="query {"
  local graphql_alias
  for branch in "${local_branches[@]}"; do
    # Create a valid GraphQL alias from the branch name.
    # The variable is named `graphql_alias` to avoid collision with the `alias` shell command.
    graphql_alias=$(echo "$branch" | tr -c 'a-zA-Z0-9_' '_')
    # Each part of the query finds the first merged or closed PR for that head branch
      graphql_query+="
        ${graphql_alias}: search(query: \"repo:${repo} is:pr head:\\\"${branch}\\\" is:closed\", type: ISSUE, first: 1) {
        nodes {
          ... on PullRequest {
            number
            title
            state
            headRefName
            author { login }
            mergedAt
            createdAt
            body
            labels(first: 10) { nodes { name } }
            assignees(first: 5) { nodes { login } }
            reviews(first: 5) { nodes { author { login } state } }
            statusCheckRollup: commits(last: 1) {
              nodes {
                commit {
                  statusCheckRollup { state }
                }
              }
            }
          }
        }
      }
    "
  done
  graphql_query+="}"
  _debug_log "GraphQL query constructed (first 500 chars): ${graphql_query:0:500}"

  # 4. Execute the GraphQL query using gh api
  local result_json

  _debug_log "Executing GraphQL query via gh api"
  result_json=$(gh api graphql -f query="$graphql_query" 2>&1)
  local gh_exit_code=$?
  _debug_log "gh api exit code: $gh_exit_code"
  _debug_log "result_json (first 500 chars): ${result_json:0:500}"


  if [[ -z "$result_json" ]]; then
    echo "[]"
    return 0
  fi

  # 5. Process the results: flatten the aliased structure into a single JSON array
  # The `jq` command now ensures that if the result of the filtering is empty,
  # it outputs an empty array `[]` instead of `null` or an empty string.
  local final_json
  _debug_log "Processing result_json with jq"
  final_json=$(echo "$result_json" | jq -c '[(.data // {}) | to_entries[] | .value.nodes[] | select(. != null)]' 2>&1)
  local jq_exit_code=$?
  _debug_log "jq exit code: $jq_exit_code"
  _debug_log "final_json: $final_json"

  if [[ -z "$final_json" || "$final_json" == "null" ]]; then
    _debug_log "final_json is empty or null, returning []"
    echo "[]"
  else
    _debug_log "Returning final_json with length: ${#final_json}"
    echo "$final_json"
  fi
}
