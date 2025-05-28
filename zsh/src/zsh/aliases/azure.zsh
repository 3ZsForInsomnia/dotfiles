function getConfig() {
  local env_string="$1"
  local vault="$2"
  local file="$3"

  echo "Getting config for $env_string from $vault to $file"

  az keyvault secret download --name "$env_string" --vault-name "$vault" --file "$file";
}

function getConfigGeneric() {
  local service="$1"
  local env="$2"
  local is_fe="$3"

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

  file="$loc/conf.base.$env.json"
  if [ "$is_fe" = true ]; then
    file="$loc/base.$env.env"
  fi
  rm -f "$file"

  getConfig "$config" "$vault" "$file"
}

function setConfig() {
  local env_string="$1"
  local vault="$2"
  local file="$3"

  echo "Setting config for $env_string from $vault to $file"

  az keyvault secret set --name "$env_string" --vault-name "$vault" --file "$file";
}

function setConfigGeneric() {
  local service="$1"
  local env="$2"
  local is_fe="$3"

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

  file="$loc/conf.base.$env.json"
  if [ "$is_fe" = true ]; then
    file="$loc/base.$env.env"
  fi

  setConfig "$config" "$vault" "$file"
}

function get_port_for() {
  print -r -- "${E_PORTS[$1:$2]}"
}
function get_url_for() {
  print -r -- "${E_URLS[$1:$2]}"
}
function get_namespace_for() {
  print -r -- "${E_NAMESPACES[$1:$2]}"
}
function get_cluster_for() {
  print -r -- "${E_CLUSTERS[$1:$2]}"
}
function get_vault_for() {
  print -r -- "${E_VAULTS[$1:$2]}"
}
function get_resource_group_for() {
  print -r -- "${E_RESOURCEGROUPS[$1:$2]}"
}
function get_config_for() {
  print -r -- "${E_CONFIGNAMES[$1:$2]}"
}
function get_location_for() {
  print -r -- "${E_LOCATIONS[$1:$2]}"
}
