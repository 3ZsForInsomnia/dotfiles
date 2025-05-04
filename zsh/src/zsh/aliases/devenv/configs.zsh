function getFeConfig() {
  local service="$1"
  local env="$2"
  local location="$3"

  env_file="$location/$env.env"
  local_env_file="$location/local.$env.env"

  rm -f "$file"
  rm -f "$local_env_file"

  backend=$(getBackendForEnv "$env")
  local_backend=$(getBackendForEnv "local")

  config=$(getConfigForEnv "$service" "$env")
  vault=$(get_vault_for_env "$env")
  getConfigGeneric "$config" "$vault" "$env_file"

  cp "$env_file" "$local_env_file"

  addBackendSettingToEnv "$env_file" "$backend" "$env"
  addBackendSettingToEnv "$local_env_file" "$local_backend" "$env"
}

function getBeConfig() {
  local env="$1"
  local location="$2"

  handleAsLocal=false

  if [ "$env" = "local" ]; then
    env="dev"
    handleAsLocal=true
  fi

  base="conf.base.json"
  base_config="$location/$base"
  env_config="$location/conf.$env.json"

  getConfigGeneric "$env" "$location" "$base"

  port=$(getPortForEnv "$env")
  propertyName=".databaseConfig.datasourceName"
  dbUser="$W_DB_BP_USERNAME"

  if [ "$handleAsLocal" = true ]; then
    dbUser="postgres"
  fi

  propertyValue="user=$dbUser dbname=$W_DB_NAME sslmode=require host=$W_DB_HOST port=$port"
  jq "$propertyName = \"$propertyValue\"" "$base_config" > "$env_config"
  rm -f "$base_config"
}

function updateBackendConfig() {
  local env="$1"
  local base_config="$2"
  local json_path="$3"
  local newVal="$4"
  shift 4
  local allowed_envs=("$@")

  if ! checkArgument "$env" "${allowed_envs[@]}"; then
    echo "Invalid environment. Must be one of: ${allowed_envs[@]}"
    return 1;
  fi

  local tmp_file="$base_config.tmp"
  local local_file="conf.local.$env.json"

  jq ".$json_path = \"$newVal\"" "$base_config" > "$tmp_file";
  mv "$tmp_file" "$local_file";
}

updateFrontendConfig() {
  local config_file="$1"
  local key="$2"
  local value="$3"

  printf "\n%s=%s" "$key" "$value" >> "$config_file"
}
