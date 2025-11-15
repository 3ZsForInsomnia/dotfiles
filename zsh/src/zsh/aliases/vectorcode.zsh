alias vc="vectorcode"
alias runVectorDb="docker run -d -v ~/.local/share/chromadb:/data -p 8000:8000 chromadb/chroma:0.6.3"

# Path to the projects list
VECTORCODE_PROJECTS_FILE="$HOME/.config/vectorcode/projects.txt"

# Ensure the config directory and file exist
_vcp_ensure_config() {
  local config_dir="$(dirname "$VECTORCODE_PROJECTS_FILE")"
  if [[ ! -d "$config_dir" ]]; then
    mkdir -p "$config_dir"
  fi
  if [[ ! -f "$VECTORCODE_PROJECTS_FILE" ]]; then
    cat >"$VECTORCODE_PROJECTS_FILE" <<EOF
EOF
  fi
}

# Sort the projects file with grouping by parent directory
# Preserves comments at top, sorts projects, adds blank lines between different parent dirs
_vcp_sort_file() {
  local temp_file
  temp_file="$(mktemp)"
  
  # Extract header comments
  rg --no-line-number --no-filename '^#' "$VECTORCODE_PROJECTS_FILE" 2>/dev/null > "$temp_file" || true
  
  # Extract, sort, and group non-comment, non-empty lines
  local -a projects
  projects=(${(f)"$(rg --no-line-number --no-filename -v '^#' "$VECTORCODE_PROJECTS_FILE" 2>/dev/null | rg --no-line-number --no-filename -v '^[[:space:]]*$' | sort -u)"})
  
  if [[ ${#projects[@]} -gt 0 ]]; then
    local last_parent=""
    local current_parent
    
    for project in "${projects[@]}"; do
      # Skip any malformed lines
      if [[ "$project" == *"<stdin>:"* ]] || [[ "$project" == *":"* && "$project" != *"/"* ]]; then
        continue
      fi
      
      # Get parent directory
      current_parent="$(dirname "$project")"
      
      # Add blank line if parent directory changed (grouping)
      if [[ -n "$last_parent" && "$current_parent" != "$last_parent" ]]; then
        echo "" >> "$temp_file"
      fi
      
      echo "$project" >> "$temp_file"
      last_parent="$current_parent"
    done
  fi
  
  mv "$temp_file" "$VECTORCODE_PROJECTS_FILE"
}

# Get all projects from the file (excluding comments and empty lines)
_vcp_get_projects() {
  _vcp_ensure_config
  rg --no-line-number --no-filename -v '^#' "$VECTORCODE_PROJECTS_FILE" | rg --no-line-number --no-filename -v '^[[:space:]]*$' | sed "s|^~|$HOME|"
}

# Check if a project exists in the list
_vcp_project_exists() {
  local project="$1"
  local expanded_project="${project/#\~/$HOME}"
  _vcp_get_projects | rg --no-line-number --no-filename -Fxq "$expanded_project"
}

# VectorCode Projects management
function vcp() {
  local subcommand="$1"

  if [[ -z "$subcommand" || "$subcommand" == "-h" || "$subcommand" == "--help" ]]; then
    cat <<EOF
Usage: vcp <command> [args]

  Commands:
    add [path]     Add a project (defaults to git root of current directory)
    remove <path>  Remove a project from the list
    list           Show all tracked projects
    sync [path]    Re-vectorise one or all projects
    edit           Open projects file in \$EDITOR
    help           Show this help message

  Examples:
    vcp add                    # Add current git repo
    vcp add ~/src/myproject    # Add specific path
    vcp remove ~/src/old       # Remove a project
    vcp list                   # List all projects
    vcp sync                   # Re-vectorise all projects
    vcp sync ~/src/myproject   # Re-vectorise specific project
EOF
    return 0
  fi

  shift

  case "$subcommand" in
  add)
    _vcp_add "$@"
    ;;
  remove | rm)
    _vcp_remove "$@"
    ;;
  list | ls)
    _vcp_list
    ;;
  sync)
    _vcp_sync "$@"
    ;;
  edit)
    _vcp_edit
    ;;
  help | -h | --help)
    vcp -h
    ;;
  *)
    echo "Error: Unknown command '$subcommand'. Use 'vcp help' for usage." >&2
    return 1
    ;;
  esac
}

# Add a project
_vcp_add() {
  _vcp_ensure_config

  local project_path="$1"

  # Default to git root if no path provided
  if [[ -z "$project_path" ]]; then
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
      echo "Error: Not in a git repository and no path provided." >&2
      return 1
    fi
    project_path="$(git rev-parse --show-toplevel)"
  fi

  # Expand and normalize path
  project_path="${project_path/#\~/$HOME}"
  project_path="$(cd "$project_path" 2>/dev/null && pwd)" || {
    echo "Error: Path '$1' does not exist." >&2
    return 1
  }

  # Check if already exists
  if _vcp_project_exists "$project_path"; then
    echo "Project already tracked: $project_path"
    return 0
  fi

  # Add to file
  echo "$project_path" >>"$VECTORCODE_PROJECTS_FILE"
  echo "Added project: $project_path"

  # Sort the file to keep it organized
  _vcp_sort_file
}

# Remove a project
_vcp_remove() {
  _vcp_ensure_config

  local project_path="$1"

  if [[ -z "$project_path" ]]; then
    echo "Error: No path provided. Usage: vcp remove <path>" >&2
    return 1
  fi

  # Expand path
  project_path="${project_path/#\~/$HOME}"

  # Check if exists
  if ! _vcp_project_exists "$project_path"; then
    echo "Error: Project not found in list: $project_path" >&2
    return 1
  fi

  # Remove from file (create temp file to avoid issues)
  local temp_file
  temp_file="$(mktemp)"
  grep -Fxv "$project_path" "$VECTORCODE_PROJECTS_FILE" >"$temp_file"
  mv "$temp_file" "$VECTORCODE_PROJECTS_FILE"

  echo "Removed project: $project_path"

  # Sort the file to keep it organized
  _vcp_sort_file
}

# List all projects
_vcp_list() {
  _vcp_ensure_config

  local projects
  projects=$(_vcp_get_projects)

  if [[ -z "$projects" ]]; then
    echo "No projects tracked yet. Use 'vcp add' to add projects."
    return 0
  fi

  echo "Tracked VectorCode projects:"
  echo ""
  
  # Sort and group projects by parent directory
  local -a project_list
  project_list=(${(f)projects})
  
  local last_parent=""
  local current_parent
  
  for project in "${project_list[@]}"; do
    current_parent="$(dirname "$project")"
    
    # Add blank line if parent directory changed (grouping)
    if [[ -n "$last_parent" && "$current_parent" != "$last_parent" ]]; then
      echo ""
    fi
    
    echo "  $project"
    last_parent="$current_parent"
  done
}

# Sync (re-vectorise) projects
_vcp_sync() {
  _vcp_ensure_config

  local target_path="$1"
  local projects

  if [[ -n "$target_path" ]]; then
    # Sync specific project
    target_path="${target_path/#\~/$HOME}"

    if ! _vcp_project_exists "$target_path"; then
      echo "Error: Project not found in list: $target_path" >&2
      echo "Use 'vcp list' to see tracked projects." >&2
      return 1
    fi

    projects="$target_path"
  else
    # Sync all projects
    projects=$(_vcp_get_projects)

    if [[ -z "$projects" ]]; then
      echo "No projects to sync. Use 'vcp add' to add projects." >&2
      return 0
    fi
  fi

  local total=0
  local success=0
  local failed=0

  echo "$projects" | while read -r project; do
    ((total++))

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Syncing project [$total]: $project"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [[ ! -d "$project" ]]; then
      echo "⚠️  Warning: Project directory not found, skipping: $project"
      ((failed++))
      continue
    fi

    # Run vectorcode vectorise with project root
    # Project-level config will determine what to include/exclude
    if vectorcode vectorise --project_root "$project"; then
      echo "✅ Successfully synced: $project"
      ((success++))
    else
      echo "❌ Failed to sync: $project"
      ((failed++))
    fi
  done

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Sync complete: $success succeeded, $failed failed out of $total total"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Edit the projects file
_vcp_edit() {
  _vcp_ensure_config

  local editor="${EDITOR:-vim}"
  "$editor" "$VECTORCODE_PROJECTS_FILE"
}

# Query wrapper with smart argument parsing
function vcq() {
  # Show help if -h is passed
  if [[ "$1" == "-h" ]]; then
    echo "Usage: vcq <query> [args...]"
    echo "  Runs vectorcode query with the given query and arguments."
    echo "  Numbers are passed as -n flag values"
    echo "  'path', 'document', or 'chunk' are passed as --include flag values"
    echo "  Multiple include values are joined and passed to --include"
    echo ""
    echo "Examples:"
    echo "  vcq 'search term' 5           # vectorcode query 'search term' -n 5"
    echo "  vcq 'search term' path        # vectorcode query 'search term' --include path"
    echo "  vcq 'search term' document 10 # vectorcode query 'search term' --include document -n 10"
    echo "  vcq 'search term' path chunk 5 # vectorcode query 'search term' --include 'path chunk' -n 5"
    return
  fi

  # First argument is always the query
  local query="$1"
  shift

  # Parse remaining arguments
  local include_args=()
  local n_flag=""

  for arg in "$@"; do
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
      # Argument is a number, use for -n flag
      n_flag="$arg"
    elif [[ "$arg" =~ ^(path|document|chunk)$ ]]; then
      # Argument is a valid include option
      include_args+=("$arg")
    else
      echo "Warning: Ignoring invalid argument '$arg'. Valid include options are: path, document, chunk" >&2
    fi
  done

  # Build the vectorcode command
  local cmd_args=("vectorcode" "query" "$query")

  # Add --include if we have string arguments
  if [[ ${#include_args[@]} -gt 0 ]]; then
    cmd_args+=("--include" "${include_args[*]}")
  fi

  # Add -n if we have a number argument
  if [[ -n "$n_flag" ]]; then
    cmd_args+=("-n" "$n_flag")
  fi

  # Execute the command
  "${cmd_args[@]}"
}

# Vectorise with smart filetype detection
function vca() {
  # Show help if -h is passed
  if [[ "$1" == "-h" ]]; then
    echo "Usage: vca [options] <filetype1> [filetype2] [filetype3] ..."
    echo "  Vectorises files of the specified types or exact filenames (recursive by default)."
    echo "  Arguments can be:"
    echo "    - File extensions without the dot (e.g., js, py, ts)"
    echo "    - Exact filenames starting with . (e.g., .env, .gitignore)"
    echo "    - Common extensionless files (e.g., Dockerfile, Makefile, Caddyfile)"
    echo "    - Path patterns with / or * (e.g., src/*.js, **/*.md)"
    echo ""
    echo "Options:"
    echo "  -h                Show this help message"
    echo "  -R, --no-recursive    Disable recursive search (default: recursive enabled)"
    echo "  -i                Include hidden files"
    echo "  -p <path>         Set project root path"
    echo ""
    echo "Examples:"
    echo "  vca js ts                    # Vectorise all .js and .ts files (recursive)"
    echo "  vca .env Dockerfile          # Vectorise .env and Dockerfile files"
    echo "  vca js .gitignore Makefile   # Mix extensions and exact filenames"
    echo "  vca -R py                    # Vectorise .py files in current dir only"
    echo "  vca -i js                    # Include hidden .js files"
    echo "  vca -p /path/to/root go      # Set project root and vectorise .go files"
    return
  fi

  # Parse arguments
  local recursive=true
  local include_hidden=false
  local project_root=""
  local filetypes=()
  local patterns=()

  while [[ $# -gt 0 ]]; do
    case $1 in
    -R | --no-recursive)
      recursive=false
      shift
      ;;
    -i)
      include_hidden=true
      shift
      ;;
    -p)
      if [[ -n "$2" ]]; then
        project_root="$2"
        shift 2
      else
        echo "Error: -p requires a path argument" >&2
        return 1
      fi
      ;;
    -*)
      echo "Error: Unknown option '$1'. Use 'vca -h' for help." >&2
      return 1
      ;;
    *)
      # Check if argument looks like a path pattern (contains / or *)
      if [[ "$1" == *"/"* || "$1" == *"*"* ]]; then
        patterns+=("$1")
      # Check if it's likely an exact filename (starts with . or common no-extension files)
      elif [[ "$1" == .* ]] || [[ "$1" =~ ^[A-Z][a-z]*file$ ]]; then
        patterns+=("$1")
      else
        # Treat as file extension
        filetypes+=("$1")
      fi
      shift
      ;;
    esac
  done

  if [[ ${#filetypes[@]} -eq 0 && ${#patterns[@]} -eq 0 ]]; then
    echo "Error: No filetypes or patterns specified. Use 'vca -h' for help." >&2
    return 1
  fi

  # Build vectorcode command with options
  local cmd_args=("vectorcode" "vectorise")

  if [[ "$recursive" == "true" ]]; then
    cmd_args+=("-r")
  fi

  if [[ "$include_hidden" == "true" ]]; then
    cmd_args+=("--include-hidden")
  fi

  if [[ -n "$project_root" ]]; then
    cmd_args+=("--project_root" "$project_root")
  fi

  # Add file extensions first, then patterns
  # Convert filetypes to appropriate patterns
  for filetype in "${filetypes[@]}"; do
    if [[ "$recursive" == "true" ]]; then
      cmd_args+=("**/*.$filetype")
    else
      cmd_args+=("*.$filetype")
    fi
  done
  cmd_args+=("${patterns[@]}")

  local all_args=("${filetypes[@]}" "${patterns[@]}")
  echo "Vectorising files: ${all_args[*]} (recursive: $recursive, hidden: $include_hidden)"
  echo "Executing command: ${cmd_args[*]}"
  "${cmd_args[@]}"
}

alias vcpa="vcp add"
alias vcpl="vcp list"
