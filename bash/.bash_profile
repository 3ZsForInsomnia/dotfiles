# source ~/.java.sh
source ~/.js-ts.sh
source ~/.git-stuff.sh
source ~/.python.sh
source ~/.searching.sh
# source ~/.work-utils.sh
source ~/.misc.sh
source ~/.db.sh
source ~/.dates.sh
source ~/.config/mutt/base.sh

alias src='j src'
alias utils='j utils'
alias dots='j dots'

alias fe='j fe'
alias plat='j plat'
alias sur='j sur'
alias kit='j kit'
alias shared='j shared'

alias twerk='node ~/src/logging-cli/index.js'
alias mightTwerk='twerk -p'
alias mightTwerkCore='twerk -c -p'
alias fullDayTwerk='echo "Main:"; mightTwerk; echo "Core:"; mightTwerkCore;'
alias willTwerk='twerk -s'
alias willTwerkToday='twerk -s -t'
alias emptyTheMightTwerk='twerk -x'
alias killTwerkHistory='twerk -xxx'
alias didTwerk='twerk -d'

alias trackedTime='node ~/src/logging-cli/harvest/client.js';
alias food='node ~/src/logging-cli/cal-score.js'
alias shareTodaysTwerk='value=$(node ~/src/logging-cli/share-todays-twerkout.js -t); echo $value PC; echo $value'
alias shareTomorrowsTwerk='value=$(node ~/src/logging-cli/share-todays-twerkout.js); echo $value PC; echo $value'

alias keepAwake='cd /Applications; ./delay-screensaver.command'

alias rss='newsboat;'
alias mail='neomutt'
alias cal='gcalcli'
. "$HOME/.cargo/env"

export TZ='America/New_York';
export CRON_LOG='$HOME/.local/state/cron/cron.log'

alias getTheWeather="curl 'wttr.in/$MY_LOCATION?format=1&u' > ~/.local/state/weather/currentWeather.txt"

alias scon="/Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli --uid $(id -u $(whoami))"
function scos() {
  d=$(date -v+"$2"M -Iminutes)
  l="$SELFCONTROL_BLOCKLISTS$1.selfcontrol"
  scon start --blocklist "$l" --enddate "$d"
}
