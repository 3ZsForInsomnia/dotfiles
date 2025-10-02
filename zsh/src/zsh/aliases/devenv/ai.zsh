alias runVectorDb="docker run -v ./chroma-data:/data -p 8000:8000 chromadb/chroma"

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
  filetypes=("$@")
  path="./**/*."

  for filetype in "${filetypes[@]}"; do
    echo "Vectorising $filetype files..."
    vectorcode vectorise "$path$filetype"
  done
}

alias vc="vectorcode"
