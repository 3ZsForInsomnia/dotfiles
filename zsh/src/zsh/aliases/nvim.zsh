openNvim() {
  if [ -z "$1" ]
  then
    nvim .
  else
    nvim "$1"
  fi
}
alias v='openNvim'

genTags() {
  if [[ "$MY_SYSTEM" == "mac" ]]; then
    # /opt/homebrew/Cellar/universal-ctags/p6.1.20241229.0/bin/ctags -R --excmd=number
    # /opt/homebrew/Cellar/universal-ctags/HEAD/bin/ctags -R --excmd=number
    ctags -R --excmd=number
  elif [[ "$MY_SYSTEM" == "linux" ]]; then
    echo "I need to set this up for linux"
  fi
}

# alias mux='tmux send-keys "aliases" C-m \; split-window -h -p 70 \; send-keys "v" C-m \; split-window -v -p 30 \;'
# alias tux='tmux -u'
