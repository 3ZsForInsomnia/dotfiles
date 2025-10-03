# Load the new compilation cache system
source "$ZSH_CONFIG_DIR/tools/compilation-cache.zsh"

# Legacy function for backward compatibility
function compile_large_zsh_files() {
  # Use the new cache-based compilation system
  zsh_compile_startup
}