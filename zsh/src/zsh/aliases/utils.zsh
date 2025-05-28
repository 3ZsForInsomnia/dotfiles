alias j='jump'
alias b='bookmark'
alias shm='showmarks'

function mkcd() {
  if [ -z "$1" ]; then
    echo "Usage: mkcd <directory>"
    return 1
  fi

  mkdir -p "$1" && cd "$1" || return 1
}

function o() {
  if [[ $1 == "www."* ]]; then
    str="https://$1"
  else
    str=$1
  fi

  open_command=""
  if [[ "$MY_SYSTEM" == "mac" ]]; then
    open_command="command open"
  elif [[ "$MY_SYSTEM" == "linux" ]]; then
    open_command="xdg-open"
  fi

  command="$open_command $str"
  eval "$command"
}

alias makeExecutable='chmod +x'
function seeMemory() {
  if [[ "$MY_SYSTEM" == "mac" ]]; then
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f MB\n", "$1:", $2 * $size / 1048576);'
  elif [[ "$MY_SYSTEM" == "linux" ]]; then
    free -m
  else
    echo "Memory stats not supported on this platform"
  fi
}

function seeCpu() {
  if command -v htop &>/dev/null; then
    htop
  elif [[ "$MY_SYSTEM" == "mac" ]]; then
    top -o cpu
  elif [[ "$MY_SYSTEM" == "linux" ]]; then
    top
  else
    echo "CPU monitor not available"
  fi
}

function backup() {
  eval 'cp $1 $1.bak'
}

function sortProcsByFilesOpen() {
  if command -v lsof &>/dev/null; then
    lsof -n | awk '{print $1}' | uniq -c | sort -rn | head -n 5
  else
    echo "Error: lsof command not found"
    return 1
  fi
}

function getProcessUsingPort() {
  if [[ -z "$1" ]]; then
    echo "Usage: getProcessUsingPort <port_number>"
    return 1
  fi
  
  if [[ "$MY_SYSTEM" == "mac" ]]; then
    lsof -iTCP:"$1" -sTCP:LISTEN
  elif [[ "$MY_SYSTEM" == "linux" ]]; then
    lsof -iTCP:"$1" -sTCP:LISTEN
  else
    netstat -ano | grep "LISTENING" | grep ":$1"
  fi
}

function killPort() {
  port="$1"
  pids=$(getProcessUsingPort "$port" | awk 'NR>1 {print $2}')
  if [[ -n "$pids" ]]; then
    echo "Killing processes $pids using TCP port $port"
    kill -9 "$pids"
  else
    echo "No process found using TCP port $port"
  fi
}

function killProcess() {
  if [ -z "$1" ]; then
    echo "Usage: killProcess <process_name>"
    return 1
  fi
  pids=$(pgrep -f "$1")
  if [ -n "$pids" ]; then
    echo "Killing processes matching: $1"
    kill -9 $pids
  else
    echo "No processes matching: $1"
  fi
}

alias kp='killProcess'

alias lc='wc -l'

# $1=file extension
function lineCountForFolder() {
  echo "Consider using 'tokei' instead (it should already be installed)"
  
  local cmd=""
  if command -v fd &>/dev/null; then
    cmd="fd"
  elif command -v find &>/dev/null; then
    cmd="find"
  else
    echo "Neither fd nor find command available"
    return 1
  fi
  
  if [ -z "$1" ]; then
    if [[ "$cmd" == "fd" ]]; then
      fd --glob '*.*' | xargs wc -l
    else
      find . -type f | xargs wc -l
    fi
  else
    if [[ "$cmd" == "fd" ]]; then
      fd --glob "*.${1}" | xargs wc -l
    else
      find . -type f -name "*.${1}" | xargs wc -l
    fi
  fi
}

function runThenReturn() {
  pwd=$(pwd)
  eval "$1"
  cd "$pwd"
}

function default() {
  if [[ -z "$1" ]]; then
    echo "$2"
  else
    echo "$1"
  fi
}

function isMacLinuxOrWin() {
  unameExists=$(command -v uname)
  if [[ -z "$unameExists" ]]; then
    echo "windows"
  fi
  output=$(uname -s)
  if [[ ${output} == "Darwin" ]]; then
    echo "mac"
  elif [[ ${output} == "Linux" ]]; then
    echo "linux"
  fi
}

# First arg: Message
# Second arg: Optional title
function createNotification() {
  if [[ "$MY_SYSTEM" == "mac" ]]; then
    if [[ -z "$2" ]]; then
      osascript -e "display notification \"$1\""
    else
      osascript -e "display notification \"$1\" with title \"$2\""
    fi
  elif [[ "$MY_SYSTEM" == "linux" ]]; then
    if [[ -z "$2" ]]; then
      notify-send "$1"
    else
      notify-send "$2" "$1"
    fi
  fi
}

function find_index {
  local input="$1"
  shift
  local options=("$@")
  
  for i in $(seq 1 ${#options[@]}); do
    if [[ "${options[$i]}" == "$input" ]]; then
      echo "$i"
      return 0
    fi
  done

  echo "-1"
  return 1
}

function checkArgument() {
  local arg_to_check="$1"
  shift
  local allowed_values=("$@")
  
  local is_allowed=0
  
  for value in "${allowed_values[@]}"; do
    if [[ "$arg_to_check" == "$value" ]]; then
      is_allowed=1
      break
    fi
  done
  
  if (( is_allowed )); then
    return 0  # Success
  else
    echo "Error: '$arg_to_check' is not an allowed value."
    echo "Allowed values are: ${allowed_values[@]}"
    return 1  # Failure
  fi
}

function toUpper() {
  tr '[:lower:]' '[:upper:]'
}

# Extract any archive automatically
function extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar e "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

