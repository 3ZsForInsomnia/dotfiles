#!/usr/bin/env zsh

# Help System Smart Completion
# Provides intelligent tab completion with function preview

function _help_completion() {
  local state context line
  typeset -A opt_args
  local cache_file=$(_help_get_cache_file)
  
  # Ensure cache exists for completion
  if [[ ! -f "$cache_file" ]]; then
    return 1
  fi
  
  local -a available_tags current_tags
  local -a matching_functions
  
  # Get all available tags
  if command -v jq >/dev/null 2>&1; then
    available_tags=($(jq -r '.tags[]' "$cache_file" 2>/dev/null))
  else
    # Fallback: extract tags from cache file
    available_tags=($(_help_extract_tags_fallback "$cache_file"))
  fi
  
  # Get current tags from command line (excluding 'help')
  current_tags=(${words[2,-1]})
  
  # Get functions matching current tags
  if [[ ${#current_tags[@]} -gt 0 ]]; then
    matching_functions=($(_help_find_functions "${current_tags[@]}"))
  fi
  
  # Determine which tags are still relevant
  local -a relevant_tags
  for tag in "${available_tags[@]}"; do
    # Skip if tag is already used
    if [[ " ${current_tags[*]} " =~ " $tag " ]]; then
      continue
    fi
    
    # Check if this tag would produce results when combined with current tags
    local test_tags=("${current_tags[@]}" "$tag")
    local -a test_results
    test_results=($(_help_find_functions "${test_tags[@]}"))
    
    if [[ ${#test_results[@]} -gt 0 ]]; then
      relevant_tags+=("$tag")
    fi
  done
  
  # Build completion arrays
  local -a tag_completions function_previews
  
  # Add relevant tags with counts
  for tag in "${relevant_tags[@]}"; do
    local test_tags=("${current_tags[@]}" "$tag")
    local -a test_results
    test_results=($(_help_find_functions "${test_tags[@]}"))
    local count=${#test_results[@]}
    
    tag_completions+=("$tag:Shows $count function(s)")
  done
  
  # Add function previews (first 10)
  local preview_count=10
  local i=0
  for func in "${matching_functions[@]}"; do
    if [[ $i -ge $preview_count ]]; then
      break
    fi
    
    local desc=$(_help_get_function_description "$func")
    function_previews+=("$func:$desc")
    ((i++))
  done
  
  # Add "more functions" indicator if there are more than 10
  if [[ ${#matching_functions[@]} -gt $preview_count ]]; then
    local remaining=$((${#matching_functions[@]} - $preview_count))
    function_previews+=("...:($remaining more functions)")
  fi
  
  # Provide completions
  if [[ ${#tag_completions[@]} -gt 0 ]]; then
    _describe -t tags 'Available Tags' tag_completions
  fi
  
  if [[ ${#function_previews[@]} -gt 0 ]]; then
    local current_tag_text=""
    if [[ ${#current_tags[@]} -gt 0 ]]; then
      current_tag_text=" (${(j:, :)current_tags})"
    fi
    _describe -t functions "Matching Functions$current_tag_text" function_previews
  fi
  
  # Handle special completions for options
  if [[ ${#current_tags[@]} -eq 0 ]]; then
    local -a special_options
    special_options=(
      '--rebuild-cache:Rebuild function cache from source files'
      '--show-cache:Show cache file information'
      '--tags:List all available tags'
    )
    _describe -t options 'Options' special_options
  fi
}

function _help_extract_tags_fallback() {
  local cache_file="$1"
  local -a tags
  
  # Extract tags from JSON without jq
  local line
  while read -r line; do
    if [[ "$line" =~ '"tags":\[([^\]]*)\]' ]]; then
      local tags_section="${match[1]}"
      # Extract individual tags
      while [[ "$tags_section" =~ '"([^"]+)"' ]]; do
        tags+=("${match[1]}")
        tags_section="${tags_section#*\"${match[1]}\"}"
      done
    fi
  done < "$cache_file"
  
  # Remove duplicates and sort
  printf '%s\n' "${tags[@]}" | sort -u
}

# Register the completion function
compdef _help_completion zhelp