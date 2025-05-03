function getConfig() {
  local env_string="$1"
  local vault="$2"
  local file="$3"

  echo "Getting config for $env_string from $vault to $file"

  az keyvault secret download --name "$env_string" --vault-name "$vault" --file "$file";
}

function getConfigGeneric() {
  local env="$1"
  local vault="$2"
  local file="$3"

  rm -f "$file"

  getConfig "$env" "$vault" "$file"
}

function addBackendSettingToEnv() {
  local env_path="$1"
  local backend="$2"
  local env="$3"

  printf "\n\n#################################################" >> "$env_path"
  printf   "\n# NOTE: This .env file is based off of %s      #" "$env" >> "$env_path"
  printf   "\n#################################################" >> "$env_path"
  printf "\n\n# Below is env-specific config\n" >> "$env_path"
  printf   "\nVITE_REACT_APP_API_PATH=%s" "$backend" >> "$env_path"
}
