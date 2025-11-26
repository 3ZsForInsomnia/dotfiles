#!/usr/bin/env zsh

# Git Branch Management Operations
# Branch creation, deletion, and maintenance utilities

### Branch Listing and Info

alias gb="git branch"

function gbl() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbl [options]"
    echo "List branches with additional info"
    echo "Options:"
    echo "  -a    Show all branches (local + remote)"
    echo "  -r    Show remote branches only"
    return 0
  fi
  
  git branch "$@"
}

### Branch Creation (Conventional Commits)

function gcbft() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcbft <name>"
    echo "Create feat/ branch"
    echo "Example: gcbft login"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi
  gcb "feat/$1"
}

function gcbfx() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcbfx <name>"
    echo "Create fix/ branch"
    echo "Example: gcbfx auth-bug"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi
  gcb "fix/$1"
}

function gcbch() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcbch <name>"
    echo "Create chore/ branch"
    echo "Example: gcbch update-deps"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi
  gcb "chore/$1"
}

function gcbrf() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcbrf <name>"
    echo "Create refactor/ branch"
    echo "Example: gcbrf user-service"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi
  gcb "refactor/$1"
}

function gcbdc() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcbdc <name>"
    echo "Create docs/ branch"
    echo "Example: gcbdc api-guide"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi
  gcb "docs/$1"
}

function gcbst() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcbst <name>"
    echo "Create style/ branch"
    echo "Example: gcbst button-colors"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi
  gcb "style/$1"
}

function gcbts() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcbts <name>"
    echo "Create test/ branch"
    echo "Example: gcbts user-auth"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi
  gcb "test/$1"
}

### Branch Deletion

function gbd() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbd <branch>"
    echo "Delete merged branch (safe delete)"
    echo "Example: gbd feature/old-feature"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi

  git branch -d "$1"
}

function gbD() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbD <branch>"
    echo "Force delete branch (DANGEROUS: deletes unmerged branches)"
    echo "Example: gbD feature/abandoned-work"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi

  git branch -D "$1"
}

function deleteMerged() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: deleteMerged"
    echo "Delete all local branches that have been merged to main"
    echo "Excludes: master, main, dev, and current branch"
    return 0
  fi

  git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d
}

alias gdm='deleteMerged'

### Branch Upstream Management

function gsup() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gsup"
    echo "Set upstream for current branch to origin"
    return 0
  fi
  local branch="$(git_current_branch)"
  git branch --set-upstream-to="origin/$branch"
}

function grsu() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grsu [remote]"
    echo "Set upstream for current branch (defaults to origin)"
    echo "Examples:"
    echo "  grsu          # Set upstream to origin/current-branch"
    echo "  grsu upstream # Set upstream to upstream/current-branch"
    return 0
  fi

  local remote="${1:-origin}"
  local branch="$(git_current_branch)"

  if [[ -z "$branch" ]]; then
    echo "Error: not in a git repository or no current branch"
    return 1
  fi

  git branch --set-upstream-to="$remote/$branch"
  echo "Set upstream for '$branch' to '$remote/$branch'"
}
