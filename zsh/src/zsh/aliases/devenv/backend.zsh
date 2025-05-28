alias gotoBpBe="plat; cd main/brokerportal"
alias runBpBe="gotoBpBe; gob; ./brokerportal"

alias goToCtBe="plat; cd main/carriertracker"
alias runCtBe="goToCtBe; gob; ./carriertracker"

alias goToAuth="plat; cd main/auth"
alias runAuth="goToAuth; gob; echo 'Note: Running local auth requires running Caddy with \`caddy run\`'; ./auth"

function runBeWith() {
  local env="$1"
  # shift
  # local allowed_envs=("$@")
  #
  # if ! checkArgument "$env" "${allowed_envs[@]}"; then
  #   echo "Invalid environment. Must be one of: ${allowed_envs[@]}"
  #   return 1;
  # fi

  plat;
  CompileDaemon \
    -build="go build -C ./main/brokerportal" \
    -command="./main/brokerportal/brokerportal -conf=./main/brokerportal/conf.$1.json"
}

function runBeDebugWith() {
  local env="$1"
  shift
  local allowed_envs=("$@")

  if ! checkArgument "$env" "${allowed_envs[@]}"; then
    echo "Invalid environment. Must be one of: ${allowed_envs[@]}"
    return 1;
  fi

  plat;
  CompileDaemon \
    -build="go build -C ./main/brokerportal" \
    -command="dlv exec ./main/brokerportal/brokerportal -- -conf=./main/brokerportal/conf.$1.json"
}

function runBpMigrations() {
  local env="$1"
  shift
  local allowed_envs=("$@")

  if ! checkArgument "$env" "${allowed_envs[@]}"; then
    echo "Invalid base environment. Must be one of: ${allowed_envs[@]}"
    return 1;
  fi

  go run "$W_PATH"/platform/main/brokerportal -conf "$W_PATH"/platform/main/brokerportal/conf."$1".json --migration --sql "$W_PATH"/platform/services/sql/
}

function useLocalCt() {
  local service="bp"
  local env="$1"
  local json_path=".servicesConfig.brokerPortalConfig.aquariumConfig.baseUrl"
  newVal=$(get_url_for "ct" "local")
  local is_local="$2"

  updateBackendConfig "$service" "$env" "$json_path" "$newVal" "$is_local" "${W_AVAILABLE_ENVS[@]}"
}

function useNonLocalCt() {
  local service="bp"
  local env="$1"
  local json_path=".servicesConfig.brokerPortalConfig.aquariumConfig.baseUrl"
  newVal=$(get_url_for "ct" "$2")
  local is_local="$2"

  updateBackendConfig "$service" "$env" "$json_path" "$newVal" "$is_local" "${W_AVAILABLE_ENVS[@]}"
}

function useLocalBpAuth() {
  local service="bp"
  local env="$1"
  local json_path=".httpPort"
  newVal=$(get_port_for "bp" "localauth")
  local is_local=true

  updateBackendConfig "$service" "$env" "$json_path" "$newVal" "$is_local" "${W_AVAILABLE_ENVS[@]}"

  fe_newVal=$(get_url_for "bpfe" "localauth")
  updateFrontendConfig "bpfe" "local" "VITE_REACT_APP_API_PATH" "$fe_newVal"

  echo "Note: Running local auth requires running Caddy with \`caddy run\`"
  runAuth;
}

function useNonLocalBpAuth() {
  local service="bp"
  local env="$1"
  local json_path=".httpPort"
  newVal=$(get_port_for "bp" "$2")
  local is_local=true

  killPort "$newVal"; # Stop the local auth server before updating the config

  updateBackendConfig "$service" "$env" "$json_path" "$newVal" "$is_local" "${W_AVAILABLE_ENVS[@]}"

  fe_newVal=$(get_url_for "bpfe" "local")
  updateFrontendConfig "bpfe" "local" "VITE_REACT_APP_API_PATH" "$fe_newVal"
}

function getBpBeConfig() {
  getBeConfig "bp" "$1"
}

function updateBpBeConfig() {
  local service="bp"
  local env="$1"
  local json_path="$2"
  local newVal="$3"
  local is_local="$4"

  updateBackendConfig "$service" "$env" "$json_path" "$newVal" "$is_local" "${W_AVAILABLE_ENVS[@]}"
}

function updateAquariumUrl() {
  local service="bp"
  local env="$1"
  local config="$2"
  local json_path=".servicesConfig.brokerPortalConfig.aquariumConfig.baseUrl"
  local is_local=true

  newVal=$(get_url_for "ct" "$env")

  updateBackendConfig "$service" "$config" "$json_path" "$newVal" "$is_local" "${W_AVAILABLE_ENVS[@]}"
}
