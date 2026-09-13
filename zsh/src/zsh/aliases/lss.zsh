#!/usr/bin/env zsh
# lss - enhanced ls with filtering and sorting options

function lss() {
  # Parse options using zparseopts
  local -A opts
  local -a args
  zparseopts -D -E -A opts -- h -help c s r d: n: -rev

  # Show help
  if [[ -n "${opts[-h]}" || -n "${opts[--help]}" ]]; then
    cat <<EOF
Usage: lss [OPTIONS] [DIRECTORY]

Enhanced ls with filtering and sorting options.

Options:
  -d <days>    Filter to files modified/created in last N days
  -n <num>     Limit output to N results
  -c           Use creation date (for filtering and sorting)
  -s           Sort by size
  -r, --rev    Reverse sort order (newest/largest first)
  -h, --help   Show this help message

Defaults:
  - Sort by modification date, ascending (newest nearest the prompt)
  - Size sorting: smallest to largest (largest nearest the prompt)
  - Date sorting: oldest to most recent
  - Directory: current directory
  - Output pages through less when it exceeds page_threshold items

Examples:
  lss              # All files, sorted by modified date
  lss -d7          # Files modified in last 7 days
  lss -d7 -n10     # Top 10 files from last 7 days
  lss -c -d7       # Files created in last 7 days, sorted by created date
  lss -s -d7       # Files modified in last 7 days, sorted by size
  lss -n5 -s -r    # Top 5 largest files
  lss --rev        # All files, newest first
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

  # Page the output through less once it exceeds this many items (header excluded).
  local page_threshold=15

  # Get remaining positional arguments (directory path)
  local target_dir="${@[-1]:-.}"
  
  # If last arg looks like it's still in opts or empty, use current dir
  if [[ -z "$target_dir" || "$target_dir" == -* ]]; then
    target_dir="."
  fi

  # Build eza command
  local eza_cmd="eza -lahUm -F --icons --git --color=always"
  
  # Determine sort field. Default is ascending, so the newest (or largest) item
  # lands nearest the prompt instead of scrolling off the top.
  if [[ -n "${opts[-s]}" ]]; then
    eza_cmd="$eza_cmd --sort=size"
  elif [[ -n "${opts[-c]}" ]]; then
    eza_cmd="$eza_cmd --sort=created"
  else
    eza_cmd="$eza_cmd --sort=modified"
  fi

  # -r/--rev flips to descending (newest/largest first).
  if [[ -n "${opts[-r]}" || -n "${opts[--rev]}" ]]; then
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

  # Output the result, paging through less when the list is long enough to warrant it.
  local rendered
  rendered=$(echo -e "$output")
  local item_count=$(($(printf '%s\n' "$rendered" | wc -l) - 1))

  if [[ -t 1 && $item_count -gt $page_threshold ]]; then
    # -R keeps eza's colors and icons intact. In the ascending default the newest
    # items are at the bottom, so +G opens there; -r/--rev puts them at the top.
    local -a less_opts=(-R)
    if [[ -z "${opts[-r]}" && -z "${opts[--rev]}" ]]; then
      less_opts+=(+G)
    fi
    printf '%s\n' "$rendered" | less "${less_opts[@]}"
  else
    printf '%s\n' "$rendered"
  fi
}
