alias wttr='curl "wttr.in/HuntersPoint?u"'
alias wttr1='curl "wttr.in/HuntersPoint?1"'
alias wttr3='curl "wttr.in/HuntersPoint?format=3&u"'
alias wttrpng='curl "wttr.in/HuntersPoint.png?u" > ~/Downloads/wttr.png && open ~/Downloads/wttr.png'

alias fuckitup='~/fuckitup.js'
function fup() {
    result=$(fuckitup -f "$@");
    echo $result PC;
    echo $result;
}
function fupc() {
    result=$(fuckitup -c "$@");
    echo $result PC;
    echo $result;
}

alias po="pomojs --log ~/.pomo.log --tmux"
alias pol='pomo -w 30 -b 5'
alias pos='pomo -d 15'

alias 8ball='~/8ball.sh'
alias oreg='o https://regex101.com'
alias gogh='bash -c "$(curl -sLo- https://git.io/vQgMr)"'
alias ogogh='o http://mayccoll.github.io/Gogh/'

