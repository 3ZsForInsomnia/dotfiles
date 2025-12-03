#
# Zsh Plugin Subtree Manager
#
# This script provides functions to initialize and update zsh plugins
# that are managed as git subtrees. It reads its configuration from the
# exported associative array `MY_ZSH_PLUGINS`.
#
# It is designed to be lazy-loaded and executed in the user's shell.
#

# --- Private Helper Functions ---

# A wrapper to ensure this script is run from the dotfiles root.
# It checks for a known directory and exits if it's not found.
function _zsh_plugins_ensure_root() {
  if [[ ! -d "zsh/src/zsh/tools" ]]; then
    echo "Error: Must be run from the dotfiles root directory"
    return 1
  fi
  return 0
}

# Parses a plugin entry from the MY_ZSH_PLUGINS array.
#
# Usage: _zsh_plugins_get_info "plugin_name"
# Sets the following global variables:
#   - _PLUGIN_REPO_URL
#   - _PLUGIN_BRANCH
function _zsh_plugins_get_info() {
  local plugin_name="$1"
  local plugin_data_string="${MY_ZSH_PLUGINS[$plugin_name]}"

  if [[ -z "$plugin_data_string" ]]; then
    echo "Error: No data found for plugin '$plugin_name' in MY_ZSH_PLUGINS."
    return 1
  fi

  local -a plugin_data
  plugin_data=("${(s: :)plugin_data_string}") # Split string by spaces

  local repo_path="${plugin_data[1]}"

  _PLUGIN_REPO_URL="https://github.com/${repo_path}.git"
  _PLUGIN_BRANCH="${plugin_data[2]}"
  return 0
}

# --- Public API ---

# Initializes all zsh plugins defined in MY_ZSH_PLUGINS.
# It will only add subtrees that do not already exist.
function zsh_plugins_init() {
  _zsh_plugins_ensure_root || return 1

  local tools_prefix="zsh/src/zsh/tools"
  echo "Initializing zsh tool subtrees..."

  for package in "${(@k)MY_ZSH_PLUGINS}"; do
    if [[ -d "$tools_prefix/$package" ]]; then
      echo "Skipping '$package' (already exists)"
    else
      _zsh_plugins_get_info "$package" || continue
      echo "Adding subtree: $package"
      git subtree add --prefix="$tools_prefix/$package" "$_PLUGIN_REPO_URL" "$_PLUGIN_BRANCH" --squash
    fi
  done
  echo "Initialization complete."
}

# Updates all zsh plugins defined in MY_ZSH_PLUGINS.
# It pulls changes for existing subtrees and adds any that are missing.
function zsh_plugins_update() {
  _zsh_plugins_ensure_root || return 1

  local tools_prefix="zsh/src/zsh/tools"
  echo "Updating zsh tool subtrees..."

  for package in "${(@k)MY_ZSH_PLUGINS}"; do
    _zsh_plugins_get_info "$package" || continue

    if [[ -d "$tools_prefix/$package" ]]; then
      echo "Updating subtree: $package"
      git subtree pull --prefix="$tools_prefix/$package" "$_PLUGIN_REPO_URL" "$_PLUGIN_BRANCH" --squash
    else
      echo "Adding missing subtree: $package"
      git subtree add --prefix="$tools_prefix/$package" "$_PLUGIN_REPO_URL" "$_PLUGIN_BRANCH" --squash
    fi
  done
  echo "Update process complete."
}

