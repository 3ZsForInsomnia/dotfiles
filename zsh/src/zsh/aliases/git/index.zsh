#!/usr/bin/env zsh

# Git Aliases and Functions - Main Index
# Sources all git-related functionality

# Get the directory where this script is located
local git_dir="${${(%):-%x}:A:h}"

# Source FZF helpers first (provides universal FZF configuration)
source "$git_dir/../../tools/fzf-helpers.zsh"

# Source all git modules
source "$git_dir/core.zsh"
source "$git_dir/stash.zsh"
source "$git_dir/rebase.zsh"
source "$git_dir/cherry-pick.zsh"
source "$git_dir/prune.zsh"
source "$git_dir/tags.zsh"
source "$git_dir/bisect.zsh"
source "$git_dir/worktree.zsh"
source "$git_dir/fzf.zsh"

# Set up shared configuration
export GIT_MAIN_BRANCH="${GIT_MAIN_BRANCH:-main}"

# Git help function - shows available commands by category
function ghelp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: ghelp [category]"
    echo "Show git command reference by category"
    echo ""
    echo "Categories:"
    echo "  core     - Basic operations (status, add, commit, etc.)"
    echo "  stash    - Stashing operations with FZF"
    echo "  rebase   - Rebase and merge operations"
    echo "  cherry   - Cherry-pick operations"
    echo "  prune    - Branch pruning based on PR status"
    echo "  tags     - Tag management and semantic versioning"
    echo "  bisect   - Find problematic commits"
    echo "  worktree - Multiple working directories"
    echo ""
    echo "Examples:"
    echo "  ghelp        # Show all categories"
    echo "  ghelp core   # Show core commands"
    echo "  ghelp stash  # Show stash commands"
    return 0
  fi

  local category="$1"

  case "$category" in
    "core")
      _show_core_help
      ;;
    "stash")
      _show_stash_help
      ;;
    "rebase")
      _show_rebase_help
      ;;
    "cherry")
      _show_cherry_help
      ;;
    "prune")
      _show_prune_help
      ;;
    "tags")
      _show_tags_help
      ;;
    "bisect")
      _show_bisect_help
      ;;
    "worktree")
      _show_worktree_help
      ;;
    "")
      _show_all_help
      ;;
    *)
      echo "Unknown category: $category"
      echo "Run 'ghelp -h' for available categories"
      ;;
  esac
}

function _show_core_help() {
  cat << 'EOF'
🔧 Core Git Operations:

Status & Info:
  gst          - Git status --short --branch (smart default)
  gstat        - Git status (base version)
  gl           - Git log --oneline --graph --decorate
  glog         - Git log with detailed format
  gsh [commit] - Git show

Add & Commit:
  ga [files]   - Git add (defaults to . if no args)
  gaa          - Git add --all
  gc <msg>     - Git commit with message
  gci          - Git commit interactive
  gempty [msg] - Create empty commit

Amending:
  gca          - Amend last commit (opens editor)
  gcan         - Amend last commit without changing message
  gcaa         - Amend last commit with all current changes

Checkout & Branches:
  gco <branch> - Git checkout (local branch completion)
  gcb <branch> - Create and checkout new branch
  gsup         - Set upstream for current branch

Branch Creation (Conventional):
  gcbft <name> - Create feat/ branch
  gcbfx <name> - Create fix/ branch
  gcbch <name> - Create chore/ branch
  gcbrf <name> - Create refactor/ branch
  gcbdc <name> - Create docs/ branch
  gcbst <name> - Create style/ branch
  gcbts <name> - Create test/ branch

Diff:
  gd [files]   - Git diff (working tree vs index)
  gds [files]  - Git diff --staged
  gdh [files]  - Git diff HEAD

Fetch & Pull:
  gf           - Git fetch --all --prune --prune-tags
  gfo          - Git fetch origin --prune --prune-tags
  gu [branch]  - Git pull --rebase (smart default)
  gup [branch] - Git pull (without rebase)

Push:
  gp [branch]  - Git push
  gpf [branch] - Git push --force-with-lease (safe force)
  gpff [branch]- Git push --force (dangerous)
  gpt          - Git push --tags

Reset & Restore:
  grh [files]  - Git reset HEAD (unstage)
  grhh         - Git reset --hard HEAD (DANGEROUS)
  grs <files>  - Git restore files

Remote Management:
  gr           - List remotes with URLs
  gra <name> <url> - Add remote
  grr <name>   - Remove remote
  grs <name> <url> - Set remote URL
  grsu [remote] - Set upstream (defaults to origin)

Compound Operations:
  gac <msg> [files]  - Add + commit
  gacp <msg> [files] - Add + commit + push
  gfapu        - Fetch all + pull with rebase

Use 'function_name -h' for detailed help on any command.
EOF
}

function _show_stash_help() {
  cat << 'EOF'
📦 Stash Operations:

Basic Stashing:
  gsta [msg]   - Stash with untracked files (smart default)
  gstat [msg]  - Stash tracked files only
  gstal        - List stashes with colors
  gstap [idx]  - Pop stash (defaults to latest)
  gstd [idx]   - Drop stash (defaults to latest with confirmation)
  gstac        - Clear all stashes (with confirmation)

Interactive FZF:
  gstaa [search] - Apply stash with FZF (searchable, preview)
  fstash       - Full interactive browser (apply/pop/drop/branch)

Helper Functions:
  stash_then_run <cmd>     - Stash → run command → apply
  run_then_find_stash <cmd> - Run command → browse stashes
  run_then_apply_stash <cmd> - Run command → apply stash
  run_then_pop_stash <cmd>  - Run command → pop latest

Ready-Made Compounds:
  gstapu       - Stash → pull rebase → apply
  gstacm       - Stash → checkout main → pull → return → apply

FZF Keys (gstaa): Enter=apply, Ctrl-D=diff vs HEAD, Ctrl-M=diff vs main
FZF Keys (fstash): Enter=show, Ctrl-A=apply, Ctrl-P=pop, Ctrl-D=drop, Ctrl-B=branch

Use 'function_name -h' for detailed help on any command.
EOF
}

function _show_rebase_help() {
  cat << 'EOF'
🔄 Rebase & Merge Operations:

Core Rebase:
  grb [branch] - Rebase onto branch (defaults to main)
  grbi <n|branch> - Interactive rebase (number or branch)
  grbc         - Continue rebase
  grba         - Abort rebase
  grbs         - Skip commit during rebase

Advanced Rebase:
  grbo <up> <br> - Rebase --onto
  grbas        - Interactive rebase with autosquash

Branch Operations:
  pullBranchThenRebaseWithIt <branch> - Checkout → pull → return → rebase
  pullBranchThenMergeWithIt <branch>  - Checkout → pull → return → merge

Merge Operations:
  gm [branch]  - Merge branch (defaults to main)
  gma          - Abort merge
  gmc          - Continue merge

Stash Integration:
  gstarbm      - Stash → rebase main → browse stashes
  gstarb <br>  - Stash → rebase branch → browse stashes

Aliases:
  grbh         - Interactive rebase (same as grbi)
  gpmm         - Pull main and rebase (same as grb)
  gprm         - Pull main and rebase (same as grb)

Environment: Set GIT_MAIN_BRANCH=master if needed (defaults to main)

Use 'function_name -h' for detailed help on any command.
EOF
}

function _show_cherry_help() {
  cat << 'EOF'
🍒 Cherry-Pick Operations:

Core Cherry-Pick:
  gcp <commit>  - Cherry-pick commit
  gcpn <commit> - Cherry-pick without committing (review first)
  gcpx <commit> - Cherry-pick with -x flag (adds tracking info)

Control:
  gcpc         - Continue cherry-pick
  gcpa         - Abort cherry-pick
  gcps         - Skip commit
  gcpq         - Quit cherry-pick

Interactive FZF:
  fcpick [branch] - Browse commits from branch (defaults to main)
  fcpicklog    - Browse from entire git log (use with caution)

FZF Keys: Enter=cherry-pick, Ctrl-X=cherry-pick -x, Ctrl-N=no-commit, Tab=multi-select

Batch Operations:
  gcprange <start> <end> - Cherry-pick commit range
  gcplast [n] [branch]   - Cherry-pick last n commits from branch

Examples:
  gcplast           # Last commit from main
  gcplast 3         # Last 3 commits from main  
  gcplast 2 dev     # Last 2 commits from dev

Info Commands:
  -x flag adds: (cherry picked from commit <hash>)
  Useful for tracking cherry-picks between branches

Use 'function_name -h' for detailed help on any command.
EOF
}

function _show_prune_help() {
  cat << 'EOF'
🌿 Branch Pruning (PR-Based):

Main Commands:
  gprune       - Prune branches for merged PRs (daily cleanup)
  gprunepr <#> - Prune branch for specific PR number

Interactive Workflow:
1. FZF selection with PR preview (title, author, commits, diff)
2. Confirmation: y=delete, N=cancel, e=edit selection
3. Progress feedback

Preview Shows:
  📝 PR description, author, dates
  📋 Commit list from branch
  📊 Diff statistics
  💬 PR discussions (if available)

FZF Keys: Tab=select, Ctrl-A=select all, Ctrl-D=deselect all

Requirements: gh CLI, jq
Features: Excludes main branch, handles missing PRs gracefully

Use 'function_name -h' for detailed help on any command.
EOF
}

function _show_tags_help() {
  cat << 'EOF'
🏷️  Tag Operations:

Basic Tags:
  gt [pattern] - List tags (sorted by version)
  gtc <tag> [commit] - Create tag
  gtca <tag> <msg> [commit] - Create annotated tag
  gtd <tag>    - Delete tag locally
  gtdr <tag> [remote] - Delete tag from remote
  gtp [tag] [remote] - Push tag(s)

Interactive FZF:
  ftag         - Browse tags with actions
  ftagco       - Interactive tag checkout

FZF Keys (ftag): Enter=show, Ctrl-D=delete, Ctrl-P=push, Ctrl-R=delete remote

Information:
  gtshow <tag> - Show tag details
  gtlog <tag1> [tag2] - Commits between tags
  gtdiff <tag1> [tag2] - Diff between tags

Semantic Versioning:
  gtnext [type] - Suggest next version (major/minor/patch)

Examples:
  gtnext       # v1.0.0 → v1.0.1
  gtnext minor # v1.0.0 → v1.1.0
  gtnext major # v1.0.0 → v2.0.0

Use 'function_name -h' for detailed help on any command.
EOF
}

function _show_bisect_help() {
  cat << 'EOF'
🔍 Bisect Operations (Find Problematic Commits):

Starting:
  gbs <bad> [good] - Start bisect (good defaults to HEAD~10)
  fbisect      - Interactive commit selection for bisect
  gbsa <bad> <good> <cmd> - Automated bisect with test command

During Bisect:
  gbg          - Mark current as good
  gbb          - Mark current as bad
  gbsk         - Skip current commit
  gbst         - Show bisect status
  gbsv         - Visualize remaining commits

Information:
  gbsl         - Show bisect log
  gbshelp      - Show command reference

Ending:
  gbr          - Reset/end bisect

Quick Shortcuts:
  gbsquick [n] - Bisect last n commits (defaults to 20)
  gbstag <bad> [good] - Bisect between tags

Examples:
  gbs HEAD HEAD~20           # Bisect last 20 commits
  gbsa HEAD HEAD~10 'make test' # Auto-bisect with test
  gbstag v1.2.0 v1.1.0      # Bisect between releases

Tips:
- Test commands for gbsa: exit 0=good, non-zero=bad
- Skip untestable commits with gbsk
- Use specific commits/tags for reliable results

Use 'function_name -h' for detailed help on any command.
EOF
}

function _show_worktree_help() {
  cat << 'EOF'
🌳 Worktree Operations (Multiple Working Directories):

Basic Operations:
  gwt          - List all worktrees
  gwta <path> <branch> - Add worktree for existing branch
  gwtab <path> <branch> - Add worktree with new branch
  gwtr <path>  - Remove worktree
  gwtrf <path> - Force remove worktree
  gwtm <old> <new> - Move worktree

Interactive FZF:
  fwt          - Browse and manage worktrees

FZF Keys: Enter=cd, Ctrl-R=remove, Ctrl-M=move, Ctrl-S=status

Branch-Based:
  gwtbr <branch> [path] - Create worktree for branch
  gwtft <feature> [path] - Create feat/ branch worktree
  gwtmain [path] - Create main branch worktree

Maintenance:
  gwtprune     - Clean up stale worktree entries
  gwtcheck     - Check all worktrees for issues

Examples:
  gwtbr feature/login        # Creates ../feature-login
  gwtft auth ../auth-work    # Creates feat/auth at ../auth-work
  gwtmain ../main            # Main branch at ../main

Complements worktree-cli for additional operations.

Use 'function_name -h' for detailed help on any command.
EOF
}

function _show_all_help() {
  cat << 'EOF'
🚀 Git Command Categories:

📋 ghelp core     - Basic operations (status, add, commit, push, pull)
📦 ghelp stash    - Stashing with FZF (interactive, named stashes)  
🔄 ghelp rebase   - Rebase and merge operations
🍒 ghelp cherry   - Cherry-pick operations with FZF
🌿 ghelp prune    - PR-based branch pruning (requires gh CLI)
🏷️  ghelp tags     - Tag management and semantic versioning
🔍 ghelp bisect   - Find problematic commits
🌳 ghelp worktree - Multiple working directories

💡 Tips:
- Add '-h' to any command for detailed help
- Most commands have smart defaults (shortest names)
- FZF integration provides interactive selection with previews
- Uses GIT_MAIN_BRANCH environment variable (defaults to 'main')

Examples:
  gst -h          # Help for git status
  ghelp stash     # All stash commands
  fcpick -h       # Help for interactive cherry-pick

🔧 Configuration:
  export GIT_MAIN_BRANCH=master  # If you use master instead of main
EOF
}

# Make help functions available
export -f ghelp _show_core_help _show_stash_help _show_rebase_help _show_cherry_help _show_prune_help _show_tags_help _show_bisect_help _show_worktree_help _show_all_help

# Success message
echo "✅ Git aliases and functions loaded!"
echo "Run 'ghelp' for command reference or 'ghelp <category>' for specific help."