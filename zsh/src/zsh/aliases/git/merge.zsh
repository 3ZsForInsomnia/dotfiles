#!/usr/bin/env zsh

# Git Merge Operations
# Merge strategies and conflict resolution

### Core Merge Operations

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

alias gma='git merge --abort'

alias gmc='git merge --continue'

### Branch Pull and Merge Operations

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

### Merge Strategy Helpers

function gmff() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gmff [branch]"
    echo "Merge with fast-forward only (fails if not possible)"
    echo "Examples:"
    echo "  gmff        # Merge main with --ff-only"
    echo "  gmff dev    # Merge dev with --ff-only"
    return 0
  fi

  local source_branch="${1:-$GIT_MAIN_BRANCH}"
  git merge --ff-only "$source_branch"
}

function gmnf() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gmnf [branch]"
    echo "Merge with no fast-forward (always creates merge commit)"
    echo "Examples:"
    echo "  gmnf        # Merge main with --no-ff"
    echo "  gmnf dev    # Merge dev with --no-ff"
    return 0
  fi

  local source_branch="${1:-$GIT_MAIN_BRANCH}"
  git merge --no-ff "$source_branch"
}

function gmsq() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gmsq [branch]"
    echo "Merge and squash all commits into one"
    echo "Examples:"
    echo "  gmsq feature  # Squash-merge feature branch"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi

  git merge --squash "$1"
}

### Merge Shortcuts and Compatibility Aliases

alias pullMasThenMergeWithIt='pullBranchThenMergeWithIt $GIT_MAIN_BRANCH' # Compatibility

### Git Add + Merge Continue

function gamc() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gamc [path]"
    echo "Add files and continue merge"
    echo "Examples:"
    echo "  gamc        # Add all changes (.) and continue merge"
    echo "  gamc file.txt # Add specific file and continue merge"
    return 0
  fi

  local path="${1:-.}"
  git add "$path"
  git merge --continue
}
