convertsecs() {
  ((h = ${1} / 3600))
  ((m = (${1} % 3600) / 60))
  ((s = ${1} % 60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

function nextEvent() {
  data=$(agenda 1 nocolor | head -2 | tail -1)
  a=$(echo "$data" | cut -f 2-5 -d " " | xargs)
  time="$(date +%Y) $a"
  event=$(echo "$data" | cut -f 6- -d " " | xargs)

  time2=$(date -j -f '%Y %b %d %R%p' "$time" +%s)
  now=$(date +%s)

  diff=$((time2 - now))
  diff2=$(convertsecs $diff)

  echo "$diff2 until event: $event"
}

function agenda() {
  if [[ -z "$1" ]]; then
    day="1"
  else
    day=$1
  fi

  if [[ "$1" == "t" ]]; then
    gcalcli agenda --no-military \
      --nodeclined \
      --nostarted \
      --details length \
      --details location \
      "$(date -v+1d -v0H)" "$(date -v+2d -v0H)"\;
  elif [[ "$2" == "nocolor" ]]; then
    gcalcli --nocolor agenda --no-military \
      --nodeclined \
      --nostarted \
      --details length \
      --details location \
      "$(date)" "$(date -v+"$day"d -v0H)"\;
  elif [[ -z "$2" ]]; then
    gcalcli agenda --no-military \
      --nodeclined \
      --nostarted \
      --details length \
      --details location \
      "$(date)" "$(date -v+"$day"d -v0H)"\;
  fi
}

alias tomorrow='date -v+1d -v0H'
alias writeNextEventToFile='nextEvent > /Users/zachary/.local/state/cal/nextEvent.txt'
alias ag='agenda'
