function getConfigsFor() {
  local service="$1"
  local env="$2"

  vault=$(get_vault_for "$service" "$env")
  if [ -z "$vault" ]; then
    echo "Vault not found for $service in $env"
    return 1
  fi
  config_name=$(get_config_for "$service" "$env")
  if [ -z "$config_name" ]; then
    echo "Config name not found for $service in $env"
    return 1
  fi

  local selected_version=$(az keyvault secret list-versions --vault-name "$vault" --name "$config_name" --query '[].id' -o tsv | 
  awk -F'/' '{print $NF}' | 
  fzf --preview "echo 'Secret details:'; 
    az keyvault secret show --vault-name \"$vault\" --name \"$config_name\" --version {} --query '{name: name, version: id, created: attributes.created, updated: attributes.updated, tags: tags}' -o yaml; 
    echo '\nSecret value:'; 
    secret=\$(az keyvault secret show --vault-name \"$vault\" --name \"$config_name\" --version {} --query 'value' -o tsv);
    echo \"\$secret\" > /tmp/az_secret_preview.json;
    bat --color always --language json --style plain /tmp/az_secret_preview.json")

  if [[ -n "$selected_version" ]]; then
    value=$(az keyvault secret show --vault-name "$vault" --name "$config_name" --version "$selected_version" --query 'value' -o tsv)

    echo "$selected_version" | pbcopy
    echo "$config_name" | pbcopy
    echo "$value" | fx
  fi
}

function getConfig() {
  local env_string="$1"
  local vault="$2"
  local file="$3"

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

function setConfigWithAttributionAndReason() {
  local config_name="$1"
  local vault="$2"
  local file="$3"
  local reason="$4"

  az keyvault secret set --name "$config_name" --vault-name "$vault" --file "$file" --tags "updatedBy=$WORK_EMAIL" "reason=$reason";
}

function setConfig() {
  local env_string="$1"
  local vault="$2"
  local file="$3"
  local reason="$4"

  echo "Setting config for $env_string from $vault to $file"

  # if reason is present, add it to tags
  if [ -z "$reason" ]; then
    az keyvault secret set --name "$env_string" --vault-name "$vault" --file "$file" --tags "updatedBy=$WORK_EMAIL";
  else
    az keyvault secret set --name "$env_string" --vault-name "$vault" --file "$file" --tags "updatedBy=$WORK_EMAIL" "reason=$reason";
  fi
}

function setConfigGeneric() {
  local service="$1"
  local env="$2"
  local is_fe="$3"
  local reason="$4"

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

  setConfig "$config" "$vault" "$file" "$reason"
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
function get_service_for() {
  print -r -- "${E_SERVICES[$1:$2]}"
}
