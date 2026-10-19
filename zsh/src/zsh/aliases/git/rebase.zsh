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
# carries that PR's original commits, which conflict with their squashed copy on the PR's
# base branch. GitHub keeps a merged PR's last head commit, so this rebases only the commits
# after it onto that base, after checking the branch is actually built on that head.
function grbsq() {
  if [[ "$1" == "-h" || -z "$1" ]]; then
    echo "Usage: grbsq <merged PR number> [branch]"
    echo "Restack a branch after the PR below it in a stack was squash-merged."
    echo ""
    echo "How: looks up the merged PR's last head commit and base branch on GitHub"
    echo "(gh pr view --json headRefOid,baseRefName), fetches origin, checks the branch"
    echo "is built on that head, then runs:"
    echo "  git rebase --onto origin/<PR's base> <PR's last head> <branch>"
    echo "Only the branch's own commits are replayed; the merged PR's original commits"
    echo "are dropped, since its base already has them as the squash commit."
    echo ""
    echo "Branch defaults to the current branch."
    echo ""
    echo "Stops without rebasing when the branch isn't built on the PR's last head (the"
    echo "PR changed after the branch was last restacked), and prints the command to"
    echo "rebase from the branch's own first commit instead."
    echo ""
    echo "Doesn't handle:"
    echo "  - Real conflicts: base commits, or later changes to the merged PR, that edit"
    echo "    the same lines still stop the rebase for you to resolve as usual."
    echo "  - A PR that merged without squashing: a plain grb is enough."
    echo "  - Branches further up the stack: their PR below hasn't merged. Check"
    echo "    git merge-base --is-ancestor <its old tip> <next branch>, then rebase"
    echo "    each onto the branch you just restacked: grbo <restacked branch> <its old tip>,"
    echo "    run on the next branch up. If the check fails, start from the next"
    echo "    branch's own first commit instead."
    echo "  - Pushing: force-push afterwards with --force-with-lease."
    echo ""
    echo "Example: grbsq 13161 feat/cd-2804-user-consumers"
    [[ "$1" == "-h" ]] && return 0 || return 1
  fi

  local merged_head merged_base branch
  merged_head=$(GH_PAGER=cat gh pr view "$1" --json headRefOid -q .headRefOid) || return 1
  merged_base=$(GH_PAGER=cat gh pr view "$1" --json baseRefName -q .baseRefName) || return 1
  branch="${2:-$(git branch --show-current)}"
  # Without tags, so a tag CI moved on the remote can't fail the fetch. --no-prune-tags
  # too: fetch.pruneTags otherwise syncs every tag even with --no-tags.
  git fetch --no-tags --no-prune-tags origin || return 1

  if ! git merge-base --is-ancestor "$merged_head" "$branch"; then
    echo "Error: $branch isn't built on PR #$1's last head ($merged_head)."
    echo "The PR changed after $branch was last restacked, so rebasing from that head"
    echo "would replay old versions of its commits. Find $branch's first own commit in:"
    echo "  git log --oneline origin/$merged_base..$branch"
    echo "then run:"
    echo "  git rebase --onto origin/$merged_base <first own commit>^ $branch"
    return 1
  fi

  git rebase --onto "origin/$merged_base" "$merged_head" "$branch"
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
