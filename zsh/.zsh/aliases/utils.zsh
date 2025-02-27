alias j='jump'
alias b='bookmark'
alias shm='showmarks'

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
alias seeMemory='free -m'
alias seeCpu='htop'

backup() {
  eval 'cp $1 $1.bak'
}

alias sortProcsByFilesOpen='lsof -n A '{print $1}' | uniq -c SO -rn H -n 5'

getPort() {
  eval 'lsof -n -i :$1 G LISTEN'
}
killPort() {
  str=$(getPort $1 A '{print $2}')
  echo "$str"

  command="kill $str"
  eval "$command"
}
killProcess() {
  process=$(ps P C -d " " -f 1)
  kill -9 "$process"
}
alias kp='killProcess'

alias lc='wc -l'

# $1=file extension
lineCountForFolder() {
  echo "Consider using `tokei` instead (it should already be installed)"
  if [ -z "$1" ]; then
    fd --glob '*.*' | xargs wc -l
  else
    fd --glob "*.${1}" | xargs wc -l
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
createNotification() {
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
  
  # Iterate over the options array to find the index of the input
  for i in "${!options[@]}"; do
    if [[ "${options[$i]}" == "$input" ]]; then
      echo "$i"
      return 0  # Success
    fi
  done

  # If no match is found, return -1
  echo "-1"
  return 1  # Failure
}

function check_input {
  local input="$1"
  local -a options=("${(@P)2}") # Access array by name using parameter expansion

  # Check if the input is in the options array
  for option in "${options[@]}"; do
    if [[ "$input" == "$option" ]]; then
      return 0  # If input matches an option, return success
    fi
  done

  # If no match is found, emit a message with allowed options
  echo "The allowed set of options is: ${options[@]}"
  return 1  # Return failure
}
