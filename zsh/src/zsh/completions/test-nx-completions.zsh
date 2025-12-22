#!/usr/bin/env zsh

# Quick test script for nx completions
# Run this in an nx workspace to verify completions work

echo "🧪 Testing Nx Completions"
echo "=========================="
echo ""

# Check if we're in an nx workspace
if [[ ! -f "nx.json" && ! -f "workspace.json" && ! -f "angular.json" ]]; then
  echo "❌ Not in an nx workspace (no nx.json, workspace.json, or angular.json found)"
  echo "   Please cd to an nx workspace and try again."
  exit 1
fi

echo "✅ Found nx workspace"
echo ""

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
  echo "⚠️  jq is not installed - JSON parsing will fail"
  echo "   Install with: brew install jq"
  exit 1
fi

echo "✅ jq is installed"
echo ""

# Test utility functions
echo "Testing utility functions:"
echo "--------------------------"

# Load the utils
autoload -Uz findNxWorkspaceRoot getNxProjects getNxProjectsWithTarget

# Test workspace root
workspace_root=$(findNxWorkspaceRoot)
if [[ -n "$workspace_root" ]]; then
  echo "✅ findNxWorkspaceRoot: $workspace_root"
else
  echo "❌ findNxWorkspaceRoot: failed"
  exit 1
fi

# Test getting all projects
all_projects=$(getNxProjects)
if [[ -n "$all_projects" ]]; then
  project_count=$(echo "$all_projects" | wc -l | tr -d ' ')
  echo "✅ getNxProjects: found $project_count projects"
  echo "   Projects: $(echo "$all_projects" | tr '\n' ', ' | sed 's/,$//')"
else
  echo "❌ getNxProjects: no projects found"
  exit 1
fi

echo ""

# Test filtering by targets
echo "Testing target filtering:"
echo "------------------------"

for target in serve test build lint; do
  filtered=$(getNxProjectsWithTarget "$target")
  if [[ -n "$filtered" ]]; then
    count=$(echo "$filtered" | wc -l | tr -d ' ')
    echo "✅ $target: $count project(s)"
    echo "   $(echo "$filtered" | tr '\n' ', ' | sed 's/,$//')"
  else
    echo "⚠️  $target: no projects with this target"
  fi
done

echo ""
echo "Testing completion registration:"
echo "--------------------------------"

# Check if completions are registered
for cmd in nxs nxt nxb nxl; do
  if compdef -p "$cmd" >/dev/null 2>&1; then
    echo "✅ $cmd: completion registered"
  else
    echo "❌ $cmd: completion NOT registered"
    echo "   Try: rm ~/.zcompdump* && exec zsh"
  fi
done

echo ""
echo "🎉 Testing complete!"
echo ""
echo "To manually test completions, try:"
echo "  nxs <TAB>   # Should show serveable projects"
echo "  nxt <TAB>   # Should show testable projects"
echo "  nxb <TAB>   # Should show buildable projects"
echo "  nxl <TAB>   # Should show lintable projects"
echo ""
echo "If completions don't work, try:"
echo "  1. Reload shell: exec zsh"
echo "  2. Clear completion cache: rm ~/.zcompdump* && exec zsh"
echo "  3. Check file paths match your setup"
