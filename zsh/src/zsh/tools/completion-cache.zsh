#!/usr/bin/env zsh

##
## Aggressive Completion Caching System
## Optimizes compinit startup by caching compaudit results and managing compdump efficiently
##

# Cache configuration
export ZSH_COMP_CACHE_DIR="${XDG_CACHE_HOME}/zsh/comp-cache"
export ZSH_COMP_AUDIT_CACHE="$ZSH_COMP_CACHE_DIR/compaudit-cache"
export ZSH_COMP_AUDIT_DIRS_HASH="$ZSH_COMP_CACHE_DIR/dirs-hash"

# Cache TTL in seconds (24 hours)
export ZSH_COMP_CACHE_TTL=$((24 * 60 * 60))

# Ensure cache directory exists
mkdir -p "$ZSH_COMP_CACHE_DIR"

# Function to calculate hash of completion directories
function _zsh_comp_dirs_hash() {
  local comp_dirs=()
  local dir

  # Get all completion directories from fpath
  for dir in $fpath; do
    if [[ -d "$dir" && "$dir" == */completions* || "$dir" == */_* ]]; then
      comp_dirs+=("$dir")
    fi
  done

  # Create hash of directory paths + modification times
  if (( ${#comp_dirs[@]} > 0 )); then
    find "${comp_dirs[@]}" -type f -name "_*" -printf "%p:%T@\n" 2>/dev/null | \
      sort | md5sum | cut -d' ' -f1
  else
    echo "no-completions"
  fi
}

# Function to check if compaudit cache is valid
function _zsh_comp_cache_valid() {
  local cache_file="$ZSH_COMP_AUDIT_CACHE"
  local hash_file="$ZSH_COMP_AUDIT_DIRS_HASH"

  # Check if cache files exist
  [[ -f "$cache_file" && -f "$hash_file" ]] || return 1

  # Check if cache is expired
  local cache_age=$(( $(date +%s) - $(stat -f "%m" "$cache_file" 2>/dev/null || echo 0) ))
  (( cache_age > ZSH_COMP_CACHE_TTL )) && return 1

  # Check if completion directories changed
  local current_hash="$(_zsh_comp_dirs_hash)"
  local cached_hash="$(cat "$hash_file" 2>/dev/null)"
  [[ "$current_hash" == "$cached_hash" ]] || return 1

  return 0
}

# Function to update compaudit cache
function _zsh_comp_update_cache() {
  local cache_file="$ZSH_COMP_AUDIT_CACHE"
  local hash_file="$ZSH_COMP_AUDIT_DIRS_HASH"
  
  # Run compaudit and cache results
  compaudit > "$cache_file" 2>&1
  local audit_result=$?
  
  # Cache the directory hash
  _zsh_comp_dirs_hash > "$hash_file"
  
  return $audit_result
}

# Optimized compinit wrapper
function zsh_fast_compinit() {
  local compdump_file="${ZSH_COMPDUMP:-${XDG_CACHE_HOME}/zsh/compdump}"
  local force_rebuild=false
  local skip_security=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--force)
        force_rebuild=true
        shift
        ;;
      -C|--no-security)
        skip_security=true
        shift
        ;;
      -d)
        compdump_file="$2"
        shift 2
        ;;
      *)
        shift
        ;;
    esac
  done

  autoload -Uz compinit

  # Fast path: skip security check if cache is valid or explicitly skipped
  if [[ "$skip_security" == true ]] || _zsh_comp_cache_valid; then
    # Use cached compaudit results or skip entirely
    if [[ "$skip_security" == true ]]; then
      compinit -C -d "$compdump_file"
    else
      # Load cached compaudit results for informational purposes only
      local cached_issues="$(cat "$ZSH_COMP_AUDIT_CACHE" 2>/dev/null)"
      if [[ -n "$cached_issues" && "$cached_issues" != "compaudit: no issues found." ]]; then
        # Issues exist but we're using cached results - show warning but continue fast
        echo "⚠️  Using cached compaudit results (use 'compinit -f' to force refresh)" >&2
      fi
      compinit -C -d "$compdump_file"
    fi
  else
    # Slow path: run security check and update cache
    if _zsh_comp_update_cache; then
      # No security issues found
      compinit -d "$compdump_file"
    else
      # Security issues found, but continue with fast init
      echo "⚠️  compaudit found issues (cached for performance)" >&2
      compinit -C -d "$compdump_file"
    fi
  fi

  # Smart compdump optimization
  _zsh_comp_optimize_dump "$compdump_file" "$force_rebuild"
}

# Optimize compdump file management
function _zsh_comp_optimize_dump() {
  local compdump_file="$1"
  local force_rebuild="$2"
  
  # Check if compdump needs rebuilding
  local needs_rebuild=false
  
  if [[ "$force_rebuild" == true ]]; then
    needs_rebuild=true
  elif [[ ! -f "$compdump_file" ]]; then
    needs_rebuild=true
  elif [[ -n ${compdump_file}(#qN.mh+24) ]]; then
    # File is older than 24 hours
    needs_rebuild=true
  else
    # Check if any completion files are newer than compdump
    local newer_files
    newer_files=$(find $fpath -name "_*" -newer "$compdump_file" 2>/dev/null | head -1)
    [[ -n "$newer_files" ]] && needs_rebuild=true
  fi

  if [[ "$needs_rebuild" == true ]]; then
    # Remove old dump to force regeneration
    rm -f "$compdump_file" "$compdump_file.zwc"
    
    # Regenerate compdump
    compinit -d "$compdump_file"
  fi

  # Compile compdump if needed (in background for speed)
  if [[ ! -f "$compdump_file.zwc" || "$compdump_file" -nt "$compdump_file.zwc" ]]; then
    {
      zcompile "$compdump_file"
    } &!
  fi
}

# Utility function to clear completion cache
function zsh_clear_comp_cache() {
  echo "🧹 Clearing completion cache..."
  rm -rf "$ZSH_COMP_CACHE_DIR"
  mkdir -p "$ZSH_COMP_CACHE_DIR"
  rm -f "${ZSH_COMPDUMP}" "${ZSH_COMPDUMP}.zwc"
  echo "✅ Cache cleared. Restart shell to rebuild completions."
}

# Utility function to show cache status
function zsh_comp_cache_status() {
  echo "📊 Completion Cache Status"
  echo "=========================="
  echo "Cache directory: $ZSH_COMP_CACHE_DIR"
  echo "Cache TTL: ${ZSH_COMP_CACHE_TTL}s ($(( ZSH_COMP_CACHE_TTL / 3600 ))h)"
  echo ""
  
  if [[ -f "$ZSH_COMP_AUDIT_CACHE" ]]; then
    local cache_age=$(( $(date +%s) - $(stat -f "%m" "$ZSH_COMP_AUDIT_CACHE" 2>/dev/null || echo 0) ))
    echo "Audit cache age: ${cache_age}s ($(( cache_age / 3600 ))h)"
    echo "Cache valid: $(_zsh_comp_cache_valid && echo "✅ yes" || echo "❌ no")"
    
    local cached_issues="$(cat "$ZSH_COMP_AUDIT_CACHE" 2>/dev/null)"
    if [[ -n "$cached_issues" && "$cached_issues" != "compaudit: no issues found." ]]; then
      echo "Cached issues: ⚠️  $(echo "$cached_issues" | wc -l) issue(s) found"
    else
      echo "Cached issues: ✅ none"
    fi
  else
    echo "Audit cache: ❌ not found"
  fi
  
  echo ""
  echo "Compdump: ${ZSH_COMPDUMP}"
  if [[ -f "${ZSH_COMPDUMP}" ]]; then
    local dump_age=$(( $(date +%s) - $(stat -f "%m" "${ZSH_COMPDUMP}" 2>/dev/null || echo 0) ))
    echo "Dump age: ${dump_age}s ($(( dump_age / 3600 ))h)"
    echo "Dump size: $(du -h "${ZSH_COMPDUMP}" 2>/dev/null | cut -f1)"
    [[ -f "${ZSH_COMPDUMP}.zwc" ]] && echo "Compiled: ✅ yes" || echo "Compiled: ❌ no"
  else
    echo "Dump: ❌ not found"
  fi
}