# source ~/.java.sh
source ~/.js-ts.sh
source ~/.git-stuff.sh
source ~/.python.sh
source ~/.searching.sh
source ~/.misc.sh
source ~/.db.sh
source ~/.dates.sh
source ~/.config/mutt/base.sh
# source ~/work.sh
source ~/.hrvst.sh

alias src='j src'
alias utils='j utils'
alias dots='j dots'
alias shots='j shots'

alias fe='j fe'
alias plat='j plat'
alias sur='j sur'
alias kit='j kit'
alias shared='j shared'
alias notes='j notes'

alias twerk='node ~/src/logging-cli/index.js'
alias mightTwerk='twerk -p'
alias mightTwerkCore='twerk -c -p'
alias fullDayTwerk='echo "Main:"; mightTwerk; echo "Core:"; mightTwerkCore;'
alias willTwerk='twerk -s'
alias willTwerkToday='twerk -s -t'
alias emptyTheMightTwerk='twerk -x'
alias killTwerkHistory='twerk -xxx'
alias didTwerk='twerk -d'

alias trackedTime='node ~/src/logging-cli/harvest/client.js'
alias food='node ~/src/logging-cli/cal-score.js'
alias shareTodaysTwerk='value=$(node ~/src/logging-cli/share-todays-twerkout.js -t); echo $value PC; echo $value'
alias shareTomorrowsTwerk='value=$(node ~/src/logging-cli/share-todays-twerkout.js); echo $value PC; echo $value'

alias keepAwake='cd /Applications; ./delay-screensaver.command'

alias rss='newsboat;'
alias mutt='neomutt'
alias ms='mailsync; notmuch new; mutt; mailsync &'
alias cal='gcalcli'
function loginToGcalCli() {
  gcalcli --client-id="$GCALCLI_CLIENT_ID" --client-secret="$1" agenda
}
# . "$HOME/.cargo/env"

export TZ='America/New_York'
export CRON_LOG="$HOME/.local/state/cron/cron.log"

alias getTheWeather="curl 'wttr.in/$MY_LOCATION?format=1&u' > ~/.local/state/weather/currentWeather.txt"

# alias scon="/Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli --uid $(id -u $(whoami))"
alias scon="/Applications/SelfControl.app/Contents/MacOS/org.eyebeam.SelfControl $(id -u $(whoami)) --install"
function selfControlBlock() {
  if [[ -z "$1" ]]; then
    block="socialMedia"
  else
    block=$1
  fi

  if [[ -z "$2" ]]; then
    t="26"
  else
    t=$2
  fi

  d="$(date -v+"$t"M -u "+%Y-%m-%d %H:%M:%S")"
  l="$SELFCONTROL_BLOCKLISTS$block.selfcontrol"
  # scon start --blocklist "$l" --enddate "$d"
  scon "$l" "$d"
}
alias scos="selfControlBlock"

alias lux="node ~/luxafor.js"
