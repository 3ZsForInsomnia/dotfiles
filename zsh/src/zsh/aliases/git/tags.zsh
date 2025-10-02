#!/usr/bin/env zsh

# Git Tag Operations
# Smart defaults and interactive helpers for managing tags

### Core Tag Operations

function gt() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gt [pattern]"
    echo "List tags, optionally filtered by pattern"
    echo "Examples:"
    echo "  gt        # List all tags (sorted by version)"
    echo "  gt v1.*   # List tags matching v1.*"
    return 0
  fi
  
  if [[ -n "$1" ]]; then
    git tag -l "$1" --sort=-version:refname
  else
    git tag --sort=-version:refname
  fi
}

function gtc() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gtc <tag> [commit]"
    echo "Create tag (defaults to HEAD)"
    echo "Examples:"
    echo "  gtc v1.0.0           # Tag HEAD as v1.0.0"
    echo "  gtc v1.0.0 abc123    # Tag specific commit"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: tag name required"
    return 1
  fi
  
  if [[ -n "$2" ]]; then
    git tag "$1" "$2"
  else
    git tag "$1"
  fi
}

function gtca() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gtca <tag> <message> [commit]"
    echo "Create annotated tag with message (defaults to HEAD)"
    echo "Examples:"
    echo "  gtca v1.0.0 'Release 1.0.0'"
    echo "  gtca v1.0.0 'Release 1.0.0' abc123"
    return 0
  fi
  
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Error: tag name and message required"
    echo "Usage: gtca <tag> <message> [commit]"
    return 1
  fi
  
  if [[ -n "$3" ]]; then
    git tag -a "$1" -m "$2" "$3"
  else
    git tag -a "$1" -m "$2"
  fi
}

function gtd() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gtd <tag>"
    echo "Delete tag locally"
    echo "Example: gtd v1.0.0"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: tag name required"
    return 1
  fi
  
  git tag -d "$1"
}

function gtdr() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gtdr <tag> [remote]"
    echo "Delete tag from remote (defaults to origin)"
    echo "Examples:"
    echo "  gtdr v1.0.0        # Delete from origin"
    echo "  gtdr v1.0.0 upstream # Delete from upstream"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: tag name required"
    return 1
  fi
  
  local remote="${2:-origin}"
  git push "$remote" --delete "$1"
}

function gtp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gtp [tag] [remote]"
    echo "Push tag(s) to remote"
    echo "Examples:"
    echo "  gtp             # Push all tags to origin"
    echo "  gtp v1.0.0      # Push specific tag to origin"
    echo "  gtp v1.0.0 upstream # Push specific tag to upstream"
    return 0
  fi
  
  local remote="${2:-origin}"
  
  if [[ -n "$1" ]]; then
    git push "$remote" "$1"
  else
    git push "$remote" --tags
  fi
}

### Interactive Tag Operations with FZF

function ftag() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: ftag"
    echo "Interactive tag browser with actions"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Show tag details"
    echo "  Ctrl-D    - Delete tag locally"
    echo "  Ctrl-P    - Push tag to origin"
    echo "  Ctrl-R    - Delete from origin"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi
  
  local tags
  tags=$(git tag --sort=-version:refname 2>/dev/null)
  
  if [[ -z "$tags" ]]; then
    echo "No tags found"
    return 0
  fi
  
  local selected
  while selected=$(echo "$tags" | \
    fzf $(fzf_git_opts) \
        --preview="_fzf_git_commit_preview {}" \
        --bind="enter:accept" \
        --bind="ctrl-d:accept" \
        --bind="ctrl-p:accept" \
        --bind="ctrl-r:accept" \
        --print-query \
        --expect="ctrl-d,ctrl-p,ctrl-r" \
        --header="Enter=show, Ctrl-D=delete, Ctrl-P=push, Ctrl-R=delete remote, Ctrl-S=inspect"); do
    
    # Parse fzf output
    local lines=("${(@f)selected}")
    local query="${lines[1]}"
    local key="${lines[2]}"
    local tag="${lines[3]}"
    
    [[ -z "$tag" ]] && break
    
    case "$key" in
      "ctrl-d")
        echo "Delete tag '$tag' locally? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
          git tag -d "$tag"
          echo "Deleted tag: $tag"
          # Refresh tags list
          tags=$(git tag --sort=-version:refname 2>/dev/null)
          [[ -z "$tags" ]] && { echo "No more tags"; break; }
        fi
        ;;
      "ctrl-p")
        echo "Push tag '$tag' to origin? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
          git push origin "$tag"
          echo "Pushed tag: $tag"
        fi
        ;;
      "ctrl-r")
        echo "Delete tag '$tag' from origin? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
          git push origin --delete "$tag"
          echo "Deleted tag from origin: $tag"
        fi
        ;;
      "")
        git show "$tag" --stat | less -R
        ;;
    esac
  done
}

function ftagco() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: ftagco"
    echo "Interactive tag checkout"
    echo "Browse and checkout a specific tag"
    return 0
  fi
  
  local tags
  tags=$(git tag --sort=-version:refname 2>/dev/null)
  
  if [[ -z "$tags" ]]; then
    echo "No tags found"
    return 0
  fi
  
  local selected
  selected=$(echo "$tags" | \
    fzf $(fzf_git_opts) \
        --preview="_fzf_git_commit_preview {}" \
        --header="Enter=checkout tag, Ctrl-S=inspect")
  
  if [[ -n "$selected" ]]; then
    echo "Checking out tag: $selected"
    git checkout "$selected"
  fi
}

### Tag Information and Comparison

function gtshow() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gtshow <tag>"
    echo "Show detailed information about a tag"
    echo "Example: gtshow v1.0.0"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: tag name required"
    return 1
  fi
  
  git show "$1" --stat
}

function gtlog() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gtlog <tag1> [tag2]"
    echo "Show commits between tags (or tag to HEAD)"
    echo "Examples:"
    echo "  gtlog v1.0.0        # Commits from v1.0.0 to HEAD"
    echo "  gtlog v1.0.0 v1.1.0 # Commits between v1.0.0 and v1.1.0"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: at least one tag required"
    return 1
  fi
  
  if [[ -n "$2" ]]; then
    git log --oneline --graph --decorate "$1..$2"
  else
    git log --oneline --graph --decorate "$1..HEAD"
  fi
}

function gtdiff() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gtdiff <tag1> [tag2]"
    echo "Show diff between tags (or tag to HEAD)"
    echo "Examples:"
    echo "  gtdiff v1.0.0        # Diff from v1.0.0 to HEAD"
    echo "  gtdiff v1.0.0 v1.1.0 # Diff between v1.0.0 and v1.1.0"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: at least one tag required"
    return 1
  fi
  
  if [[ -n "$2" ]]; then
    git diff "$1..$2"
  else
    git diff "$1..HEAD"
  fi
}

### Semantic Version Helpers

function gtnext() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gtnext [major|minor|patch]"
    echo "Suggest next semantic version tag (defaults to patch)"
    echo "Based on latest tag matching v*.*.* pattern"
    echo "Examples:"
    echo "  gtnext       # v1.0.0 -> v1.0.1"
    echo "  gtnext minor # v1.0.0 -> v1.1.0"
    echo "  gtnext major # v1.0.0 -> v2.0.0"
    return 0
  fi
  
  local bump_type="${1:-patch}"
  
  # Get latest semantic version tag
  local latest_tag
  latest_tag=$(git tag -l 'v*.*.*' --sort=-version:refname | head -1)
  
  if [[ -z "$latest_tag" ]]; then
    echo "No semantic version tags found (v*.*.* pattern)"
    echo "Suggested first tag: v0.1.0"
    return 0
  fi
  
  # Extract version numbers
  local version="${latest_tag#v}"
  local major minor patch
  IFS='.' read -r major minor patch <<<"$version"
  
  case "$bump_type" in
    major)
      ((major++))
      minor=0
      patch=0
      ;;
    minor)
      ((minor++))
      patch=0
      ;;
    patch)
      ((patch++))
      ;;
    *)
      echo "Error: bump type must be major, minor, or patch"
      return 1
      ;;
  esac
  
  local next_tag="v${major}.${minor}.${patch}"
  echo "Current: $latest_tag"
  echo "Next $bump_type: $next_tag"
}