#!/usr/bin/env zsh

# FZF Helpers - Common configurations, preview functions, and utilities
# Used across all FZF integrations for consistency and performance

### Universal FZF Configuration

# Set universal FZF defaults
export FZF_DEFAULT_OPTS="
  --multi
  --ansi
  --height=70%
  --border=rounded
  --preview-window=right:60%:wrap
  --bind='alt-p:toggle-preview'
  --bind='alt-v:execute(nvim {+})'
  --bind='alt-o:execute(open {+})'
  --bind='alt-y:execute(echo {+} | tr \" \" \"\n\" | pbcopy)'
  --bind='ctrl-s:execute(_fzf_inspect {})'
"

# History search configuration (keeps chronological order)
export FZF_CTRL_R_OPTS="--reverse --no-sort"

### Smart Preview Functions (Fast)

# Git commit preview - fast summary only
function _fzf_git_commit_preview() {
  local commit="$1"

  # Validate commit hash
  if ! git rev-parse --verify "$commit" >/dev/null 2>&1; then
    echo "Invalid commit: $commit"
    return 1
  fi

  echo "📝 $(git log -1 --format='%s' "$commit")"
  echo ""
  echo "👤 $(git log -1 --format='%an <%ae>' "$commit")"
  echo "📅 $(git log -1 --format='%cd' --date=relative "$commit")"
  echo "🔗 $(git log -1 --format='%H' "$commit")"
  echo ""
  echo "📊 Changes:"
  git show --stat --format="" "$commit"
}

# Git branch preview - shows recent commits and branch info
function _fzf_git_branch_preview() {
  local branch="$1"

  # Clean branch name (remove origin/ prefix, whitespace, etc.)
  branch=$(echo "$branch" | sed 's/^[* ]*//' | sed 's/^origin\///')

  if ! git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
    echo "Branch not found locally: $branch"
    return 1
  fi

  echo "🌿 Branch: $branch"
  echo ""

  # Show divergence from main/master
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
  local ahead_behind
  ahead_behind=$(git rev-list --left-right --count "$main_branch"..."$branch" 2>/dev/null || echo "0	0")
  local behind=$(echo "$ahead_behind" | cut -f1)
  local ahead=$(echo "$ahead_behind" | cut -f2)

  if [[ "$ahead" -gt 0 || "$behind" -gt 0 ]]; then
    echo "📈 $ahead ahead, $behind behind $main_branch"
    echo ""
  fi

  echo "📋 Recent commits:"
  git log --oneline --graph --color=always --date=short \
    --pretty="format:%C(auto)%cd %h%d %s %C(blue)<%an>%C(reset)" \
    "$branch" -10
}

# Git stash preview - shows stash info and summary
function _fzf_git_stash_preview() {
  local stash="$1"

  if ! git stash list | grep -q "$stash"; then
    echo "Stash not found: $stash"
    return 1
  fi

  echo "📦 $(git stash list | grep "$stash")"
  echo ""
  echo "📊 Changes in stash:"
  git stash show --stat "$stash" 2>/dev/null || echo "No changes to show"
  echo ""
  echo "📝 Files changed:"
  git stash show --name-only "$stash" 2>/dev/null | head -20
  if [[ $(git stash show --name-only "$stash" 2>/dev/null | wc -l) -gt 20 ]]; then
    echo "... and more files"
  fi
}

### Kubernetes Preview Functions

# Pod preview - shows status, events, and container info
function _fzf_k8s_pod_preview() {
  local pod_line="$1"
  local pod_name=$(echo "$pod_line" | awk '{print $1}')
  local namespace="${2:-default}"

  if [[ -z "$pod_name" ]]; then
    echo "No pod selected"
    return
  fi

  echo "🔍 Pod: $pod_name"
  echo "📦 Namespace: $namespace"
  echo ""

  # Pod status
  echo "📊 Status:"
  kubectl get pod "$pod_name" -n "$namespace" -o wide 2>/dev/null || echo "Could not fetch pod status"
  echo ""

  # Container info
  echo "📦 Containers:"
  kubectl get pod "$pod_name" -n "$namespace" -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | tr ' ' '\n' | sed 's/^/  - /' || echo "Could not fetch container info"
  echo ""

  # Recent events
  echo "📋 Recent Events:"
  kubectl get events -n "$namespace" --field-selector involvedObject.name="$pod_name" --sort-by='.lastTimestamp' -o custom-columns=TYPE:.type,REASON:.reason,MESSAGE:.message --no-headers 2>/dev/null | tail -5 | sed 's/^/  /' || echo "  No recent events"
  echo ""

  # Resource usage (if metrics available)
  echo "💾 Resource Usage:"
  kubectl top pod "$pod_name" -n "$namespace" 2>/dev/null | tail -1 | sed 's/^/  /' || echo "  Metrics not available"
}

# Service preview - shows endpoints and port info
function _fzf_k8s_service_preview() {
  local service_line="$1"
  local service_name=$(echo "$service_line" | awk '{print $1}')
  local namespace="${2:-default}"

  if [[ -z "$service_name" ]]; then
    echo "No service selected"
    return
  fi

  echo "🌐 Service: $service_name"
  echo "📦 Namespace: $namespace"
  echo ""

  # Service details
  echo "📊 Service Info:"
  kubectl get service "$service_name" -n "$namespace" -o wide 2>/dev/null || echo "Could not fetch service info"
  echo ""

  # Endpoints
  echo "🎯 Endpoints:"
  kubectl get endpoints "$service_name" -n "$namespace" -o custom-columns=ADDRESSES:.subsets[*].addresses[*].ip,PORTS:.subsets[*].ports[*].port --no-headers 2>/dev/null | sed 's/^/  /' || echo "  No endpoints available"
  echo ""

  # Associated pods
  echo "📦 Associated Pods:"
  local selector=$(kubectl get service "$service_name" -n "$namespace" -o jsonpath='{.spec.selector}' 2>/dev/null)
  if [[ -n "$selector" && "$selector" != "{}" ]]; then
    kubectl get pods -n "$namespace" --selector="$(echo "$selector" | jq -r 'to_entries | map("\(.key)=\(.value)") | join(",")')" -o custom-columns=NAME:.metadata.name,STATUS:.status.phase --no-headers 2>/dev/null | sed 's/^/  /' || echo "  Could not find associated pods"
  else
    echo "  No selector found"
  fi
}

# Kubernetes inspect functions (detailed views)
function _fzf_k8s_pod_inspect() {
  local pod_line="$1"
  local pod_name=$(echo "$pod_line" | awk '{print $1}')
  local namespace="${2:-default}"

  if [[ -z "$pod_name" ]]; then
    echo "No pod selected"
    return
  fi

  echo "🔍 Detailed Pod Information: $pod_name"
  echo "Namespace: $namespace"
  echo "========================================"
  echo ""

  kubectl describe pod "$pod_name" -n "$namespace" | less -R
}

function _fzf_k8s_service_inspect() {
  local service_line="$1"
  local service_name=$(echo "$service_line" | awk '{print $1}')
  local namespace="${2:-default}"

  if [[ -z "$service_name" ]]; then
    echo "No service selected"
    return
  fi

  echo "🌐 Detailed Service Information: $service_name"
  echo "Namespace: $namespace"
  echo "==========================================="
  echo ""

  kubectl describe service "$service_name" -n "$namespace" | less -R
}

# File preview - enhanced with git info when in git repo
function _fzf_file_preview() {
  local file="$1"

  if [[ -d "$file" ]]; then
    echo "📁 Directory: $file"
    echo ""
    eza -la --icons --git --color=always "$file" 2>/dev/null || ls -la "$file"
  elif [[ -f "$file" ]]; then
    echo "📄 File: $file"

    # Show git status if in git repo
    if git rev-parse --git-dir >/dev/null 2>&1; then
      local git_status
      git_status=$(git status --porcelain "$file" 2>/dev/null)
      if [[ -n "$git_status" ]]; then
        echo "🔄 Git: $git_status"
      fi
    fi

    echo ""
    # Show file content with syntax highlighting
    bat --style=numbers --color=always --line-range :50 "$file" 2>/dev/null ||
      head -50 "$file"
  else
    echo "Unknown item: $file"
  fi
}

# Process preview - shows process details
function _fzf_process_preview() {
  local line="$1"
  local pid=$(echo "$line" | awk '{print $2}')

  if [[ -z "$pid" || ! "$pid" =~ ^[0-9]+$ ]]; then
    echo "Invalid process line: $line"
    return 1
  fi

  echo "🔍 Process Details:"
  echo "$line"
  echo ""

  # Show process tree context
  echo "🌳 Process tree:"
  pstree -p "$pid" 2>/dev/null || ps -f -p "$pid" 2>/dev/null || echo "Process not found"

  echo ""
  echo "💾 Memory usage:"
  ps -o pid,ppid,pgid,%cpu,%mem,vsz,rss,comm -p "$pid" 2>/dev/null || echo "Memory info not available"
}

### Smart Inspect Functions (Detailed)

# Git commit inspect - full diff with smart truncation
function _fzf_git_commit_inspect() {
  local commit="$1"

  if ! git rev-parse --verify "$commit" >/dev/null 2>&1; then
    echo "Invalid commit: $commit"
    return 1
  fi

  # Check diff size
  local diff_lines
  diff_lines=$(git show --format="" "$commit" | wc -l)

  if [[ "$diff_lines" -gt 500 ]]; then
    echo "Large diff ($diff_lines lines) - showing summary + truncated diff"
    echo "Press 'q' to return to selection, or scroll for more..."
    echo ""
    git show --stat "$commit"
    echo ""
    echo "--- First 200 lines of diff ---"
    git show --format="" "$commit" | head -200
    echo ""
    echo "--- Diff truncated ($diff_lines total lines) ---"
    echo "Use 'git show $commit' in terminal for full diff"
  else
    git show --color=always "$commit"
  fi | less -R
}

# File inspect - full file in pager
function _fzf_file_inspect() {
  local file="$1"

  if [[ -d "$file" ]]; then
    echo "📁 Directory contents: $file"
    echo ""
    eza -la --icons --git --color=always "$file" 2>/dev/null || ls -la "$file"
  elif [[ -f "$file" ]]; then
    bat --color=always "$file" 2>/dev/null || less "$file"
  else
    echo "Cannot inspect: $file"
  fi
}

# Process inspect - detailed process information
function _fzf_process_inspect() {
  local line="$1"
  local pid=$(echo "$line" | awk '{print $2}')

  if [[ -z "$pid" || ! "$pid" =~ ^[0-9]+$ ]]; then
    echo "Invalid process: $line"
    return 1
  fi

  echo "🔍 Detailed Process Information for PID $pid"
  echo "================================================"
  echo ""

  echo "📋 Basic Info:"
  ps -f -p "$pid" 2>/dev/null || echo "Process not found"
  echo ""

  echo "🌳 Process Tree:"
  pstree -p "$pid" 2>/dev/null || echo "Process tree not available"
  echo ""

  echo "💾 Memory Details:"
  ps -o pid,ppid,pgid,%cpu,%mem,vsz,rss,etime,comm -p "$pid" 2>/dev/null || echo "Memory details not available"
  echo ""

  if command -v lsof >/dev/null 2>&1; then
    echo "📁 Open Files (first 20):"
    lsof -p "$pid" 2>/dev/null | head -20 || echo "Cannot access open files"
  fi

  echo ""
  echo "Press any key to continue..."
  read -k1
}

### Universal Inspect Router

# Smart inspect function that routes to appropriate handler
function _fzf_inspect() {
  local item="$1"
  local namespace="$2" # Optional namespace for k8s resources

  # Git commit hash pattern
  if [[ "$item" =~ ^[a-f0-9]{7,40}$ ]]; then
    _fzf_git_commit_inspect "$item"
  # Git stash pattern
  elif [[ "$item" =~ ^stash@\{[0-9]+\}$ ]]; then
    git stash show -p "$item" | less -R
  # Kubernetes pod pattern (pod name with namespace context)
  elif [[ "$item" =~ ^[a-zA-Z0-9-]+$ ]] && [[ -n "$namespace" ]] && kubectl get pod "$item" -n "$namespace" >/dev/null 2>&1; then
    _fzf_k8s_pod_inspect "$item" "$namespace"
  # Kubernetes service pattern
  elif [[ "$item" =~ ^[a-zA-Z0-9-]+$ ]] && [[ -n "$namespace" ]] && kubectl get service "$item" -n "$namespace" >/dev/null 2>&1; then
    _fzf_k8s_service_inspect "$item" "$namespace"
  # File path
  elif [[ -e "$item" ]]; then
    _fzf_file_inspect "$item"
  # Process line (contains PID)
  elif [[ "$item" =~ [0-9]+ ]] && echo "$item" | grep -q -E '\s+[0-9]+\s+'; then
    _fzf_process_inspect "$item"
  else
    echo "No detailed inspection available for: $item"
    echo "Press any key to continue..."
    read -k1
  fi
}

### Utility Functions

# Standard FZF options for different contexts
function fzf_git_opts() {
  echo "--reverse --ansi --height=70% --border=rounded --preview-window=right:65%:wrap"
}

function fzf_file_opts() {
  echo "--multi --ansi --height=70% --border=rounded --preview-window=right:60%:wrap"
}

function fzf_select_opts() {
  echo "--height=40% --border --reverse"
}

# Export functions for use in subshells
# export -f _fzf_git_commit_preview _fzf_git_branch_preview _fzf_git_stash_preview
# export -f _fzf_file_preview _fzf_process_preview
# export -f _fzf_k8s_pod_preview _fzf_k8s_service_preview
# export -f _fzf_git_commit_inspect _fzf_file_inspect _fzf_process_inspect _fzf_inspect
# export -f _fzf_k8s_pod_inspect _fzf_k8s_service_inspect
# export -f _fgdiff_preview _fgsearch_filter_author
