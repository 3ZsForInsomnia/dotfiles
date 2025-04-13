alias k="kubectl"

alias kpf="k port-forward"

function get_pods_by_namespace {
  local namespace=$1
  local app_prefix=$2
  
  # Get the list of pod names in the namespace
  kubectl get pods -n "$namespace" -o custom-columns=NAME:.metadata.name --no-headers 2>/dev/null
}

alias get_pods="k get po -n "

# Function to get the most recent pod based on version
function get_latest_pod {
  local namespace=$1
  local app_prefix="sql-patch"

  # Get all matching pods
  pods=$(get_pods_by_namespace "$namespace" "$app_prefix")

  if [[ -z "$pods" ]]; then
      echo "No pods found with the prefix '${app_prefix}' in the namespace '${namespace}'"
      return 1
  fi

  # Sort by version and get the latest pod
  latest_pod=$(echo "$pods" | awk -F '-' '{print $3, $0}' | sort -t. -k1,1nr -k2,2nr -k3,3nr | head -n 1 | cut -d' ' -f2)

  # Remove any `<stdin>` from output if present (most likely not needed, but added for your specific case)
  clean_pod=$(echo "$latest_pod" | sed 's/^<stdin>:.*://g')

  # Print the cleaned result
  echo "$clean_pod"
}

view_kpod_logs() {
  local namespace="$1"

  job=$(fkp "$namespace")

  k logs -n "$namespace" "$job"
}

get_latest_version_row() {
  local input_data=("$@")
  local latest_row=""
  local max_version=""

  for row in "${input_data[@]}"; do
    # Extract the version part
    local version=$(echo "$row" | grep -o 'sql-patch-[0-9]\+\.[0-9]\+\.[0-9]\+')
    
    # Check if the current version is greater than the max_version
    if [[ "$version" > "$max_version" ]]; then
      max_version="$version"
      latest_row="$row"
    elif [[ "$version" == "$max_version" ]]; then
      # Update latest_row if they are the same
      latest_row="$row"
    fi
  done

  echo "$latest_row"
}

view_kpod_log_latest() {
  output=$(get_pods_by_namespace "$1" "sql-patch")
  pods=("${(@f)$(echo "$output")}")

  latest_pod=$(get_latest_version_row "${pods[@]}")

  k logs -n "$1" "$latest_pod"
}

getKDepls() {
  local namespace=$1

  k get deployments -n "$namespace"
}

delKDepl() {
  local namespace=$1
  local deployment=$2

  k delete deployment "$deployment" -n "$namespace"
}

findAndDelKDepl() {
  local namespace=$1

  selected_deployment=$(fkd "$namespace")

  if [[ -n "$selected_deployment" ]]; then
    delKDepl "$namespace" "$selected_deployment"
  else
    echo "No deployment selected."
    return 1
  fi
}
