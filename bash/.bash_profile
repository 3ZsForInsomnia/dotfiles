source ~/.java.sh
source ~/.js-ts.sh
source ~/.git-stuff.sh
source ~/.python.sh
source ~/.searching.sh
source ~/.work-utils.sh
source ~/.misc.sh
source ~/.db.sh

alias src='j src'
alias utils='j utils'
alias dots='j dots'

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

function rename_wezterm_title {
  echo "\x1b]1337;SetUserVar=panetitle=$(echo -n $1 | base64)\x07"
}
