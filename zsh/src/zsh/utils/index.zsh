#!/usr/bin/env zsh

# Utils Index - Autoload all utility functions
# This file sets up lazy loading for all utils via fpath

# Add utils directory to fpath
fpath+=(${0:h})

# Autoload process utilities
autoload -Uz getRunningProcesses
autoload -Uz getProcessByPort

# Autoload development utilities
autoload -Uz parsePackageJsonScripts

# Autoload project utilities
autoload -Uz findProjectRoot

# Autoload Nx utilities
autoload -Uz findNxWorkspaceRoot
autoload -Uz getNxProjects
autoload -Uz getNxProjectJsonPath
autoload -Uz getNxProjectTargets
autoload -Uz projectHasTarget
autoload -Uz getNxProjectsWithTarget
autoload -Uz getNxProjectInfo

# Autoload Python utilities
autoload -Uz getPyenvVersions
autoload -Uz getPyenvCurrentVersion

# Autoload Docker utilities
autoload -Uz getDockerRunningContainers
autoload -Uz getDockerAllContainers
autoload -Uz getDockerImages
autoload -Uz getDockerNetworks
autoload -Uz getDockerVolumes

# Autoload Kubernetes utilities
autoload -Uz getKubernetesNamespaces
autoload -Uz getKubernetesPods
autoload -Uz getKubernetesServices
autoload -Uz getKubernetesDeployments
