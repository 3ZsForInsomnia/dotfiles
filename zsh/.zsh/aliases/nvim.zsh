openNvim() {
  if [ -z "$1" ]
  then
    nvim .
  else
    nvim "$1"
  fi
}
alias v='openNvim'

alias genTags='ctags -R --excmd=number'

# alias mux='tmux send-keys "aliases" C-m \; split-window -h -p 70 \; send-keys "v" C-m \; split-window -v -p 30 \;'
# alias tux='tmux -u'
