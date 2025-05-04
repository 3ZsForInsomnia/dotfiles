alias fe="j fe"
alias febp="j febp"

function runFeWith() {
  local env="$1"
  local as_if_it_were="$2"
  shift 2
  local allowed_envs=("$@")

  if ! checkArgument "$env" "${allowed_envs[@]}"; then
    echo "Invalid base environment. Must be one of: ${allowed_envs[@]}"
    return 1;
  fi

  config_file="$W_FEBP/$env.env"
  if [[ "$env" == "local" ]]; then
    config_file="$W_FEBP/local.dev.env"
    echo "Note that if you are pointing to local backend, you must be running \`kubeFwd\` and the \`brokerportal\` backend separately!"
    if [[ -e "$W_FEBP/local.$as_if_it_were.env" ]]; then
      config_file="$W_FEBP/local.$as_if_it_were.env"
      echo "Running FE with local backend, based on $as_if_it_were config";
    else
      echo "Running FE with local backend, based on dev config. The config you wanted to use does not exist!";
    fi
  else
    echo "Running FE with $env backend";
  fi

  dotenvx run --env-file "$config_file" -- nx serve broker-portal-fe
}

function getBpFeConfig() {
  getFeConfig "bpfe" "$1" "$W_FEBP"
}

function updateBpFeConfig() {
  local env="$1"
  local port="$2"

  file="$W_FEBP/local.$env.env"
  key="VITE_REACT_APP_API_PATH"
  value="http://localhost:$port/"

  updateFrontendConfig "$file" "$key" "$value"
}
