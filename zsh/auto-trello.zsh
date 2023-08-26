function getBoard() {
  boards=("0 Inbox" "1 Job" "2 Projects" "3 Music" "4 Chores" "5 Health" "6 Reading" "7 Recurring")
  echo "${boards[$(($1 + 1))]}"
}

function getList() {
  lists=("Backlog" "To Do" "Doing" "Done")
  echo "${lists[$(($1 + 1))]}"
}

# $1 = board
# $2 = list
# $3 = card title
# $4 = card description
function tadd() {
  board=$(getBoard "$1")
  list=$(getList "$2")
  trello add-card -b "$board" -l "$list" "$3" "$4"
}

# $1 = title
# $2 = description
function tqa() {
  tadd "1" "2" "$1" "$2"
}

# $1 = card ID
# $2 = list (destination)
# $3 = board (destination, only needed if changed)
function tmove() {
  list=$(getList "$2")
  if [[ -z "$3" ]]; then
    board=$(getBoard "$3")
    trello move-card "$1" "$list" "$board"
  else
    trello move-card "$1" "$list"
  fi
}

# $1 = board
# $2 = list
# Moves a card from to-do to doing
function tstart() {
  id=$(tgetid "$1" "To Do")
  tmove "$id" "Doing"
}

# $1 = board
# $2 = list
# Moves a card from doing to done
function tfinish() {
  id=$(tgetid "$1" "Doing")
  tmove "$id" "Done"
}

# $1 = board
# $2 = list
# Moves a card from done back to doing
function tunfinish() {
  id=$(tgetid "$1" "Done")
  tmove "$id" "Doing"
}

# $1 = card ID || board
# $2 = list
function tdet() {
  if [[ -z "$2" ]]; then
    trello card-details "$1"
  else
    id=$(tgetid "$1" "$2")
    trello card-details "$id"
  fi
}

# $1 = board
function tgd() {
  board=$(getBoard "$1")
  trello show-cards -b "$board" -l "Doing"
}

# $1 = board
function tgu() {
  board=$(getBoard "$1")
  trello show-cards -b "$board" -l "To Do"
}

# $1 = board
# $2 = list
function tget() {
  board=$(getBoard "$1")
  list=$(getList "$2")

  trello show-cards -b "$board" -l "$list"
}

# $1 = board
# $2 = list
function tgetid() {
  tget "$1" "$2" | fzf | cut -d ' ' -f 2
}
