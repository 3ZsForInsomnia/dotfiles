function addBackendSettingToEnv() {
  local file="$1"
  local backend="$2"
  # local service="$1"
  # local env="$2"
  #
  # location=$(get_location_for "$service" "$env")
  # backend=$(get_url_for "$service" "$env")
  # file="$location/$env.env"

  printf "\n\n#################################################" >>"$file"
  printf "\n# NOTE: This .env file is based off of %s      #" "$env" >>"$file"
  printf "\n#################################################" >>"$file"
  printf "\n\n# Below is env-specific config\n" >>"$file"
  printf "\nVITE_REACT_APP_API_PATH=%s" "$backend" >>"$file"
}

function setBeConfig() {
  # Handle help flag
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: setBeConfig <service> <env> [config_type]"
    echo ""
    echo "Upload backend configuration files to Azure Key Vault"
    echo ""
    echo "Arguments:"
    echo "  service      Service name"
    echo "  env          Environment (e.g., qat, prod)"
    echo "  config_type  Optional config type:"
    echo "               - (empty)  uses conf.<env>.json (default)"
    echo "               - base     uses conf.base.<env>.json"
    echo "               - local    uses conf.local.<env>.json"
    echo ""
    echo "Examples:"
    echo "  setBeConfig myservice qat           # uploads conf.qat.json"
    echo "  setBeConfig myservice qat base      # uploads conf.base.qat.json"
    echo "  setBeConfig myservice qat local     # uploads conf.local.qat.json"
    return 0
  fi

  local service="$1"
  local env="$2"
  local config_type="$3" # optional: "base", "local", or empty for default

  loc=$(get_location_for "$service" "$env")
  vault=$(get_vault_for "$service" "$env")
  config=$(get_config_for "$service" "$env")

  if [ -z "$loc" ]; then
    echo "Location not found for $service in $env"
    return 1
  fi
  if [ -z "$vault" ]; then
    echo "Vault not found for $service in $env"
    return 1
  fi
  if [ -z "$config" ]; then
    echo "Config not found for $service in $env"
    return 1
  fi

  # Determine which config file to use
  local file
  if [ -z "$config_type" ]; then
    file="$loc/conf.$env.json"
  elif [ "$config_type" = "base" ]; then
    file="$loc/conf.base.$env.json"
  elif [ "$config_type" = "local" ]; then
    file="$loc/conf.local.$env.json"
  else
    echo "Invalid config_type. Must be 'base', 'local', or empty for default"
    return 1
  fi

  # Validate file exists
  if [ ! -f "$file" ]; then
    echo "Config file not found: $file"
    return 1
  fi

  # Print file info regardless of upload success
  echo "Using config file: $file"

  setConfig "$config" "$vault" "$file"
}

function commentOutNonLocalFrontendEnvars() {
  local service="$1"
  local env="$2"
  shift 2
  local vars_to_comment=("$@")

  location=$(get_location_for "$service" "$env")
  file="$location/$env.env"

  # Make sure the file exists
  if [[ ! -f "$file" ]]; then
    echo "File not found: $file"
    return 1
  fi

  # Create a temporary file
  local temp_file="$file.tmp"
  touch "$temp_file" # Initialize empty temp file

  # Process each line of the file
  while IFS= read -r line || [[ -n "$line" ]]; do
    local should_comment=false

    # Check if this line sets any of the specified variables and is not already commented
    for var in "${vars_to_comment[@]}"; do
      if [[ "$line" =~ ^[[:space:]]*${var}[[:space:]]*= && ! "$line" =~ ^[[:space:]]*# ]]; then
        should_comment=true
        break # Exit the loop once we know we need to comment this line
      fi
    done

    # Write the line to the temp file, with a comment if needed
    if [[ "$should_comment" == true ]]; then
      echo "# $line" >>"$temp_file"
    else
      echo "$line" >>"$temp_file"
    fi
  done <"$file"

  # Replace the original file with the temporary file
  mv "$temp_file" "$file"

}

function getFeConfig() {
  local service="$1"
  local env="$2"

  location=$(get_location_for "$service" "$env")
  env_file="$location/$env.env"
  local_env_file="$location/local.$env.env"

  rm -f "$env_file"
  rm -f "$local_env_file"

  getConfigGeneric "$service" "$env" true

  cp "$location/base.$env.env" "$env_file"

  # This creates the "user-modified" section of the config file
  backend=$(get_url_for "$service" "$env")
  addBackendSettingToEnv "$env_file" "$backend"

  commentOutNonLocalFrontendEnvars "$service" "$env" \
    "VITE_REACT_APP_METRICS_APP_ID" \
    "VITE_REACT_APP_METRICS_CLIENT_TOKEN" \
    "VITE_REACT_APP_METRICS_SITE" \
    "VITE_REACT_APP_METRICS_SERVICE"

  cp "$env_file" "$local_env_file"
  backend=$(get_url_for "$service" "local")
  updateFrontendConfig "$service" "qat" "VITE_REACT_APP_API_PATH" "$backend" true
}

function updateFrontendConfig() {
  local service="$1"
  local env="$2"
  local key="$3"
  local value="$4"
  local is_local="$5"

  config_dir=$(get_location_for "$service" "$env")
  config_file="$config_dir/$env.env"
  if [[ "$is_local" == true ]]; then
    config_file="$config_dir/local.$env.env"
  fi
  echo "Updating $key in $config_file to $value"

  printf "\n%s=%s" "$key" "$value" >>"$config_file"
}

function getBeConfig() {
  local service="$1"
  local env="$2"
  location=$(get_location_for "$service" "$env")
  port=$(get_port_for "$service" "$env")

  rm -f "$location/conf.$env.json"
  rm -f "$location/conf.local.$env.json"

  getConfigGeneric "$service" "$env"

  base="conf.base.$env.json"
  downloaded_config="$location/$base"
  new_config="$location/conf.$env.json"
  new_local_config="$location/conf.local.$env.json"

  propertyName=".databaseConfig.datasourceName"
  dbUser="$W_DB_BP_USERNAME"

  if [[ "$env" == "qat" ]]; then
    W_DB_NAME="qat"
  fi

  propertyValue="user=$dbUser dbname=$W_DB_NAME sslmode=require host=$W_DB_HOST port=$port"
  echo "Updating $propertyName in $downloaded_config to $propertyValue for config $new_config"
  jq "$propertyName = \"$propertyValue\"" "$downloaded_config" >"$new_config"

  propertyValue="user=$dbUser dbname=$W_DB_NAME sslmode=require host=$W_DB_HOST port=$port"
  echo "Updating $propertyName in $downloaded_config to $propertyValue for config $new_local_config"
  jq "$propertyName = \"$propertyValue\"" "$downloaded_config" >"$new_local_config"
}

function updateBackendConfig() {
  local service="$1"
  local env="$2"
  local json_path="$3"
  local newVal="$4"
  local is_local="$5"
  shift 5
  local allowed_envs=("$@")

  if ! checkArgument "$env" "${allowed_envs[@]}"; then
    echo "Invalid environment. Must be one of: ${allowed_envs[@]}"
    return 1
  fi

  location=$(get_location_for "$service" "$env")
  local base_config="$location/conf.$env.json"
  local tmp_file="$base_config.tmp"
  file="$location/conf.$env.json"
  if [[ "$is_local" == true ]]; then
    file="$location/conf.local.$env.json"
  fi

  jq "$json_path = \"$newVal\"" "$base_config" >"$tmp_file"
  mv "$tmp_file" "$file"
}
