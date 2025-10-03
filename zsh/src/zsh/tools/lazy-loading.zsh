#!/usr/bin/env zsh

# Optimized lazy loading system
typeset -gA LAZYLOAD_DIRS LAZYLOAD_CMDS LAZYLOAD_LOADED

# lazyLoad - Conditionally load code based on different triggers
# Usage:
#   lazyLoad directory "/path/to/trigger/dir" source_func_or_file "Optional description" [no_immediate_check]
#   lazyLoad command "some_command" source_func_or_file "Optional description"
function lazyLoad() {
  local trigger_type="$1"
  local trigger_value="$2"
  local to_load="$3"
  local description="${4:-"Lazy-loaded content"}"
  local skip_immediate="${5:-false}"
  
  # Initialize the hook system if not done already
  if [[ -z "$LAZYLOAD_HOOKS_INITIALIZED" ]]; then
    autoload -U add-zsh-hook
    LAZYLOAD_HOOKS_INITIALIZED=1
  fi
  
  case "$trigger_type" in
    directory)
      # Store in associative array for O(1) lookup
      if [[ -n "${LAZYLOAD_DIRS[$trigger_value]}" ]]; then
        LAZYLOAD_DIRS[$trigger_value]="${LAZYLOAD_DIRS[$trigger_value]}:$to_load"
      else
        LAZYLOAD_DIRS[$trigger_value]="$to_load"
        
        # Only register the hook once for all directories
        if [[ ${#LAZYLOAD_DIRS} -eq 1 ]]; then
          add-zsh-hook chpwd _lazyload_check_directory
        fi
      fi
      
      # Check immediately unless explicitly skipped
      if [[ "$skip_immediate" != "true" ]]; then
        _lazyload_check_directory
      fi
      ;;
      
    command)
      # Store in associative array
      if [[ -n "${LAZYLOAD_CMDS[$trigger_value]}" ]]; then
        LAZYLOAD_CMDS[$trigger_value]="${LAZYLOAD_CMDS[$trigger_value]}:$to_load"
      else
        LAZYLOAD_CMDS[$trigger_value]="$to_load"
        
        # Only register the hook once for all commands
        if [[ ${#LAZYLOAD_CMDS} -eq 1 ]]; then
          add-zsh-hook preexec _lazyload_check_command
        fi
      fi
      ;;
      
    *)
      echo "⚠️ Error: Unknown trigger type '$trigger_type'"
      echo "   Supported types: directory, command"
      return 1
      ;;
  esac
}

# Single directory check function for all directories
function _lazyload_check_directory() {
  local trigger_dir file_list
  
  # Check each registered directory
  for trigger_dir in "${(@k)LAZYLOAD_DIRS}"; do
    if [[ "$PWD" == "$trigger_dir"* ]]; then
      file_list="${LAZYLOAD_DIRS[$trigger_dir]}"
      _lazyload_source_files "$file_list"
    fi
  done
}

# Single command check function for all commands
function _lazyload_check_command() {
  local cmd="$1"
  local trigger_cmd file_list
  
  # Check each registered command
  for trigger_cmd in "${(@k)LAZYLOAD_CMDS}"; do
    if [[ "$cmd" == "$trigger_cmd"* ]]; then
      file_list="${LAZYLOAD_CMDS[$trigger_cmd]}"
      _lazyload_source_files "$file_list"
    fi
  done
}

# Helper function to source files (reduces code duplication)
function _lazyload_source_files() {
  local file_list="$1"
  local IFS=':'
  local file load_key
  
  for file in ${=file_list}; do
    load_key="${file//[^a-zA-Z0-9]/_}"
    
    if [[ -z "${LAZYLOAD_LOADED[$load_key]}" ]]; then
      if [[ -f "$file" ]]; then
        source "$file"
        LAZYLOAD_LOADED[$load_key]=1
        # echo "🔄 Loaded: $file"  # Uncomment for debugging
      else
        echo "⚠️ Error: File doesn't exist: $file"
      fi
    fi
  done
}

# Backward compatibility wrapper
function lazyLoadMulti() {
  local to_load="$1"
  local description="$2"
  shift 2
  
  for trigger in "$@"; do
    if [[ -d "$trigger" ]]; then
      lazyLoad "directory" "$trigger" "$to_load" "$description" true  # Skip immediate check
    else
      lazyLoad "command" "$trigger" "$to_load" "$description"
    fi
  done
}

# Utility function to defer initial directory check
function lazyLoadDeferredCheck() {
  zsh-defer _lazyload_check_directory
}