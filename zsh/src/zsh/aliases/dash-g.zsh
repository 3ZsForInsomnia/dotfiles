alias -g F='| fzf'
alias -g L='| less'
alias -g G='| rg -i '
alias -g SO='| sort'

alias -g H='| head'
alias -g T='| tail'

alias -g W='| wc -l'

alias -g J='| jq'
alias -g Z='| fx'
alias -g C='| cut'
alias -g TR='| tr'

alias -g X='| xargs'
alias -g S='| sed'
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

alias -g V='| nvim '
alias -g O='> wtf.txt'
