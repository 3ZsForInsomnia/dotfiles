#!/usr/bin/env zsh
# Global Aliases (-g) for ZSH
# These aliases can be used anywhere in a command line, not just at the beginning

# ===== SEARCHING =====
alias -g G='| rg -i '   # Case-insensitive grep with ripgrep
alias -g GV='| rg -v'   # Invert match
alias -g GC='| rg -C 3' # Show 3 lines of context

# ===== SELECTION =====
alias -g F='| fzf' # Interactive filtering

# ===== TEXT PROCESSING =====
alias -g L='| less'                        # Paging
alias -g SO='| sort'                       # Simple sort
alias -g U='| sort | uniq'                 # Remove duplicates
alias -g UC='| sort | uniq -c'             # Count occurrences
alias -g USD='| sort | uniq -c | sort -nr' # Sort by frequency

# ===== TRUNCATION =====
alias -g H='| head' # First few lines
alias -g H1='| head -n 10'
alias -g H2='| head -n 20'
alias -g T='| tail' # Last few lines
alias -g T1='| tail -n 10'
alias -g T2='| tail -n 20'

# ===== DATA FORMATTING =====
alias -g J='| jq' # JSON processing
alias -g Z='| fx' # JSON viewer

# ===== TEXT MANIPULATION =====
alias -g X='| xargs' # Command building
alias -g C='| cut'   # Cut columns
alias -g TR='| tr'   # Translate characters
alias -g S='| sed'   # Stream editor
alias -g A='| awk'   # Text processing
alias -g W='| wc -l' # Count lines

# ===== COLUMN EXTRACTION =====
alias -g K='| awky' # Custom awk wrapper

# AWK column selector function
function awky() {
  awk -v var="$1" '{print $var}'
}

# Column selection shortcuts
for i in {1..9}; do
  alias -g F$i="| awky $i"
done

# ===== CLIPBOARD OPERATIONS =====
if [ "$MY_SYSTEM" = "linux" ]; then
  alias -g PC='| xclip -sel clip'    # Pipe to clipboard
  alias -g PP='| xclip -sel clip -o' # Pipe from clipboard
  alias P='xclip -sel clip -o'       # Print clipboard

  alias copy='xclip -sel clip -o'  # Clipboard command
  alias paste='xclip -sel clip -o' # Paste command

  alias clip="copyq"
elif [ "$MY_SYSTEM" = "mac" ]; then
  alias -g PC='| pbcopy'
  alias -g PP='| pbpaste'
  alias P='pbpaste'

  alias copy='pbcopy'
  alias paste='pbpaste'

  alias clip="/Applications/CopyQ.app/Contents/MacOS/CopyQ"
fi

function cl() {
  local position=${1:-0} # Default to clipboard position 0
  clip read "$position"
}

# For use in command substitution
function CL() {
  local position=${1:-0}
  cl "$position" # No need for echo + command substitution
}

# ===== EDITING & OUTPUT =====
alias -g V='| nvim '   # Pipe to Neovim
alias -g O='> wtf.txt' # Quick output file
