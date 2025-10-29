#!/usr/bin/env zsh

# Process preview for FZF
# Usage: process.zsh <process-line>

source "${0:h}/_helpers.zsh"

local line="$1"

if [[ -z "$line" ]]; then
  echo "❌ No process line specified"
  exit 1
fi

# Extract PID from the line (assumes it's the second column)
local pid=$(echo "$line" | awk '{print $2}')

if [[ -z "$pid" || ! "$pid" =~ ^[0-9]+$ ]]; then
  echo "❌ Invalid process line: $line"
  exit 1
fi

_preview_header "🔍" "Process Details"
echo ""
echo "$line"
echo ""

# Show detailed process info
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  _preview_header "📊" "Resource Usage:"
  ps -p "$pid" -o pid,ppid,user,%cpu,%mem,etime,command 2>/dev/null || echo "Process not found"
  echo ""
  
  _preview_header "🔗" "Open Files:"
  lsof -p "$pid" 2>/dev/null | head -20 || echo "No open files or permission denied"
else
  # Linux
  _preview_header "📊" "Resource Usage:"
  ps -p "$pid" -o pid,ppid,user,%cpu,%mem,etime,cmd 2>/dev/null || echo "Process not found"
  echo ""
  
  if [[ -r "/proc/$pid/status" ]]; then
    _preview_header "ℹ️" "Process Status:"
    cat "/proc/$pid/status" | head -20
  fi
fi
