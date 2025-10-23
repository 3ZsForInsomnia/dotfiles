alias vc="vectorcode"

alias runVectorDb="docker run -d -v ~/.local/share/chromadb:/data -p 8000:8000 chromadb/chroma:0.6.3"

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

# takes a list of filetypes and runs `vectorcode vectorise` on them
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
