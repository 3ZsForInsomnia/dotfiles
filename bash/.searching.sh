grepFile() {
  eval 'lss G $1'
}
alias grf='grepFile'

alias lsg='lss G'

alias fzz="fzf --ansi --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias fzzp="fzz PC"
alias fzzv="v | fzz"
