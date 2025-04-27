# $1 - status
# $2 - emoji - defaults to tomato
# $3 - time - defaults to 25 minutes
function setSlack() {
  statusMessage=$(default "$1" "Busy")
  emoji=$(default "$2" "tomato")
  time=$(default "$3" "25")

  curl "$SLACK_ZAP_WEBHOOK" -G \
    --data-urlencode "message=$statusMessage" \
    --data-urlencode "emoji=:$emoji:" \
    --data-urlencode "time='in $time minutes'"
}

# $1 - Optional status message
function setSlackToAvailable() {
  setSlack "$1" ":large-green-circle:" ""
}

# $1 - What am I working on?
# $2 - How long will I be working on it?
function setSlackToBusy() {
  message=$(default "Busy: $1" "Busy")
  setSlack "$message" "tomato" "$2"
}
