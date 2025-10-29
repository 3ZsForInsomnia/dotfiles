#!/usr/bin/env zsh

# Kubernetes pod preview for FZF
# Usage: k8s-pod.zsh <pod-line> [namespace]

source "${0:h}/_helpers.zsh"

local pod_line="$1"
local namespace="${2:-default}"

if [[ -z "$pod_line" ]]; then
  echo "❌ No pod specified"
  exit 1
fi

local pod_name=$(echo "$pod_line" | awk '{print $1}')

if [[ -z "$pod_name" ]]; then
  echo "❌ Could not extract pod name from: $pod_line"
  exit 1
fi

_preview_header "🔍" "Pod: $pod_name"
_preview_kv "📦" "Namespace: $namespace"
echo ""

# Pod status
_preview_header "📊" "Status:"
kubectl get pod "$pod_name" -n "$namespace" -o wide 2>/dev/null || echo "Could not fetch pod status"
echo ""

# Container info
_preview_header "📦" "Containers:"
kubectl get pod "$pod_name" -n "$namespace" -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | tr ' ' '\n' | sed 's/^/  - /' || echo "Could not fetch container info"
echo ""

# Recent events
_preview_header "📋" "Recent Events:"
kubectl get events -n "$namespace" --field-selector involvedObject.name="$pod_name" --sort-by='.lastTimestamp' -o custom-columns=TYPE:.type,REASON:.reason,MESSAGE:.message --no-headers 2>/dev/null | tail -5 | sed 's/^/  /' || echo "  No recent events"
echo ""

# Resource usage (if metrics available)
_preview_header "💾" "Resource Usage:"
kubectl top pod "$pod_name" -n "$namespace" 2>/dev/null | tail -1 | sed 's/^/  /' || echo "  Metrics not available"
