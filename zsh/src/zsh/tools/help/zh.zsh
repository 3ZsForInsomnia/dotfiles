#!/usr/bin/env zsh

# zh - Simple tag-based function discovery
# Usage: zh [tag1] [tag2] ... or zh --rebuild-cache or zh --tags

function _zh_get_cache_file() {
  echo "${XDG_CACHE_HOME:-$HOME/.cache}/zh-cache.txt"
}

function _zh_infer_tags_from_path() {
  local file="$1"
  local relative_path="${file#*aliases/}"
  local tags=""
  
  # Handle subdirectories by parsing path components
  if [[ "$relative_path" == *"/"* ]]; then
    # Extract directory name (everything before last /)
    local dir_name="${relative_path%/*}"
    local filename="${relative_path##*/}"
    filename="${filename%%.zsh}"
    
    # Apply mappings for directory names
    case "$dir_name" in
      kubernetes) dir_name="kube" ;;
      searching) dir_name="search" ;;
      utils) dir_name="util" ;;
    esac
    
    # Apply mappings for filenames
    case "$filename" in
      kubernetes) filename="kube" ;;
      searching) filename="search" ;;
      utils) filename="util" ;;
    esac
    
    tags="$dir_name,$filename"
  else
    # Just a filename in the root aliases directory
    local filename="${relative_path%%.zsh}"
    
    # Apply mappings
    case "$filename" in
      kubernetes) filename="kube" ;;
      searching) filename="search" ;;
      utils) filename="util" ;;
    esac
    
    tags="$filename"
  fi
  
  echo "$tags"
}

function _zh_rebuild_cache() {
  local cache_file=$(_zh_get_cache_file)
  local aliases_dir="$ZSH_CONFIG_DIR/aliases"
  
  echo "🔄 Rebuilding zh cache..."
  echo "   Cache: $cache_file"
  
  # Clear cache file
  > "$cache_file"
  
  # Find and process all .zsh files
  fd -t f "\.zsh$" "$aliases_dir" | while read -r file; do
    # Skip index files
    [[ "$(basename "$file")" == "index.zsh" ]] && continue
    
    echo "   Processing: ${file:t}..."
    
    local file_tags=$(_zh_infer_tags_from_path "$file")
    
    # Parse aliases and functions
    local section_name=""
    local section_tags=""
    local current_function=""
    local in_help_block=false
    local help_text=""
    
    while IFS= read -r line || [[ -n "$line" ]]; do
      # Skip empty lines and comments
      [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
      
      # Parse section start: ### Section <name>: <tags>
      if [[ "$line" =~ ^###[[:space:]]+Section && "$line" == *":"* ]]; then
        # Extract section name and tags using parameter expansion
        local section_part="${line#*Section }"  # Remove "### Section "
        section_name="${section_part%%:*}"      # Everything before :
        section_tags="${section_part#*: }"      # Everything after ": "
        section_name="${section_name// /}"      # Remove spaces from name
        continue
      fi
      
      # Parse section end: ### EndSection <name>
      if [[ "$line" =~ ^###[[:space:]]+EndSection ]]; then
        local end_section_name="${line#*EndSection }"  # Extract name
        if [[ "$end_section_name" == "$section_name" ]]; then
          section_name=""
          section_tags=""
        fi
        continue
      fi
      
      # Parse aliases
      if [[ "$line" =~ ^alias && "$line" == *"="* ]]; then
        local alias_part="${line#alias }"
        local alias_name="${alias_part%%=*}"
        alias_name="${alias_name// /}"
        local alias_value="${line#*=}"
        # Clean up value - remove quotes and problematic chars
        alias_value="${alias_value#[\"\']}"
        alias_value="${alias_value%[\"\']}"
        alias_value="${alias_value//\`/}"  # Remove backticks
        alias_value="${alias_value//\\/}"  # Remove backslashes
        
        # Combine file tags with section tags
        local combined_tags="$file_tags"
        if [[ -n "$section_tags" ]]; then
          combined_tags="$combined_tags,$section_tags"
        fi
        
        echo "ALIAS|$alias_name|$combined_tags|$alias_value" >> "$cache_file"
      fi
      
      # Parse functions
      if [[ "$line" =~ ^function && "$line" == *"()"* ]]; then
        # Extract function name using parameter expansion
        local func_part="${line#function }"  # Remove "function "
        local func_name="${func_part%%\(*}"   # Everything before (
        func_name="${func_name// /}"         # Remove spaces
        
        # Start tracking this function for help text extraction
        current_function="$func_name"
        in_help_block=false
        help_text=""
        
        # Store tags for later use
        local func_combined_tags="$file_tags"
        if [[ -n "$section_tags" ]]; then
          func_combined_tags="$func_combined_tags,$section_tags"
        fi
        continue
      fi
      
      # Look for help text inside functions
      if [[ -n "$current_function" ]]; then
        # Check for help block start - more flexible pattern
        if [[ "$line" == *'if'* && "$line" == *'"$1"'* && "$line" == *'"-h"'* ]]; then
          in_help_block=true
          continue
        fi
        
        # If we're in a help block, collect the text
        if [[ "$in_help_block" == true ]]; then
          # Check for end of help block
          if [[ "$line" == *'return 0'* ]] || [[ "$line" == *'return 1'* ]] || [[ "$line" =~ '^[[:space:]]*fi$' ]]; then
            # Extract description from help text
            local desc=""
            if [[ -n "$help_text" ]]; then
              # Look for description line (usually after Usage line)
              desc=$(echo "$help_text" | /usr/bin/grep -v "Usage:" | /usr/bin/grep -E '^[[:space:]]*echo[[:space:]]+"[^"]*"' | head -1 | sed -E 's/.*echo[[:space:]]+"([^"]*)".*$/\1/')
              # If no non-Usage line found, extract from Usage line
              if [[ -z "$desc" ]]; then
                desc=$(echo "$help_text" | /usr/bin/grep "Usage:" | head -1 | sed -E 's/.*echo[[:space:]]+"([^"]*)".*$/\1/' | sed 's/Usage: [^[:space:]]* *-* *//')
              fi
            fi
            
            # Write function entry with description
            echo "FUNCTION|$current_function|$func_combined_tags|$desc" >> "$cache_file"
            
            # Reset function tracking
            current_function=""
            in_help_block=false
            help_text=""
            continue
          fi
          
          # Collect help text
          help_text+="$line"$'\n'
        fi
        
        # Check for end of function without help block
        if [[ "$line" =~ '^[[:space:]]*}' && "$in_help_block" == false ]]; then
          # Function ended without help block
          echo "FUNCTION|$current_function|$func_combined_tags|" >> "$cache_file"
          current_function=""
        fi
      fi
      
    done < "$file"
  done
  
  local count=$(wc -l < "$cache_file" | tr -d ' ')
  echo "✅ Cache rebuilt with $count items"
}

function _zh_list_tags() {
  local cache_file=$(_zh_get_cache_file)
  
  if [[ ! -f "$cache_file" ]]; then
    echo "❌ Cache not found. Run 'zh --rebuild-cache' first."
    return 1
  fi
  
  echo "📋 Available Tags:"
  echo ""
  
  # Extract all tags, split on commas, sort unique
  cut -d'|' -f3 "$cache_file" | tr ',' '\n' | /usr/bin/grep -v '^$' | sort -u | sed 's/^/  /'
}

function _zh_search() {
  local -a search_tags=("$@")
  local cache_file=$(_zh_get_cache_file)
  
  if [[ ! -f "$cache_file" ]]; then
    echo "❌ Cache not found. Run 'zh --rebuild-cache' first."
    return 1
  fi
  
  # Filter by checking each tag in the tags field (field 3)
  local results=""
  while IFS='|' read -r type name tags desc; do
    local match_all=true
    
    # Check if all search tags are present in this item's tags
    for search_tag in "${search_tags[@]}"; do
      if [[ "$tags" != *"$search_tag"* ]]; then
        match_all=false
        break
      fi
    done
    
    # If all tags match, add to results
    if [[ "$match_all" == true ]]; then
      if [[ -n "$results" ]]; then
        results+=$'\n'
      fi
      results+="$type|$name|$desc"
    fi
  done < "$cache_file"
  
  if [[ -z "$results" ]]; then
    echo "No functions found matching tags: $*"
    echo ""
    echo "💡 Use 'zh --tags' to see all available tags"
    return 1
  fi
  
  echo "🔍 Functions matching tags: $*"
  echo ""
  
  # Display results
  echo "$results" | while IFS='|' read -r type name desc; do
    printf "  %-20s (%s) - %s\n" "$name" "$type" "$desc"
  done
  
  local count=$(echo "$results" | wc -l | tr -d ' ')
  echo ""
  echo "Found $count item(s)"
}

function zh() {
  case "$1" in
    -h|--help)
      echo "Usage: zh [tag1] [tag2] ... [tagN]"
      echo "Show functions/aliases matching ALL specified tags"
      echo ""
      echo "Options:"
      echo "  --rebuild-cache    Rebuild function cache"
      echo "  --tags             List all available tags"
      echo ""
      echo "Examples:"
      echo "  zh                 # Show popular tag combinations"
      echo "  zh git             # All git-related functions"
      echo "  zh git core        # Core git operations"
      echo "  zh git fzf         # Interactive git browsers"
      echo "  zh kube            # Kubernetes functions"
      echo "  zh docker          # Docker commands"
      echo "  zh search          # File and text search"
      echo ""
      echo "💡 Use 'zh --tags' to see all available tags"
      echo "💡 Tags come from file/folder names in your aliases directory"
      ;;
    --rebuild-cache)
      _zh_rebuild_cache
      ;;
    --tags)
      _zh_list_tags
      ;;
    "")
      # Show overview with popular tag combinations
      echo "🚀 zh - Tag-based Function Discovery"
      echo ""
      echo "Popular tag combinations:"
      echo "  zh git             - All git functions and aliases"
      echo "  zh git core        - Core git operations (add, commit, push, etc.)"
      echo "  zh git fzf         - Interactive git browsers"
      echo "  zh kube            - Kubernetes functions"
      echo "  zh docker          - Docker commands and aliases"
      echo "  zh search          - File and text search functions"
      echo "  zh util            - Utility functions"
      echo ""
      echo "Discover functions:"
      echo "  zh --tags          - List all available tags"
      echo "  zh <tag>           - Show functions with specific tag"
      echo "  zh <tag1> <tag2>   - Show functions with ALL specified tags"
      echo ""
      echo "💡 Tags are generated from your aliases directory structure"
      echo "💡 Use 'zh -h' for detailed help and examples"
      ;;
    *)
      _zh_search "$@"
      ;;
  esac
}

# Load completion if available
# Get the directory this script is in
_zh_script_dir="$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")"
if [[ -f "$_zh_script_dir/zh-completion.zsh" ]]; then
  source "$_zh_script_dir/zh-completion.zsh"
elif [[ -f "$ZSH_CONFIG_DIR/tools/help/zh-completion.zsh" ]]; then
  source "$ZSH_CONFIG_DIR/tools/help/zh-completion.zsh"
fi
unset _zh_script_dir