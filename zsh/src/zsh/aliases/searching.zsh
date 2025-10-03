alias alg='alias P'

alias ls='eza -lahUm -F --icons --git'
alias lsg='ls G'
alias lsd='eza -lahUmD -F --icons -I ".git"'

function lsrFunc() {
  if [ -z "$1" ]; then
    eza -lahRTUm -F --git -I ".git" --icons
  else
    eza -lahRTUm -F --git -I ".git" --icons -L $1
  fi
}
alias lsr='lsrFunc'
alias lsrg='eza -lahRTUm -F --git -I ".git" --icons G'

alias grep='rg -i'
alias find='fd -H'
alias f='find'
alias ff='f | fzz'

# Searches by file extension
function fef() {
  result=$(fd -e "$1" | fzf -m --ansi --preview 'bat --style=numbers --color=always --line-range :500 {}')
  echo "$result" | copy
  echo "$result"
}

alias fzz="fzf -m --ansi --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias fzp="fzz PC"
alias fzv="fzz --bind 'enter:become(nvim {+})'"
alias fzo='o "$(fzf)"'

# ftags - search ctags with preview
# only works if tags-file was generated with --excmd=number
function ftags() {
  local line
  [ -e tags ] &&
    line=$(
      awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
        fzf \
          --nth=1,2 \
          --with-nth=2 \
          --preview-window="50%" \
          --preview="bat {3} --color=always | tail -n +\$(echo {4} | tr -d \";\\\"\")"
    ) && ${EDITOR:-vim} $(cut -f3 <<<"$line") -c "set nocst" \
    -c "silent tag $(cut -f2 <<<"$line")"
}

# fcdf - find and cd to file or directory
# Usage: fcdf [--all|-a] [query]
# Options:
#   --all, -a: Include git-ignored files
function fcdf() {
  local include_ignored=false
  local query=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --all | -a)
      include_ignored=true
      shift
      ;;
    *)
      query="$1"
      shift
      ;;
    esac
  done

  local fd_cmd="fd --hidden --follow --exclude .git"
  [[ "$include_ignored" = true ]] && fd_cmd="$fd_cmd --no-ignore"
  [[ -n "$query" ]] && fd_cmd="$fd_cmd '$query'"

  local target
  target=$(eval "$fd_cmd" 2>/dev/null |
    fzf --preview="_fzf_file_preview {}" \
      --preview-window="right:60%:wrap" \
      --header="Enter=cd to file/dir, Ctrl-S=inspect, Alt-V=open in nvim")

  if [[ -n "$target" ]]; then
    if [[ -d "$target" ]]; then
      cd "$target" || return 1
      echo "Changed to directory: $target"
    else
      local dir
      dir=$(dirname "$target")
      cd "$dir" || return 1
      echo "Changed to directory: $dir (parent of $target)"
    fi
  else
    echo "No target selected."
    return 1
  fi
}

# fda - including hidden directories
function fda() {
  local dir
  dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m) && cd "$dir" || return 0
}

# fzf bookmarks
function fbm() {
  local mark
  mark=$(cat $XDG_DATA_HOME/bookmarks/.bookmarks 2>/dev/null | fzf +m) && jump "$mark"
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
function fkill() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fkill [signal]"
    echo "Interactive process killer with enhanced preview"
    echo "Default signal is 9 (SIGKILL)"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Kill selected process(es)"
    echo "  Ctrl-S    - Show detailed process information"
    echo "  Tab       - Multi-select processes"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d |
      fzf -m --preview="_fzf_process_preview {}" \
        --preview-window="right:60%:wrap" \
        --header="Enter=kill, Ctrl-S=inspect, Tab=multi-select" |
      awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d |
      fzf -m --preview="_fzf_process_preview {}" \
        --preview-window="right:60%:wrap" \
        --header="Enter=kill, Ctrl-S=inspect, Tab=multi-select" |
      awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

function fkillport() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fkillport [port] [signal]"
    echo "Interactive port-based process killer with enhanced preview"
    echo "If port is specified, shows only processes using that port"
    echo "Default signal is 9 (SIGKILL)"
    return 0
  fi

  local port_arg=${1:-}
  local procs pid

  if [[ -n "$port_arg" ]]; then
    procs=$(getProcessUsingPort "$port_arg")
  else
    procs=$(lsof -iTCP -sTCP:LISTEN -n -P 2>/dev/null)
  fi

  if [[ -z "$procs" ]]; then
    echo "No processes found listening on ports"
    return 1
  fi

  pid=$(echo "$procs" | sed 1d |
    fzf -m --preview="_fzf_process_preview {}" \
      --preview-window="right:60%:wrap" \
      --header="Enter=kill, Ctrl-S=inspect, Tab=multi-select" \
      --prompt="Select process to kill: " |
    awk '{print $2}' | sort -u | tr '\n' ' ' | xargs)

  if [[ -n "$pid" ]]; then
    kill -${2:-9} $pid
    echo "Killed process(es) with PID: $pid"
  else
    echo "No process selected."
    return 1
  fi
}

function flp() {
  lpass show -c --password $(lpass ls | fzf | awk '{print $(NF)}' | sed 's/\]//g')
}

function fenv() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fenv"
    echo "Interactive environment variable browser"
    echo "Browse and copy environment variables to clipboard"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Copy variable to clipboard and display"
    echo "  Alt-Y     - Copy to clipboard (same as Enter)"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  local out
  out=$(env | sort |
    fzf --preview="echo {}" \
      --preview-window="up:3:wrap" \
      --header="Enter=copy to clipboard, Ctrl-C=cancel")
  echo "$out" | copy
  echo "$out"
}

function frg() {
  local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case"
  local INITIAL_QUERY="${*:-}"
  : | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2})'
}
