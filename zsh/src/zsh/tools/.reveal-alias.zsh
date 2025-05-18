_reveal_cmd_alias=""

# Cache for aliases to avoid repeated lookups
typeset -A _alias_cache

# Reveal Executed Alias - optimized version
alias_for() {
  # Skip commands with punctuation (faster check)
  [[ $1 == *[[:punct:]]* ]] && return
  
  local search=${1}
  local result
  
  # Check cache first
  if [[ -n "${_alias_cache[$search]}" ]]; then
    result="${_alias_cache[$search]}"
  else
    # Not in cache, look it up
    local found="$( alias $search 2>/dev/null )"
    if [[ -n $found ]]; then
      # Process only if found
      found=${found//\\//}          # Replace backslash with slash
      found=${found%\'}             # Remove end single quote
      found=${found#"$search='"}    # Remove alias name
      _alias_cache[$search]="$found" # Store in cache
      result="$found"
    else
      _alias_cache[$search]=""      # Cache empty result too
      return
    fi
  fi
  
  # Only create output string if we found something
  [[ -n "$result" ]] && print -r -- "$result ${2}"
}

expand_command_line() {
  # Extract first word without invoking awk
  local first rest
  first="${1%% *}"
  rest="${1#$first}"
  
  # Skip hyphens (faster check without substitution)
  [[ "$first" == "-"* ]] && return
  
  # Get alias expansion
  _reveal_cmd_alias="$(alias_for "${first}" "${rest:1}")"
  [[ -n $_reveal_cmd_alias ]] && print -r -- "${T_GREEN}❯ ${T_YELLOW}${_reveal_cmd_alias}${F_RESET}"
}

pre_validation() {
  [[ $# -eq 0 ]] && return
  expand_command_line "$@"
}

autoload -U add-zsh-hook
add-zsh-hook preexec pre_validation
