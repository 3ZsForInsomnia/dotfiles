# $1 - status - or -h for help
# $2 - emoji - defaults to tomato
# $3 - time - defaults to 25 minutes
function setSlack() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: setSlack [status message] [emoji] [time]"
    echo "Example: setSlack 'In a meeting' 'calendar' '30'"
    return 0
  fi

  statusMessage=$(default "$1" "Busy")
  emoji=$(default "$2" "tomato")
  time=$(default "$3" "30")

  curl "$SLACK_ZAP_WEBHOOK" -G \
    --data-urlencode "message=$statusMessage" \
    --data-urlencode "emoji=:$emoji:" \
    --data-urlencode "time='in $time minutes'"
}

function clearSlackStatus() {
  curl "$SLACK_ZAP_WEBHOOK" -G \
    --data-urlencode "clear=true"
}
alias slackClear="clearSlackStatus"

# $1 - Optional status message - or -h for help
function setSlackToAvailable() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: setSlackToAvailable [status message]"
    echo "Example: setSlackToAvailable 'Available'"
    return 0
  fi

  message=$(default "$1" "Available")

  clearSlackStatus
  setSlack "$message" ":large_green_circle:" ""
}
alias slackAvailable="setSlackToAvailable"

# $1 - What am I working on? Or -h for help
# $2 - How long will I be working on it?
function setSlackToBusy() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: setSlackToBusy [status message] [time]"
    echo "Example: setSlackToBusy 'In a meeting' '30'"
    return 0
  fi

  message=$(default "Busy: $1" "Busy")

  clearSlackStatus
  setSlack "$message" "tomato" "$2"
}
alias slackBusy="setSlackToBusy"

function setSlackToSmallTask() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: setSlackToSmallTask [status message] [time]"
    echo "Example: setSlackToSmallTask 'Code review' '15'"
    return 0
  fi

  message=$(default "Working on: $1" "Working")

  clearSlackStatus
  setSlack "$message" ":tomato:" "30"
}
alias slackSmall="setSlackToSmallTask"

function setSlackToLargeTask() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: setSlackToLargeTask [status message] [time]"
    echo "Example: setSlackToLargeTask 'Writing documentation' '60'"
    return 0
  fi

  message=$(default "Working on: $1" "Working")

  clearSlackStatus
  setSlack "$message" ":tomato:" "60"
}
alias slackLarge="setSlackToLargeTask"

alias setSlackToPRs="setSlackToSmallTask 'Reviewing PRs'"
