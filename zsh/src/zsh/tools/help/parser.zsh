#!/usr/bin/env zsh

# Help System Parser - Extract functions and tags from source files
# Parses zsh source files to build function metadata

function _help_parse_all_files() {
  local aliases_dir="$ZSH_CONFIG_DIR/aliases"
  local -a all_files
  local parsed_data=""
  
  if [[ ! -d "$aliases_dir" ]]; then
    echo "❌ Aliases directory not found: $aliases_dir" >&2
    return 1
  fi

  # Find all .zsh files
  all_files=($(/usr/bin/find "$aliases_dir" -name "*.zsh" -type f 2>/dev/null))
  
  # Fallback if command find failed
  if [[ ${#all_files[@]} -eq 0 ]]; then
    all_files=($(ls -1 "$aliases_dir"/**/*.zsh 2>/dev/null))
  fi
  
  if [[ ${#all_files[@]} -eq 0 ]]; then
    echo "❌ No .zsh files found in $aliases_dir" >&2
    return 1
  fi

  echo "📂 Parsing ${#all_files[@]} files..." >&2
  
  # Parse each file
  local file
  for file in "${all_files[@]}"; do
    echo "   Processing: ${file:t}..." >&2
    parsed_data+="$(_help_parse_file "$file")"$'\n'
  done

  echo "$parsed_data"
}

function _help_parse_file() {
  local file="$1"
  local file_tags=""
  local section_name=""
  local section_tags=""
  local current_function=""
  local function_tags=""
  local function_desc=""
  local in_help_block=false
  local help_text=""
  local line_num=0
  local output=""

  # Infer tags from file path
  local inferred_tags=$(_help_infer_tags_from_path "$file")
  
  while IFS= read -r line || [[ -n "$line" ]]; do
    ((line_num++))
    
    # Parse section definitions
    if [[ "$line" =~ '^### Section ([^:]+): (.+)$' ]]; then
      section_name="${match[1]}"
      section_tags="${match[2]}"
      continue
    fi
    
    # Parse section endings
    if [[ "$line" =~ '^### EndSection ([^[:space:]]+)' ]]; then
      if [[ "${match[1]}" == "$section_name" ]]; then
        section_name=""
        section_tags=""
      fi
      continue
    fi
    
    # Parse explicit function tags
    if [[ "$line" =~ '^# Tags: (.+)$' ]]; then
      function_tags="${match[1]}"
      continue
    fi
    
    # Parse function definitions
    if [[ "$line" =~ '^function ([a-zA-Z_][a-zA-Z0-9_]*)\(\)' ]]; then
      current_function="${match[1]}"
      in_help_block=false
      help_text=""
      continue
    fi
    
    # Parse alias definitions
    if [[ "$line" =~ '^alias ([a-zA-Z_][a-zA-Z0-9_]*)=' ]]; then
      local alias_name="${match[1]}"
      local alias_value="${line#*=}"
      # Remove quotes
      alias_value="${alias_value#[\"\']}"
      alias_value="${alias_value%[\"\']}"
      
      # Combine all tags for this alias
      local combined_tags="$inferred_tags"
      [[ -n "$section_tags" ]] && combined_tags="$combined_tags $section_tags"
      [[ -n "$function_tags" ]] && combined_tags="$combined_tags $function_tags"
      
      output+="ALIAS|$alias_name|$(echo $combined_tags | tr ' ' ',')|$alias_value"$'\n'
      function_tags=""
      continue
    fi
    
    # Look for help text inside functions
    if [[ -n "$current_function" ]]; then
      if [[ "$line" =~ 'if.*\[\[.*"\$1".*==.*"-h"' ]]; then
        in_help_block=true
        continue
      fi
      
      if [[ "$in_help_block" == true ]]; then
        if [[ "$line" =~ 'return [0-9]' ]] || [[ "$line" =~ '^  fi$' ]] || [[ "$line" =~ '^}$' ]]; then
          # End of help block or function
          if [[ -n "$help_text" ]]; then
            # Extract first meaningful description line
            local desc=$(echo "$help_text" | /usr/bin/grep -E '^[[:space:]]*echo[[:space:]]+"[^"]*"' | head -1 | /usr/bin/sed -E 's/.*echo[[:space:]]+"([^"]*)".*$/\1/' | /usr/bin/sed 's/Usage: [^[:space:]]* *-* *//')
            
            # Combine all tags for this function
            local combined_tags="$inferred_tags"
            [[ -n "$section_tags" ]] && combined_tags="$combined_tags $section_tags" 
            [[ -n "$function_tags" ]] && combined_tags="$combined_tags $function_tags"
            
            output+="FUNCTION|$current_function|$(echo $combined_tags | tr ' ' ',')|$desc"$'\n'
          fi
          current_function=""
          function_tags=""
          in_help_block=false
          help_text=""
          continue
        fi
        
        help_text+="$line"$'\n'
      fi
    fi
    
  done < "$file"
  
  echo "$output"
}

function _help_infer_tags_from_path() {
  local file="$1"
  local relative_path="${file#*aliases/}"
  local tags=""
  
  # Map common patterns
  case "$relative_path" in
    kubernetes.zsh)
      tags="kube"
      ;;
    git/*)
      tags="git"
      local subfile="${relative_path#git/}"
      case "${subfile%%.zsh}" in
        bisect) tags="$tags bisect" ;;
        stash) tags="$tags stash" ;;
        rebase) tags="$tags rebase" ;;
        tags) tags="$tags tag" ;;
        cherry-pick) tags="$tags cherry-pick" ;;
        worktree) tags="$tags worktree" ;;
        prune) tags="$tags prune" ;;
        fzf) tags="$tags fzf" ;;
        core) tags="$tags core" ;;
      esac
      ;;
    searching.zsh)
      tags="search"
      ;;
    docker.zsh)
      tags="docker"
      ;;
    utils.zsh)
      tags="util"
      ;;
    nvim.zsh)
      tags="nvim"
      ;;
  esac
  
  echo "$tags"
}