#!/usr/bin/env zsh

echo "ℹ️  FZF functions (fcdf, fzv, fzo, fkill, etc.) intentionally have no completions"
echo "   They provide their own interactive selection interface"
# Test script for new completions
# Run this to verify completions are working

echo "🧪 Testing ZSH Completions"
echo "=========================="

# Function to test if completion is registered
test_completion() {
  local cmd="$1"
  local desc="$2"
  
  if command -v "$cmd" >/dev/null 2>&1; then
    if compdef -p "$cmd" >/dev/null 2>&1; then
      echo "✅ $desc: $cmd completion registered"
    else
      echo "❌ $desc: $cmd completion NOT registered"
    fi
  else
    echo "⚠️  $desc: $cmd command not found (completion available when installed)"
  fi
}

echo "\n📦 Kubernetes Completions:"
test_completion "k" "kubectl alias"
test_completion "kpf" "kubectl port-forward"
test_completion "view_kpod_logs" "pod logs viewer"
test_completion "get_pods" "pod lister"

echo "\n🐳 Docker Completions:"
test_completion "d" "docker alias"
test_completion "dinto" "docker exec interactive"
test_completion "dl" "docker logs"
test_completion "dc" "docker compose"

echo "\n📁 File Completions:"
test_completion "fef" "find by extension"
test_completion "v" "nvim alias"
test_completion "o" "open command"

echo "\n☁️  Azure Completions:"
test_completion "getConfigsFor" "get Azure configs"
test_completion "setConfigGeneric" "set Azure configs"
test_completion "getConfig" "get Azure secret"

echo "\n🐍 Python Tool Completions:"
test_completion "pe" "pyenv alias"
test_completion "pel" "pyenv local"
test_completion "peg" "pyenv global"
test_completion "por" "poetry run"
test_completion "poetry" "poetry"

echo "\n📦 JavaScript/Node Tool Completions:"
test_completion "nr" "npm/yarn run scripts"
test_completion "npm" "npm"
test_completion "yarn" "yarn"
test_completion "nx" "nx workspace"
test_completion "nxs" "nx serve"

echo "\n🔧 Cache Status:"
if [[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh-kube-completions" ]]; then
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-kube-completions"
  local cache_files=$(ls "$cache_dir" 2>/dev/null | wc -l)
  echo "✅ Kubernetes cache directory exists ($cache_files files)"
else
  echo "ℹ️  Kubernetes cache directory will be created on first use"
fi

echo "\n🎯 Quick Test Commands:"
echo "Try these commands with <TAB> completion:"
echo "  k get pods <TAB>"
echo "  dinto <TAB>"
echo "  fef <TAB>"
echo "  view_kpod_logs myservice dev <TAB>"
echo ""
echo "🔄 To rebuild completions: rm ~/.zcompdump* && compinit"