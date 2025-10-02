#!/usr/bin/env zsh

# Git Rebase and Merge Operations
# Note: git config has rebase.autoStash = true, so stashing is handled automatically

### Core Rebase Operations

function grb() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grb [branch]"
    echo "Rebase current branch onto target branch (defaults to main)"
    echo "Examples:"
    echo "  grb        # Rebase onto main"
    echo "  grb dev    # Rebase onto dev branch"
    return 0
  fi

  local target_branch="${1:-$GIT_MAIN_BRANCH}"
  git rebase "$target_branch"
}

function grbi() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grbi [commits]"
    echo "Interactive rebase"
    echo "Examples:"
    echo "  grbi 3       # Interactive rebase last 3 commits"
    echo "  grbi HEAD~5  # Interactive rebase last 5 commits"
    echo "  grbi main    # Interactive rebase since main"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: number of commits or branch required"
    echo "Examples: grbi 3, grbi HEAD~5, grbi main"
    return 1
  fi

  # If it's a number, use HEAD~n format
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    git rebase --interactive "HEAD~$1"
  else
    git rebase --interactive "$1"
  fi
}

function grbc() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grbc"
    echo "Continue rebase after resolving conflicts"
    return 0
  fi
  git rebase --continue
}

function grba() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grba"
    echo "Abort current rebase"
    return 0
  fi
  git rebase --abort
}

function grbs() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grbs"
    echo "Skip current commit during rebase"
    return 0
  fi
  git rebase --skip
}

### Branch Pull and Rebase Operations

function pullBranchThenRebaseWithIt() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: pullBranchThenRebaseWithIt <branch>"
    echo "Checkout branch, pull latest, return to current branch, rebase onto it"
    echo "Example: pullBranchThenRebaseWithIt dev"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi

  local target_branch="$1"
  local current_branch=$(git rev-parse --abbrev-ref HEAD)

  if [[ "$current_branch" == "$target_branch" ]]; then
    echo "Error: already on target branch '$target_branch'"
    return 1
  fi

  echo "Switching to $target_branch..."
  git checkout "$target_branch" || return 1

  echo "Pulling latest changes..."
  git pull --rebase || {
    echo "Failed to pull $target_branch"
    git checkout "$current_branch"
    return 1
  }

  echo "Returning to $current_branch..."
  git checkout "$current_branch" || return 1

  echo "Rebasing $current_branch onto $target_branch..."
  git rebase "$target_branch"
}

### Merge Operations (less common but useful)

function gm() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gm [branch]"
    echo "Merge branch into current branch (defaults to main)"
    echo "Examples:"
    echo "  gm        # Merge main into current branch"
    echo "  gm dev    # Merge dev into current branch"
    return 0
  fi

  local source_branch="${1:-$GIT_MAIN_BRANCH}"
  git merge "$source_branch"
}

function gma() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gma"
    echo "Abort current merge"
    return 0
  fi
  git merge --abort
}

function gmc() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gmc"
    echo "Continue merge after resolving conflicts"
    return 0
  fi
  git merge --continue
}

function pullBranchThenMergeWithIt() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: pullBranchThenMergeWithIt <branch>"
    echo "Checkout branch, pull latest, return to current branch, merge it"
    echo "Example: pullBranchThenMergeWithIt dev"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi

  local target_branch="$1"
  local current_branch=$(git rev-parse --abbrev-ref HEAD)

  if [[ "$current_branch" == "$target_branch" ]]; then
    echo "Error: already on target branch '$target_branch'"
    return 1
  fi

  echo "Switching to $target_branch..."
  git checkout "$target_branch" || return 1

  echo "Pulling latest changes..."
  git pull --rebase || {
    echo "Failed to pull $target_branch"
    git checkout "$current_branch"
    return 1
  }

  echo "Returning to $current_branch..."
  git checkout "$current_branch" || return 1

  echo "Merging $target_branch into $current_branch..."
  git merge "$target_branch"
}

### Advanced Rebase Helpers

function grbo() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grbo <upstream> <branch>"
    echo "Rebase --onto for advanced branch management"
    echo "Example: grbo main feature-base"
    return 0
  fi

  if [[ -z "$1" || -z "$2" ]]; then
    echo "Error: upstream and branch arguments required"
    echo "Usage: grbo <upstream> <branch>"
    return 1
  fi

  git rebase --onto "$1" "$2"
}

function grbas() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grbas"
    echo "Interactive rebase with autosquash (useful with fixup commits)"
    echo "Rebases since main branch with autosquash enabled"
    return 0
  fi
  git rebase --interactive --autosquash "$GIT_MAIN_BRANCH"
}

### Stash + Rebase Compound Operations

function gstarbm() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstarbm"
    echo "Stash changes, rebase onto main, then browse stashes"
    return 0
  fi
  run_then_find_stash "grb"
}

function gstarb() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstarb <branch>"
    echo "Stash changes, rebase onto branch, then browse stashes"
    echo "Example: gstarb dev"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi

  run_then_find_stash "grb $1"
}

### Quick Rebase Shortcuts

alias grbh='grbi'                                                           # Interactive rebase (h for HEAD)
alias gpmm='grb'                                                            # Pull main and rebase (your current alias)
alias gprm='grb'                                                            # Alternative name for same operation
alias pullMasThenRebaseWithIt='pullBranchThenRebaseWithIt $GIT_MAIN_BRANCH' # Compatibility
