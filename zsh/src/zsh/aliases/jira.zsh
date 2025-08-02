alias myJira="jira issue list -a$(jira me) -s~Done -s~Canceled -q'project IS NOT EMPTY'"

alias jiraopen="jira issue list -sopen"
alias viewJiraTicket="jira issue view --comments 5"
alias viewCurrentTicket="jira issue view $(current_branch) --comments 5"

alias viewUsersTickets="jira issue list -sopen -s'In Progress' -s'Blocked' -s'CODE REVIEW' -q'project IS NOT EMPTY' -a"

function assignTicket() {
  local issue_id=$1
  local assignee=$2

  if [[ -z $issue_id || -z $assignee ]]; then
    echo "Usage: assign"
  fi

  jira issue assign "$issue_id" "$assignee"
}

function assignMe() {
  local issue_id=$1

  if [[ -z $issue_id ]]; then
    echo "Usage: assignMe <issue_id>"
    return 1
  fi

  jira issue assign "$issue_id" "$(jira me)"
}

function watchTicket() {
  jira issue watch "$1" "$(jira me)"
}

function commentOn() {
  local issue_id=$1
  shift # Remove issue_id from positional parameters
  local comment="$*"

  if [[ -z $issue_id ]]; then
    echo "Usage: commentOn <issue_id> <comment (optional)>"
    return 1
  fi

  if [[ -z $comment ]]; then
    # Opens the default editor to add a comment
    jira issue comment "$issue_id"
  else
    jira issue comment "$issue_id" "$comment"
  fi
}

function moveTicketTo() {
  local issue_id=$1
  local status=$2

  if [[ -z $issue_id || -z $status ]]; then
    echo "Usage: moveTicketTo <issue_id> <status>"
    return 1
  fi

  jira issue move "$issue_id" "$status"
}

# Usage: moveCurrentTicketTo [status]
# If no status is provided, it will prompt to select one
moveCurrentTicketTo() {
  # Get current branch name
  local branch=$(git branch --show-current)

  # Extract ticket ID using regex
  local ticket_id
  if [[ $branch =~ (SC-[0-9]+|POD[1-4]-[0-9]+) ]]; then
    ticket_id=${BASH_REMATCH[1]}
  else
    echo "Current branch '$branch' doesn't contain a valid Jira ticket ID (SC-XXXX or PODX-XXXX)"
    return 1
  fi

  # If no status provided, let user select from common statuses
  local status=$1
  if [[ -z $status ]]; then
    local statuses=("$jira_doing" "$jira_rev" "$jira_qa")
    status=$(printf "%s\n" "${statuses[@]}" | fzf --prompt="Move ticket $ticket_id to: ")

    if [[ -z $status ]]; then
      echo "No status selected."
      return 1
    fi
  fi

  echo "Moving $ticket_id to $status..."
  moveTicketTo "$ticket_id" "$status"
}

# Convenience aliases
alias moveCurrTicketToReview="moveCurrentTicketTo \"$jira_rev\""
alias moveCurrTicketToQA="moveCurrentTicketTo \"$jira_qa\""
alias moveCurrTicketToInProgress="moveCurrentTicketTo \"$jira_doing\""

# Statuses
export jira_open="Open"
export jira_blocked="Blocked"
export jira_doing="In Progress"
export jira_rev="Code Review"
export jira_qa="QA Review"
export jira_done="Done"

# Issue link types
export jira_relates=" relates to "
export jira_blocks=" blocks "
export jira_blocked_by=" is blocked by "
export jira_depends_on=" depends on "
export jira_fixes=" fixes "
export jira_done_before=" has to be done before "
export jira_done_after=" has to be done after "

# First arg is confluence doc ID
function getConfluenceDoc() {
  local doc_id=$1
  local base_path="$W_PATH/platform/confluence"

  local url="https://onedigitalproduct.atlassian.net/wiki/rest/api/content/$doc_id?expand=body.storage"
  local download_location="$base_path/$doc_id.json"

  curl -u "$WORK_EMAIL:$JIRA_API_TOKEN" "$url" >"$download_location"

  # Extract and sanitize title
  local title=$(jq -r '.title' "$download_location" | tr ' /:' '_' | tr -cd '[:alnum:]_-.')
  local new_location="$base_path/${title}.json"

  mv "$download_location" "$new_location"
  echo "Saved as $new_location"
}
