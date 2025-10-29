#!/usr/bin/env zsh

# Kubernetes service preview for FZF
# Usage: k8s-service.zsh <service-line> [namespace]

source "${0:h}/_helpers.zsh"

local service_line="$1"
local namespace="${2:-default}"

if [[ -z "$service_line" ]]; then
  echo "❌ No service specified"
  exit 1
fi

local service_name=$(echo "$service_line" | awk '{print $1}')

if [[ -z "$service_name" ]]; then
  echo "❌ Could not extract service name from: $service_line"
  exit 1
fi

_preview_header "🌐" "Service: $service_name"
_preview_kv "📦" "Namespace: $namespace"
echo ""

# Service details
_preview_header "📊" "Service Info:"
kubectl get service "$service_name" -n "$namespace" -o wide 2>/dev/null || echo "Could not fetch service info"
echo ""

# Endpoints
_preview_header "🎯" "Endpoints:"
kubectl get endpoints "$service_name" -n "$namespace" -o custom-columns=ADDRESSES:.subsets[*].addresses[*].ip,PORTS:.subsets[*].ports[*].port --no-headers 2>/dev/null | sed 's/^/  /' || echo "  No endpoints available"
echo ""

# Associated pods
_preview_header "📦" "Associated Pods:"
local selector=$(kubectl get service "$service_name" -n "$namespace" -o jsonpath='{.spec.selector}' 2>/dev/null)
if [[ -n "$selector" && "$selector" != "{}" ]]; then
  kubectl get pods -n "$namespace" --selector="$(echo "$selector" | jq -r 'to_entries | map("\(.key)=\(.value)") | join(",")')" -o custom-columns=NAME:.metadata.name,STATUS:.status.phase --no-headers 2>/dev/null | sed 's/^/  /' || echo "  Could not find associated pods"
else
  echo "  No selector found"
fi
