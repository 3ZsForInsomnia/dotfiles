#!/usr/bin/env zsh

# Process utility functions
# Reusable functions for process and port management

# Get running processes with PID and name
# Output format: "PID:process_name" one per line
getRunningProcesses() {
  if [[ "$OSTYPE" == darwin* ]]; then
    # macOS
    ps -eo pid,comm | tail -n +2 | awk '{print $1":"$2}'
  else
    # Linux
    ps -eo pid,comm --no-headers | awk '{print $1":"$2}'
  fi
}

# Get process information by port number
# Usage: getProcessByPort <port>
# Output format: "PID:process_name:port" or empty if not found
getProcessByPort() {
  local port="$1"
  
  if [[ -z "$port" ]]; then
    echo "Error: port number required" >&2
    return 1
  fi
  
  if [[ "$OSTYPE" == darwin* ]]; then
    # macOS - use lsof
    lsof -ti :"$port" 2>/dev/null | while read -r pid; do
      local proc_name=$(ps -p "$pid" -o comm= 2>/dev/null)
      [[ -n "$proc_name" ]] && echo "${pid}:${proc_name}:${port}"
    done
  else
    # Linux - use lsof or netstat fallback
    if command -v lsof >/dev/null 2>&1; then
      lsof -ti :"$port" 2>/dev/null | while read -r pid; do
        local proc_name=$(ps -p "$pid" -o comm= 2>/dev/null)
        [[ -n "$proc_name" ]] && echo "${pid}:${proc_name}:${port}"
      done
    else
      # Fallback to netstat
      local pid=$(netstat -tlnp 2>/dev/null | grep ":${port} " | awk '{print $7}' | cut -d'/' -f1)
      if [[ -n "$pid" ]]; then
        local proc_name=$(ps -p "$pid" -o comm= 2>/dev/null)
        [[ -n "$proc_name" ]] && echo "${pid}:${proc_name}:${port}"
      fi
    fi
  fi
}
