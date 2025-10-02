typeset -A LAZYLOAD_LOADED

# lazyLoad - Conditionally load code based on different triggers
# Usage:
#   lazyLoad directory "/path/to/trigger/dir" source_func_or_file "Optional description"
#   lazyLoad command "some_command" source_func_or_file "Optional description"
#
# Examples:
#   lazyLoad directory "$HOME/work" sourceWorkStuff "Work configurations"
#   lazyLoad command "kubectl" sourceKubeStuff "Kubectl configurations"
function lazyLoad() {
  local trigger_type="$1"
  local trigger_value="$2"
  local to_load="$3"
  local description="${4:-"Lazy-loaded content"}"
  
  # Initialize the hook system if not done already
  if [[ -z "$LAZYLOAD_HOOKS_INITIALIZED" ]]; then
    autoload -U add-zsh-hook
    LAZYLOAD_HOOKS_INITIALIZED=1
  fi
  
  # Create a unique variable name for this trigger
  local safe_trigger="${trigger_value//[^a-zA-Z0-9]/_}"
  local handler_var="LAZYLOAD_HANDLER_${trigger_type}_${safe_trigger}"
  
  # Register the file using simple variable append
  if [[ -z "${(P)handler_var}" ]]; then
    eval "$handler_var=\"$to_load\""
  else
    eval "$handler_var=\"${(P)handler_var}:$to_load\""
  fi
  
  case "$trigger_type" in
    directory)
      local func_name="_check_directory_trigger_${safe_trigger}"
      
      # Define or update the function
      # Use here-document to avoid complex quoting
      eval "$func_name() {
$(cat <<EOF
        if [[ "\$PWD" == "$trigger_value"* ]]; then
          local file_list="${(P)handler_var}"
          
          local IFS=':'
          for file in \${=file_list}; do
            local load_key="\${file//[^a-zA-Z0-9]/_}"
            local loaded_var="LAZYLOAD_LOADED_\$load_key"
            
            if [[ -z "\${(P)loaded_var}" ]]; then
              # echo "🔄 Loading: \$file"
              if [[ -f "\$file" ]]; then
                source "\$file"
                eval "\$loaded_var=1"
              else
                echo "⚠️ Error: File doesn't exist: \$file"
              fi
            fi
          done
        fi
EOF
)
      }"
      
      # Register the hook if not already done
      # Use faster check - avoid array search
      if [[ ${chpwd_functions[(r)$func_name]} != $func_name ]]; then
        add-zsh-hook chpwd "$func_name"
      fi
      
      # Check immediately
      $func_name
      ;;
      
    command)
      local func_name="_check_command_trigger_${safe_trigger}"
      
      # Define or update the function
      # Use here-document to avoid complex quoting
      eval "$func_name() {
$(cat <<EOF
        local cmd="\$1"
        if [[ "\$cmd" == "$trigger_value"* ]]; then
          local file_list="${(P)handler_var}"
          
          local IFS=':'
          for file in \${=file_list}; do
            local load_key="\${file//[^a-zA-Z0-9]/_}"
            local loaded_var="LAZYLOAD_LOADED_\$load_key"
            
            if [[ -z "\${(P)loaded_var}" ]]; then
              # echo "🔄 Loading: \$file"
              if [[ -f "\$file" ]]; then
                source "\$file"
                eval "\$loaded_var=1"
              else
                echo "⚠️ Error: File doesn't exist: \$file"
              fi
            fi
          done
        fi
EOF
)
      }"
      
      # Register the hook if not already done
      # Use faster check - avoid array search  
      if [[ ${preexec_functions[(r)$func_name]} != $func_name ]]; then
        add-zsh-hook preexec "$func_name"
      fi
      ;;
      
    *)
      echo "⚠️ Error: Unknown trigger type '$trigger_type'"
      echo "   Supported types: directory, command"
      return 1
      ;;
  esac
}

function lazyLoadMulti() {
  local to_load="$1"
  local description="$2"
  shift 2
  
  # Now $@ contains all the triggers
  for trigger in "$@"; do
    # Determine if this is a directory or command
    if [[ -d "$trigger" ]]; then
      # It's a directory
      lazyLoad "directory" "$trigger" "$to_load" "$description" 
    else
      # Assume it's a command
      lazyLoad "command" "$trigger" "$to_load" "$description"
    fi
  done
}

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

source $ZSH_CONFIG_DIR/tools/zsh-defer/zsh-defer.plugin.zsh
source "$HOME/src/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZSH_CONFIG_DIR/.p10k.zsh"
source "$ZSH_CONFIG_DIR/path-modifiers.zsh"
source "$ZSH_CONFIG_DIR/.env"

zsh-defer setup_deferred_env
zsh-defer source "$ZSH_CONFIG_DIR/tools/zsh-autosuggestions/zsh-autosuggestions.zsh"
zsh-defer source "$ZSH_CONFIG_DIR/tools/fast-syntax-highlight/fast-syntax-highlighting.plugin.zsh"
zsh-defer source "$ZSH_CONFIG_DIR/tools/zsh-you-should-use/you-should-use.plugin.zsh"
zsh-defer source "$ZSH_CONFIG_DIR/tools/zshmarks/zshmarks.plugin.zsh"
zsh-defer source "$ZSH_CONFIG_DIR/tools/help/zh.zsh"
zsh-defer compile_large_zsh_files

source "$ZSH_CONFIG_DIR/tools/reveal-alias.zsh"
source "$ZSH_CONFIG_DIR/aliases/index.zsh"
