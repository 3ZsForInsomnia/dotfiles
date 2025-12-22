#!/usr/bin/env zsh

# Git Stash Operations with FZF Integration
# Smart defaults include untracked files, FZF for selection/preview

### Core Stashing Operations

function gsta() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gsta [message]"
    echo "Git stash with untracked files (smart default)"
    echo "Examples:"
    echo "  gsta                    # Quick stash with untracked"
    echo "  gsta 'work in progress' # Named stash with untracked"
    echo "  gsta -t                 # Tracked files only"
    return 0
  fi

  # Handle tracked-only flag
  if [[ "$1" == "-t" ]]; then
    shift
    if [[ -n "$1" ]]; then
      git stash push -m "$1"
    else
      git stash
    fi
  else
    # Default: include untracked
    if [[ -n "$1" ]]; then
      git stash push -u -m "$1"
    else
      git stash -u
    fi
  fi
}

function gstat() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstat [message]"
    echo "Git stash tracked files only (base version)"
    echo "Examples:"
    echo "  gstat                # Quick stash tracked only"
    echo "  gstat 'before merge' # Named stash tracked only"
    return 0
  fi

  if [[ -n "$1" ]]; then
    git stash push -m "$1"
  else
    git stash
  fi
}

function gstal() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstal"
    echo "List all stashes"
    return 0
  fi
  git stash list --pretty="%C(yellow)%gd%C(reset) %C(green)(%cr)%C(reset) %gs"
}

function gstap() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstap [index]"
    echo "Pop stash (defaults to latest)"
    echo "Examples:"
    echo "  gstap    # Pop latest stash"
    echo "  gstap 2  # Pop stash@{2}"
    return 0
  fi

  if [[ -n "$1" ]]; then
    git stash pop "stash@{$1}"
  else
    git stash pop
  fi
}

function gstac() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstac"
    echo "Clear all stashes (DANGEROUS)"
    return 0
  fi

  echo "This will delete ALL stashes. Are you sure? (y/N)"
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    git stash clear
    echo "All stashes cleared."
  else
    echo "Cancelled."
  fi
}

function gstd() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstd [index]"
    echo "Drop stash (defaults to latest)"
    echo "Examples:"
    echo "  gstd    # Drop latest stash"
    echo "Example: gstd 1  # Drop stash@{1}"
    return 0
  fi

  if [[ -n "$1" ]]; then
    git stash drop "stash@{$1}"
  else
    # Show what we're about to drop
    local latest=$(git stash list -n 1 --pretty="%gd %gs" 2>/dev/null)
    if [[ -z "$latest" ]]; then
      echo "No stashes to drop"
      return 0
    fi

    echo "Drop latest stash: $latest? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      git stash drop
      echo "Dropped latest stash."
    else
      echo "Cancelled."
    fi
  fi
}

### FZF-Enhanced Stash Operations

function gstaa() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstaa [search]"
    echo "Apply stash with FZF selection and diff preview"
    echo "Keys:"
    echo "  Enter    - Apply selected stash"
    echo "  Ctrl-S   - Inspect diff vs HEAD (see conflicts)"
    echo "Examples:"
    echo "  gstaa           # Browse all stashes"
    echo "  gstaa feature   # Filter stashes containing 'feature'"
    return 0
  fi

  local stashes
  stashes=$(git stash list --pretty="%C(yellow)%gd%C(reset) %C(green)(%cr)%C(reset) %gs" 2>/dev/null)

  if [[ -z "$stashes" ]]; then
    echo "No stashes found"
    return 0
  fi

  local selected
  selected=$(echo "$stashes" |
    fzf --ansi \
      --reverse \
      --query="${1:-}" \
      --preview='git stash show -p --color=always {1} | delta' \
      --preview-window="right:65%:wrap" \
      --bind="ctrl-s:execute(git diff {1} | delta | less -R)" \
      --header="Enter=apply, Ctrl-S=inspect diff vs HEAD, Alt-P=toggle preview")

  if [[ -n "$selected" ]]; then
    local stash_id=$(echo "$selected" | awk '{print $1}')
    git stash apply "$stash_id"
    echo "Applied $stash_id"
  fi
}

alias gstp="git stash pop"

function fstash() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fstash"
    echo "Interactive stash browser with advanced options"
    echo "Keys:"
    echo "  Enter    - Show stash contents"
    echo "  Ctrl-A   - Apply stash"
    echo "  Ctrl-P   - Pop stash"
    echo "  Ctrl-D   - Drop stash"
    echo "  Ctrl-B   - Create branch from stash"
    echo "  Ctrl-S   - Inspect diff vs HEAD (see conflicts)"
    return 0
  fi

  local stashes
  stashes=$(git stash list --pretty="%C(yellow)%gd%C(reset) %C(green)(%cr)%C(reset) %gs" 2>/dev/null)

  if [[ -z "$stashes" ]]; then
    echo "No stashes found"
    return 0
  fi

  local out q k sha
  while out=$(echo "$stashes" |
    fzf --ansi \
      --reverse \
      --no-sort \
      --query="$q" \
      --print-query \
      --expect=ctrl-a,ctrl-p,ctrl-d,ctrl-b,ctrl-s \
      --preview='git stash show -p --color=always {1} | delta' \
      --preview-window="right:65%:wrap" \
      --header="Enter=show, Ctrl-A=apply, Ctrl-P=pop, Ctrl-D=drop, Ctrl-B=branch, Ctrl-S=inspect"); do

    mapfile -t out <<<"$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"

    [[ -z "$sha" ]] && continue

    local stash_id=$(echo "$sha" | awk '{print $1}')

    case "$k" in
    ctrl-a)
      git stash apply "$stash_id"
      echo "Applied $stash_id"
      break
      ;;
    ctrl-p)
      git stash pop "$stash_id"
      echo "Popped $stash_id"
      break
      ;;
    ctrl-d)
      echo "Drop $stash_id? (y/N)"
      read -r response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        git stash drop "$stash_id"
        echo "Dropped $stash_id"
        stashes=$(git stash list --pretty="%C(yellow)%gd%C(reset) %C(green)(%cr)%C(reset) %gs" 2>/dev/null)
        [[ -z "$stashes" ]] && {
          echo "No more stashes"
          break
        }
      fi
      ;;
    ctrl-b)
      echo "Enter branch name:"
      read -r branch_name
      if [[ -n "$branch_name" ]]; then
        git stash branch "$branch_name" "$stash_id"
        echo "Created branch '$branch_name' from $stash_id"
        break
      fi
      ;;
      ctrl-s)
        git diff "$stash_id" | delta | less -R
        ;;
    "")
      git stash show -p "$stash_id" | less -R
      ;;
    esac
  done
}

### Stash Helper Functions (for compound operations)

function stash_then_run() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: stash_then_run <command>"
    echo "Stash changes, run command, then apply latest stash"
    echo "Example: stash_then_run 'git pull --rebase'"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: command required"
    return 1
  fi

  # Check if there are changes to stash
  if git diff-index --quiet HEAD -- && git ls-files --others --exclude-standard | head -1 | grep -q .; then
    echo "No changes to stash"
    eval "$1"
    return $?
  fi

  echo "Stashing changes..."
  gsta "auto-stash before: $1"

  echo "Running: $1"
  eval "$1"
  local exit_code=$?

  echo "Applying latest stash..."
  git stash pop

  return $exit_code
}

function run_then_apply_stash() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: run_then_apply_stash <command>"
    echo "Run command, then interactively apply a stash"
    echo "Example: run_then_apply_stash 'git pull --rebase'"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: command required"
    return 1
  fi

  echo "Running: $1"
  eval "$1"
  local exit_code=$?

  if [[ $exit_code -eq 0 ]]; then
    echo "Command succeeded. Apply a stash?"
    gstaa
  else
    echo "Command failed with exit code $exit_code"
    return $exit_code
  fi
}

function run_then_find_stash() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: run_then_find_stash <command>"
    echo "Run command, then open interactive stash browser"
    echo "Example: run_then_find_stash 'git pull --rebase'"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: command required"
    return 1
  fi

  echo "Running: $1"
  eval "$1"
  local exit_code=$?

  if [[ $exit_code -eq 0 ]]; then
    echo "Command succeeded. Opening stash browser..."
    fstash
  else
    echo "Command failed with exit code $exit_code"
    return $exit_code
  fi
}

function run_then_pop_stash() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: run_then_pop_stash <command>"
    echo "Run command, then pop latest stash"
    echo "Example: run_then_pop_stash 'git checkout main'"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: command required"
    return 1
  fi

  echo "Running: $1"
  eval "$1"
  local exit_code=$?

  if [[ $exit_code -eq 0 ]]; then
    echo "Popping latest stash..."
    gstap
  else
    echo "Command failed with exit code $exit_code. Stash preserved."
    return $exit_code
  fi
}

### Common Compound Operations

function gstapu() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstapu"
    echo "Stash + pull with rebase + apply stash"
    return 0
  fi
  stash_then_run "git pull --rebase"
}

function gstacm() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstacm"
    echo "Stash + checkout main + pull + return to branch + apply stash"
    return 0
  fi

  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@' 2>/dev/null || echo "main")

  stash_then_run "git checkout $main_branch && git pull --rebase && git checkout $current_branch"
}
