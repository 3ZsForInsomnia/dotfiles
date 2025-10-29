#!/usr/bin/env zsh

# Git Cherry-Pick Operations
# Smart defaults and interactive helpers for cherry-picking commits

### Core Cherry-Pick Operations

function gcp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcp <commit> [commits...]"
    echo "Cherry-pick commit(s)"
    echo "Examples:"
    echo "  gcp abc123           # Cherry-pick single commit"
    echo "  gcp abc123 def456    # Cherry-pick multiple commits"
    echo "  gcp abc123..def456   # Cherry-pick range of commits"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: commit hash required"
    echo "Use 'gl' to see commit history or 'fcpick' for interactive selection"
    return 1
  fi
  
  git cherry-pick "$@"
}

function gcpn() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcpn <commit> [commits...]"
    echo "Cherry-pick commit(s) without committing (--no-commit)"
    echo "Useful for reviewing changes before committing"
    echo "Examples:"
    echo "  gcpn abc123    # Stage changes without committing"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: commit hash required"
    return 1
  fi
  
  git cherry-pick --no-commit "$@"
}

function gcpx() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcpx <commit> [commits...]"
    echo "Cherry-pick with -x flag"
    echo "Adds '(cherry picked from commit <hash>)' line to commit message"
    echo "Useful for tracking cherry-picks between branches or releases"
    echo "Examples:"
    echo "  gcpx abc123    # Cherry-pick with tracking info"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: commit hash required"
    return 1
  fi
  
  git cherry-pick -x "$@"
}

### Cherry-Pick Control

function gcpc() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcpc"
    echo "Continue cherry-pick after resolving conflicts"
    return 0
  fi
  git cherry-pick --continue
}

function gcpa() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcpa"
    echo "Abort current cherry-pick operation"
    return 0
  fi
  git cherry-pick --abort
}

function gcps() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcps"
    echo "Skip current commit during cherry-pick"
    return 0
  fi
  git cherry-pick --skip
}

function gcpq() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcpq"
    echo "Quit cherry-pick operation (like abort but keeps current state)"
    return 0
  fi
  git cherry-pick --quit
}

### Interactive Cherry-Pick with FZF

function fcpick() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fcpick [branch]"
    echo "Interactive commit picker for cherry-picking"
    echo "Shows commits from specified branch (defaults to main)"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Cherry-pick selected commit(s)"
    echo "  Ctrl-X    - Cherry-pick with -x flag (adds tracking info)"
    echo "  Ctrl-N    - Cherry-pick without committing (stage changes only)"
    echo "  Tab       - Select multiple commits"
    echo "  Ctrl-C    - Cancel selection"
    echo ""
    echo "Examples:"
    echo "  fcpick        # Pick from main branch"
    echo "  fcpick dev    # Pick from dev branch"
    return 0
  fi
  
  local source_branch="${1:-$GIT_MAIN_BRANCH}"
  local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  
  if [[ "$current_branch" == "$source_branch" ]]; then
    echo "Error: cannot cherry-pick from same branch"
    return 1
  fi
  
  # Get commits that are in source_branch but not in current branch
  local commits
  commits=$(git log --oneline --pretty=format:"%h %s %C(green)(%cr)%C(reset) %C(blue)<%an>%C(reset)" \
    ${current_branch}..${source_branch} 2>/dev/null)
  
  if [[ -z "$commits" ]]; then
    echo "No commits found in $source_branch that aren't in $current_branch"
    return 0
  fi
  
  local selected
  selected=$(echo "$commits" | \
    fzf --ansi \
        --reverse \
        --multi \
        --preview="$ZSH_PREVIEWS_DIR/git-commit.zsh {1}" \
        --preview-window="right:65%:wrap" \
        --bind="enter:accept" \
        --bind="ctrl-x:accept" \
        --bind="ctrl-n:accept" \
        --print-query \
        --expect="ctrl-x,ctrl-n" \
        --header="Enter=cherry-pick, Ctrl-X=cherry-pick -x, Ctrl-N=no-commit, Ctrl-S=inspect, Tab=multi-select")
  
  if [[ -z "$selected" ]]; then
    return 0
  fi
  
  # Parse fzf output
  local lines=("${(@f)selected}")
  local query="${lines[1]}"
  local key="${lines[2]}"
  local commits_selected=("${lines[@]:2}")
  
  if [[ ${#commits_selected[@]} -eq 0 ]]; then
    return 0
  fi
  
  # Extract commit hashes
  local hashes=()
  for commit in "${commits_selected[@]}"; do
    hashes+=($(echo "$commit" | awk '{print $1}'))
  done
  
  # Execute cherry-pick based on key pressed
  case "$key" in
    "ctrl-x")
      echo "Cherry-picking with -x: ${hashes[@]}"
      git cherry-pick -x "${hashes[@]}"
      ;;
    "ctrl-n")
      echo "Cherry-picking without commit: ${hashes[@]}"
      git cherry-pick --no-commit "${hashes[@]}"
      ;;
    *)
      echo "Cherry-picking: ${hashes[@]}"
      git cherry-pick "${hashes[@]}"
      ;;
  esac
}

function fcpicklog() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fcpicklog"
    echo "Interactive commit picker from entire git log"
    echo "Shows last 100 commits across all branches - use with caution"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Cherry-pick selected commit(s)"
    echo "  Tab       - Select multiple commits"
    echo "  Ctrl-C    - Cancel selection"
    echo ""
    echo "Note: This shows commits that may already exist in your branch"
    return 0
  fi
  
  local commits
  commits=$(git log --oneline --all --graph \
    --pretty=format:"%h %s %C(green)(%cr)%C(reset) %C(blue)<%an>%C(reset)" -100)
  
  local selected
  selected=$(echo "$commits" | \
    fzf --ansi --multi $(fzf_git_opts) \
        --preview="$ZSH_PREVIEWS_DIR/git-commit.zsh {1}" \
        --header="Enter=cherry-pick, Tab=multi-select, Ctrl-S=inspect, Ctrl-C=cancel")
  
  if [[ -z "$selected" ]]; then
    return 0
  fi
  
  # Extract commit hashes (handle the graph characters)
  local hashes=()
  while IFS= read -r line; do
    local hash=$(echo "$line" | grep -o '[a-f0-9]\{7,\}' | head -1)
    if [[ -n "$hash" ]]; then
      hashes+=("$hash")
    fi
  done <<<"$selected"
  
  if [[ ${#hashes[@]} -gt 0 ]]; then
    echo "Cherry-picking: ${hashes[@]}"
    git cherry-pick "${hashes[@]}"
  fi
}

### Batch Cherry-Pick Operations

function gcprange() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcprange <start-commit> <end-commit>"
    echo "Cherry-pick a range of commits (start..end)"
    echo "Example: gcprange abc123 def456"
    return 0
  fi
  
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Error: start and end commit hashes required"
    echo "Usage: gcprange <start-commit> <end-commit>"
    return 1
  fi
  
  git cherry-pick "${1}..${2}"
}

function gcplast() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcplast [n] [branch]"
    echo "Cherry-pick last n commits from branch (defaults: n=1, branch=main)"
    echo "Examples:"
    echo "  gcplast      # Last commit from main"
    echo "  gcplast 3    # Last 3 commits from main"
    echo "  gcplast 2 dev # Last 2 commits from dev"
    return 0
  fi
  
  local num_commits="${1:-1}"
  local source_branch="${2:-$GIT_MAIN_BRANCH}"
  local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  
  if [[ "$current_branch" == "$source_branch" ]]; then
    echo "Error: cannot cherry-pick from same branch"
    return 1
  fi
  
  if ! [[ "$num_commits" =~ ^[0-9]+$ ]]; then
    echo "Error: first argument must be a number"
    return 1
  fi
  
  # Get the last n commits from source branch
  local commits
  commits=($(git log --oneline -n "$num_commits" --format="%h" "$source_branch" 2>/dev/null))
  
  if [[ ${#commits[@]} -eq 0 ]]; then
    echo "No commits found in $source_branch"
    return 1
  fi
  
  # Reverse array to cherry-pick in chronological order
  local reversed_commits=()
  for ((i=${#commits[@]}-1; i>=0; i--)); do
    reversed_commits+=("${commits[$i]}")
  done
  
  echo "Cherry-picking last $num_commits commit(s) from $source_branch: ${reversed_commits[@]}"
  git cherry-pick "${reversed_commits[@]}"
}
