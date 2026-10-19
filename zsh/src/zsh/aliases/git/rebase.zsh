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
    echo "  grbi h5      # Shorthand for HEAD~5 (h + number)"
    echo "  grbi HEAD~5  # Interactive rebase last 5 commits"
    echo "  grbi main    # Interactive rebase since main"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: number of commits or branch required"
    echo "Examples: grbi 3, grbi h5, grbi HEAD~5, grbi main"
    return 1
  fi

  # If it's h followed by a number, translate to HEAD~n
  if [[ "$1" =~ ^h([0-9]+)$ ]]; then
    git rebase --interactive "HEAD~${match[1]}"
  # If it's a plain number, use HEAD~n format
  elif [[ "$1" =~ ^[0-9]+$ ]]; then
    git rebase --interactive "HEAD~$1"
  else
    git rebase --interactive "$1"
  fi
}

alias grbc='git rebase --continue'

alias grba='git rebase --abort'

alias grbs='git rebase --skip'

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

  echo "Pulling latest changes for $target_branch..."
  git pull --rebase --no-tags origin "$target_branch" || {
    echo "Failed to pull $target_branch. Returning to $current_branch."
    git checkout "$current_branch"
    return 1
  }

  echo "Returning to $current_branch..."
  git checkout "$current_branch" || return 1

  echo "Rebasing $current_branch onto $target_branch..."
  git rebase "$target_branch"
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

# Restacks a branch after the PR below it in a stack was squash-merged. The branch still
# carries that PR's original commits, which conflict with their squashed copy on main. GitHub
# keeps a merged PR's last head commit, so this rebases only the commits after it onto main.
function grbsq() {
  if [[ "$1" == "-h" || -z "$1" ]]; then
    echo "Usage: grbsq <merged PR number> [branch]"
    echo "Restack a branch after the PR below it in a stack was squash-merged."
    echo ""
    echo "How: looks up the merged PR's last head commit on GitHub (gh pr view --json"
    echo "headRefOid), fetches origin, then runs:"
    echo "  git rebase --onto origin/\$GIT_MAIN_BRANCH <that commit> [branch]"
    echo "Only the branch's own commits are replayed; the merged PR's original commits"
    echo "are dropped, since main already has them as the squash commit."
    echo ""
    echo "Branch defaults to the current branch."
    echo ""
    echo "Doesn't handle:"
    echo "  - Real conflicts: main commits, or later changes to the merged PR, that edit"
    echo "    the same lines still stop the rebase for you to resolve as usual."
    echo "  - A branch that isn't built on the merged PR's last head (rebased since, or"
    echo "    built on an older version of it): the wrong commits get replayed. Check"
    echo "    with: git merge-base --is-ancestor <PR head> <branch>"
    echo "  - A PR that merged without squashing: a plain grb is enough."
    echo "  - Branches further up the stack: run it once per branch, each against the PR"
    echo "    directly below it."
    echo "  - Pushing: force-push afterwards with --force-with-lease."
    echo ""
    echo "Example: grbsq 13161 feat/cd-2804-user-consumers"
    [[ "$1" == "-h" ]] && return 0 || return 1
  fi

  local old_base
  old_base=$(GH_PAGER=cat gh pr view "$1" --json headRefOid -q .headRefOid) || return 1
  git fetch origin || return 1
  git rebase --onto "origin/$GIT_MAIN_BRANCH" "$old_base" ${2:+"$2"}
}

alias grbas='git rebase --interactive --autosquash "$GIT_MAIN_BRANCH"'

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

alias pullMasThenRebaseWithIt='pullBranchThenRebaseWithIt $GIT_MAIN_BRANCH'
alias pullMasThenRebaseAndPush='pullMasThenRebaseWithIt; gpf'

### Git Add + Rebase Continue
function garbc() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: garbc [-p] [path]"
    echo "Add files and continue rebase"
    echo "  -p  Force push after successful rebase continue"
    echo "Examples:"
    echo "  garbc            # Add all changes (.) and continue rebase"
    echo "  garbc file.txt   # Add specific file and continue rebase"
    echo "  garbc -p         # Add all, continue rebase, then force push"
    echo "  garbc file.txt -p # Add file, continue rebase, then force push"
    return 0
  fi

  local push_after=false
  local add_target="."

  for arg in "$@"; do
    if [[ "$arg" == "-p" ]]; then
      push_after=true
    else
      add_target="$arg"
    fi
  done

  git add "$add_target"
  git rebase --continue || return 1

  if $push_after; then
    gpf
  fi
}
