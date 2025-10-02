#!/usr/bin/env zsh

# Git Worktree Operations
# Manage multiple working directories for the same repository
# Complements worktree-cli for additional worktree operations

# Default main branch
export GIT_MAIN_BRANCH="${GIT_MAIN_BRANCH:-main}"

### Core Worktree Operations

function gwt() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwt"
    echo "List all worktrees with status"
    return 0
  fi
  git worktree list
}

function gwta() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwta <path> [branch]"
    echo "Add new worktree"
    echo "Examples:"
    echo "  gwta ../feature-x feature/login    # New worktree for existing branch"
    echo "  gwta ../hotfix -b hotfix/critical  # New worktree with new branch"
    echo "  gwta ../main main                  # New worktree for main branch"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: path required"
    echo "Usage: gwta <path> [branch]"
    return 1
  fi
  
  local path="$1"
  shift
  
  if [[ -n "$1" ]]; then
    git worktree add "$path" "$@"
  else
    echo "Error: branch name required"
    echo "Usage: gwta <path> <branch> or gwta <path> -b <new-branch>"
    return 1
  fi
}

function gwtab() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwtab <path> <branch-name>"
    echo "Add worktree with new branch"
    echo "Examples:"
    echo "  gwtab ../feature-x feature/login"
    echo "  gwtab ../hotfix hotfix/critical"
    return 0
  fi
  
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Error: path and branch name required"
    echo "Usage: gwtab <path> <branch-name>"
    return 1
  fi
  
  git worktree add -b "$2" "$1"
}

function gwtr() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwtr <path>"
    echo "Remove worktree"
    echo "Example: gwtr ../feature-x"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: path required"
    return 1
  fi
  
  git worktree remove "$1"
}

function gwtrf() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwtrf <path>"
    echo "Force remove worktree (even with uncommitted changes)"
    echo "Example: gwtrf ../feature-x"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: path required"
    return 1
  fi
  
  git worktree remove --force "$1"
}

function gwtm() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwtm <old-path> <new-path>"
    echo "Move worktree to new location"
    echo "Example: gwtm ../old-feature ../new-feature"
    return 0
  fi
  
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Error: old path and new path required"
    echo "Usage: gwtm <old-path> <new-path>"
    return 1
  fi
  
  git worktree move "$1" "$2"
}

### Interactive Worktree Management with FZF

function fwt() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fwt"
    echo "Interactive worktree browser and manager"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Change to worktree directory"
    echo "  Ctrl-R    - Remove worktree"
    echo "  Ctrl-M    - Move worktree"
    echo "  Ctrl-S    - Show worktree status"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi
  
  local worktrees
  worktrees=$(git worktree list --porcelain 2>/dev/null)
  
  if [[ -z "$worktrees" ]]; then
    echo "No worktrees found"
    return 0
  fi
  
  # Parse worktree list into display format
  local display_lines=()
  local worktree_paths=()
  local worktree_branches=()
  
  local current_path=""
  local current_branch=""
  local current_head=""
  
  while IFS= read -r line; do
    if [[ "$line" =~ ^worktree\ (.*) ]]; then
      # Save previous entry
      if [[ -n "$current_path" ]]; then
        local display_line="$current_path"
        [[ -n "$current_branch" ]] && display_line="$display_line [$current_branch]"
        [[ "$current_head" == "detached" ]] && display_line="$display_line (detached)"
        display_lines+=("$display_line")
        worktree_paths+=("$current_path")
        worktree_branches+=("$current_branch")
      fi
      
      current_path="${match[1]}"
      current_branch=""
      current_head=""
    elif [[ "$line" =~ ^branch\ refs/heads/(.*) ]]; then
      current_branch="${match[1]}"
    elif [[ "$line" =~ ^HEAD\ (.{40}) ]]; then
      current_head="detached"
    fi
  done <<<"$worktrees"
  
  # Don't forget the last entry
  if [[ -n "$current_path" ]]; then
    local display_line="$current_path"
    [[ -n "$current_branch" ]] && display_line="$display_line [$current_branch]"
    [[ "$current_head" == "detached" ]] && display_line="$display_line (detached)"
    display_lines+=("$display_line")
    worktree_paths+=("$current_path")
    worktree_branches+=("$current_branch")
  fi
  
  if [[ ${#display_lines[@]} -eq 0 ]]; then
    echo "No worktrees found"
    return 0
  fi
  
  local selected
  while selected=$(printf '%s\n' "${display_lines[@]}" | \
    fzf $(fzf_git_opts) \
        --preview="_show_worktree_preview {}" \
        --bind="enter:accept" \
        --bind="ctrl-r:accept" \
        --bind="ctrl-m:accept" \
        --bind="ctrl-s:accept" \
        --print-query \
        --expect="ctrl-r,ctrl-m,ctrl-s" \
        --header="Enter=cd, Ctrl-R=remove, Ctrl-M=move, Ctrl-S=status, Alt-P=toggle preview"); do
    
    # Parse fzf output
    local lines=("${(@f)selected}")
    local query="${lines[1]}"
    local key="${lines[2]}"
    local selection="${lines[3]}"
    
    [[ -z "$selection" ]] && break
    
    # Find the selected worktree path
    local selected_path=""
    for ((i=1; i<=${#display_lines[@]}; i++)); do
      if [[ "${display_lines[$i]}" == "$selection" ]]; then
        selected_path="${worktree_paths[$i]}"
        break
      fi
    done
    
    [[ -z "$selected_path" ]] && continue
    
    case "$key" in
      "ctrl-r")
        echo "Remove worktree '$selected_path'? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
          git worktree remove "$selected_path" && echo "Removed: $selected_path"
          # Refresh the list
          worktrees=$(git worktree list --porcelain 2>/dev/null)
          [[ -z "$worktrees" ]] && { echo "No more worktrees"; break; }
          # Re-parse worktrees (simplified for demo)
          display_lines=($(git worktree list | awk '{print $1}'))
          worktree_paths=("${display_lines[@]}")
        fi
        ;;
      "ctrl-m")
        echo "Enter new path for '$selected_path':"
        read -r new_path
        if [[ -n "$new_path" ]]; then
          git worktree move "$selected_path" "$new_path" && echo "Moved to: $new_path"
        fi
        ;;
      "ctrl-s")
        echo "Status of worktree: $selected_path"
        (cd "$selected_path" && git status --short --branch)
        echo "Press Enter to continue..."
        read -r
        ;;
      "")
        if [[ -d "$selected_path" ]]; then
          echo "Changing to: $selected_path"
          cd "$selected_path"
          break
        else
          echo "Directory not found: $selected_path"
        fi
        ;;
    esac
  done
}

function _show_worktree_preview() {
  local worktree_line="$1"
  local path=$(echo "$worktree_line" | awk '{print $1}')
  
  if [[ ! -d "$path" ]]; then
    echo "Directory not found: $path"
    return
  fi
  
  echo "📁 Worktree: $path"
  echo ""
  
  # Show git status
  echo "📊 Status:"
  (cd "$path" && git status --short --branch 2>/dev/null) || echo "Not a git repository"
  echo ""
  
  # Show recent commits
  echo "📋 Recent commits:"
  (cd "$path" && git log --oneline -5 2>/dev/null) || echo "No commits"
  echo ""
  
  # Show disk usage
  echo "💾 Disk usage:"
  du -sh "$path" 2>/dev/null || echo "Unknown"
}

# Export for FZF
# export -f _show_worktree_preview

### Branch-Based Worktree Operations

function gwtbr() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwtbr <branch-name> [path]"
    echo "Create worktree for branch (path defaults to ../branch-name)"
    echo "Examples:"
    echo "  gwtbr feature/login           # Creates ../feature-login"
    echo "  gwtbr feature/auth ../auth    # Creates ../auth"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi
  
  local branch="$1"
  local path="$2"
  
  # Default path based on branch name
  if [[ -z "$path" ]]; then
    # Convert branch name to directory name
    path="../$(echo "$branch" | sed 's|/|-|g')"
  fi
  
  # Check if branch exists
  if git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
    echo "Creating worktree for existing branch '$branch' at '$path'"
    git worktree add "$path" "$branch"
  else
    echo "Branch '$branch' doesn't exist. Create new branch? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo "Creating worktree with new branch '$branch' at '$path'"
      git worktree add -b "$branch" "$path"
    else
      echo "Cancelled."
      return 1
    fi
  fi
}

### Worktree Cleanup and Maintenance

function gwtprune() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwtprune"
    echo "Remove worktree entries for deleted directories"
    echo "Cleans up worktree list when directories were manually deleted"
    return 0
  fi
  
  echo "Pruning stale worktree entries..."
  git worktree prune -v
}

function gwtcheck() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwtcheck"
    echo "Check all worktrees for issues (missing directories, etc.)"
    return 0
  fi
  
  local issues_found=false
  
  echo "Checking all worktrees..."
  echo ""
  
  git worktree list --porcelain | while IFS= read -r line; do
    if [[ "$line" =~ ^worktree\ (.*) ]]; then
      local path="${match[1]}"
      if [[ ! -d "$path" ]]; then
        echo "❌ Missing directory: $path"
        issues_found=true
      else
        echo "✅ OK: $path"
      fi
    fi
  done
  
  echo ""
  if $issues_found; then
    echo "Issues found. Run 'gwtprune' to clean up stale entries."
  else
    echo "All worktrees OK!"
  fi
}

### Quick Worktree Shortcuts

function gwtmain() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwtmain [path]"
    echo "Create worktree for main branch (defaults to ../main)"
    return 0
  fi
  
  local path="${1:-../main}"
  echo "Creating worktree for $GIT_MAIN_BRANCH at '$path'"
  git worktree add "$path" "$GIT_MAIN_BRANCH"
}

function gwtft() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gwtft <feature-name> [path]"
    echo "Create worktree for feature/ branch"
    echo "Examples:"
    echo "  gwtft login        # Creates worktree for feat/login at ../feat-login"
    echo "  gwtft auth ../auth # Creates worktree for feat/auth at ../auth"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: feature name required"
    return 1
  fi
  
  local feature_name="$1"
  local branch="feat/$feature_name"
  local path="${2:-../feat-$feature_name}"
  
  gwtbr "$branch" "$path"
}
