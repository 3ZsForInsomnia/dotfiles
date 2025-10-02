#!/usr/bin/env zsh

# Clean Cache Building - Avoid contamination
function _help_build_json_cache_clean() {
  local parsed_data="$1"
  
  # Build JSON in a completely isolated way
  python3 -c "
import sys
import json

# Read parsed data
parsed_lines = '''$parsed_data'''.strip().split('\n')

functions = {}
all_tags = set()

for line in parsed_lines:
    if not line.strip():
        continue
        
    parts = line.split('|')
    if len(parts) != 4:
        continue
        
    func_type, name, tags, desc = parts
    
    # Clean up the data
    tags = tags.strip()
    desc = desc.strip()
    
    # Add to functions
    functions[name] = {
        'type': func_type,
        'tags': tags,
        'desc': desc
    }
    
    # Collect tags
    if tags:
        for tag in tags.split(','):
            tag = tag.strip()
            if tag:
                all_tags.add(tag)

# Build final JSON
result = {
    'functions': functions,
    'tags': sorted(list(all_tags))
}

print(json.dumps(result, separators=(',', ':')))
"
}

# Test the clean version
function _help_rebuild_cache_clean() {
  local cache_file=$(_help_get_cache_file)
  local cache_dir="${cache_file:h}"
  
  # Ensure cache directory exists
  mkdir -p "$cache_dir"
  
  echo "🔄 Rebuilding function cache (clean version)..."
  echo "   Cache file: $cache_file"
  
  # Parse all files
  local parsed_data
  parsed_data=$(_help_parse_all_files)
  
  if [[ -z "$parsed_data" ]]; then
    echo "❌ No functions found to cache" >&2
    return 1
  fi
  
  # Convert parsed data to JSON using clean method
  local json_data
  json_data=$(_help_build_json_cache_clean "$parsed_data")
  
  # Write to cache file
  echo "$json_data" > "$cache_file"
  
  if [[ $? -eq 0 ]]; then
    local func_count=$(echo "$parsed_data" | wc -l | tr -d ' ')
    echo "✅ Cache rebuilt successfully with $func_count functions"
    
    # Validate JSON
    if python3 -m json.tool "$cache_file" >/dev/null 2>&1; then
      echo "✅ JSON validation passed"
    else
      echo "❌ JSON validation failed"
    fi
    
    return 0
  else
    echo "❌ Failed to write cache file" >&2
    return 1
  fi
}