# Project 3: Completions Refactoring

This document outlines the project to refactor the entire Zsh completion system to improve maintainability, performance, and consistency by applying the DRY (Don't Repeat Yourself) principle.

## 1. Core Philosophy

The goal is to evolve the completion system by:
1.  **Extracting Reusable Logic:** Moving shared logic into dedicated helper functions.
2.  **Establishing Clear Structure:** Defining where different types of logic should live.
3.  **Improving Performance:** Integrating the new caching system where appropriate.
4.  **Implementing New Features:** Adding "intelligent" completion features identified during the planning phase.

## 2. Architectural Guidelines

- **`zsh/src/zsh/utils/`**: This directory is for **general-purpose helper functions** that are not specific to completions. They should be written to return raw data and be usable in any part of the Zsh configuration (aliases, previews, etc.).
- **`zsh/src/zsh/completions/helpers/`**: This new directory will house **completion-specific helper functions**. These functions will often wrap calls to `utils` functions and format the output specifically for the Zsh completion system (e.g., using `_describe`).
- **`zsh/src/zsh/aliases/`**: This directory contains many existing functions that are currently used by completions. A key part of this refactor is to **move that logic** into either `utils/` or `completions/helpers/`.

## 3. New Completion Features to Implement

The following new features, identified in our planning sessions, will be implemented as part of this refactor:

- [ ] **Intelligent Git Completions:**
  - **Goal:** Enhance `_git_core` completions for branches and commits.
  - **Implementation:** Modify the completion logic to sort candidates by recency of use.
  - **Note:** FZF-based UI for completions is a separate, future project.

- [ ] **Azure Completions Caching:**
  - **Goal:** Improve performance of Azure CLI completions.
  - **Implementation:** Use the new caching system (`_cache_ctl` from Project 2) within `_azure_functions` to cache the output of `az` commands (e.g., listing VMs, resource groups).

## 4. Refactoring Checklist

The core of this project is a systematic review and refactor of all existing completion files. The goal for each file is to:
- Identify and extract reusable logic into `utils` or `completions/helpers`.
- Move any functional dependencies out of the `aliases` folder.
- Simplify the completion file to be a clean interface to the underlying helpers.
- Apply caching for any slow, dynamic commands.

### Completion Files for Refactoring:

- [ ] `_azure_functions`
- [ ] `_compilation`
- [ ] `_completion_integration`
- [ ] `_config_utils`
- [ ] `_dash_g`
- [ ] `_dates`
- [ ] `_db`
- [ ] `_dev_env_completion`
- [ ] `_devenv_backend`
- [ ] `_devenv_database`
- [ ] `_devenv_frontend`
- [ ] `_devenv_locations`
- [ ] `_devenv_misc`
- [ ] `_devenv_procfiles`
- [ ] `_docker`
- [ ] `_docker_compose`
- [ ] `_docker_functions`
- [ ] `_f`
- [ ] `_file_functions`
- [ ] `_fk`
- [ ] `_fx`
- [ ] `_ghub`
- [ ] `_git_bisect`
- [ ] `_git_branch`
- [ ] `_git_cache_system`
- [ ] `_git_cherry_pick`
- [ ] `_git_completion_integration`
- [ ] `_git_core`
- [ ] `_git_fzf`
- [ ] `_git_fzf_individual`
- [ ] `_git_merge`
- [ ] `_git_prune`
- [ ] `_git_rebase`
- [ ] `_git_stash`
- [ ] `_git_tag_completion`
- [ ] `_git_tags`
- [ ] `_git_worktree`
- [ ] `_golang`
- [ ] `_help`
- [ ] `_jira`
- [ ] `_js_tools`
- [ ] `_kube_cache_system`
- [ ] `_kube_functions`
- [ ] `_kube_integration`
- [ ] `_kube_work_aliases`
- [ ] `_kubernetes`
- [ ] `_kubernetes_fzf_individual`
- [ ] `_ls_aliases`
- [ ] `_lua`
- [ ] `_misc_aliases`
- [ ] `_nvim-update`
- [ ] `_python_tools`
- [ ] `_search_fzf_individual`
- [ ] `_sgpt`
- [ ] `_slack`
- [ ] `_tui_tools`
- [ ] `_utils_functions`
- [ ] `_vectorcode`
- [ ] `_wezterm_aliases`
- [ ] `_work_config`
- [ ] `_work_special`
- [ ] `_work_variables`
- [ ] `helpers` (directory)
- [ ] `test_completions.zsh`
