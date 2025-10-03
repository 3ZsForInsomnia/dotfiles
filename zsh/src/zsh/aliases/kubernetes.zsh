# Load FZF helpers for preview functions
if [[ -f "$ZSH_CONFIG_DIR/tools/fzf-helpers.zsh" ]]; then
  source "$ZSH_CONFIG_DIR/tools/fzf-helpers.zsh"
fi

alias k="kubectl"
alias kpf="k port-forward"

# Basic Service/Env/Namespace functions
# ------------------------------------------------------------------------------
function get_pods_by_namespace {
  local service=$1
  local env=$2

  namespace=$(get_namespace_for "$service" "$env")

  # Get the list of pod names in the namespace
  kubectl get pods -n "$namespace" -o custom-columns=NAME:.metadata.name --no-headers 2>/dev/null
}

alias get_pods="k get po -n "

# Function to get the most recent pod based on version
function get_latest_pod {
  local service=$1
  local env=$2

  namespace=$(get_namespace_for "$service" "$env")
  local app_prefix="sql-patch"

  # Get all matching pods
  pods=$(get_pods_by_namespace "$service" "$env")

  if [[ -z "$pods" ]]; then
      echo "No pods found with the prefix '${app_prefix}' in the namespace '${namespace}'"
      return 1
  fi

  # Sort by version and get the latest pod
  latest_pod=$(echo "$pods" | awk -F '-' '{print $3, $0}' | sort -t. -k1,1nr -k2,2nr -k3,3nr | head -n 1 | cut -d' ' -f2)

  # Remove any `<stdin>` from output if present
  clean_pod=$(echo "$latest_pod" | sed 's/^<stdin>:.*://g')

  # Print the cleaned result
  echo "$clean_pod"
}

function view_kpod_logs() {
  local service="$1"
  local env="$2"
  local pod="$3"
  local container="$4"
  local follow=${5:-false}

  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$pod" ]]; then
    # Get pod using fzf
    echo "Fetching pods in namespace: $namespace"
    pod=$(fkp "$namespace")
    if [[ -z "$pod" ]]; then
      return 1
    fi
  fi

  if [[ -z "$container" ]]; then
    containers=$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[*].name}')
    if [[ $(echo "$containers" | wc -w) -gt 1 ]]; then
      container=$(echo "$containers" | tr ' ' '\n' | fzf --height=40% --border --prompt="Select Container: ")
      if [[ -z "$container" ]]; then
        echo "No container selected."
        return 1
      fi
    fi
  fi
  
  echo "Viewing logs for pod $pod ${container:+container $container} in namespace $namespace"
  
  if [[ "$follow" == "true" ]]; then
    if [[ -n "$container" ]]; then
      kubectl logs -n "$namespace" "$pod" -c "$container" -f
    else
      kubectl logs -n "$namespace" "$pod" -f
    fi
  else
    if [[ -n "$container" ]]; then
      kubectl logs -n "$namespace" "$pod" -c "$container"
    else
      kubectl logs -n "$namespace" "$pod"
    fi
  fi
  
  # Build kubectl logs command
  local log_cmd="kubectl logs -n $namespace $pod"
  if [[ -n "$container" ]]; then
    log_cmd="$log_cmd -c $container"
  fi
  if [[ "$follow" == true ]]; then
    log_cmd="$log_cmd -f"
  fi  
  if [[ -n "$tail_lines" ]]; then
    log_cmd="$log_cmd --tail=$tail_lines"
  fi
  
  # Display info
  echo "📋 Viewing logs for: $pod"
  if [[ -n "$container" ]]; then
    echo "📦 Container: $container"
  fi
  echo "📍 Namespace: $namespace"
  if [[ -n "$service" && -n "$env" ]]; then
    echo "🏷️  Service: $service (env: $env)"
  fi
  if [[ "$follow" == true ]]; then
    echo "🔄 Streaming logs (press Ctrl+C to exit)"
  fi
  echo ""
  
  # Execute logs command
  eval "$log_cmd"
}

function get_latest_version_row() {
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

function view_kpod_log_latest() {
  local service="$1"
  local env="$2"
  
  namespace=$(get_namespace_for "$service" "$env")
  echo "Fetching logs for the latest pod in namespace: $namespace"
  
  output=$(get_pods_by_namespace "$service" "$env")
  pods=("${(@f)$(echo "$output")}")

  latest_pod=$(get_latest_version_row "${pods[@]}")

  k logs -n "$namespace" "$latest_pod"
}

# Deployment Management
# ------------------------------------------------------------------------------
function getKDepls() {
  local service=$1
  local env=$2

  namespace=$(get_namespace_for "$service" "$env")

  k get deployments -n "$namespace"
}

function delKDepl() {
  local service=$1
  local env=$2
  local deployment=$3

  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$deployment" ]]; then
    deployment=$(fkd "$namespace")
    if [[ -z "$deployment" ]]; then
      return 1
    fi
  fi

  echo "You are about to delete deployment: $deployment in namespace $namespace"
  echo -n "Are you sure? (y/N) "
  read confirm
  
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    k delete deployment "$deployment" -n "$namespace"
    echo "Deployment $deployment deleted"
  else
    echo "Operation canceled"
  fi
}

function findAndDelKDepl() {
  local service=$1
  local env=$2

  namespace=$(get_namespace_for "$service" "$env")
  selected_deployment=$(fkd "$namespace")

  if [[ -n "$selected_deployment" ]]; then
    echo "Deleting deployment: $selected_deployment"
    delKDepl "$service" "$env" "$selected_deployment"
  else
    echo "No deployment selected."
    return 1
  fi
}

function getKPodStatus() {
  local service=$1
  local env=$2
  local pod=$3
  local container=$4

  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$pod" ]]; then
    echo "🔍 Select pod for logs:"
    pod=$(fkp "$namespace")
    if [[ -z "$pod" ]]; then
      return 1
    fi
  fi

  k get po -n "$namespace" | grep "$pod"
  k describe pod "$pod" -n "$namespace" | grep -A 5 "Conditions:"
}

function restartKPod() {
  local service=$1
  local env=$2
  local pod=$3

  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$pod" ]]; then
    pod=$(fkp "$namespace")
    if [[ -z "$pod" ]]; then
      return 1
    fi
  fi
  
  echo "This will delete the pod and let Kubernetes recreate it"
  echo -n "Continue with pod $pod? (y/N) "
  read confirm
  
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    kubectl delete pod "$pod" -n "$namespace"
    echo "Pod $pod deleted, waiting for recreation..."
    sleep 2
    kubectl get pod -n "$namespace" | grep $(echo "$pod" | cut -d'-' -f1-2)
  else
    echo "Operation canceled"
  fi
}

# Namespace/Context Management
# ------------------------------------------------------------------------------
function kns() {
  # Switch to namespace (service/env aware)
  local service=$1
  local env=$2
  
  if [[ -n "$service" && -n "$env" ]]; then
    namespace=$(get_namespace_for "$service" "$env")
    kubectl config set-context --current --namespace="$namespace"
    echo "✅ Switched to namespace: $namespace (service: $service, env: $env)"
  else
    local ns=$(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers | fzf --height=40% --border --prompt="Switch to Namespace: ")
    if [[ -n "$ns" ]]; then
      kubectl config set-context --current --namespace="$ns"
      echo "✅ Switched to namespace: $ns"
    else
      echo "No namespace selected."
    fi
  fi
}

# Service/Pod Shell Access
# ------------------------------------------------------------------------------
function kpsh() {
  # Interactive shell into pod (service/env aware)
  local service=$1
  local env=$2
  local pod=$3
  
  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$pod" ]]; then
    pod=$(fkp "$namespace")
    if [[ -z "$pod" ]]; then
      return 1
    fi
  fi
  
  if [[ -z "$container" ]]; then
    local containers=$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[*].name}')
    
    if [[ $(echo "$containers" | wc -w) -gt 1 ]]; then
      echo "🔍 Multiple containers found, select one:"
      container=$(echo "$containers" | tr ' ' '\n' | 
        fzf $(fzf_select_opts) --prompt="Select Container: ")
      if [[ -z "$container" ]]; then
        echo "❌ No container selected."
        return 1
      fi
    fi
    echo "Starting shell in pod $pod, container $container..."
    kubectl exec -it -n "$namespace" "$pod" -c "$container" -- sh -c "bash || ash || sh"
  else
    echo "Starting shell in pod $pod..."
    kubectl exec -it -n "$namespace" "$pod" -- sh -c "bash || ash || sh"
  fi
}

# Deployment Management
# ------------------------------------------------------------------------------
function kdrst() {
  # Restart deployment (service/env aware)
  local service=$1
  local env=$2
  local deployment=$3
  
  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$deployment" ]]; then
    deployment=$(fkd "$namespace")
    if [[ -z "$deployment" ]]; then
      return 1
    fi
  fi
  
  echo "Restarting deployment: $deployment in namespace $namespace"
  kubectl rollout restart deployment "$deployment" -n "$namespace"
  
  echo "Checking rollout status (Ctrl+C to exit)..."
  kubectl rollout status deployment "$deployment" -n "$namespace"
}

function kdscale() {
  # Scale deployment (service/env aware)
  local service=$1
  local env=$2
  local deployment=$3
  
  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$deployment" ]]; then
    deployment=$(fkd "$namespace")
    if [[ -z "$deployment" ]]; then
      return 1
    fi
  fi
  
  local current_replicas=$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.replicas}')
  echo "Deployment: $deployment"
  echo "Current replicas: $current_replicas"
  echo -n "Enter new replica count (0-20): "
  read replicas
  
  if [[ "$replicas" =~ ^[0-9]+$ && $replicas -le 20 ]]; then
    echo "Scaling deployment: $deployment to $replicas replicas in namespace $namespace"
    kubectl scale deployment "$deployment" --replicas="$replicas" -n "$namespace"
    
    echo "Waiting for scaling operation to complete..."
    kubectl rollout status deployment "$deployment" -n "$namespace"
  else
    echo "Invalid input or too many replicas requested (max 20)"
  fi
}

# Service Port Forwarding
# ------------------------------------------------------------------------------
function kspf() {
  # Port forward to service (service/env aware)
  local service=$1
  local env=$2
  local k8s_service=$3
  
  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$k8s_service" ]]; then
    k8s_service=$(fksvc "$namespace")
    if [[ -z "$k8s_service" ]]; then
      return 1
    fi
  fi
  
  # Get available ports from the service
  local ports=$(kubectl get service "$k8s_service" -n "$namespace" -o jsonpath='{.spec.ports[*].port}')
  local port
  
  if [[ $(echo "$ports" | wc -w) -gt 1 ]]; then
    port=$(echo "$ports" | tr ' ' '\n' | fzf --height=40% --border --prompt="Select Service Port: ")
    if [[ -z "$port" ]]; then
      echo "No port selected."
      return 1
    fi
  else
    port=$ports
  fi
  
  echo -n "Local port to use (default $port): "
  read local_port
  local_port=${local_port:-$port}
  
  echo "🔌 Port forwarding $k8s_service:$port to localhost:$local_port"
  echo "   Namespace: $namespace"
  echo "   Service: $service (env: $env)"
  echo "   Press Ctrl+C to stop"
  kubectl port-forward service/"$k8s_service" -n "$namespace" "$local_port:$port"
}

# Secret Viewing
# ------------------------------------------------------------------------------
function ksview() {
  # View Secret contents (service/env aware)
  local service=$1
  local env=$2
  local secret=$3
  
  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$secret" ]]; then
    secret=$(fksecret "$namespace")
    if [[ -z "$secret" ]]; then
      return 1
    fi
  fi
  
  echo "Secret: $secret"
  echo "Namespace: $namespace"
  echo "Service: $service (env: $env)"
  echo "-------------"
  
  # Try to use yq for better formatting if available
  if command -v yq >/dev/null 2>&1; then
    kubectl get secret "$secret" -n "$namespace" -o yaml | yq e '.data | map_values(@base64d)' - | less
  else
    # Fallback to manual decoding
    kubectl get secret "$secret" -n "$namespace" -o jsonpath='{.data}' | 
      sed 's/:/\n/g' | 
      sed 's/{//g' | 
      sed 's/}//g' | 
      sed 's/"//g' | 
      sed 's/,/\n/g' | 
      while read line; do
        if [[ "$line" =~ ^[a-zA-Z0-9_-]+$ ]]; then
          key=$line
        else
          echo "$key: $(echo $line | base64 --decode)"
        fi
      done | less
  fi
}

# Pod Health Checking
# ------------------------------------------------------------------------------
function kpods_check() {
  # Check for problematic pods (service/env aware)
  local service=$1
  local env=$2
  
  namespace=$(get_namespace_for "$service" "$env")
  
  echo "Checking pods in namespace: $namespace"
  echo "Service: $service (env: $env)"
  
  kubectl get pods -n "$namespace" -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,RESTARTS:.status.containerStatuses[0].restartCount,AGE:.metadata.creationTimestamp | 
    awk 'NR>1 && ($2!="Running" || $3>0) {print $0}' | 
    (grep -v '^$' || echo "All pods are healthy!")
}

# Namespace Functions with FZF
# ------------------------------------------------------------------------------
function fkns() {
  # Interactive namespace selection
  local ns=$(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers | fzf --height=40% --border --prompt="Select Namespace: ")
  if [[ -n "$ns" ]]; then
    echo "$ns" | copy
    echo "$ns"
  fi
}

# Context Functions with FZF
# ------------------------------------------------------------------------------
function fkctx() {
  # Interactive context selection
  local ctx=$(kubectl config get-contexts -o name | fzf --height=40% --border --prompt="Select Context: ")
  if [[ -n "$ctx" ]]; then
    echo "$ctx" | copy
    echo "$ctx"
  fi
}

function kctx() {
  # Switch to context
  local ctx=$(kubectl config get-contexts -o name | fzf --height=40% --border --prompt="Switch to Context: ")
  if [[ -n "$ctx" ]]; then
    kubectl config use-context "$ctx"
    echo "Switched to context: $ctx"
  fi
}

# Pod Functions with FZF
# ------------------------------------------------------------------------------
function fkp() {
 if [[ "$1" == "-h" ]]; then
   echo "Usage: fkp [service] [env] | fkp [namespace]"
   echo "Interactive pod selection with enhanced preview"
   echo "Shows pod status, events, and resource usage"
   echo ""
   echo "FZF Key Bindings:"
   echo "  Enter     - Select pod (copy to clipboard)"
   echo "  Ctrl-S    - Show detailed pod description"
   echo "  Ctrl-L    - View pod logs"
   echo "  Ctrl-E    - Shell into pod"
   echo "  Ctrl-R    - Restart pod (delete to trigger restart)"
   echo "  Alt-P     - Toggle preview"
   echo "  Ctrl-C    - Cancel"
   return 0
 fi

  # Interactive pod selection
  local service=$1
  local env=$2
  local namespace
  
  if [[ -n "$service" && -n "$env" ]]; then
    namespace=$(get_namespace_for "$service" "$env")
  else
    namespace=${1:-$(kubectl config view --minify -o jsonpath='{..namespace}')}
  fi
  
  if [[ -z "$namespace" ]]; then
    namespace=$(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers | 
      fzf $(fzf_select_opts) --prompt="Select Namespace: ")
    if [[ -z "$namespace" ]]; then
      echo "No namespace selected."
      return 1
    fi
  fi
  
 echo "🔍 Fetching pods in namespace: $namespace"
 
  # Get pod list without headers and use fzf to select
  local pod_line
  pod_line=$(kubectl get pods -n "$namespace" \
    -o "custom-columns=NAME:.metadata.name,STATUS:.status.phase,RESTARTS:.status.containerStatuses[0].restartCount,AGE:.metadata.creationTimestamp" \
    --no-headers --sort-by=.metadata.creationTimestamp | \
    fzf $(fzf_git_opts) \
        --preview="$ZSH_CONFIG_DIR/tools/k8s-preview-wrapper.zsh _fzf_k8s_pod_preview {} $namespace" \
        --bind="ctrl-l:execute(kubectl logs -n $namespace {1} -f)" \
        --bind="ctrl-e:execute(kubectl exec -it -n $namespace {1} -- /bin/bash || kubectl exec -it -n $namespace {1} -- /bin/sh)" \
        --bind="ctrl-r:execute(kubectl delete pod -n $namespace {1})" \
        --bind="ctrl-s:execute($ZSH_CONFIG_DIR/tools/k8s-preview-wrapper.zsh _fzf_k8s_pod_inspect {} $namespace)" \
        --header="Enter=select, Ctrl-L=logs, Ctrl-E=shell, Ctrl-R=restart, Ctrl-S=describe")
  
  if [[ -n "$pod_line" ]]; then
    # Extract just the pod name (first column)
    local pod_name=$(echo "$pod_line" | awk '{print $1}')
    echo "$pod_name" | pbcopy
    echo "✅ Selected pod: $pod_name (copied to clipboard)"
    echo "$pod_name"
    return 0
  else
    echo "❌ No pod selected."
    return 1
  fi
}

function kplogs() {
 if [[ "$1" == "-h" ]]; then
   echo "Usage: kplogs [service] [env] [pod] [container]"
   echo "Interactive pod logs viewer with streaming support"
   echo ""  
   echo "Options:"
   echo "  -f, --follow    Follow logs (stream)"
   echo "  --tail N        Show last N lines"
   echo ""
   echo "Examples:"
   echo "  kplogs                    # Interactive pod selection"
   echo "  kplogs myservice prod     # Select pod from service/env"
   echo "  kplogs -f                 # Stream logs"
   return 0
 fi

  # Interactive pod logs viewer (service/env aware)
 local follow=false
 local tail_lines=""
 
 # Parse flags
 while [[ $# -gt 0 ]]; do
   case "$1" in
     -f|--follow)
       follow=true
       shift
       ;;
     --tail)
       tail_lines="$2"
       shift 2
       ;;
     *)
       break
       ;;
   esac
 done
 
  local service=$1
  local env=$2
  local pod=$3
  
  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$pod" ]]; then
    pod=$(fkp "$namespace")
    if [[ -z "$pod" ]]; then
      return 1
    fi
  fi
  
  local containers=$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[*].name}')
  local container
  
  if [[ $(echo "$containers" | wc -w) -gt 1 ]]; then
    container=$(echo "$containers" | tr ' ' '\n' | fzf --height=40% --border --prompt="Select Container: ")
    if [[ -z "$container" ]]; then
      echo "No container selected."
      return 1
    fi
  fi
}

### Service Functions with FZF

function fks() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: fks [namespace]"
    echo "Interactive service browser with enhanced preview"
    echo "Shows service details, endpoints, and associated pods"
    echo ""
    echo "FZF Key Bindings:"
    echo "  Enter     - Select service (copy to clipboard)"
    echo "  Ctrl-S    - Show detailed service description"
    echo "  Ctrl-P    - Port-forward to service"
    echo "  Ctrl-E    - Show endpoints"
    echo "  Alt-P     - Toggle preview"
    echo "  Ctrl-C    - Cancel"
    return 0
  fi

  local namespace=${1:-$(kubectl config view --minify -o jsonpath='{..namespace}')}
  
  if [[ -z "$namespace" ]]; then
    namespace=$(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers | 
      fzf $(fzf_select_opts) --prompt="Select Namespace: ")
    if [[ -z "$namespace" ]]; then
      echo "❌ No namespace selected."
      return 1
    fi
  fi
  
  echo "🔍 Fetching services in namespace: $namespace"
  
  # Get service list
  local service_line
  service_line=$(kubectl get services -n "$namespace" \
    -o "custom-columns=NAME:.metadata.name,TYPE:.spec.type,CLUSTER-IP:.spec.clusterIP,EXTERNAL-IP:.status.loadBalancer.ingress[0].ip,PORTS:.spec.ports[*].port" \
    --no-headers | \
    fzf $(fzf_git_opts) \
        --preview="$ZSH_CONFIG_DIR/tools/k8s-preview-wrapper.zsh _fzf_k8s_service_preview {} $namespace" \
        --bind="ctrl-p:execute(echo 'Port-forward: kubectl port-forward -n $namespace service/{1} LOCAL_PORT:SERVICE_PORT')" \
        --bind="ctrl-e:execute(kubectl get endpoints -n $namespace {1})" \
        --bind="ctrl-s:execute($ZSH_CONFIG_DIR/tools/k8s-preview-wrapper.zsh _fzf_k8s_service_inspect {} $namespace)" \
        --header="Enter=select, Ctrl-P=port-forward info, Ctrl-E=endpoints, Ctrl-S=describe")
  
  if [[ -n "$service_line" ]]; then
    local service_name=$(echo "$service_line" | awk '{print $1}')
    echo "$service_name" | pbcopy
    echo "✅ Selected service: $service_name (copied to clipboard)"
    echo "$service_name"
    return 0
  else
    echo "❌ No service selected."
    return 1
  fi
}

# Deployment Functions with FZF
# ------------------------------------------------------------------------------
function fkd() {
  # Interactive deployment selection
  local service=$1
  local env=$2
  local namespace
  
  if [[ -n "$service" && -n "$env" ]]; then
    namespace=$(get_namespace_for "$service" "$env")
  else
    namespace=${1:-$(kubectl config view --minify -o jsonpath='{..namespace}')}
  fi
  
  if [[ -z "$namespace" ]]; then
    namespace=$(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers | fzf --height=40% --border --prompt="Select Namespace: ")
    if [[ -z "$namespace" ]]; then
      echo "No namespace selected."
      return 1
    fi
  fi
  
  local depl_line=$(kubectl get deployments -n "$namespace" -o "custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,UP-TO-DATE:.status.updatedReplicas,AVAILABLE:.status.availableReplicas,AGE:.metadata.creationTimestamp" --no-headers | fzf --height=40% --border --prompt="Select Deployment ($namespace): ")
  
  if [[ -n "$depl_line" ]]; then
    local deployment_name=$(echo "$depl_line" | awk '{print $1}')
    echo "$deployment_name" | copy
    echo "$deployment_name"
    return 0
  else
    echo "No deployment selected."
    return 1
  fi
}

# Service Functions with FZF
# ------------------------------------------------------------------------------
function fksvc() {
  # Interactive service selection
  local service=$1
  local env=$2
  local namespace
  
  if [[ -n "$service" && -n "$env" ]]; then
    namespace=$(get_namespace_for "$service" "$env")
  else
    namespace=${1:-$(kubectl config view --minify -o jsonpath='{..namespace}')}
  fi
  
  if [[ -z "$namespace" ]]; then
    namespace=$(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers | fzf --height=40% --border --prompt="Select Namespace: ")
    if [[ -z "$namespace" ]]; then
      echo "No namespace selected."
      return 1
    fi
  fi
  
  local svc_line=$(kubectl get services -n "$namespace" -o "custom-columns=NAME:.metadata.name,TYPE:.spec.type,CLUSTER-IP:.spec.clusterIP,EXTERNAL-IP:.status.loadBalancer.ingress[0].ip,PORTS:.spec.ports[0].port" --no-headers | fzf --height=40% --border --prompt="Select Service ($namespace): ")
  
  if [[ -n "$svc_line" ]]; then
    local service_name=$(echo "$svc_line" | awk '{print $1}')
    echo "$service_name" | copy
    echo "$service_name"
    return 0
  else
    echo "No service selected."
    return 1
  fi
}

# ConfigMap Functions with FZF
# ------------------------------------------------------------------------------
function fkcm() {
  # Interactive ConfigMap selection
  local service=$1
  local env=$2
  local namespace
  
  if [[ -n "$service" && -n "$env" ]]; then
    namespace=$(get_namespace_for "$service" "$env")
  else
    namespace=${1:-$(kubectl config view --minify -o jsonpath='{..namespace}')}
  fi
  
  if [[ -z "$namespace" ]]; then
    namespace=$(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers | fzf --height=40% --border --prompt="Select Namespace: ")
    if [[ -z "$namespace" ]]; then
      echo "No namespace selected."
      return 1
    fi
  fi
  
  local cm=$(kubectl get configmaps -n "$namespace" -o custom-columns=NAME:.metadata.name,DATA:.data | fzf --height=40% --border --prompt="Select ConfigMap ($namespace): ")
  
  if [[ -n "$cm" ]]; then
    local cm_name=$(echo "$cm" | awk '{print $1}')
    echo "$cm_name" | copy
    echo "$cm_name"
    return 0
  else
    echo "No ConfigMap selected."
    return 1
  fi
}

# Secret Functions with FZF
# ------------------------------------------------------------------------------
function fksecret() {
  # Interactive Secret selection
  local service=$1
  local env=$2
  local namespace
  
  if [[ -n "$service" && -n "$env" ]]; then
    namespace=$(get_namespace_for "$service" "$env")
  else
    namespace=${1:-$(kubectl config view --minify -o jsonpath='{..namespace}')}
  fi
  
  if [[ -z "$namespace" ]]; then
    namespace=$(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers | fzf --height=40% --border --prompt="Select Namespace: ")
    if [[ -z "$namespace" ]]; then
      echo "No namespace selected."
      return 1
    fi
  fi
  
  local secret=$(kubectl get secrets -n "$namespace" -o custom-columns=NAME:.metadata.name,TYPE:.type,DATA:.data | fzf --height=40% --border --prompt="Select Secret ($namespace): ")
  
  if [[ -n "$secret" ]]; then
    local secret_name=$(echo "$secret" | awk '{print $1}')
    echo "$secret_name" | copy
    echo "$secret_name"
    return 0
  else
    echo "No Secret selected."
    return 1
  fi
}

# Job Functions with FZF
# ------------------------------------------------------------------------------
function fkjob() {
  # Interactive Job selection
  local service=$1
  local env=$2
  local namespace
  
  if [[ -n "$service" && -n "$env" ]]; then
    namespace=$(get_namespace_for "$service" "$env")
  else
    namespace=${1:-$(kubectl config view --minify -o jsonpath='{..namespace}')}
  fi
  
  if [[ -z "$namespace" ]]; then
    namespace=$(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers | fzf --height=40% --border --prompt="Select Namespace: ")
    if [[ -z "$namespace" ]]; then
      echo "No namespace selected."
      return 1
    fi
  fi
  
  local job=$(kubectl get jobs -n "$namespace" -o custom-columns=NAME:.metadata.name,COMPLETIONS:.status.succeeded,DURATION:.status.completionTime,AGE:.metadata.creationTimestamp | fzf --height=40% --border --prompt="Select Job ($namespace): ")
  
  if [[ -n "$job" ]]; then
    local job_name=$(echo "$job" | awk '{print $1}')
    echo "$job_name" | copy
    echo "$job_name"
    return 0
  else
    echo "No Job selected."
    return 1
  fi
}

function kjlogs() {
  # View logs for a job
  local service=$1
  local env=$2
  local job=$3
  
  namespace=$(get_namespace_for "$service" "$env")
  
  if [[ -z "$job" ]]; then
    job=$(fkjob "$namespace")
    if [[ -z "$job" ]]; then
      return 1
    fi
  fi
  
  local pod=$(kubectl get pods -n "$namespace" -l job-name="$job" -o custom-columns=NAME:.metadata.name --no-headers | head -1)
  echo "Viewing logs for job $job (pod $pod) in namespace $namespace"
  echo "Service: $service (env: $env)"
  kubectl logs -n "$namespace" "$pod"
}

# Debugging Functions
# ------------------------------------------------------------------------------
function kdesc() {
  # Interactive resource description (service/env aware)
  local service=$1
  local env=$2
  
  namespace=$(get_namespace_for "$service" "$env")
  local resource_type=$(echo -e "pod\ndeployment\nservice\nconfigmap\nsecret\njob\ningress" | fzf --height=40% --border --prompt="Select Resource Type: ")
  
  if [[ -n "$resource_type" ]]; then
    local resource
    case "$resource_type" in
      pod) resource=$(fkp "$namespace") ;;
      deployment) resource=$(fkd "$namespace") ;;
      service) resource=$(fksvc "$namespace") ;;
      configmap) resource=$(fkcm "$namespace") ;;
      secret) resource=$(fksecret "$namespace") ;;
      job) resource=$(fkjob "$namespace") ;;
      ingress) resource=$(kubectl get ingress -n "$namespace" -o custom-columns=NAME:.metadata.name --no-headers | fzf --height=40% --border --prompt="Select Ingress: ") ;;
    esac
    
    if [[ -n "$resource" ]]; then
      echo "Describing $resource_type: $resource"
      echo "Namespace: $namespace"
      echo "Service: $service (env: $env)"
      kubectl describe "$resource_type" "$resource" -n "$namespace" | less
    fi
  fi
}

function kevents() {
  # Show events for namespace (service/env aware)
  local service=$1
  local env=$2
  
  namespace=$(get_namespace_for "$service" "$env")
  
  echo "Events in namespace: $namespace"
  echo "Service: $service (env: $env)"
  kubectl get events -n "$namespace" --sort-by='.lastTimestamp' | less
}

# Utilities
# ------------------------------------------------------------------------------
function kgetall() {
  # Get all resources in a namespace (service/env aware)
  local service=$1
  local env=$2
  
  namespace=$(get_namespace_for "$service" "$env")
  
  echo "All resources in namespace: $namespace"
  echo "Service: $service (env: $env)"
  kubectl get all -n "$namespace"
}

function kwho_am_i() {
  # Show current kubernetes context and user info
  local ctx=$(kubectl config current-context)
  local user=$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$ctx\")].context.user}")
  local ns=$(kubectl config view --minify -o jsonpath='{..namespace}')
  
  echo "Context: $ctx"
  echo "User: $user"
  echo "Namespace: ${ns:-default}"
  echo "Server: $(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$ctx\")].context.cluster}")\")].cluster.server}")"
}

function kubeForwardPorts() {
  local namespace=$1
  local service=$2
  shift 2
  
  cmd="kpf -n $namespace $service $*"
  eval "$cmd"
}

function kfwd() {
  local app=$1
  local env=$2

  local namespace=$(get_namespace_for "$app" "$env")
  local service=$(get_service_for "$app" "$env")
  local ports=$(get_port_for "$app" "$env")

  cmd="kubeForwardPorts $namespace $service $ports"
  eval "$cmd"
}

# Help function
# ------------------------------------------------------------------------------
function khelp() {
  echo "================= Kubernetes Helper Functions ================="
  echo ""
  echo "USAGE PATTERN: Most commands accept <service> and <env> as parameters"
  echo "               to automatically determine the namespace."
  echo ""
  echo "Pod Management:"
  echo "  fkp <service> <env>        - Find and select a pod"
  echo "  kpsh <service> <env>       - Shell into a pod"
  echo "  kplogs <service> <env>     - View pod logs"
  echo "  restartKPod <service> <env>- Restart a pod"
  echo "  getKPodStatus <service> <env> - Get pod status"
  echo ""
  echo "Deployment Management:"
  echo "  fkd <service> <env>        - Find and select a deployment"
  echo "  kdrst <service> <env>      - Restart a deployment"
  echo "  kdscale <service> <env>    - Scale a deployment"
  echo "  delKDepl <service> <env>   - Delete a deployment"
  echo "  findAndDelKDepl <service> <env> - Find and delete deployments"
  echo "  getKDepls <service> <env>  - List deployments"
  echo ""
  echo "Service Management:"
  echo "  fksvc <service> <env>      - Find and select a service"
  echo "  kspf <service> <env>       - Port forward to a service"
  echo ""
  echo "Context/Namespace:"
  echo "  fkns                       - Find and copy namespace name"
  echo "  kns <service> <env>        - Switch to a namespace"
  echo "  fkctx                      - Find and copy context name" 
  echo "  kctx                       - Switch to a context"
  echo "  kwho_am_i                  - Show current k8s context info"
  echo ""
  echo "ConfigMaps and Secrets:"
  echo "  fkcm <service> <env>       - Find and select a ConfigMap"
  echo "  fksecret <service> <env>   - Find and select a Secret"
  echo "  ksview <service> <env>     - View Secret contents"
  echo ""
  echo "Jobs:"
  echo "  fkjob <service> <env>      - Find and select a Job"
  echo "  kjlogs <service> <env>     - View logs for a Job"
  echo ""
  echo "Utilities:"
  echo "  kdesc <service> <env>      - Describe a resource"
  echo "  kevents <service> <env>    - Show events in a namespace"
  echo "  kgetall <service> <env>    - Get all resources in a namespace"
  echo "  kpods_check <service> <env>- Check for problematic pods"
  echo ""
  echo "Example: kplogs my-service dev"
  echo ""
}

# Initialize kubernetes completion cache integration
# This integrates cache updates with context switching functions
if [[ -f "$ZSH_CONFIG_DIR/completions/_kube_integration" ]]; then
  source "$ZSH_CONFIG_DIR/completions/_kube_integration"
fi
