alias alg='alias P'

alias ls='eza -lahUm -F --icons --git'
alias lsg='ls G'
alias lsd='eza -lahUFmD --icons -I ".git"' 

function lsrFunc() {
  if [ -z "$1" ]; then
    eza -lahRTFUm --git -I ".git"--icons 
  else
    eza -lahRTFUm --git -I ".git"--icons -L $1
  fi
}
alias lsr='lsrFunc'
alias lsrg='eza -lahRTFUm --git -I ".git"--icons G'

alias grep='rg -i'
alias find='fd -H'
alias f='find'
alias ff='f | fzz'

# Searches by file extension
function fef() {
  result=$(fd -e "$1" | fzf -m --ansi --preview 'bat --style=numbers --color=always --line-range :500 {}')
  echo "$result" | pbcopy
  echo "$result"
}

alias fzz="fzf -m --ansi --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias fzp="fzz PC"
alias fzv="fzz --bind 'enter:become(nvim {+})'"
alias fzo='o "$(fzf)"'

# ftags - search ctags with preview
# only works if tags-file was generated with --excmd=number
ftags() {
  local line
  [ -e tags ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    fzf \
      --nth=1,2 \
      --with-nth=2 \
      --preview-window="50%" \
      --preview="bat {3} --color=always | tail -n +\$(echo {4} | tr -d \";\\\"\")"
  ) && ${EDITOR:-vim} $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fzf bookmarks
fbm() {
  local mark
  mark=$(cat $XDG_DATA_HOME/bookmarks/.bookmarks 2> /dev/null | fzf +m) && jump "$mark"
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

flp() {
  lpass show -c --password $(lpass ls  | fzf | awk '{print $(NF)}' | sed 's/\]//g')
}

function fkp {
  local namespace=$1

  # Get the list of pods
  pods=$(get_pods_by_namespace "$namespace")

  if [[ -z "$pods" ]]; then
    echo "No pods found in the namespace '${namespace}'"
    return 1
  fi

  # Use fzf to select a pod
  selected_pod=$(echo "$pods" | fzz --height=40% --border --prompt="Select a pod: ")

  if [[ -n "$selected_pod" ]]; then
    echo "$selected_pod" | pbcopy
    echo "$selected_pod"
  else
    echo "No pod selected."
    return 1
  fi
}

function fkd {
  local namespace=$1

  deployments=$(getKDepls "$namespace")

  selected_deployment=$(echo "$deployments" | fzp --height=40% --border --prompt="Select a deployment: ")

  if [[ -n "$selected_deployment" ]]; then
    echo "$selected_deployment" | pbcopy
    echo "$selected_deployment"
  else
    echo "No deployment selected."
    return 1
  fi
}
