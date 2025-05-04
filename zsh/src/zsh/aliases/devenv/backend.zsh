alias gotoBpBe="plat; cd main/brokerportal"
alias runBpBe="gotoBpBe; gob; ./brokerportal"

alias goToCtBe="plat; cd main/carriertracker"
alias runCtBe="goToCtBe; gob; ./carriertracker"

alias goToAuth="plat; cd main/auth"
alias runAuth="goToAuth; gob; echo 'Note: Running local auth requires running Caddy with \`caddy run\`'; ./auth"

function runBeWith() {
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
  url=$(get_url_for "ct" "local")
  port=$(get_port_for "ct" "local")

  aquaUrl="$url:$port"
  aquaConfig=".servicesConfig.brokerPortalConfig.aquariumConfig.baseUrl"

  updateBackendConfig "$1" "$W_BEBP/conf.local.$1.json" "$aquaConfig" "$aquaUrl" "${W_AVAILABLE_ENVS[@]}"
}

function useNonLocalCt() {
  url=$(get_url_for "ct" "$1")
  aquaConfig=".servicesConfig.brokerPortalConfig.aquariumConfig.baseUrl"

  updateBackendConfig "$1" "$W_BEBP/conf.local.$1.json" "$aquaConfig" "$url" "${W_AVAILABLE_ENVS[@]}"
}

function useLocalBpAuth() {
  port=$(get_port_for "bp" "localauth")

  updateBackendConfig "$1" "$W_BEBP/conf.$1.json" ".httpPort" "$port" "${W_AVAILABLE_ENVS[@]}"
  updatePortInDotEnv "$1" "$port";
 
  echo "Note: Running local auth requires running Caddy with \`caddy run\`"
  runAuth;
}

function useNonLocalBpAuth() {
  port=$(get_port_for "bp" "local")

  killPort "$port"; # Stop the local auth server before updating the config

  updateBackendConfig "$1" "$W_BEBP/conf.$1.json" ".httpPort" "$port" "${W_AVAILABLE_ENVS[@]}"
  updatePortInDotEnv "$1" "$port"
}

function getBpBeConfig() {
  getBeConfig "$1" "$W_BEBP"
}

function updateBpBeConfig() {
  updateBackendConfig "$1" "$W_BEBP/conf.$1.json" ".httpPort" "$2" "${W_AVAILABLE_ENVS[@]}"
}

function updateAquariumUrl() {
  updateBackendConfig "$1" "$W_BEBP/conf.$1.json" ".servicesConfig.brokerPortalConfig.aquariumConfig.baseUrl" "$2" "${W_AVAILABLE_ENVS[@]}"
}
