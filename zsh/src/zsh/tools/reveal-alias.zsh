_reveal_cmd_alias=""


# Reveal Executed Alias - optimized version
function alias_for() {
  # Skip commands with punctuation (faster check)
  [[ $1 == *[[:punct:]]* ]] && return
  
  local search=${1}
  
  # Skip if search is empty or contains problematic characters
  [[ -z "$search" ]] && return
  [[ "$search" =~ [^a-zA-Z0-9_.-] ]] && return
  
  local result
  
  # Direct alias lookup (remove caching for now to fix the error)
  local found="$( alias $search 2>/dev/null )"
  if [[ -n $found ]]; then
    # Process only if found
    found=${found//\\//}          # Replace backslash with slash
    found=${found%\'}             # Remove end single quote
    found=${found#"$search='"}    # Remove alias name
    result="$found"
  else
    return
  fi
  
  # Only create output string if we found something
  [[ -n "$result" ]] && print -r -- "$result ${2}"
}

function expand_command_line() {
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

function pre_validation() {
  [[ $# -eq 0 ]] && return
  expand_command_line "$@"
}

autoload -U add-zsh-hook
add-zsh-hook preexec pre_validation
