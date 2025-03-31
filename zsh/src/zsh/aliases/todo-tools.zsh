alias jirame="jira issue list -a$(jira me) -s~Done -s~Canceled"

alias jiraopen="jira issue list -sopen"

jiraTasksForUser() {
  jira issue list -sopen -a"$1"
}

jiraViewIssue() {
  jira issue view "pod1-$1"
}
