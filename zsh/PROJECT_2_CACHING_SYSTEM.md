# Project 2: Zsh Caching System

This document outlines the project to design and implement a general-purpose caching system for the Zsh environment.

## 1. Core Philosophy

The goal is to create a simple, robust, and performant caching utility to speed up shell operations, particularly dynamic completions and other frequently run commands that produce stable output.

After evaluating external tools like `zsh-smartcache`, the decision is to **build a custom, lightweight caching helper**. This provides a tailored solution without adding external dependencies and allows for fine-grained control over caching behavior.

## 2. System Requirements

The caching system should be:
- **Performant:** Have minimal overhead. Reading from the cache should be significantly faster than executing the original command.
- **Flexible:** Capable of caching the output of any command.
- **Resilient:** A failure in caching one item should not affect others.
- **Configurable:** Allow for different cache durations (Time-to-Live, or TTL) for different items.
- **Transparent:** Easy to inspect and clear the cache for debugging.

## 3. Proposed Architecture

### 3.1. Multi-File Cache Storage
- To avoid a single monolithic and potentially slow cache file, the system will use a **multi-file approach**.
- Each distinct piece of data will be stored in its own file within a dedicated cache directory (e.g., `$ZDOTDIR/cache/` or `~/.cache/zsh/`).
- The filename will be derived from a unique "cache key" or "namespace" provided to the caching function.

### 3.2. The `_cache_ctl` Helper Function
A central helper function, tentatively named `_cache_ctl`, will be the primary interface for all caching operations. It will be placed in `zsh/src/zsh/utils/cache-utils.zsh` and autoloaded.

#### Proposed API:
```zsh
_cache_ctl <namespace> <ttl_minutes> <command_string...>
```
- `<namespace>`: A unique identifier for the cache entry (e.g., `azure_vms`, `git_recent_branches`). This will be used to generate the filename.
- `<ttl_minutes>`: The cache duration in minutes. If the cache file is older than this, it will be regenerated.
- `<command_string...>`: The full command to execute to generate the data if the cache is stale or non-existent.

#### Example Usage (in a completion function):
```zsh
# Get a list of Azure VMs, caching the result for 60 minutes
local vms
vms=(${(f)"$(_cache_ctl 'azure_vms' 60 "az vm list --query '[].name' -o tsv")"})
_describe 'Azure VMs' vms
```

### 3.3. Workflow
1. The `_cache_ctl` function is called with a namespace, TTL, and command.
2. It constructs the cache file path (e.g., `~/.cache/zsh/azure_vms.cache`).
3. It checks if the file exists and if its modification time is within the TTL.
4. **Cache Hit:** If the cache is valid, it `cat`s the file content to stdout and exits.
5. **Cache Miss:** If the cache is invalid or missing, it executes the `<command_string>`, captures its output, writes the output to the cache file, and then also prints the output to stdout.

## 4. Action Plan

- [ ] **Step 1: Implement `_cache_ctl`**
  - Create `zsh/src/zsh/utils/cache-utils.zsh`.
  - Write the `_cache_ctl` function implementing the file-based TTL logic.
  - Ensure it handles arguments and command execution safely.
  - Add comments explaining its usage.

- [ ] **Step 2: Implement Cache Management Functions**
  - Create helper functions for inspecting and managing the cache:
    - `cache_list`: List all current cache files and their age.
    - `cache_clear <namespace>`: Delete a specific cache entry.
    - `cache_clear_all`: Wipe the entire Zsh cache directory.
  - Add completions for these new functions.

- [ ] **Step 3: Integrate into a Pilot Completion**
  - Identify a slow-running completion (e.g., for a cloud CLI tool).
  - Refactor it to use `_cache_ctl` to demonstrate its effectiveness.
  - Benchmark the performance improvement.

- [ ] **Step 4: Document the System**
  - Add comments to the `cache-utils.zsh` file.
  - Update this project document with the final API and usage examples.
