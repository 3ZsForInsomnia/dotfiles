#!/usr/bin/env zsh

# FZF-Enhanced Git Operations
# Interactive browsing and selection with rich previews

### Section FZF Branch Operations: fzf, branch, browse

function fbr() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fbr"
    echo "Interactive branch checkout with enhanced preview"
    echo "Shows recent branches with commit history and branch info"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Checkout selected branch"
    echo "  Ctrl-D    - Delete selected branch"
   echo "  Ctrl-S    - Show detailed branch information"
   echo "  Alt-P     - Toggle preview"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ \
    --format="%(refname:short)")

  if [[ -z "$branches" ]]; then
    echo "No branches found"
    return 0
  fi

  branch=$(echo "$branches" |
    fzf $(fzf_git_opts) \
      --preview="_fzf_git_branch_preview {1}" \
      --bind="ctrl-d:execute(git branch -d {1})+reload(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short) %(committerdate:relative) %(authorname)')" \
      --header="Enter=checkout, Ctrl-D=delete, Ctrl-S=inspect, Ctrl-C=cancel")

  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
}

### EndSection FZF Branch Operations

### Section FZF Commit Operations: fzf, commit, browse

function fcoc() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fcoc"
    echo "Interactive commit checkout with enhanced preview"
    echo "Browse commits with fast preview and detailed inspect on demand"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Checkout selected commit"
   echo "  Ctrl-S    - Show full commit diff (inspect)"
   echo "  Alt-P     - Toggle preview"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse -100)

  if [[ -z "$commits" ]]; then
    echo "No commits found"
    return 0
  fi

  commit=$(echo "$commits" |
    fzf --tac --no-sort $(fzf_git_opts) \
      --preview="_fzf_git_commit_preview {1}" \
      --header="Enter=checkout, Ctrl-S=inspect diff, Ctrl-C=cancel" |
    awk '{print $1}')

  if [[ -n "$commit" ]]; then
    echo "Checking out commit: $commit"
    git checkout "$commit"
  fi
}

### FZF Tag Operations

function ftco() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: ftco"
    echo "Interactive tag checkout with FZF"
    echo "Browse and checkout tags with preview"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Checkout selected tag"
   echo "  Ctrl-S    - Show detailed tag information"
   echo "  Alt-P     - Toggle preview"
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
  selected=$(echo "$tags" |
    fzf $(fzf_git_opts) \
      --preview="_fzf_git_commit_preview {}" \
      --header="Enter=checkout tag, Ctrl-S=inspect, Ctrl-C=cancel")

  if [[ -n "$selected" ]]; then
    echo "Checking out tag: $selected"
    git checkout "$selected"
  fi
}

### FZF Remote Operations

function fbremote() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fbremote"
    echo "Interactive remote branch browser"
    echo "Browse and checkout remote branches"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Checkout remote branch (creates local tracking branch)"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  local remote_branches
  remote_branches=$(git branch -r --sort=-committerdate | grep -v HEAD)

  if [[ -z "$remote_branches" ]]; then
    echo "No remote branches found"
    return 0
  fi

  local selected
  selected=$(echo "$remote_branches" |
    sed 's/origin\///' |
    fzf $(fzf_git_opts) \
      --preview="_fzf_git_branch_preview origin/{}" \
      --header="Enter=checkout remote branch, Ctrl-S=inspect, Ctrl-C=cancel")

  if [[ -n "$selected" ]]; then
    local branch_name=$(echo "$selected" | xargs)
    echo "Checking out remote branch: $branch_name"
    git checkout -b "$branch_name" "origin/$branch_name"
  fi
}
