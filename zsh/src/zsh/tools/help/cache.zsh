#!/usr/bin/env zsh

# Help System Cache Management
# Builds and maintains function metadata cache

function _help_get_cache_file() {
  echo "${XDG_CACHE_HOME:-$HOME/.cache}/zsh-help-cache.json"
}

function _help_ensure_cache() {
  local cache_file=$(_help_get_cache_file)
  
  if [[ -f "$cache_file" ]]; then
    return 0
  fi
  
  echo "📦 Building function cache..." >&2
  _help_rebuild_cache
}

function _help_rebuild_cache() {
  local cache_file=$(_help_get_cache_file)
  local cache_dir="${cache_file:h}"
  
  # Ensure cache directory exists
  mkdir -p "$cache_dir"
  
  echo "🔄 Rebuilding function cache..."
  echo "   Cache file: $cache_file"
  
  # Parse all files and build JSON
  # Try a completely different approach - parse files directly here
  local parsed_data=""
  local aliases_dir="$ZSH_CONFIG_DIR/aliases"
  local -a all_files
  
  # Find all .zsh files
  all_files=($(/usr/bin/find "$aliases_dir" -name "*.zsh" -type f 2>/dev/null))
  
  if [[ ${#all_files[@]} -eq 0 ]]; then
    echo "❌ No .zsh files found in $aliases_dir" >&2
    return 1
  fi
  
  echo "📂 Processing ${#all_files[@]} files directly..."
  
  # Parse each file directly in this function to avoid any context issues
  local file
  for file in "${all_files[@]}"; do
    echo "   Processing: ${file:t}..." >&2
    
    # Simple inline parsing - look for aliases and basic functions
    while IFS= read -r line || [[ -n "$line" ]]; do
      # Skip empty lines and comments
      [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
      
      # Parse aliases
      if [[ "$line" =~ ^alias && "$line" == *"="* ]]; then
        # Extract alias name using parameter expansion
        local alias_part="${line#alias }"  # Remove 'alias '
        local alias_name="${alias_part%%=*}"  # Get everything before '='
        alias_name="${alias_name// /}"  # Remove any spaces
        local alias_value="${line#*=}"
        # Remove quotes
        alias_value="${alias_value#[\"\']}"
        alias_value="${alias_value%[\"\']}"
        
        # Get tags from file path
        local file_tags=$(_help_infer_tags_from_path "$file")
        
        parsed_data+="ALIAS:::$alias_name:::$file_tags:::$alias_value"$'\n'
      fi
      
      # Parse functions (basic detection)
      if [[ "$line" =~ ^function && "$line" == *"()" ]]; then
        # Extract function name using parameter expansion
        local func_part="${line#function }"  # Remove 'function '
        local func_name="${func_part%%\(\)*}"  # Get everything before '()'
        func_name="${func_name// /}"  # Remove any spaces
        local file_tags=$(_help_infer_tags_from_path "$file")
        parsed_data+="FUNCTION:::$func_name:::$file_tags:::"$'\n'
      fi
      
    done < "$file"
  done
  
  # Debug: save parsed data to temp file for inspection
  echo "$parsed_data" > "/tmp/zhelp_debug_parsed_data.txt"
  echo "   DEBUG: Saved parsed data to /tmp/zhelp_debug_parsed_data.txt" >&2
  echo "   DEBUG: Parsed data has $(echo "$parsed_data" | wc -l) lines and ${#parsed_data} characters" >&2
  
  if [[ -z "$parsed_data" ]]; then
    echo "❌ No functions found to cache" >&2
    return 1
  fi
  
  # Convert parsed data to JSON
  local json_data=$(_help_build_json_shell "$parsed_data")
  
  # Write to cache file
  echo "$json_data" > "$cache_file"
  
  if [[ $? -eq 0 ]]; then
    local func_count=$(echo "$parsed_data" | wc -l | tr -d ' ')
    echo "✅ Cache rebuilt successfully with $func_count functions"
    return 0
  else
    echo "❌ Failed to write cache file" >&2
    return 1
  fi
}

function _help_build_json_cache() {
  local parsed_data="$1"
  local json=""
  local functions_json=""
  local tags_json=""
  local -A all_tags
  local first_func=true
  
  # Redirect all output to avoid contamination
  {
  
  # Process each line of parsed data
  while IFS='|' read -r type name tags desc; do
    [[ -z "$name" ]] && continue
    
    # Add to functions section
    if [[ "$first_func" == true ]]; then
      first_func=false
    else
      functions_json+=","
    fi
    
    # Escape JSON strings
    local escaped_name=$(printf '%s' "$name" | sed 's/"/\\"/g')
    local escaped_desc=$(printf '%s' "$desc" | sed 's/"/\\"/g')
    local escaped_tags=$(printf '%s' "$tags" | sed 's/"/\\"/g')
    
    functions_json+="\"$escaped_name\":{\"type\":\"$type\",\"tags\":\"$escaped_tags\",\"desc\":\"$escaped_desc\"}"
    
    # Collect unique tags
    local tag
    for tag in ${(s:,:)tags}; do
      [[ -n "$tag" ]] && all_tags[$tag]=1
    done
    
  done <<< "$parsed_data"
  
  # Build tags array
  local first_tag=true
  for tag in ${(k)all_tags}; do
    if [[ "$first_tag" == true ]]; then
      first_tag=false
    else
      tags_json+=","
    fi
    tags_json+="\"$tag\""
  done
  
    json="{"
    json+="\"functions\":{$functions_json},\"tags\":[$tags_json]}"
    echo "$json"
  
  } 2>/dev/null  # Suppress any error output that might contaminate JSON
}
function _help_build_json_shell() {
  local parsed_data="$1"
  local all_tags_str=""
  local functions_json=""
  local first_func=true
  
  # Use a temp file to avoid subshell issues
  local temp_file="/tmp/zhelp_lines_$$"
  echo "$parsed_data" > "$temp_file"
  
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" ]] && continue
    
    # Split on our delimiter using parameter expansion
    if [[ "$line" != *":::"* ]]; then continue; fi
    
    local func_type="${line%%:::*}"
    local rest="${line#*:::}"
    local name="${rest%%:::*}"
    rest="${rest#*:::}"
    local tags="${rest%%:::*}"
    local desc="${rest#*:::}"
    
    [[ -z "$name" ]] && continue
    
    # Clean up description - replace backticks with single quotes and escape JSON chars
    # Clean up problematic characters for JSON
    desc="${desc//\`/}"                      # Remove backticks
    desc="${desc//\\/}"                      # Remove backslashes entirely
    desc="${desc//\"/}"                      # Remove double quotes entirely
    desc="${desc//$'\r'/ }"                  # Replace carriage returns
    desc="${desc//$'\n'/ }"                  # Replace newlines with spaces
    
    # Build function entry
    if [[ "$first_func" == true ]]; then
      first_func=false
    else
      functions_json+=","
    fi
    
    functions_json+="\"$name\":{\"type\":\"$func_type\",\"tags\":\"$tags\",\"desc\":\"$desc\"}"
    
    # Collect tags
    if [[ -n "$tags" ]]; then
      # Add tags to our string list if not already present
      local tag
      local IFS=','
      for tag in $tags; do
        if [[ -n "$tag" && "$all_tags_str" != *"\"$tag\""* ]]; then
          if [[ -n "$all_tags_str" ]]; then
            all_tags_str+=","
          fi
          all_tags_str+="\"$tag\""
        fi
      done
    fi
  done < "$temp_file"
  
  # Clean up temp file
  rm -f "$temp_file"
  
  # Output final JSON  
  echo "{\"functions\":{$functions_json},\"tags\":[$all_tags_str]}"
}
function _help_show_cache_info() {
  local cache_file=$(_help_get_cache_file)
  
  echo "📊 Help System Cache Info"
  echo "   File: $cache_file"
  
  if [[ -f "$cache_file" ]]; then
    local size=$(du -h "$cache_file" | cut -f1)
    local mtime=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$cache_file" 2>/dev/null || stat -c "%y" "$cache_file" 2>/dev/null)
    echo "   Size: $size"
    echo "   Modified: $mtime"
    
    # Count functions and tags
    if command -v jq >/dev/null 2>&1; then
      local func_count=$(jq -r '.functions | length' "$cache_file" 2>/dev/null)
      local tag_count=$(jq -r '.tags | length' "$cache_file" 2>/dev/null)
      echo "   Functions: $func_count"
      echo "   Tags: $tag_count"
    else
      echo "   Install 'jq' for detailed stats"
    fi
  else
    echo "   Status: ❌ Cache file does not exist"
    echo "   Run 'help --rebuild-cache' to create it"
  fi
}

function _help_find_functions() {
  local -a search_tags=("$@")
  local cache_file=$(_help_get_cache_file)
  
  if [[ ! -f "$cache_file" ]]; then
    return 1
  fi
  
  # If jq is available, use it for JSON parsing
  if command -v jq >/dev/null 2>&1; then
    _help_find_functions_jq "$cache_file" "${search_tags[@]}"
  else
    _help_find_functions_fallback "$cache_file" "${search_tags[@]}"
  fi
}

function _help_find_functions_jq() {
  local cache_file="$1"
  shift
  local -a search_tags=("$@")
  
  # Build jq filter to match all tags
  local filter="[.functions | to_entries[] | select("
  local first_tag=true
  
  for tag in "${search_tags[@]}"; do
    if [[ "$first_tag" == true ]]; then
      first_tag=false
    else
      filter+=" and "
    fi
    filter+="(.value.tags | contains(\"$tag\"))"
  done
  
  filter+=") | .key] | .[]"
  
  jq -r "$filter" "$cache_file" 2>/dev/null
}

function _help_find_functions_fallback() {
  local cache_file="$1"
  shift
  local -a search_tags=("$@")
  
  # Simple text-based matching fallback
  local -a results
  local line func_name func_tags
  
  # Extract function data and match tags
  while read -r line; do
    if [[ "$line" =~ '"([^"]+)":.*"tags":"([^"]*)"' ]]; then
      func_name="${match[1]}"
      func_tags="${match[2]}"
      
      # Check if all search tags are present
      local all_match=true
      for tag in "${search_tags[@]}"; do
        if [[ "$func_tags" != *"$tag"* ]]; then
          all_match=false
          break
        fi
      done
      
      if [[ "$all_match" == true ]]; then
        results+=("$func_name")
      fi
    fi
  done < "$cache_file"
  
  printf '%s\n' "${results[@]}"
}

function _help_get_function_description() {
  local func_name="$1"
  local cache_file=$(_help_get_cache_file)
  
  if [[ ! -f "$cache_file" ]]; then
    return 1
  fi
  
  if command -v jq >/dev/null 2>&1; then
    jq -r ".functions.\"$func_name\".desc // \"No description available\"" "$cache_file" 2>/dev/null
  else
    # Fallback text parsing
    local line
    while read -r line; do
      if [[ "$line" =~ "\"$func_name\":" ]] && [[ "$line" =~ '"desc":"([^"]*)"' ]]; then
        echo "${match[1]}"
        return 0
      fi
    done < "$cache_file"
    echo "No description available"
  fi
}

function _help_list_all_tags() {
  local cache_file=$(_help_get_cache_file)
  
  if [[ ! -f "$cache_file" ]]; then
    echo "❌ Cache not found. Run 'help --rebuild-cache' first."
    return 1
  fi
  
  echo "📋 Available Tags:"
  echo ""
  
  if command -v jq >/dev/null 2>&1; then
    jq -r '.tags[] | "  " + .' "$cache_file" 2>/dev/null | sort
  else
    # Fallback text parsing
    local line
    while read -r line; do
      if [[ "$line" =~ '"tags":\[([^\]]*)\]' ]]; then
        local tags_section="${match[1]}"
        # Extract individual tags
        while [[ "$tags_section" =~ '"([^"]+)"' ]]; do
          echo "  ${match[1]}"
          tags_section="${tags_section#*\"${match[1]}\"}"
        done
      fi
    done < "$cache_file" | sort -u
  fi
}