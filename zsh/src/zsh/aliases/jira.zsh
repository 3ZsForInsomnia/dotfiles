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
  shift  # Remove issue_id from positional parameters
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
