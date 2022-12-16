mgmt=manage.py
rs=runserver

alias httpServe='python ~/simpleHTTP.py'
alias dfe='python $mgmt $rs'

alias pipstall='pip install --editable .'
alias p='python'
alias p3='python3'
alias psrvp='py $mgmt $rs 8000'
alias pymig='py $mgmt migrate'
alias prsv='py $mgmt $rs'
alias pyman='py $mgmt'
alias pymans='pyman $rs'

alias pe='pyenv'
alias pel='pyenv local'
alias peg='pyenv global'

alias da='django-admin'

alias olo='python3 -m http.server'

# alias serve='python ~/simplePostServer.py 8000'
curlJSON() {
  eval 'curl -X POST -H "Content-Type: application/json" -d @$1 http://localhost:8000'
}
