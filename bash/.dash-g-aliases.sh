alias -g P='| peco'
alias -g L='| less'
alias -g G='| rg -i '
alias -g C='| cut'
alias -g J='| jq'
alias -g W='> wtf.txt'
alias -g H='| head'
alias -g T='| tail'
alias -g TR='| tr'
alias -g S='| sed'
alias -g SO='| sort'
alias -g X='| xargs'
alias -g A='| awk'
alias -g K='| awky'
awky() {
  awk -v var="$1" '{print $var}'
}

if [ "$MY_SYSTEM" = "linux" ]; then
  alias -g PC='| xclip -sel clip'
  alias -g PP='| xclip -sel clip -o'
elif [ "$MY_SYSTEM" = "mac" ]; then
  alias -g PC='| pbcopy'
  alias -g PP='| pbpaste'
fi
