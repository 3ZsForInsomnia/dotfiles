#!/usr/bin/env zsh

# Kubernetes utility functions
# Reusable functions for Kubernetes operations

# Get Kubernetes namespaces
# Output format: "namespace_name" one per line
getKubernetesNamespaces() {
  if ! command -v kubectl >/dev/null 2>&1; then
    return 1
  fi
  
  kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n'
}

# Get Kubernetes pods in a namespace
# Usage: getKubernetesPods [namespace]
# Output format: "pod_name" one per line
getKubernetesPods() {
  local namespace="${1:-default}"
  
  if ! command -v kubectl >/dev/null 2>&1; then
    return 1
  fi
  
  kubectl get pods -n "$namespace" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n'
}

# Get Kubernetes services in a namespace
# Usage: getKubernetesServices [namespace]
# Output format: "service_name" one per line
getKubernetesServices() {
  local namespace="${1:-default}"
  
  if ! command -v kubectl >/dev/null 2>&1; then
    return 1
  fi
  
  kubectl get services -n "$namespace" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n'
}

# Get Kubernetes deployments in a namespace
# Usage: getKubernetesDeployments [namespace]
# Output format: "deployment_name" one per line
getKubernetesDeployments() {
  local namespace="${1:-default}"
  
  if ! command -v kubectl >/dev/null 2>&1; then
    return 1
  fi
  
  kubectl get deployments -n "$namespace" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n'
}
