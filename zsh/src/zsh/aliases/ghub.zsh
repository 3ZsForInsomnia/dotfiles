# USAGE: select_run_for_workflow <workflow_file> <n>
# Returns the run id of a selected run
select_run_for_workflow() {
  local workflow=$1
  local n=${2:-10}
  gh run list --workflow "$workflow" -L "$n" --json databaseId,displayTitle,headBranch,status,conclusion,createdAt \
    --jq '.[] | "\(.databaseId)\t[\(.createdAt)] \(.displayTitle) (\(.headBranch)) [\(.status):\(.conclusion)]"' \
    | fzf --prompt="Select run: " | awk '{print $1}'
}

# USAGE: viewLogsFor <workflow_file> [n]
# Shows the logs for a selected recent run
viewGhubLogsFor() {
  local workflow=$1
  local n=${2:-10}
  local run_id=$(select_run_for_workflow "$workflow" "$n")
  if [[ -z $run_id ]]; then
    echo "No run selected."
    return 1
  fi
  gh run view --log "$run_id"
}
