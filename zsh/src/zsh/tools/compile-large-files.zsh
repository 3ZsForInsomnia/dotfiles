function compile_large_zsh_files() {
  local size_threshold=2560 # This in in bytes (2.5 KB)
  
  # Run silently to avoid startup noise
  # echo "Compiling large .zsh files..."
  
  # Use faster approach - avoid subshell pipe
  local -a zsh_files
  zsh_files=($ZSH_CONFIG_DIR/**/*.zsh(N))
  
  local file
  for file in "${zsh_files[@]}"; do
    local file_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    
    if [[ $file_size -gt $size_threshold ]]; then
      if [[ ! -f "${file}.zwc" || "$file" -nt "${file}.zwc" ]]; then
        # echo "Compiling large file: $file ($file_size bytes)"
        zcompile "$file"
      fi
    fi
  done
}
