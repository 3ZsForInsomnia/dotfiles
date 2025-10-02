alias ghs="gh copilot suggest -t shell"
alias ghe="gh copilot explain"

function ghen() {
  if [[ -z "$1" ]]; then
    echo "Usage: cop_explain <entry-number>"
    return 1
  fi

  local entry
  entry=$(cl "$1")
  gh copilot explain "'$entry'"
}

# USAGE: select_run_for_workflow <workflow_file> <n>
# Returns the run id of a selected run
function select_run_for_workflow() {
  local workflow=$1
  local n=${2:-10}
  gh run list --workflow "$workflow" -L "$n" --json databaseId,displayTitle,headBranch,status,conclusion,createdAt \
    --jq '.[] | "\(.databaseId)\t[\(.createdAt)] \(.displayTitle) (\(.headBranch)) [\(.status):\(.conclusion)]"' |
    fzf --prompt="Select run: " | awk '{print $1}'
}

# USAGE: viewGhubPrChecks <pr_number>
# Shows the status of checks for a specified PR and opens logs in browser
function viewGhubPrChecks() {
  local pr_number=$1

  if [[ -z $pr_number ]]; then
    echo "No PR number provided."
    return 1
  fi

  # Get the head branch name from the PR
  local pr_head
  pr_head=$(gh pr view "$pr_number" --json headRefName --jq '.headRefName')

  if [[ -z $pr_head ]]; then
    echo "Could not determine PR head branch."
    return 1
  fi

  echo "Finding workflow runs for branch: $pr_head"

  # List runs from the PR branch (newest to oldest)
  local run_id
  run_id=$(gh run list --branch "$pr_head" -L 20 --json databaseId,name,headBranch,status,conclusion,createdAt \
    --jq '.[] | "\(.databaseId)\t[\(.createdAt)] \(.name) (\(.headBranch)) [\(.status):\(.conclusion)]"' |
    sort -r |
    fzf --prompt="Select workflow run: " | awk '{print $1}')

  if [[ -z $run_id ]]; then
    echo "No run selected."
    return 1
  fi

  echo "Selected run ID: $run_id"

  # Give user option to view entire run or specific job
  local view_option
  view_option=$(echo -e "View entire run\nSelect specific job" | fzf --prompt="Choose view option: ")

  if [[ $view_option == "View entire run" ]]; then
    echo "Opening run in browser"
    gh run view --web "$run_id"
  else
    # Get jobs for this run (newest first)
    local job_id
    job_id=$(gh run view "$run_id" --json jobs \
      --jq '.jobs[] | "\(.databaseId)\t\(.name) [\(.status):\(.conclusion)] - \(.startedAt)"' |
      sort -r |
      fzf --prompt="Select job to view logs: " | awk '{print $1}')

    if [[ -z $job_id ]]; then
      echo "No job selected."
      return 1
    fi

    echo "Opening job in browser"
    gh run view --job "$job_id" --web
  fi
}
