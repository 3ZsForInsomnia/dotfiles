#!/usr/bin/env zsh

# Enhanced Help System - Main Entry Point
# Tag-based function discovery with smart completion

# Load help system modules
# Get the directory of this script
if [[ -n "${ZSH_VERSION:-}" ]]; then
  # In zsh, use the special parameter
  _help_script_dir="${${(%):-%x}:A:h}"
else
  # Fallback for other shells or when the parameter expansion fails
  _help_script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]:-$0}")")"
fi

# Final fallback
if [[ ! -d "$_help_script_dir" || ! -f "$_help_script_dir/parser.zsh" ]]; then
  _help_script_dir="$ZSH_CONFIG_DIR/tools/help"
fi

help_dir="$_help_script_dir"
source "$help_dir/parser.zsh"
source "$help_dir/cache.zsh"
source "$help_dir/completion.zsh"

function zhelp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: zhelp [tag1] [tag2] ... [tagN]"
    echo "Show functions matching ALL specified tags"
    echo ""
    echo "Options:"
    echo "  --rebuild-cache    Rebuild function cache from source files"
    echo "  --show-cache       Show cache file location and stats"
    echo "  --tags             List all available tags"
    echo ""
    echo "Examples:"
    echo "  zhelp               # Show overview and popular tag combinations"
    echo "  zhelp git           # All git functions"
    echo "  zhelp git fzf       # Interactive git functions"
    echo "  zhelp kube pod      # Pod-related kubernetes functions"
    echo "  zhelp --tags        # List all available tags"
    echo ""
    echo "💡 Use Tab completion to discover tags and preview results!"
    return 0
  fi

  # Handle special options
  case "$1" in
    "--rebuild-cache")
      _help_rebuild_cache
      return $?
      ;;
    "--show-cache")
      _help_show_cache_info
      return 0
      ;;
    "--tags")
      _help_list_all_tags
      return 0
      ;;
  esac

  # Ensure cache exists
  if ! _help_ensure_cache; then
    echo "❌ Could not load or build function cache"
    echo "Try running: zhelp --rebuild-cache"
    return 1
  fi

  # Show overview if no tags specified
  if [[ $# -eq 0 ]]; then
    _help_show_overview
    return 0
  fi

  # Find functions matching all specified tags
  local -a matching_functions
  matching_functions=($(_help_find_functions "$@"))

  if [[ ${#matching_functions[@]} -eq 0 ]]; then
    echo "No functions found matching tags: $*"
    echo ""
    echo "💡 Use 'help --tags' to see all available tags"
    echo "💡 Use Tab completion to see valid tag combinations"
    return 1
  fi

  # Display matching functions
  _help_display_functions "$@" "${matching_functions[@]}"
}

function _help_show_overview() {
  echo "🚀 Enhanced Function Help System"
  echo ""
  echo "Popular tag combinations:"
  echo "  zhelp git           - All git functions"
  echo "  zhelp git fzf       - Interactive git browsers"
  echo "  zhelp kube          - Kubernetes functions"
  echo "  zhelp kube fzf      - Interactive kubernetes browsers"  
  echo "  zhelp search        - File and text search functions"
  echo "  zhelp fzf           - All interactive FZF functions"
  echo ""
  echo "Discover functions:"
  echo "  zhelp --tags        - List all available tags"
  echo "  zhelp <tag><Tab>    - See related tags and preview functions"
  echo ""
  echo "💡 Most functions support -h for detailed help"
  echo "💡 Use Tab completion for smart tag discovery!"
}

function _help_display_functions() {
  local -a tags=("$@")
  shift $#
  local -a functions=("$@")
  
  # Remove the function arguments from tags array 
  local -a display_tags=()
  local i=1
  while [[ $i -le ${#tags[@]} && "${tags[$i]}" != "${functions[1]}" ]]; do
    display_tags+=("${tags[$i]}")
    ((i++))
  done

  # Build comma-separated tag list manually for portability
  local tag_list=""
  local first=true
  for tag in "${display_tags[@]}"; do
    if [[ "$first" == true ]]; then
      first=false
      tag_list="$tag"
    else
      tag_list="$tag_list, $tag"
    fi
  done
  
  echo "🔍 Functions matching tags: $tag_list"
  echo ""

  # Get function details from cache
  local func desc
  for func in "${functions[@]}"; do
    desc=$(_help_get_function_description "$func")
    printf "  %-20s - %s\n" "$func" "$desc"
  done

  echo ""
  echo "Found ${#functions[@]} function(s)"
  echo "💡 Use 'function_name -h' for detailed help"
}