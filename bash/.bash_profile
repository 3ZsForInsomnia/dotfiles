source ~/.java.sh
source ~/.nvim-tmux-etc.sh
source ~/.js-ts.sh
source ~/.git-stuff.sh
source ~/.python.sh
source ~/.searching.sh
source ~/.misc.sh
source ~/.db.sh
source ~/.dates.sh
source ~/.slack.sh
source ~/.work-utils.sh
source ~/.env
# source ~/.config/mutt/base.sh
# source ~/.hrvst.sh

alias src='j src'
alias dots='j dots'
alias shots='j shots'
alias shared='j shared'
alias notes='j notes'

alias rss='newsboat;'
# alias mutt='neomutt'
# alias ms='mailsync; notmuch new; mutt; mailsync &'

export TZ='America/New_York'
export CRON_LOG="$HOME/.local/state/cron/cron.log"

# alias scon="/Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli --uid $(id -u $(whoami))"
# alias scon="/Applications/SelfControl.app/Contents/MacOS/org.eyebeam.SelfControl $(id -u $(whoami)) --install"
# function selfControlBlock() {
#   if [[ -z "$1" ]]; then
#     block="socialMedia"
#   else
#     block=$1
#   fi
#
#   if [[ -z "$2" ]]; then
#     t="26"
#   else
#     t=$2
#   fi
#
#   d="$(date -v+"$t"M -u "+%Y-%m-%d %H:%M:%S")"
#   l="$SELFCONTROL_BLOCKLISTS$block.selfcontrol"
#   # scon start --blocklist "$l" --enddate "$d"
#   scon "$l" "$d"
# }
# alias scos="selfControlBlock"

alias lux="node ~/luxafor.js"

. "$HOME/.cargo/env"

alias bright='brightnessctl s '

alias alacreate='alacritty msg create-window '
