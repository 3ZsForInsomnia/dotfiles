alias -g G='| rg -i '
alias -g GV='| rg -v'
alias -g GC='| rg -C 3'

alias -g F='| fzf'

alias -g L='| less'
alias -g SO='| sort'
# Sort and remove duplicates
alias -g U='| sort | uniq'
# Sort, remove duplicates, and add number of occurrences
alias -g UC='| sort | uniq -c'
# Sort, remove duplicates, and add number of occurrences in reverse order (most frequent first)
alias -g USD='| sort | uniq -c | sort -nr'

alias -g H='| head'
alias -g H1='| head -n 10'
alias -g H2='| head -n 20'
alias -g T='| tail'
alias -g T1='| tail -n 10'
alias -g T2='| tail -n 20'

alias -g J='| jq'
alias -g Z='| fx'

alias -g X='| xargs'

alias -g C='| cut'
alias -g TR='| tr'
alias -g S='| sed'

alias -g A='| awk'
alias -g K='| awky'
awky() {
  awk -v var="$1" '{print $var}'
}

# Get the nth column
alias -g F1='| awky 1'
alias -g F2='| awky 2'
alias -g F3='| awky 3'
alias -g F4='| awky 4'
alias -g F5='| awky 5'
alias -g F6='| awky 6'
alias -g F7='| awky 7'
alias -g F8='| awky 8'
alias -g F9='| awky 9'

if [ "$MY_SYSTEM" = "linux" ]; then
  alias -g PC='| xclip -sel clip'
  alias -g PP='| xclip -sel clip -o'
elif [ "$MY_SYSTEM" = "mac" ]; then
  alias -g PC='| pbcopy'
  alias -g PP='| pbpaste'
fi

alias -g V='| nvim '
alias -g O='> wtf.txt'

alias -g W='| wc -l'
