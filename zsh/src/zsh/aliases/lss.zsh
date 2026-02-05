#!/usr/bin/env zsh
# lss - enhanced ls with filtering and sorting options

function lss() {
  # Parse options using zparseopts
  local -A opts
  local -a args
  zparseopts -D -E -A opts -- h -help c s d: n: -rev

  # Show help
  if [[ -n "${opts[-h]}" || -n "${opts[--help]}" ]]; then
    cat <<EOF
Usage: lss [OPTIONS] [DIRECTORY]

Enhanced ls with filtering and sorting options.

Options:
  -d <days>    Filter to files modified/created in last N days
  -n <num>     Limit output to N results
  -c           Use creation date (for filtering and sorting)
  -s           Sort by size (largest first)
  --rev        Reverse sort order
  -h, --help   Show this help message

Defaults:
  - Sort by modification date (newest first)
  - Size sorting: largest to smallest
  - Date sorting: most recent to oldest
  - Directory: current directory

Examples:
  lss              # All files, sorted by modified date
  lss -d7          # Files modified in last 7 days
  lss -d7 -n10     # Top 10 files from last 7 days
  lss -c -d7       # Files created in last 7 days, sorted by created date
  lss -s -d7       # Files modified in last 7 days, sorted by size
  lss -n5 -s       # Top 5 files sorted by size
  lss --rev        # All files, oldest first
  lss -d7 ../dir   # Files in ../dir from last 7 days

Note: -c and -s are mutually exclusive
EOF
    return 0
  fi

  # Check for mutually exclusive flags
  if [[ -n "${opts[-c]}" && -n "${opts[-s]}" ]]; then
    echo "Error: -c and -s flags are mutually exclusive" >&2
    return 1
  fi

  # Get remaining positional arguments (directory path)
  local target_dir="${@[-1]:-.}"
  
  # If last arg looks like it's still in opts or empty, use current dir
  if [[ -z "$target_dir" || "$target_dir" == -* ]]; then
    target_dir="."
  fi

  # Build eza command
  local eza_cmd="eza -lahUm -F --icons --git --color=always"
  
  # Determine sort field
  if [[ -n "${opts[-s]}" ]]; then
    # Sort by size
    eza_cmd="$eza_cmd --sort=size --reverse"
  elif [[ -n "${opts[-c]}" ]]; then
    # Sort by creation date
    eza_cmd="$eza_cmd --sort=created --reverse"
  else
    # Default: sort by modification date
    eza_cmd="$eza_cmd --sort=modified --reverse"
  fi

  # Add reverse flag if needed (this will un-reverse, making it ascending)
  if [[ -n "${opts[--rev]}" ]]; then
    eza_cmd="$eza_cmd --reverse"
  fi

  # Add target directory
  eza_cmd="$eza_cmd '$target_dir'"

  # Execute base command
  local output
  output=$(eval "$eza_cmd" 2>&1)
  
  if [[ $? -ne 0 ]]; then
    echo "$output" >&2
    return 1
  fi

  # Apply time filter if -d is specified
  if [[ -n "${opts[-d]}" ]]; then
    local days="${opts[-d]}"
    local cutoff_date=$(date -v-${days}d +%s 2>/dev/null || date -d "${days} days ago" +%s 2>/dev/null)
    
    if [[ -z "$cutoff_date" ]]; then
      echo "Error: Could not calculate cutoff date" >&2
      return 1
    fi

    # Filter by checking file modification or creation time
    local filtered_output=""
    local header_line=""
    local line_num=0
    
    while IFS= read -r line; do
      ((line_num++))
      
      # Keep the header line
      if [[ $line_num -eq 1 ]]; then
        header_line="$line"
        continue
      fi
      
      # Extract filename from the line (last field after stripping ANSI codes)
      local filename=$(echo "$line" | sed -E 's/.*[[:space:]]([^[:space:]]+)[[:space:]]*$/\1/' | sed 's/[*/@|]$//')
      
      # Get the full path
      local filepath
      if [[ "$target_dir" == "." ]]; then
        filepath="$filename"
      else
        filepath="${target_dir}/${filename}"
      fi
      
      # Check if file exists and get its timestamp
      if [[ -e "$filepath" ]]; then
        local file_date
        if [[ -n "${opts[-c]}" ]]; then
          # Use creation/birth time
          file_date=$(stat -f %B "$filepath" 2>/dev/null || stat -c %W "$filepath" 2>/dev/null)
        else
          # Use modification time
          file_date=$(stat -f %m "$filepath" 2>/dev/null || stat -c %Y "$filepath" 2>/dev/null)
        fi
        
        # Compare with cutoff date
        if [[ -n "$file_date" && "$file_date" -ge "$cutoff_date" ]]; then
          filtered_output="${filtered_output}${line}\n"
        fi
      fi
    done <<< "$output"
    
    # Reconstruct output with header
    if [[ -n "$filtered_output" ]]; then
      output="${header_line}\n${filtered_output}"
    else
      output="${header_line}\n"
    fi
  fi

  # Apply result limit if -n is specified
  if [[ -n "${opts[-n]}" ]]; then
    local limit="${opts[-n]}"
    # Add 1 to account for header line
    output=$(echo -e "$output" | head -n $((limit + 1)))
  fi

  # Output the result
  echo -e "$output"
}
