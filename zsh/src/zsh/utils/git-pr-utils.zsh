# This script is responsible for fetching pull request data from GitHub
# for local branches that have been merged or closed.

# It uses a single, efficient GraphQL query to minimize API calls.

function _get_merged_closed_prs_with_local_branches_json() {
  # 1. Get the current repository owner and name
  local repo

  repo=$(gh repo view --json owner,name --jq '.owner.login + "/" + .name' 2>/dev/null)

  if [[ -z "$repo" ]]; then
    echo "Error: Could not determine GitHub repository." >&2
    return 1
  fi

  # 2. Get all local branches, excluding the main branch
  local local_branches
  local_branches=(${(f)"$(git for-each-ref --format='%(refname:short)' refs/heads/ | rg -v "^($GIT_MAIN_BRANCH)$")"})

  if [[ ${#local_branches[@]} -eq 0 ]]; then
    echo "[]"
    return 0
  fi

  # 3. Dynamically construct the GraphQL query with an alias for each branch
  local graphql_query="query {"
  for branch in "${local_branches[@]}"; do
    # Create a valid GraphQL alias from the branch name.
    # The variable is named `graphql_alias` to avoid collision with the `alias` shell command.
    local graphql_alias
    graphql_alias=$(echo "$branch" | tr -c 'a-zA-Z0-9_' '_')
    # Each part of the query finds the first merged or closed PR for that head branch
      graphql_query+="
        ${graphql_alias}: search(query: \"repo:${repo} is:pr head:\\\"${branch}\\\" is:merged,closed\", type: ISSUE, first: 1) {
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

  # 4. Execute the GraphQL query using gh api
  local result_json

  result_json=$(gh api graphql -f query="$graphql_query" 2>/dev/null)


  if [[ -z "$result_json" ]]; then
    echo "[]"
    return 0
  fi

  # 5. Process the results: flatten the aliased structure into a single JSON array
  # The `jq` command now ensures that if the result of the filtering is empty,
  # it outputs an empty array `[]` instead of `null` or an empty string.
  local final_json
  final_json=$(echo "$result_json" | jq -c '[(.data // {}) | to_entries[] | .value.nodes[] | select(. != null)]')

  if [[ -z "$final_json" || "$final_json" == "null" ]]; then
    echo "[]"
  else
    echo "$final_json"
  fi
}
