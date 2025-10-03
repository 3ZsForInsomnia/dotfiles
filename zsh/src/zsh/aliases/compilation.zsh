# ZSH Compilation Cache Management Aliases

# Quick check if compilation cache is working
function zcomp-check() {
  if [[ -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh-compilation/compilation-index" ]]; then
    echo "✅ Compilation cache is active"
    zsh_compile_stats
  else
    echo "❌ Compilation cache not initialized"
    echo "💡 Run 'zcomp' to initialize the cache system"
  fi
}
# HOW TO USE THE NEW COMPILATION CACHE SYSTEM:
#
# AUTOMATIC OPERATION:
# - The cache system runs automatically on shell startup (deferred to background)
# - It tracks all .zsh files >1KB and compiles them when needed
# - Maintains an index of file states to avoid redundant stat() calls
# - Background compilation keeps your shell startup fast
#
# MANUAL COMMANDS:
# - `zcomp` - Check and compile files that need it (verbose output)
# - `zcomp-force` - Force rebuild all cached files (useful after major changes)
# - `zcomp-fg` - Run compilation in foreground instead of background
# - `zcomp-stats` - Show cache statistics and status
# - `zcomp-clean` - Remove orphaned .zwc files and old cache data
# - `zcomp-invalidate 'pattern'` - Force recompilation of specific files
#
# EXAMPLES:
# - `zcomp-invalidate 'aliases/*'` - Recompile all alias files
# - `zcomp-invalidate 'tools/lazy-loading.zsh'` - Recompile specific file
# - `zcomp-clean --dry-run` - See what would be cleaned without doing it
#
# PERFORMANCE BENEFITS:
# - Eliminates filesystem scanning on every startup
# - Caches file modification times and states
# - Only compiles files that actually changed
# - Background processing keeps shell responsive
# - Batch operations reduce zcompile overhead

# Quick compilation commands
alias zcomp='zsh_compile_with_cache --verbose'
alias zcomp-force='zsh_compile_with_cache --force --verbose'
alias zcomp-fg='zsh_compile_with_cache --foreground --verbose'

# Cache management
alias zcomp-stats='zsh_compile_stats'
alias zcomp-clean='zsh_compile_clean'
alias zcomp-clean-dry='zsh_compile_clean --dry-run'

# Development helpers
alias zcomp-invalidate='zsh_compile_invalidate'
alias zcomp-rebuild='zsh_compile_with_cache --force'

# Quick stats
function zcomp-info() {
  echo "🔧 ZSH Compilation Cache Commands:"
  echo "   zcomp           - Compile with cache (verbose)"
  echo "   zcomp-force     - Force rebuild all"
  echo "   zcomp-fg        - Foreground compilation"
  echo "   zcomp-stats     - Show cache statistics"
  echo "   zcomp-clean     - Clean orphaned files"
  echo "   zcomp-invalidate - Invalidate specific files"
  echo ""
  echo "💡 Common Usage Patterns:"
  echo "   zcomp-invalidate 'aliases/*'  - Recompile all aliases"
  echo "   zcomp-invalidate 'tools/*'    - Recompile all tools"
  echo "   zcomp-clean --dry-run         - Preview cleanup"
  echo ""
  echo "🚀 The system runs automatically in background on startup"
  echo "   No manual intervention needed for normal usage"
  echo ""
  zsh_compile_stats
}