mgmt=manage.py
rs=runserver

alias httpServe='python ~/simpleHTTP.py'
alias dfe='python $mgmt $rs'

alias pipstall='pip install --editable .'
alias py='python'
alias py3='python3'
alias pyserve='py $mgmt $rs 8000'
alias pygrate='py $mgmt migrate'
alias pyfe='py $mgmt $rs'
alias pyman='py $mgmt'
alias pymans='pyman $rs'

alias pen='pyenv'
alias penl='pyenv local'
alias peng='pyenv global'

alias da='django-admin'

alias olo='python3 -m http.server'

# alias serve='python ~/simplePostServer.py 8000'
curlJSON() {
  eval 'curl -X POST -H "Content-Type: application/json" -d @$1 http://localhost:8000'
}
