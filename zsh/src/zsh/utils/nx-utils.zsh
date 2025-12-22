#!/usr/bin/env zsh

# Nx workspace utility functions
# Functions for finding and parsing nx project configurations

# Find the nx workspace root
# Returns: absolute path to workspace root, or empty if not found
findNxWorkspaceRoot() {
  local search_dir="${1:-.}"
  local current_dir="$(cd "$search_dir" 2>/dev/null && pwd)"
  
  while [[ -n "$current_dir" && "$current_dir" != "/" ]]; do
    # Check for nx workspace markers
    if [[ -f "$current_dir/nx.json" ]] || \
       [[ -f "$current_dir/workspace.json" ]] || \
       [[ -f "$current_dir/angular.json" ]]; then
      echo "$current_dir"
      return 0
    fi
    current_dir="$(dirname "$current_dir")"
  done
  
  return 1
}

# Get all nx projects from workspace configuration
# Returns: array of project names, one per line
getNxProjects() {
  local workspace_root
  workspace_root=$(findNxWorkspaceRoot)
  
  if [[ -z "$workspace_root" ]]; then
    return 1
  fi
  
  # Try nx.json first (modern nx with project.json files)
  if [[ -f "$workspace_root/nx.json" ]] && command -v jq >/dev/null 2>&1; then
    # Modern nx stores projects as object keys or in projects array
    local projects
    projects=$(jq -r '
      if .projects then
        if (.projects | type) == "object" then
          .projects | keys[]
        elif (.projects | type) == "array" then
          .projects[]
        else
          empty
        end
      else
        empty
      end
    ' "$workspace_root/nx.json" 2>/dev/null)
    
    if [[ -n "$projects" ]]; then
      echo "$projects"
      return 0
    fi
  fi
  
  # Try workspace.json (legacy nx)
  if [[ -f "$workspace_root/workspace.json" ]] && command -v jq >/dev/null 2>&1; then
    jq -r '.projects | keys[]' "$workspace_root/workspace.json" 2>/dev/null
    return 0
  fi
  
  # Try angular.json (nx with angular)
  if [[ -f "$workspace_root/angular.json" ]] && command -v jq >/dev/null 2>&1; then
    jq -r '.projects | keys[]' "$workspace_root/angular.json" 2>/dev/null
    return 0
  fi
  
  # Fallback: scan for project.json files
  if [[ -d "$workspace_root/apps" ]] || [[ -d "$workspace_root/libs" ]]; then
    find "$workspace_root/apps" "$workspace_root/libs" \
      -maxdepth 2 -name "project.json" 2>/dev/null | \
      while read -r project_file; do
        basename "$(dirname "$project_file")"
      done
    return 0
  fi
  
  return 1
}

# Get the project.json path for a given project
# Args: $1 - project name
# Returns: absolute path to project.json, or empty if not found
getNxProjectJsonPath() {
  local project_name="$1"
  local workspace_root
  workspace_root=$(findNxWorkspaceRoot)
  
  if [[ -z "$workspace_root" ]]; then
    return 1
  fi
  
  # Check common locations
  local possible_paths=(
    "$workspace_root/apps/$project_name/project.json"
    "$workspace_root/libs/$project_name/project.json"
    "$workspace_root/packages/$project_name/project.json"
    "$workspace_root/$project_name/project.json"
  )
  
  for path in "${possible_paths[@]}"; do
    if [[ -f "$path" ]]; then
      echo "$path"
      return 0
    fi
  done
  
  # Fallback: search for it
  local found
  found=$(find "$workspace_root" -name "project.json" -path "*/$project_name/project.json" -print -quit 2>/dev/null)
  
  if [[ -n "$found" ]]; then
    echo "$found"
    return 0
  fi
  
  return 1
}

# Get available targets for a specific project
# Args: $1 - project name
# Returns: array of target names, one per line
getNxProjectTargets() {
  local project_name="$1"
  local project_json
  project_json=$(getNxProjectJsonPath "$project_name")
  
  if [[ -z "$project_json" ]] || [[ ! -f "$project_json" ]]; then
    return 1
  fi
  
  if ! command -v jq >/dev/null 2>&1; then
    return 1
  fi
  
  jq -r '.targets | keys[]' "$project_json" 2>/dev/null
}

# Check if a project has a specific target
# Args: $1 - project name, $2 - target name
# Returns: 0 if target exists, 1 otherwise
projectHasTarget() {
  local project_name="$1"
  local target_name="$2"
  local project_json
  project_json=$(getNxProjectJsonPath "$project_name")
  
  if [[ -z "$project_json" ]] || [[ ! -f "$project_json" ]]; then
    return 1
  fi
  
  if ! command -v jq >/dev/null 2>&1; then
    return 1
  fi
  
  jq -e ".targets.\"$target_name\" != null" "$project_json" >/dev/null 2>&1
}

# Get all projects that have a specific target
# Args: $1 - target name (e.g., "serve", "test", "build", "lint")
# Returns: array of project names, one per line
getNxProjectsWithTarget() {
  local target_name="$1"
  local -a projects_with_target
  
  # Get all projects
  local all_projects
  all_projects=$(getNxProjects)
  
  if [[ -z "$all_projects" ]]; then
    return 1
  fi
  
  # Filter projects that have the target
  while IFS= read -r project; do
    if projectHasTarget "$project" "$target_name"; then
      echo "$project"
    fi
  done <<< "$all_projects"
}

# Get project information including available targets
# Args: $1 - project name
# Returns: formatted string with project info
getNxProjectInfo() {
  local project_name="$1"
  local project_json
  project_json=$(getNxProjectJsonPath "$project_name")
  
  if [[ -z "$project_json" ]] || [[ ! -f "$project_json" ]]; then
    echo "$project_name (no project.json found)"
    return 1
  fi
  
  if ! command -v jq >/dev/null 2>&1; then
    echo "$project_name"
    return 0
  fi
  
  local targets
  targets=$(jq -r '.targets | keys | join(", ")' "$project_json" 2>/dev/null)
  
  if [[ -n "$targets" ]]; then
    echo "$project_name [$targets]"
  else
    echo "$project_name"
  fi
}
