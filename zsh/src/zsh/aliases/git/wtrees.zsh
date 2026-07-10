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

  local pathes="$1"
  shift

  if [[ -n "$1" ]]; then
    git worktree add "$pathes" "$@"
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

# Short, human display name for a worktree. The main worktree shows as
# "(main)"; worktrees under a ".worktrees/" dir show only the part after it
# (e.g. /repo/.worktrees/feat-x -> feat-x); anything else falls back to its
# basename.
function _gwt_display_name() {
  local wt_path="$1" main_wt="$2"
  if [[ "$wt_path" == "$main_wt" ]]; then
    print -r -- "(main)"
  elif [[ "$wt_path" == */.worktrees/* ]]; then
    print -r -- "${wt_path##*/.worktrees/}"
  else
    print -r -- "${wt_path:t}"
  fi
}

# Emit one tab-delimited fzf line per worktree: "<name> [branch] (detached)\t<abs-path>".
# The absolute path is kept as a hidden trailing column (fzf --with-nth=1) so the
# preview and the cd/remove/move actions still have the real path to work with.
function _gwt_fzf_lines() {
  local porcelain main_wt
  porcelain=$(git worktree list --porcelain 2>/dev/null)
  [[ -z "$porcelain" ]] && return 1
  main_wt=$(awk '/^worktree /{print $2; exit}' <<<"$porcelain")

  local line current_path="" current_branch="" current_head=""

  # Flush the entry we just finished parsing.
  _gwt_flush() {
    [[ -z "$current_path" ]] && return
    local display="$(_gwt_display_name "$current_path" "$main_wt")"
    [[ -n "$current_branch" ]] && display="$display [$current_branch]"
    [[ "$current_head" == "detached" ]] && display="$display (detached)"
    printf '%s\t%s\n' "$display" "$current_path"
  }

  while IFS= read -r line; do
    if [[ "$line" =~ ^worktree\ (.*) ]]; then
      _gwt_flush
      current_path="${match[1]}"; current_branch=""; current_head=""
    elif [[ "$line" =~ ^branch\ refs/heads/(.*) ]]; then
      current_branch="${match[1]}"
    elif [[ "$line" == "detached" ]]; then
      current_head="detached"
    fi
  done <<<"$porcelain"
  _gwt_flush
  unfunction _gwt_flush
}

function fwt() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fwt"
    echo "Interactive worktree browser and manager"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Change to worktree directory"
    echo "  Ctrl-R    - Remove worktree"
    echo "  Ctrl-W    - Move worktree to new location"
    echo "  Ctrl-S    - Show worktree status"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  # Each loop iteration regenerates the list, so destructive actions (remove)
  # simply fall through and the refreshed list is shown on the next pass.
  local selected lines query key selection selected_path response new_path
  while :; do
    local fzf_input
    fzf_input=$(_gwt_fzf_lines)
    if [[ -z "$fzf_input" ]]; then
      echo "No worktrees found"
      break
    fi

    selected=$(printf '%s\n' "$fzf_input" | \
      fzf $(fzf_git_opts) \
          --delimiter=$'\t' --with-nth=1 \
          --preview="$ZSH_PREVIEWS_DIR/git-worktree.zsh {2}" \
          --bind="enter:accept" \
          --bind="ctrl-r:accept" \
          --bind="ctrl-w:accept" \
          --bind="ctrl-s:accept" \
          --print-query \
          --expect="ctrl-r,ctrl-w,ctrl-s" \
          --header="Enter=cd  Ctrl-R=remove  Ctrl-W=move  Ctrl-S=status  Alt-P=toggle preview") || break

    lines=("${(@f)selected}")
    query="${lines[1]}"
    key="${lines[2]}"
    selection="${lines[3]}"

    [[ -z "$selection" ]] && break

    # The hidden last column (after the tab) is the absolute worktree path.
    selected_path="${selection##*$'\t'}"
    [[ -z "$selected_path" ]] && continue

    case "$key" in
      "ctrl-r")
        echo "Remove worktree '$selected_path'? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
          git worktree remove "$selected_path" && echo "Removed: $selected_path"
        fi
        ;;
      "ctrl-w")
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
  local pathes="$2"

  # Default path based on branch name
  if [[ -z "$pathes" ]]; then
    # Convert branch name to directory name
    pathes="../$(echo "$branch" | sed 's|/|-|g')"
  fi

  # Check if branch exists
  if git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
    echo "Creating worktree for existing branch '$branch' at '$pathes'"
    git worktree add "$pathes" "$branch"
  else
    echo "Branch '$branch' doesn't exist. Create new branch? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo "Creating worktree with new branch '$branch' at '$pathes'"
      git worktree add -b "$branch" "$pathes"
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
      local pathes="${match[1]}"
      if [[ ! -d "$pathes" ]]; then
        echo "❌ Missing directory: $pathes"
        issues_found=true
      else
        echo "✅ OK: $pathes"
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

  local pathes="${1:-../main}"
  echo "Creating worktree for $GIT_MAIN_BRANCH at '$pathes'"
  git worktree add "$pathes" "$GIT_MAIN_BRANCH"
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
  local pathes="${2:-../feat-$feature_name}"

  gwtbr "$branch" "$pathes"
}
