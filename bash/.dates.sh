convertsecs() {
  ((h = ${1} / 3600))
  ((m = (${1} % 3600) / 60))
  ((s = ${1} % 60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

function nextEvent() {
  data=$(gcalcli --nocolor agenda --no-military --nostarted --nodeclined --details length --details location "$(date)" "$(date -v+1d -v0H)" | head -2 | tail -1)
  a=$(echo "$data" | cut -f 2-5 -d " " | xargs)
  time="$(date +%Y) $a"
  event=$(echo "$data" | cut -f 6- -d " " | xargs)

  time2=$(date -j -f '%Y %b %d %R%p' "$time" +%s)
  now=$(date +%s)

  diff=$((time2 - now))
  diff2=$(convertsecs $diff)

  echo "$diff2 until event: $event"
}

alias tomorrow='date -v+1d -v0H'
alias writeNextEventToFile='nextEvent > /Users/zachary/.local/state/cal/nextEvent.txt'
alias ag="$HOME/.local/bin/dates.js"
alias ag1='cal agenda "$(date)" "$(tomorrow)"'
alias agm="ag -e 'aft'"
alias aga="ag -e 'eve' -s 'aft'"
alias age="ag -e 'mid' -s 'eve'"
alias agt="ag -n 1"
