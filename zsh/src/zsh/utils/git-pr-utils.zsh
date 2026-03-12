# Utilities for fetching pull request data from GitHub for local branches
# that have been merged or closed. Uses a single GraphQL query to minimize API calls.
#
# Each function is independently callable for debugging:
#   _gprune_get_local_branches
#   _gprune_build_graphql_query <repo> <branch1> <branch2> ...
#   _gprune_fetch_pr_data <graphql_query>
#   _gprune_parse_pr_results <raw_json>
#   _get_merged_closed_prs_with_local_branches_json  (composed pipeline)

function _gprune_debug_log() {
  if [[ -n "$DEBUG_GPRUNE" ]]; then
    echo "[DEBUG] $*" >&2
  fi
}

function _gprune_get_repo() {
  gh repo view --json owner,name --jq '.owner.login + "/" + .name' 2>/dev/null
}

function _gprune_get_local_branches() {
  git for-each-ref --format='%(refname:short)' refs/heads/ \
    | rg -I -N -v "^($GIT_MAIN_BRANCH)$"
}

function _gprune_build_graphql_query() {
  local repo="$1"
  shift
  local branches=("$@")

  if [[ ${#branches[@]} -eq 0 ]]; then
    echo ""
    return 1
  fi

  local query="query {"
  local alias_name
  for branch in "${branches[@]}"; do
    alias_name=$(echo "$branch" | tr -c 'a-zA-Z0-9_' '_')
    query+="
      ${alias_name}: search(query: \"repo:${repo} is:pr head:\\\"${branch}\\\" is:closed\", type: ISSUE, first: 1) {
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
  query+="}"

  echo "$query"
}

function _gprune_fetch_pr_data() {
  local graphql_query="$1"

  if [[ -z "$graphql_query" ]]; then
    echo ""
    return 1
  fi

  gh api graphql -f query="$graphql_query" 2>&1
}

function _gprune_parse_pr_results() {
  local raw_json="$1"

  if [[ -z "$raw_json" ]]; then
    echo "[]"
    return 0
  fi

  local parsed
  parsed=$(echo "$raw_json" | jq -c '[(.data // {}) | to_entries[] | .value.nodes[] | select(. != null)]' 2>&1)

  if [[ -z "$parsed" || "$parsed" == "null" ]]; then
    echo "[]"
  else
    echo "$parsed"
  fi
}

# Composed pipeline — calls each step in sequence.
function _get_merged_closed_prs_with_local_branches_json() {
  _gprune_debug_log "Getting repository info"
  local repo
  repo=$(_gprune_get_repo)
  _gprune_debug_log "Repository: $repo"

  if [[ -z "$repo" ]]; then
    echo "Error: Could not determine GitHub repository." >&2
    return 1
  fi

  _gprune_debug_log "Getting local branches (excluding $GIT_MAIN_BRANCH)"
  local local_branches
  local_branches=(${(f)"$(_gprune_get_local_branches)"})
  _gprune_debug_log "Found ${#local_branches[@]} local branches: ${local_branches[*]}"

  if [[ ${#local_branches[@]} -eq 0 ]]; then
    echo "[]"
    return 0
  fi

  _gprune_debug_log "Constructing GraphQL query for ${#local_branches[@]} branches"
  local graphql_query
  graphql_query=$(_gprune_build_graphql_query "$repo" "${local_branches[@]}")
  _gprune_debug_log "GraphQL query constructed (first 500 chars): ${graphql_query:0:500}"

  _gprune_debug_log "Executing GraphQL query via gh api"
  local result_json
  result_json=$(_gprune_fetch_pr_data "$graphql_query")
  _gprune_debug_log "result_json (first 500 chars): ${result_json:0:500}"

  _gprune_debug_log "Processing result_json with jq"
  local final_json
  final_json=$(_gprune_parse_pr_results "$result_json")
  _gprune_debug_log "final_json: $final_json"

  echo "$final_json"
}
