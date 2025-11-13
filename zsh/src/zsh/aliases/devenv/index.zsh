function sourceDevEnvStuff() {
  local alias_path="$ZSH_CONFIG_DIR/aliases/devenv"

  sources=(
    "backend.zsh"
    "configs.zsh"
    "database.zsh"
    "frontend.zsh"
    "locations.zsh"
    "misc.zsh"
    "procfiles.zsh"
  )

  for source_file in "${sources[@]}"; do
    if [[ ! -f "$alias_path/$source_file" ]]; then
      echo "Error: $alias_path/$source_file not found."
    else
      source "$alias_path/$source_file"
    fi
  done
}

sourceDevEnvStuff
