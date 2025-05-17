function addBackendSettingToEnv() {
  local service="$1"
  local env="$2"

  location=$(get_location_for "$service" "$env")
  backend=$(get_url_for "$service" "$env")
  file="$location/$env.env"

  printf "\n\n#################################################" >> "$file"
  printf   "\n# NOTE: This .env file is based off of %s      #" "$env" >> "$file"
  printf   "\n#################################################" >> "$file"
  printf "\n\n# Below is env-specific config\n" >> "$file"
  printf   "\nVITE_REACT_APP_API_PATH=%s" "$backend" >> "$file"
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
  touch "$temp_file"  # Initialize empty temp file

  # Process each line of the file
  while IFS= read -r line || [[ -n "$line" ]]; do
    local should_comment=false
    
    # Check if this line sets any of the specified variables and is not already commented
    for var in "${vars_to_comment[@]}"; do
      if [[ "$line" =~ ^[[:space:]]*${var}[[:space:]]*= && ! "$line" =~ ^[[:space:]]*# ]]; then
        should_comment=true
        break  # Exit the loop once we know we need to comment this line
      fi
    done
    
    # Write the line to the temp file, with a comment if needed
    if [[ "$should_comment" == true ]]; then
      echo "# $line" >> "$temp_file"
    else
      echo "$line" >> "$temp_file"
    fi
  done < "$file"

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
  addBackendSettingToEnv "$service" "$env"

  commentOutNonLocalFrontendEnvars "$service" "$env" \
    "VITE_REACT_APP_METRICS_APP_ID" \
    "VITE_REACT_APP_METRICS_CLIENT_TOKEN" \
    "VITE_REACT_APP_METRICS_SITE" \
    "VITE_REACT_APP_METRICS_SERVICE"
}

function updateFrontendConfig() {
  local service="$1"
  local env="$2"
  local key="$3"
  local value="$4"

  config_dir=$(get_location_for "$service" "$env")
  config_file="$config_dir/$env.env"

  printf "\n%s=%s" "$key" "$value" >> "$config_file"
}

function getBeConfig() {
  local service="$1"
  local env="$2"
  location=$(get_location_for "$service" "$env")

  rm -f "$location/conf.$env.json"
  rm -f "$location/conf.local.$env.json"

  getConfigGeneric "$service" "$env"

  base="conf.base.$env.json"
  downloaded_config="$location/$base"
  new_config="$location/conf.$env.json"
  new_local_config="$location/conf.local.$env.json"

  propertyName=".databaseConfig.datasourceName"
  dbUser="$W_DB_BP_USERNAME"

  propertyValue="user=$dbUser dbname=$W_DB_NAME sslmode=require host=$W_DB_HOST port=$port"
  jq "$propertyName = \"$propertyValue\"" "$downloaded_config" > "$new_config"

  dbUser="postgres"
  propertyValue="user=$dbUser dbname=$W_DB_NAME sslmode=require host=$W_DB_HOST port=$port"
  jq "$propertyName = \"$propertyValue\"" "$downloaded_config" > "$new_local_config"
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
    return 1;
  fi

  location=$(get_location_for "$service" "$env")
  local base_config="$location/conf.base.$env.json"
  local tmp_file="$base_config.tmp"
  file="$location/conf.$env.json"
  if [[ "$is_local" == true ]]; then
    file="$location/conf.local.$env.json"
  fi

  jq "$json_path = \"$newVal\"" "$base_config" > "$tmp_file";
  mv "$tmp_file" "$file";
}
