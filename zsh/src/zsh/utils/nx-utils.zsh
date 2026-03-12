#!/usr/bin/env zsh

# Nx workspace utility functions

_nx_cache_dir="${ZSH_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache}"
_nx_cache_file="$_nx_cache_dir/nx-projects.json"
_nx_cache_ttl=3600

findNxWorkspaceRoot() {
  local current_dir="$(cd "${1:-.}" 2>/dev/null && pwd)"

  while [[ -n "$current_dir" && "$current_dir" != "/" ]]; do
    if [[ -f "$current_dir/nx.json" ]]; then
      echo "$current_dir"
      return 0
    fi
    current_dir="$(dirname "$current_dir")"
  done

  return 1
}

_nx_workspace_is_cached() {
  local workspace_name="$1"
  [[ -f "$_nx_cache_file" ]] || return 1
  jq -e --arg w "$workspace_name" '.[$w]' "$_nx_cache_file" >/dev/null 2>&1
}

_nx_cache_is_stale() {
  [[ -f "$_nx_cache_file" ]] || return 0
  local cache_age=$(( $(date +%s) - $(stat -f %m "$_nx_cache_file" 2>/dev/null || echo 0) ))
  (( cache_age >= _nx_cache_ttl ))
}


_nx_build_cache() {
  local workspace_root="$1"
  local workspace_name="$(basename "$workspace_root")"

  mkdir -p "$_nx_cache_dir"

  local -A target_map
  while IFS= read -r project_file; do
    local project_name=$(basename "$(dirname "$project_file")")
    local targets
    targets=$(jq -r '.targets // {} | keys[]' "$project_file" 2>/dev/null)
    while IFS= read -r target; do
      [[ -n "$target" ]] && target_map[$target]="${target_map[$target]:+${target_map[$target]},}\"$project_name\""
    done <<< "$targets"
  done < <(find "$workspace_root" -name "project.json" -not -path "*/node_modules/*" 2>/dev/null)

  local workspace_json
  workspace_json=$({
    echo "{"
    local first=true
    for target in "${(@k)target_map}"; do
      $first || echo ","
      first=false
      printf '  "%s": [%s]' "$target" "${target_map[$target]}"
    done
    echo "\n}"
  })

  local existing="{}"
  [[ -f "$_nx_cache_file" ]] && existing=$(cat "$_nx_cache_file")

  echo "$existing" | jq --arg w "$workspace_name" --argjson data "$workspace_json" '.[$w] = $data' > "$_nx_cache_file"
}

_nx_ensure_cache() {
  local workspace_root
  workspace_root=$(findNxWorkspaceRoot) || return 1
  local workspace_name="$(basename "$workspace_root")"

  if ! _nx_workspace_is_cached "$workspace_name"; then
    _nx_build_cache "$workspace_root"
  fi

  echo "$workspace_name"

  if _nx_cache_is_stale; then
    _nx_build_cache "$workspace_root" &!
  fi
}

getNxProjects() {
  local workspace_name
  workspace_name=$(_nx_ensure_cache) || return 1
  jq -r --arg w "$workspace_name" '.[$w] | [.[] | .[]] | unique | .[]' "$_nx_cache_file" 2>/dev/null
}

getNxProjectsWithTarget() {
  local target_name="$1"
  local workspace_name
  workspace_name=$(_nx_ensure_cache) || return 1
  jq -r --arg w "$workspace_name" --arg t "$target_name" '.[$w][$t] // [] | .[]' "$_nx_cache_file" 2>/dev/null
}

getNxProjectTargets() {
  local project_name="$1"
  local workspace_name
  workspace_name=$(_nx_ensure_cache) || return 1
  jq -r --arg w "$workspace_name" --arg p "$project_name" '.[$w] | to_entries[] | select(.value | index($p)) | .key' "$_nx_cache_file" 2>/dev/null
}

projectHasTarget() {
  local project_name="$1"
  local target_name="$2"
  local workspace_name
  workspace_name=$(_nx_ensure_cache) || return 1
  jq -e --arg w "$workspace_name" --arg t "$target_name" --arg p "$project_name" '.[$w][$t] // [] | index($p) != null' "$_nx_cache_file" >/dev/null 2>&1
}

getNxProjectJsonPath() {
  local project_name="$1"
  local workspace_root
  workspace_root=$(findNxWorkspaceRoot) || return 1

  find "$workspace_root" -name "project.json" -path "*/$project_name/project.json" -not -path "*/node_modules/*" -print -quit 2>/dev/null
}

getNxProjectInfo() {
  local project_name="$1"
  local targets
  targets=$(getNxProjectTargets "$project_name")

  if [[ -n "$targets" ]]; then
    local target_list=$(echo "$targets" | tr '\n' ', ' | sed 's/, $//')
    echo "$project_name [$target_list]"
  else
    echo "$project_name"
  fi
}

nxInvalidateCache() {
  local workspace_root
  workspace_root=$(findNxWorkspaceRoot)

  if [[ -z "$workspace_root" ]]; then
    rm -f "$_nx_cache_file"
    return
  fi

  local workspace_name="$(basename "$workspace_root")"
  local existing="{}"
  [[ -f "$_nx_cache_file" ]] && existing=$(cat "$_nx_cache_file")
  echo "$existing" | jq --arg w "$workspace_name" 'del(.[$w])' > "$_nx_cache_file"
}

