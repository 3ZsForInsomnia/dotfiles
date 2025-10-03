#!/usr/bin/env zsh

# ZSH Compilation Cache System
# Eliminates filesystem scanning and provides intelligent compilation management

# Cache file locations
ZSH_COMP_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-compilation"
ZSH_COMP_CACHE_INDEX="$ZSH_COMP_CACHE_DIR/compilation-index"
ZSH_COMP_CACHE_DEPS="$ZSH_COMP_CACHE_DIR/dependencies"

# Configuration
ZSH_COMP_SIZE_THRESHOLD=1024  # 1KB minimum for compilation
ZSH_COMP_MAX_AGE=$((7 * 24 * 60 * 60))  # 7 days in seconds

# Ensure cache directory exists
function _zsh_comp_ensure_cache_dir() {
  [[ -d "$ZSH_COMP_CACHE_DIR" ]] || mkdir -p "$ZSH_COMP_CACHE_DIR"
}

# Build initial cache index
function _zsh_comp_build_index() {
  _zsh_comp_ensure_cache_dir
  
  local -a zsh_files
  local cache_data=""
  local file size mtime
  
  # Find all .zsh files in config directory
  zsh_files=($ZSH_CONFIG_DIR/**/*.zsh(N))
  
  for file in "${zsh_files[@]}"; do
    # Get file stats efficiently
    if [[ -f "$file" ]]; then
      # Use zstat (faster than external stat)
      zmodload zsh/stat &>/dev/null
      if zstat -A file_stats -F "%s" "$file" 2>/dev/null; then
        size=${file_stats[1]}
        mtime=${file_stats[2]}
      else
        # Fallback to external stat
        size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
        mtime=$(stat -f%m "$file" 2>/dev/null || stat -c%Y "$file" 2>/dev/null || echo 0)
      fi
      
      # Only track files above size threshold
      if (( size >= ZSH_COMP_SIZE_THRESHOLD )); then
        local zwc_file="${file}.zwc"
        local zwc_mtime=0
        local needs_compile=1
        
        # Check if .zwc exists and is newer
        if [[ -f "$zwc_file" ]]; then
          if zstat -A zwc_stats -F "%s" "$zwc_file" 2>/dev/null; then
            zwc_mtime=${zwc_stats[2]}
          else
            zwc_mtime=$(stat -f%m "$zwc_file" 2>/dev/null || stat -c%Y "$zwc_file" 2>/dev/null || echo 0)
          fi
          
          # Check if compilation is up to date
          (( zwc_mtime >= mtime )) && needs_compile=0
        fi
        
        # Format: file|size|mtime|zwc_mtime|needs_compile
        cache_data+="${file}|${size}|${mtime}|${zwc_mtime}|${needs_compile}"$'\n'
      fi
    fi
  done
  
  # Write cache index atomically
  echo "$cache_data" > "${ZSH_COMP_CACHE_INDEX}.tmp" && 
    mv "${ZSH_COMP_CACHE_INDEX}.tmp" "$ZSH_COMP_CACHE_INDEX"
}

# Load compilation cache and compile needed files
function zsh_compile_with_cache() {
  local force_rebuild=false
  local background_mode=true
  local verbose=false
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --force|-f)
        force_rebuild=true
        shift
        ;;
      --foreground)
        background_mode=false
        shift
        ;;
      --verbose|-v)
        verbose=true
        shift
        ;;
      *)
        echo "Usage: zsh_compile_with_cache [--force] [--foreground] [--verbose]"
        return 1
        ;;
    esac
  done
  
  _zsh_comp_ensure_cache_dir
  
  # Check if cache needs rebuilding
  local rebuild_cache=false
  if [[ "$force_rebuild" == true ]] || [[ ! -f "$ZSH_COMP_CACHE_INDEX" ]]; then
    rebuild_cache=true
  else
    # Check cache age
    local cache_mtime
    if zstat -A cache_stats "$ZSH_COMP_CACHE_INDEX" 2>/dev/null; then
      cache_mtime=${cache_stats[2]}
    else
      cache_mtime=$(stat -f%m "$ZSH_COMP_CACHE_INDEX" 2>/dev/null || stat -c%Y "$ZSH_COMP_CACHE_INDEX" 2>/dev/null || echo 0)
    fi
    
    local current_time=$(date +%s)
    (( current_time - cache_mtime > ZSH_COMP_MAX_AGE )) && rebuild_cache=true
  fi
  
  # Rebuild cache if needed
  if [[ "$rebuild_cache" == true ]]; then
    [[ "$verbose" == true ]] && echo "🔄 Rebuilding compilation cache..."
    _zsh_comp_build_index
  fi
  
  # Process compilation tasks
  if [[ "$background_mode" == true ]]; then
    _zsh_comp_process_background "$verbose"
  else
    _zsh_comp_process_foreground "$verbose"
  fi
}

# Process compilation in foreground
function _zsh_comp_process_foreground() {
  local verbose="$1"
  local compiled_count=0
  local line file size mtime zwc_mtime needs_compile
  
  while IFS='|' read -r file size mtime zwc_mtime needs_compile; do
    [[ -z "$file" ]] && continue
    
    if (( needs_compile == 1 )); then
      if [[ "$verbose" == true ]]; then
        echo "📦 Compiling: ${file:t} (${size} bytes)"
      fi
      
      if zcompile "$file" 2>/dev/null; then
        (( compiled_count++ ))
      elif [[ "$verbose" == true ]]; then
        echo "❌ Failed to compile: $file"
      fi
    fi
  done < "$ZSH_COMP_CACHE_INDEX"
  
  [[ "$verbose" == true ]] && echo "✅ Compiled $compiled_count files"
}

# Process compilation in background
function _zsh_comp_process_background() {
  local verbose="$1"
  
  # Create background compilation script
  local bg_script="${ZSH_COMP_CACHE_DIR}/bg_compile.zsh"
  cat > "$bg_script" << 'EOF'
#!/usr/bin/env zsh
compiled_count=0
while IFS='|' read -r file size mtime zwc_mtime needs_compile; do
  [[ -z "$file" ]] && continue
  if (( needs_compile == 1 )); then
    if zcompile "$file" 2>/dev/null; then
      (( compiled_count++ ))
    fi
  fi
done
EOF
  
  # Launch background job
  {
    source "$bg_script" < "$ZSH_COMP_CACHE_INDEX"
    rm -f "$bg_script"
  } &!
  
  [[ "$verbose" == true ]] && echo "🚀 Background compilation started (PID: $!)"
}

# Fast compilation check for startup
function zsh_compile_startup() {
  # Quick check - only compile if cache is missing or very old
  if [[ ! -f "$ZSH_COMP_CACHE_INDEX" ]]; then
    zsh_compile_with_cache --foreground
  else
    # Background compilation for maintenance
    zsh_compile_with_cache &!
  fi
}

# Clean old .zwc files and cache
function zsh_compile_clean() {
  local dry_run=false
  
  if [[ "$1" == "--dry-run" ]]; then
    dry_run=true
    echo "🔍 Dry run mode - showing what would be deleted:"
  fi
  
  local -a zwc_files orphan_files
  local cleaned_count=0
  
  # Find all .zwc files
  zwc_files=($ZSH_CONFIG_DIR/**/*.zwc(N))
  
  for zwc_file in "${zwc_files[@]}"; do
    local source_file="${zwc_file%.zwc}"
    
    if [[ ! -f "$source_file" ]]; then
      # Orphaned .zwc file
      if [[ "$dry_run" == true ]]; then
        echo "  Would delete: $zwc_file (source missing)"
      else
        rm -f "$zwc_file"
      fi
      (( cleaned_count++ ))
    fi
  done
  
  # Clean old cache files
  if [[ -d "$ZSH_COMP_CACHE_DIR" ]]; then
    local -a old_files
    old_files=($ZSH_COMP_CACHE_DIR/*(N.mh+7))  # Files older than 7 days
    
    for old_file in "${old_files[@]}"; do
      if [[ "$dry_run" == true ]]; then
        echo "  Would delete: $old_file (old cache)"
      else
        rm -f "$old_file"
      fi
      (( cleaned_count++ ))
    done
  fi
  
  if [[ "$dry_run" == true ]]; then
    echo "📊 Total items that would be cleaned: $cleaned_count"
  else
    echo "🧹 Cleaned $cleaned_count items"
  fi
}

# Show compilation cache statistics
function zsh_compile_stats() {
  echo "📊 ZSH Compilation Cache Statistics"
  echo "   Cache directory: $ZSH_COMP_CACHE_DIR"
  
  if [[ -f "$ZSH_COMP_CACHE_INDEX" ]]; then
    local total_files=$(wc -l < "$ZSH_COMP_CACHE_INDEX" | tr -d ' ')
    local needs_compile=$(awk -F'|' '$5 == 1 { count++ } END { print count+0 }' "$ZSH_COMP_CACHE_INDEX")
    local cache_size
    
    if [[ -d "$ZSH_COMP_CACHE_DIR" ]]; then
      cache_size=$(du -sh "$ZSH_COMP_CACHE_DIR" 2>/dev/null | cut -f1)
    else
      cache_size="0B"
    fi
    
    echo "   Tracked files: $total_files"
    echo "   Need compilation: $needs_compile"
    echo "   Cache size: $cache_size"
    
    # Show recently compiled files
    local -a recent_zwc
    recent_zwc=($ZSH_CONFIG_DIR/**/*.zwc(N.mh-1))  # Files modified in last hour
    if (( ${#recent_zwc[@]} > 0 )); then
      echo "   Recently compiled: ${#recent_zwc[@]} files"
    fi
  else
    echo "   Status: ❌ No cache index found"
    echo "   Run 'zsh_compile_with_cache' to initialize"
  fi
}

# Invalidate cache for specific files or patterns  
function zsh_compile_invalidate() {
  local pattern="$1"
  
  if [[ -z "$pattern" ]]; then
    echo "Usage: zsh_compile_invalidate <file_pattern>"
    echo "Example: zsh_compile_invalidate 'aliases/*.zsh'"
    return 1
  fi
  
  local -a matching_files
  matching_files=($ZSH_CONFIG_DIR/${~pattern}(N))
  
  if (( ${#matching_files[@]} == 0 )); then
    echo "❌ No files match pattern: $pattern"
    return 1
  fi
  
  local invalidated_count=0
  for file in "${matching_files[@]}"; do
    local zwc_file="${file}.zwc"
    if [[ -f "$zwc_file" ]]; then
      rm -f "$zwc_file"
      (( invalidated_count++ ))
      echo "🗑️  Invalidated: ${file:t}"
    fi
  done
  
  echo "✅ Invalidated $invalidated_count compiled files"
  
  # Rebuild cache to reflect changes
  _zsh_comp_build_index
}