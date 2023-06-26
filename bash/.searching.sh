alias fzz="fzf -m --ansi --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias fzp="fzz PC"
alias fzv="fzz --bind 'enter:become(nvim {+})'"

alias alg='alias P'

alias ls='exa -lahUFm --icons --git'
alias lsg='ls G'
alias lsd='exa -lahUFmD --icons -I ".git"' 
function lsrFunc() {
  if [ -z "$1" ]; then
    exa -lahRTFUm --git -I ".git"--icons 
  else
    exa -lahRTFUm --git -I ".git"--icons -L $1
  fi
}
alias lsr='lsrFunc'
alias lsrg='exa -lahRTFUm --git -I ".git"--icons G'

alias find='fd -H'
alias f='find'
