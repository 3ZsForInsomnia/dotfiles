#!/usr/bin/env zsh

# Docker utility functions
# Reusable functions for Docker operations

# Get running Docker containers
# Output format: "container_name" one per line
getDockerRunningContainers() {
  if ! command -v docker >/dev/null 2>&1; then
    return 1
  fi
  
  docker ps --format '{{.Names}}' 2>/dev/null
}

# Get all Docker containers (running and stopped)
# Output format: "container_name" one per line
getDockerAllContainers() {
  if ! command -v docker >/dev/null 2>&1; then
    return 1
  fi
  
  docker ps -a --format '{{.Names}}' 2>/dev/null
}

# Get Docker images
# Output format: "repository:tag" one per line (excluding <none>)
getDockerImages() {
  if ! command -v docker >/dev/null 2>&1; then
    return 1
  fi
  
  docker images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null | grep -v '<none>'
}

# Get Docker networks
# Output format: "network_name" one per line
getDockerNetworks() {
  if ! command -v docker >/dev/null 2>&1; then
    return 1
  fi
  
  docker network ls --format '{{.Name}}' 2>/dev/null
}

# Get Docker volumes
# Output format: "volume_name" one per line
getDockerVolumes() {
  if ! command -v docker >/dev/null 2>&1; then
    return 1
  fi
  
  docker volume ls --format '{{.Name}}' 2>/dev/null
}
