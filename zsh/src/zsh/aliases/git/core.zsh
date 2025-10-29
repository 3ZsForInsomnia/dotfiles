#!/usr/bin/env zsh

alias g="git"

# Core Git Operations
# Smart defaults use the shortest names, base versions use longer names

### Helper Functions
function git_current_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

### Utility Functions

alias groot="git rev-parse --show-toplevel"

function goToGroot() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: goToGroot"
    echo "Change directory to git repository root"
    return 0
  fi
  cd "$(groot)"
}

function cst() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: cst"
    echo "Clear terminal and show git status"
    return 0
  fi
  clear && gst
}

function gibid() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gibid"
    echo "Git commit all changes and amend without editing message"
    echo "Useful for quick fixups"
    return 0
  fi
  git commit -a --amend --no-edit
}

function gibidp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gibidp"
    echo "Git commit all changes, amend without editing, and force push"
    echo "Combines gibid + force push with lease"
    return 0
  fi
  gibid && gpf
}

function gignore() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gignore [pattern]"
    echo "Edit global gitignore file or add pattern"
    echo "Examples:"
    echo "  gignore           # Open global gitignore in editor"
    echo "  gignore '*.log'   # Add pattern to global gitignore"
    return 0
  fi

  local gitignore_file="$HOME/.config/git/.gitignore_global"

  if [[ -n "$1" ]]; then
    echo "$1" >>"$gitignore_file"
    echo "Added '$1' to global gitignore"
  else
    ${EDITOR:-nvim} "$gitignore_file"
  fi
}

function searchGitLogs() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: searchGitLogs <search-string>"
    echo "Search git log for commits that added/removed specific string"
    echo "Uses git log -S to find commits that changed the occurrence of string"
    echo "Example: searchGitLogs 'function_name'"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: search string required"
    return 1
  fi

  local string="$1"
  git log -S "$string" --source --all --patch --color | less -R
}

### Status
function gst() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gst"
    echo "Git status with --short --branch (smart default)"
    return 0
  fi
  git status --short --branch
}

function gstat() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gstat"
    echo "Git status (base version, no flags)"
    return 0
  fi
  git status
}

### Add
function ga() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: ga [files]"
    echo "Git add files (defaults to . if no args)"
    echo "Examples:"
    echo "  ga        # Add all files"
    echo "  ga file.js # Add specific file"
    return 0
  fi

  if [[ -z "$1" ]]; then
    git add .
  else
    git add "$@"
  fi
}

function gaa() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gaa"
    echo "Git add --all (explicit all)"
    return 0
  fi
  git add --all
}

### Commit
function gc() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gc <message>"
    echo "Git commit with message"
    echo "Example: gc 'fix: resolve bug'"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: commit message required"
    return 1
  fi
  git commit -m "$1"
}

function gci() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gci"
    echo "Git commit interactive (opens editor)"
    return 0
  fi
  git commit
}

function gempty() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gempty [message]"
    echo "Create empty commit"
    echo "Example: gempty 'trigger CI'"
    return 0
  fi

  local message="${1:-empty commit}"
  git commit --allow-empty -m "$message"
}

### Commit Amending
function gca() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gca"
    echo "Amend last commit (opens editor)"
    return 0
  fi
  git commit --amend
}

function gcan() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcan"
    echo "Amend last commit without changing message"
    return 0
  fi
  git commit --amend --no-edit
}

function gcaa() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcaa"
    echo "Amend last commit with all current changes"
    return 0
  fi
  git commit --amend --all
}

### Checkout
function gco() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gco <branch>"
    echo "Git checkout branch (with local branch completion)"
    return 0
  fi
  git checkout "$@"
}

alias gcm="git checkout $GIT_MAIN_BRANCH"

function gcb() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gcb <branch>"
    echo "Create and checkout new branch, or checkout existing branch"
    echo "Example: gcb feature/new-login"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: branch name required"
    return 1
  fi

  # Check if branch exists locally
  if git show-ref --verify --quiet "refs/heads/$1"; then
    echo "Branch '$1' exists, checking out..."
    git checkout "$1"
  else
    echo "Creating new branch '$1'..."
    git checkout -b "$1"
  fi
}

### Diff
function gd() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gd [files]"
    echo "Git diff (working tree vs index)"
    return 0
  fi
  git diff "$@"
}

function gds() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gds [files]"
    echo "Git diff staged (index vs HEAD)"
    return 0
  fi
  git diff --staged "$@"
}

function gdh() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gdh [files]"
    echo "Git diff HEAD (working tree vs HEAD)"
    return 0
  fi
  git diff HEAD "$@"
}

### Fetch
function gf() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gf [-f]"
    echo "Git fetch --all --prune --prune-tags (smart default)"
    echo "  -f: force update moved tags"
    return 0
  fi

  if [[ "$1" == "-f" ]]; then
    git fetch --all --prune --force --tags
  else
    git fetch --all --prune --prune-tags
  fi
}

function gfo() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gfo"
    echo "Git fetch origin only --prune --prune-tags"
    return 0
  fi
  git fetch origin --prune --prune-tags
}

### Pull
function gu() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gu [branch]"
    echo "Git pull with rebase (smart default)"
    echo "Examples:"
    echo "  gu        # Pull current branch with rebase"
    echo "  gu main   # Pull main branch with rebase"
    return 0
  fi

  if [[ -z "$1" ]]; then
    git pull --rebase
  else
    git pull --rebase origin "$1"
  fi
}

function gup() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gup [branch]"
    echo "Git pull without rebase"
    echo "Examples:"
    echo "  gup        # Pull current branch"
    echo "  gup main   # Pull main branch"
    return 0
  fi

  if [[ -z "$1" ]]; then
    git pull
  else
    git pull origin "$1"
  fi
}

### Push
function gp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gp [branch]"
    echo "Git push"
    echo "Examples:"
    echo "  gp        # Push current branch"
    echo "  gp main   # Push main branch"
    return 0
  fi

  if [[ -z "$1" ]]; then
    local branch="$(git_current_branch)"
    git push origin "$branch"
  else
    git push origin "$1"
  fi
}

function gpf() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gpf [branch]"
    echo "Git push --force-with-lease (safe force)"
    return 0
  fi

  if [[ -z "$1" ]]; then
    local branch="$(git_current_branch)"
    git push --force-with-lease origin "$branch"
  else
    git push --force-with-lease origin "$1"
  fi
}

function gpff() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gpff [branch]"
    echo "Git push --force (dangerous, use gpf instead)"
    return 0
  fi

  if [[ -z "$1" ]]; then
    local branch="$(git_current_branch)"
    git push --force origin "$branch"
  else
    git push --force origin "$1"
  fi
}

function gpt() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gpt"
    echo "Git push tags"
    return 0
  fi
  git push --tags
}

### Branch Management

alias gb="git branch"

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

function gsup() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gsup"
    echo "Set upstream for current branch to origin"
    return 0
  fi
  local branch="$(git_current_branch)"
  git branch --set-upstream-to="origin/$branch"
}

### Reset/Restore
function grh() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grh [files]"
    echo "Git reset HEAD (unstage files)"
    return 0
  fi
  git reset HEAD "$@"
}

function grhh() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grhh"
    echo "Git reset --hard HEAD (DANGEROUS: loses changes)"
    return 0
  fi
  git reset --hard HEAD
}

function grs() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grs <files>"
    echo "Git restore files"
    return 0
  fi
  git restore "$@"
}

### Show
function gsh() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gsh [commit]"
    echo "Git show commit (defaults to HEAD)"
    return 0
  fi
  git show "$@"
}

### Log
function gl() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gl"
    echo "Git log --oneline --graph --decorate (smart default)"
    return 0
  fi
  git log --oneline --graph --decorate
}

alias glg="git log"

function glog() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: glog"
    echo "Git log with detailed format"
    return 0
  fi
  git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'
}

### Compound Operations
function gac() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gac <message> [files]"
    echo "Git add + commit"
    echo "Examples:"
    echo "  gac 'fix bug'           # Add all, commit"
    echo "  gac 'fix bug' file.js   # Add file.js, commit"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: commit message required"
    return 1
  fi

  local message="$1"
  shift

  if [[ -z "$1" ]]; then
    ga
  else
    ga "$@"
  fi
  gc "$message"
}

function gacp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gacp <message> [files]"
    echo "Git add + commit + push"
    echo "Examples:"
    echo "  gacp 'fix bug'           # Add all, commit, push"
    echo "  gacp 'fix bug' file.js   # Add file.js, commit, push"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: commit message required"
    return 1
  fi

  local message="$1"
  shift

  gac "$message" "$@"
  gp
}

function gfapu() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gfapu"
    echo "Git fetch all + pull with rebase (force-updates tags)"
    return 0
  fi
  gf -f
  gu
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

### Remote Management

function gr() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gr"
    echo "List all remotes with URLs"
    return 0
  fi
  git remote -v
}

function gra() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gra <name> <url>"
    echo "Add remote"
    echo "Examples:"
    echo "  gra upstream https://github.com/user/repo.git"
    echo "  gra fork https://github.com/myuser/repo.git"
    return 0
  fi

  if [[ -z "$1" || -z "$2" ]]; then
    echo "Error: remote name and URL required"
    echo "Usage: gra <name> <url>"
    return 1
  fi

  git remote add "$1" "$2"
}

function grr() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grr <name>"
    echo "Remove remote"
    echo "Example: grr upstream"
    return 0
  fi

  if [[ -z "$1" ]]; then
    echo "Error: remote name required"
    return 1
  fi

  git remote remove "$1"
}

function grs() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: grs <name> <url>"
    echo "Set URL for existing remote"
    echo "Example: grs origin https://github.com/newuser/repo.git"
    return 0
  fi

  if [[ -z "$1" || -z "$2" ]]; then
    echo "Error: remote name and URL required"
    echo "Usage: grs <name> <url>"
    return 1
  fi

  git remote set-url "$1" "$2"
}

### Interactive Commit Operations

function fcom() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fcom"
    echo "Interactive commit browser and checkout"
    echo "Browse commits with enhanced preview and actions"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Checkout selected commit"
    echo "  Ctrl-S    - Show full commit diff (inspect)"
    echo "  Alt-Y     - Copy commit hash to clipboard"
    echo "  Alt-P     - Toggle preview"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  local commit
  commit=$(git log --oneline --graph --color=always -100 |
    fzf --ansi --no-sort $(fzf_git_opts) \
      --preview="$ZSH_PREVIEWS_DIR/git-commit.zsh {1}" \
      --header="Enter=checkout, Ctrl-S=inspect diff, Alt-Y=copy hash, Ctrl-C=cancel" |
    awk '{print $1}' | sed 's/[^a-f0-9]//g')

  if [[ -n "$commit" ]]; then
    echo "Checking out commit: $commit"
    git checkout "$commit"
  fi
}

### Branch Comparison Tools

function fgdiff() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fgdiff [options] [branch1] [branch2]"
    echo "Interactive branch comparison with file-by-file diff preview"
    echo ""
    echo "Options:"
    echo "  -m, --main     Use main branch as base"
    echo "  -c, --current  Use current branch"
    echo ""
    echo "Examples:"
    echo "  fgdiff                    # Compare current branch vs main"
    echo "  fgdiff -m -c              # Same as above (explicit)"
    echo "  fgdiff main feature       # Compare main vs feature branch"
    echo "  fgdiff -m feature         # Compare main vs feature branch"
    echo "  fgdiff feature            # Compare feature vs current branch"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - View full diff in pager"
    echo "  Ctrl-S    - Show file in editor"
    echo "  Alt-V     - Open file in nvim"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  local branch1="" branch2=""
  local use_main=false use_current=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -m | --main)
      use_main=true
      shift
      ;;
    -c | --current)
      use_current=true
      shift
      ;;
    *)
      if [[ -z "$branch1" ]]; then
        branch1="$1"
      elif [[ -z "$branch2" ]]; then
        branch2="$1"
      else
        echo "Error: too many branch arguments"
        return 1
      fi
      shift
      ;;
    esac
  done

  # Resolve branch names
  if [[ "$use_main" == true ]]; then
    if [[ -n "$branch1" ]]; then
      # -m was specified with a branch, so main vs branch
      branch2="$branch1"
      branch1="$GIT_MAIN_BRANCH"
    else
      # Just -m specified
      branch1="$GIT_MAIN_BRANCH"
    fi
  fi

  if [[ "$use_current" == true ]]; then
    if [[ -n "$branch2" ]]; then
      # We already have branch2 set, current becomes branch1
      branch1="$(git_current_branch)"
    else
      # Current becomes branch2
      branch2="$(git_current_branch)"
    fi
  fi

  # Set defaults if branches not specified
  if [[ -z "$branch1" ]]; then
    branch1="$GIT_MAIN_BRANCH"
  fi
  if [[ -z "$branch2" ]]; then
    branch2="$GIT_MAIN_BRANCH"
  fi

  # Validate branches exist
  if ! git show-ref --verify --quiet "refs/heads/$branch1" 2>/dev/null; then
    echo "Error: branch '$branch1' not found"
    return 1
  fi
  if ! git show-ref --verify --quiet "refs/heads/$branch2" 2>/dev/null; then
    echo "Error: branch '$branch2' not found"
    return 1
  fi

  echo "📊 Comparing branches: $branch1 → $branch2"
  echo ""

  # Get list of changed files
  local changed_files
  changed_files=$(git diff --name-only "$branch1".."$branch2" 2>/dev/null)

  if [[ -z "$changed_files" ]]; then
    echo "No differences found between $branch1 and $branch2"
    return 0
  fi

  local file_count=$(echo "$changed_files" | wc -l)
  echo "Found $file_count changed file(s)"
  echo ""

  # Interactive file selection with diff preview
  local selected_file
  selected_file=$(echo "$changed_files" |
    fzf $(fzf_git_opts) \
      --preview="_fgdiff_preview $branch1 $branch2 {}" \
      --header="Comparing $branch1 → $branch2 | Enter=view diff, Ctrl-S=inspect, Alt-V=edit")

  if [[ -n "$selected_file" ]]; then
    echo "Opening diff for: $selected_file"
    git diff --color=always "$branch1".."$branch2" -- "$selected_file" | less -R
  fi
}

# Helper function for branch diff preview
function _fgdiff_preview() {
  local branch1="$1" branch2="$2" file="$3"

  if [[ -z "$file" ]]; then
    echo "No file selected"
    return
  fi

  echo "📄 File: $file"
  echo "🔄 Changes: $branch1 → $branch2"
  echo ""

  # Show diff stats first
  local stats
  stats=$(git diff --stat "$branch1".."$branch2" -- "$file" 2>/dev/null)
  if [[ -n "$stats" ]]; then
    echo "📊 $stats"
    echo ""
  fi

  # Show the actual diff (truncated)
  local diff_lines
  diff_lines=$(git diff "$branch1".."$branch2" -- "$file" 2>/dev/null | wc -l)

  if [[ "$diff_lines" -gt 100 ]]; then
    echo "📋 Diff preview (first 100 lines of $diff_lines total):"
    echo ""
    git diff --color=always "$branch1".."$branch2" -- "$file" | head -100
    echo ""
    echo "... diff truncated (use Enter to see full diff)"
  else
    echo "📋 Full diff:"
    echo ""
    git diff --color=always "$branch1".."$branch2" -- "$file"
  fi
}

### Interactive Commit Search

function fgsearch() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fgsearch [search-term]"
    echo "Interactive git log search with FZF"
    echo "Searches commit messages, author names, and file changes"
    echo ""
    echo "Options:"
    echo "  -S <term>    Search for code changes (pickaxe search)"
    echo "  -G <term>    Search for code changes (regex)"
    echo "  --author     Filter by author"
    echo "  --since      Filter by date (e.g., '2 weeks ago')"
    echo ""
    echo "Examples:"
    echo "  fgsearch                      # Browse all commits interactively"
    echo "  fgsearch 'fix bug'            # Search commit messages for 'fix bug'"
    echo "  fgsearch -S 'function_name'   # Search for commits that changed 'function_name'"
    echo "  fgsearch --author john        # Search commits by author 'john'"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Checkout selected commit"
    echo "  Ctrl-S    - Show full commit diff"
    echo "  Ctrl-A    - Filter by author"
    echo "  Alt-Y     - Copy commit hash"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  local search_term=""
  local git_log_args=()
  local pickaxe_search=""
  local author_filter=""
  local date_filter=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -S)
      pickaxe_search="$2"
      git_log_args+=("-S" "$2")
      shift 2
      ;;
    -G)
      pickaxe_search="$2"
      git_log_args+=("-G" "$2")
      shift 2
      ;;
    --author)
      author_filter="$2"
      git_log_args+=("--author=$2")
      shift 2
      ;;
    --since)
      date_filter="$2"
      git_log_args+=("--since=$2")
      shift 2
      ;;
    *)
      search_term="$1"
      shift
      ;;
    esac
  done

  # Build the git log command
  local log_cmd="git log --oneline --graph --color=always"

  # Add search arguments
  for arg in "${git_log_args[@]}"; do
    log_cmd="$log_cmd '$arg'"
  done

  # Add grep for commit message if search term provided
  if [[ -n "$search_term" ]]; then
    log_cmd="$log_cmd --grep='$search_term'"
  fi

  # Limit to reasonable number of commits
  log_cmd="$log_cmd -200"

  echo "🔍 Searching git commits..."
  if [[ -n "$search_term" ]]; then
    echo "   Message: '$search_term'"
  fi
  if [[ -n "$pickaxe_search" ]]; then
    echo "   Code changes: '$pickaxe_search'"
  fi
  if [[ -n "$author_filter" ]]; then
    echo "   Author: '$author_filter'"
  fi
  if [[ -n "$date_filter" ]]; then
    echo "   Since: '$date_filter'"
  fi
  echo ""

  # Execute search and show results
  local commits
  commits=$(eval "$log_cmd" 2>/dev/null)

  if [[ -z "$commits" ]]; then
    echo "No commits found matching criteria"
    return 0
  fi

  local commit_count=$(echo "$commits" | wc -l)
  echo "Found $commit_count matching commit(s)"
  echo ""

  # Interactive selection
  local selected_commit
  selected_commit=$(echo "$commits" |
    fzf --ansi --no-sort $(fzf_git_opts) \
      --preview="$ZSH_PREVIEWS_DIR/git-commit.zsh {1}" \
      --bind="ctrl-a:execute(_fgsearch_filter_author {})" \
      --header="Enter=checkout, Ctrl-S=inspect, Ctrl-A=filter by author, Alt-Y=copy hash" |
    awk '{print $1}' | sed 's/[^a-f0-9]//g')

  if [[ -n "$selected_commit" ]]; then
    echo "Checking out commit: $selected_commit"
    git checkout "$selected_commit"
  fi
}

# Helper function for author filtering during search
function _fgsearch_filter_author() {
  local commit_line="$1"
  local commit_hash=$(echo "$commit_line" | awk '{print $1}' | sed 's/[^a-f0-9]//g')

  if [[ -n "$commit_hash" ]]; then
    local author=$(git log -1 --format='%an' "$commit_hash" 2>/dev/null)
    if [[ -n "$author" ]]; then
      echo "Filtering by author: $author"
      fgsearch --author "$author"
    fi
  fi
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
