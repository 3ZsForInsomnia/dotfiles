#!/usr/bin/env zsh

# zh completion system
# Provides smart tag completion and result previews

function _zh_get_cache_file() {
  echo "${XDG_CACHE_HOME:-$HOME/.cache}/zh-cache.txt"
}

function _zh_completion() {
  # Save current stdout/stderr and redirect to null during completion
  exec 3>&1 4>&2
  exec 1>/dev/null 2>/dev/null
  
  local -a all_tags relevant_tags current_args
  local cache_file=$(_zh_get_cache_file)
  
  if [[ ! -f "$cache_file" ]]; then
    _message "zh cache not found - run 'zh --rebuild-cache'"
    return 1
  fi
  
  # Handle special options
  if [[ $CURRENT -eq 2 && $words[2] == -* ]]; then
    local -a opts=(
      '--rebuild-cache:rebuild the function cache'
      '--tags:list all available tags'
      '-h:show help'
      '--help:show help'
    )
    _describe 'zh options' opts
    return 0
  fi
  
  # Get current arguments (tags already specified)
  current_args=(${words[2,$CURRENT-1]})
  
  if [[ ${#current_args[@]} -eq 0 ]]; then
    # No tags yet - show all available tags
    local -a all_available_tags
    all_available_tags=($(cut -d'|' -f3 "$cache_file" | tr ',' '\n' | /usr/bin/grep -v '^$' | sort -u))
    
    local -a tag_completions
    for tag in "${all_available_tags[@]}"; do
      local tag_count=$(cut -d'|' -f3 "$cache_file" | /usr/bin/grep -c "$tag")
      tag_completions+=("$tag:$tag ($tag_count items)")
    done
    
    _describe 'available tags' tag_completions
    return 0
  fi
  
  # Find what tags are relevant given current selection
  local -A relevant_tag_counts
  local match_count=0
  local -a preview_items
  
  while IFS='|' read -r type name tags desc; do
    local match_all=true
    
    # Check if all current args are present in this item's tags
    for search_tag in "${current_args[@]}"; do
      if [[ "$tags" != *"$search_tag"* ]]; then
        match_all=false
        break
      fi
    done
    
    if [[ "$match_all" == true ]]; then
      ((match_count++))
      
      # Collect preview items (first 5)
      if [[ ${#preview_items[@]} -lt 5 ]]; then
        local short_desc="${desc:0:45}"
        [[ ${#desc} -gt 45 ]] && short_desc="$short_desc..."
        preview_items+=("$name:($type) $short_desc")
      fi
      
      # Count additional tags that could be added
      # Split the tag string and process each individual tag
      # Use portable tag splitting
      local tag
      local temp_tags="$tags"
      while [[ "$temp_tags" == *","* ]]; do
        tag="${temp_tags%%,*}"  # Get first tag
        temp_tags="${temp_tags#*,}"  # Remove first tag and comma
        
        tag="${tag// /}"  # Remove spaces
        if [[ -n "$tag" ]]; then
          # Only count if not already in current args
          local already_used=false
          for used_tag in "${current_args[@]}"; do
            if [[ "$tag" == "$used_tag" ]]; then
              already_used=true
              break
            fi
          done
          if [[ "$already_used" == false ]]; then
            # This tag appears in items that match current selection
            ((relevant_tag_counts[$tag]++))
          fi
        fi
      done
      
      # Don't forget the last tag (after the last comma, or the only tag if no commas)
      tag="$temp_tags"
      tag="${tag// /}"  # Remove spaces
      if [[ -n "$tag" ]]; then
        # Only count if not already in current args
        local already_used=false
        for used_tag in "${current_args[@]}"; do
          if [[ "$tag" == "$used_tag" ]]; then
            already_used=true
            break
          fi
        done
        if [[ "$already_used" == false ]]; then
          # This tag appears in items that match current selection
          ((relevant_tag_counts[$tag]++))
        fi
      fi
    fi
  done < "$cache_file"
  
  # Build completions: first show relevant tags, then preview
  local -a completions
  
  # Add relevant tags (those that appear with current selection)
  for tag in ${(k)relevant_tag_counts}; do
    local count=${relevant_tag_counts[$tag]}
    completions+=("$tag:$tag ($count more items)")
  done
  
  # Add preview section
  if [[ $match_count -gt 0 ]]; then
    # Add preview separator (non-selectable)
    completions+=("___SEPARATOR___:── Preview: $match_count matches for '${current_args[*]}' ──")
    
    local item  
    for item in "${preview_items[@]}"; do
      # Extract name and description
      local name="${item%%:*}"
      local desc_part="${item#*:}"
      # Make these selectable - when selected, they should run the command
      completions+=("$name:$desc_part")
    done
    
    if [[ $match_count -gt 5 ]]; then
      completions+=("___MORE___:... and $((match_count - 5)) more (run 'zh ${current_args[*]}' to see all)")
    fi
  fi
  
  # Split completions into two groups for better display
  local -a tag_completions preview_completions
  
  for item in "${completions[@]}"; do
    local name="${item%%:*}"
    if [[ "$name" == ___* ]]; then
      # Non-selectable items (separators, more info)
      continue  # Skip these entirely
    elif [[ " ${current_args[*]} " == *" $name "* ]]; then
      # Skip already used tags
      continue
    else
      # Check if it's a tag or a function/alias name
      if [[ ${relevant_tag_counts[$name]} -gt 0 ]]; then
        tag_completions+=("$item")
      else
        # For functions/aliases, add them as selectable items
        local desc_part="${item#*:}"
        preview_completions+=("$name:$desc_part")
      fi
    fi
  done
  
  # Show tags and preview items as separate groups
  # Restore stdout/stderr for completion output
  exec 1>&3 2>&4
  exec 3>&- 4>&-
  
  if [[ ${#tag_completions[@]} -gt 0 ]]; then
    _describe -t tags 'additional tags' tag_completions
  fi
  
  if [[ ${#preview_completions[@]} -gt 0 ]]; then
    # Show separator and preview items
    _message "── Preview: $match_count matches for '${current_args[*]}' ──"
    
    _describe -t functions 'functions (select to run)' preview_completions
  fi
}

# Register completion
compdef _zh_completion zh