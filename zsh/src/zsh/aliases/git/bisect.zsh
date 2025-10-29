#!/usr/bin/env zsh

# Git Bisect Operations
# Interactive helpers for finding problematic commits

### Core Bisect Operations

function gbs() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbs <bad-commit> [good-commit]"
    echo "Start bisect between commits (good defaults to HEAD~10)"
    echo "Examples:"
    echo "  gbs HEAD           # Bisect last 10 commits"
    echo "  gbs abc123 def456  # Bisect between specific commits"
    echo "  gbs v1.2.0 v1.1.0  # Bisect between tags"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: bad commit required"
    echo "Usage: gbs <bad-commit> [good-commit]"
    return 1
  fi
  
  local bad_commit="$1"
  local good_commit="${2:-HEAD~10}"
  
  echo "Starting bisect between $good_commit (good) and $bad_commit (bad)"
  git bisect start "$bad_commit" "$good_commit"
  
  echo ""
  echo "Bisect commands:"
  echo "  gbg  - Mark current commit as good"
  echo "  gbb  - Mark current commit as bad"
  echo "  gbr  - Reset bisect"
  echo "  gbsk - Skip current commit"
  echo ""
  echo "Current commit to test:"
  git log --oneline -1
}

function gbg() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbg"
    echo "Mark current commit as good during bisect"
    return 0
  fi
  
  git bisect good
  if [[ $? -eq 0 ]]; then
    echo ""
    echo "Next commit to test:"
    git log --oneline -1 2>/dev/null || echo "Bisect complete!"
  fi
}

function gbb() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbb"
    echo "Mark current commit as bad during bisect"
    return 0
  fi
  
  git bisect bad
  if [[ $? -eq 0 ]]; then
    echo ""
    echo "Next commit to test:"
    git log --oneline -1 2>/dev/null || echo "Bisect complete!"
  fi
}

function gbr() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbr"
    echo "Reset/end bisect session"
    return 0
  fi
  
  git bisect reset
  echo "Bisect session ended"
}

function gbsk() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbsk"
    echo "Skip current commit during bisect"
    return 0
  fi
  
  git bisect skip
  if [[ $? -eq 0 ]]; then
    echo ""
    echo "Next commit to test:"
    git log --oneline -1 2>/dev/null || echo "Bisect complete!"
  fi
}

function gbst() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbst"
    echo "Show current bisect status"
    return 0
  fi
  
  if git bisect log >/dev/null 2>&1; then
    echo "Bisect in progress:"
    echo ""
    git bisect log | tail -10
    echo ""
    echo "Current commit:"
    git log --oneline -1
    echo ""
    echo "Remaining commits to test: $(git rev-list --bisect-all --count 2>/dev/null || echo 'unknown')"
  else
    echo "No bisect in progress"
  fi
}

### Automated Bisect

function gbsa() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbsa <bad-commit> <good-commit> <test-command>"
    echo "Automated bisect with test command"
    echo "Test command should exit 0 for good, non-zero for bad"
    echo "Examples:"
    echo "  gbsa HEAD HEAD~10 'make test'"
    echo "  gbsa abc123 def456 'npm test'"
    echo "  gbsa v1.2.0 v1.1.0 './run-tests.sh'"
    return 0
  fi
  
  if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
    echo "Error: bad commit, good commit, and test command required"
    echo "Usage: gbsa <bad-commit> <good-commit> <test-command>"
    return 1
  fi
  
  local bad_commit="$1"
  local good_commit="$2"
  local test_command="$3"
  
  echo "Starting automated bisect..."
  echo "Bad: $bad_commit"
  echo "Good: $good_commit"
  echo "Test: $test_command"
  echo ""
  
  git bisect start "$bad_commit" "$good_commit"
  git bisect run sh -c "$test_command"
  
  echo ""
  echo "Bisect complete! Check the results above."
}

### Interactive Bisect with FZF

function fbisect() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fbisect"
    echo "Interactive bisect setup - select good and bad commits with FZF"
    echo "Two-step process: first select BAD commit, then select GOOD commit"
    echo ""
    echo "This replaces the basic gbs function with a more user-friendly interface"
    return 0
  fi
  
  echo "🔍 Step 1: Select the BAD commit (has the problem)"
  local bad_commit
  bad_commit=$(git log --oneline --graph -100 | \
    fzf $(fzf_git_opts) \
        --preview="$ZSH_PREVIEWS_DIR/git-commit.zsh {1}" \
        --header="🚫 Select BAD commit (has the problem)" |
    awk '{print $1}' | sed 's/[^a-f0-9]//g')
  
  if [[ -z "$bad_commit" ]]; then
    echo "❌ No bad commit selected, cancelled"
    return 0
  fi
  
  echo ""
  echo "✅ Selected BAD commit: $bad_commit"
  echo ""
  echo "🔍 Step 2: Select the GOOD commit (known working state)"
  
  local good_commit
  good_commit=$(git log --oneline --graph -100 | \
    fzf $(fzf_git_opts) \
        --preview="$ZSH_PREVIEWS_DIR/git-commit.zsh {1}" \
        --header="✅ Select GOOD commit (known working)" |
    awk '{print $1}' | sed 's/[^a-f0-9]//g')
  
  if [[ -z "$good_commit" ]]; then
    echo "❌ No good commit selected, cancelled"
    return 0
  fi
  
  echo ""
  echo "🎯 Starting git bisect:"
  echo "   BAD:  $bad_commit"
  echo "   GOOD: $good_commit"
  echo ""
  
  git bisect start "$bad_commit" "$good_commit"
  
  echo "📋 Bisect started! Use these commands:"
  echo "   gbg  - Mark current commit as good"
  echo "   gbb  - Mark current commit as bad"
  echo "   gbr  - Reset/end bisect"
  echo "   fbisect-next - Interactive commit marking"
  echo ""
  echo "Current commit to test:"
  git log --oneline -1
}

function fbisect-next() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fbisect-next"
    echo "Interactive commit marking during bisect"
    echo "Shows current commit with actions: good, bad, skip, or reset"
    return 0
  fi
  
  # Check if bisect is in progress
  if ! git bisect log >/dev/null 2>&1; then
    echo "❌ No bisect in progress. Use 'fbisect' to start one."
    return 1
  fi
  
  echo "🎯 Current bisect commit:"
  git log --oneline -1
  echo ""
  git show --stat HEAD
  echo ""
  
  local action
  action=$(echo -e "✅ Good (works correctly)\n❌ Bad (has the problem)\n⏭️  Skip (can't test)\n🔄 Show commit details\n🛑 Reset bisect" | \
    fzf --height=40% --border --reverse \
        --header="How is this commit?" \
        --prompt="Bisect action> ")
  
  case "$action" in
    "✅ Good"*)
      git bisect good
      if [[ $? -eq 0 ]]; then
        echo ""
        echo "✅ Marked as good. Next commit:"
        git log --oneline -1 2>/dev/null || echo "🎉 Bisect complete!"
      fi
      ;;
    "❌ Bad"*)
      git bisect bad
      if [[ $? -eq 0 ]]; then
        echo ""
        echo "❌ Marked as bad. Next commit:"
        git log --oneline -1 2>/dev/null || echo "🎉 Bisect complete!"
      fi
      ;;
    "⏭️  Skip"*)
      git bisect skip
      if [[ $? -eq 0 ]]; then
        echo ""
        echo "⏭️ Skipped commit. Next commit:"
        git log --oneline -1 2>/dev/null || echo "🎉 Bisect complete!"
      fi
      ;;
    "🔄 Show"*)
      git show --color=always HEAD | less -R
      fbisect-next  # Recurse to show menu again
      ;;
    "🛑 Reset"*)
      echo "Are you sure you want to reset bisect? (y/N)"
      read -r response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        git bisect reset
        echo "🛑 Bisect session ended"
      else
        fbisect-next  # Show menu again
      fi
      ;;
    *)
      echo "❌ Cancelled"
      ;;
  esac
}

### Bisect History and Analysis

function gbsl() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbsl"
    echo "Show full bisect log/history"
    return 0
  fi
  
  if git bisect log >/dev/null 2>&1; then
    git bisect log
  else
    echo "No bisect in progress or no bisect history"
  fi
}

function gbsv() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbsv"
    echo "Visualize bisect range (commits being tested)"
    return 0
  fi
  
  if git bisect log >/dev/null 2>&1; then
    echo "Commits in bisect range:"
    git bisect visualize --oneline
  else
    echo "No bisect in progress"
  fi
}

### Bisect Helpers

function gbshelp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbshelp"
    echo "Show bisect command reference"
    return 0
  fi
  
  cat << 'EOF'
Git Bisect Command Reference:

Starting:
  gbs <bad> [good]  - Start bisect (good defaults to HEAD~10)
  fbisect          - Interactive commit selection
  gbsa <bad> <good> <cmd> - Automated bisect with test command

During bisect:
  gbg              - Mark current as good
  gbb              - Mark current as bad  
  gbsk             - Skip current commit
  gbst             - Show bisect status
  gbsv             - Visualize remaining commits

Information:
  gbsl             - Show bisect log
  gbshelp          - This help

Ending:
  gbr              - Reset/end bisect

Tips:
- Use specific commits/tags for more reliable results
- Test commands for gbsa should exit 0=good, non-zero=bad
- You can bisect between any two commits, not just recent ones
- Skip commits that don't build or are otherwise untestable
EOF
}

### Smart Bisect Shortcuts

function gbsquick() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbsquick [commits-back]"
    echo "Quick bisect last N commits (defaults to 20)"
    echo "Assumes HEAD is bad, HEAD~N is good"
    echo "Example: gbsquick 50"
    return 0
  fi
  
  local commits_back="${1:-20}"
  
  if ! [[ "$commits_back" =~ ^[0-9]+$ ]]; then
    echo "Error: commits-back must be a number"
    return 1
  fi
  
  echo "Quick bisect: assuming HEAD is bad, HEAD~$commits_back is good"
  gbs HEAD "HEAD~$commits_back"
}

function gbstag() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gbstag <bad-tag> [good-tag]"
    echo "Bisect between tags (good-tag defaults to previous tag)"
    echo "Examples:"
    echo "  gbstag v1.2.0        # Bisect from previous tag to v1.2.0"
    echo "  gbstag v1.2.0 v1.0.0 # Bisect between v1.0.0 and v1.2.0"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Error: bad tag required"
    return 1
  fi
  
  local bad_tag="$1"
  local good_tag="$2"
  
  if [[ -z "$good_tag" ]]; then
    # Find previous tag
    good_tag=$(git tag --sort=-version:refname | grep -A1 "^$bad_tag$" | tail -1)
    if [[ -z "$good_tag" || "$good_tag" == "$bad_tag" ]]; then
      echo "Error: could not find previous tag, please specify good tag"
      return 1
    fi
  fi
  
  echo "Bisecting between tags: $good_tag (good) -> $bad_tag (bad)"
  gbs "$bad_tag" "$good_tag"
}