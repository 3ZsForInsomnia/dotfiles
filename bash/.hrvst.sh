# $1 = command
# $2 = subcommand
function h() {
  hrvst "$1" "$2" --is_active
}

# $1 = subcommand
function ht() {
  h "tasks" "$1"
}

function htl() {
  ht "list"
}

# $1 = subcommand
function hp() {
  h projects "$1"
}

function hpl() {
  hp list
}

alias hal='hrvst alias list'

# $1 = hours as decimal
# $2 = project
# $3 = task
function hlog() {
  echo "h log "$(("$1"))" --project_id $2 --task_id $3 --editor"
}

function hlogm() {
  hlog "$2" 38620315 "$1"
}

function hlogp() {
  hlog "$2" 38620324 "$1"
}

alias hlpm='hlogp 19405816'
alias hlph='hlogp 21414436'
alias hlpp='hlogp 21414435'
alias hlpn='hlogp 21414438'
alias hlpf='hlogp 21414437'
alias hlpl='hlogp 21414439'

alias hlmh='hlogp 21414260'
alias hlmm='hlogp 21414192'
alias hlmp='hlogp 21414195'
alias hlmo='hlogp 21414264'
alias hlmc='hlogp 21414193'

# Prints options for hlog
function hlogo() {
  echo "Project can be \"me\" or \"pro\""
  echo "ME tasks can be: health, music, misc, project, chores/hygiene"
  echo "PRO tasks can be: meetings, prep, help, feat, nonfeat, learn"
}
