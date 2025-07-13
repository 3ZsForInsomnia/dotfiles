alias ai='sgpt'
alias ais='sgpt --shell'
alias aip='sgpt --code'
alias aic='sgpt --chat'
alias ail='sgpt --list-chats'
alias aih='sgpt --show-chat'
alias air='sgpt --repl'

function aipy() {
  local prompt="$1"

  sgpt --code "$prompt using python"
}
