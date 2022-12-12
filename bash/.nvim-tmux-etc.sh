openNvim() {
  if [ -z $1 ]
  then
    nvim .
  else
    nvim $1
  fi
}
alias v='openNvim'
alias aliases='nvim -S ~/vim-sessions/.aliases.vim'

alias genTags='ctags -R'

alias mux='tmux send-keys "cd ~/src/dotfiles/; nvim -S '~/vim-sessions/aliases.vim'" C-m \; split-window -h -p 70 \; send-keys 'v' C-m \; split-window -v -p 30 \;'
alias tux='tmux -u'
