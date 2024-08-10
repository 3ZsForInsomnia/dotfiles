function wttr() {
  curl "wttr.in/$MY_LOCATION?u"
}
function wttr1() {
  curl "wttr.in/$MY_LOCATION?1"
}
function wttr3() {
  curl "wttr.in/$MY_LOCATION?3&u"
}
function wttrpng() {
  curl "wttr.in/$MY_LOCATION.png?u" >"$HOME/Downloads/wttr.png" && open "$HOME/Downloads/wttr.png"
}

function fup() {
  result=$(fuckitup -f "$@")
  echo "$result" PC
  echo "$result"
}
function fupc() {
  result=$(fuckitup -c "$@")
  echo "$result" PC
  echo "$result"
}

alias po="pomojs --log ~/.pomo.log --tmux"
alias pol='po -w 30 -b 5'
alias pos='po -d 15'

alias oreg='o https://regex101.com'
alias gogh='bash -c "$(curl -sLo- https://git.io/vQgMr)"'
alias ogogh='o http://mayccoll.github.io/Gogh/'

alias lpa='lpass'
alias lpas='lpa show --password'

# Neccessary as http-server (npx library) asserts its alias as http, which httpie uses
alias http='/opt/homebrew/bin/http' # This is httpie's script
alias http-server='$HOME/.npm/_npx/e5196fa6dc3cecbc/node_modules/.bin/http-server'

alias task='node ~/tasks.js'

alias img='wezterm imgcat '

alias lzd="lazydocker"
