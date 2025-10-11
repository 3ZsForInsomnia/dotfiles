alias por="poetry run"
alias posh="poetry shell"
alias porp="por python"

alias httpServe='python ~/simpleHTTP.py'
alias olo='python3 -m http.server'
function curlJSON() {
  eval 'curl -X POST -H "Content-Type: application/json" -d @$1 http://localhost:8000'
}

alias p='python3'
alias p3='python3'

alias pe='pyenv'
alias pel='pyenv local'
alias peg='pyenv global'

alias ve='venv'
alias vea='. .venv/bin/activate'
alias veag="~/.global-py/bin/activate"

function flaskAppStart() {
  flask --app "$1" run --debug
}
alias fas='flaskAppStart'
