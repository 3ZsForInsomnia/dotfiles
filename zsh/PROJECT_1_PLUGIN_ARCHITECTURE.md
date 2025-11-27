# Project 1: Zsh Plugin & Loading Architecture

This document outlines the project to formalize and refine the existing system for loading Zsh plugins and custom configurations.

## 1. Core Philosophy

After evaluation, the decision is to **avoid a formal Zsh plugin manager** (like Zinit or Antigen). The current manual, performance-conscious approach provides maximum control and already incorporates advanced techniques like lazy-loading and compilation.

This project is **not** about refactoring all internal code into a "plugin-like" format. A "plugin" is defined as a third-party tool, typically managed as a git submodule. Our internal code will continue to be organized by feature in dedicated folders (`completions/`, `previews/`, `utils/`, etc.), as this structure is more cohesive and better supports context-aware lazy loading.

The goal is to **document and streamline the existing manual loading system**.

## 2. Project Goals

### 2.1. Document the Loading System
- Create a definitive guide explaining how the Zsh configuration is bootstrapped and loaded.
- Explain the role of key files and directories:
  - `zshrc` (entry point)
  - `source-things.zsh` (main sourcing logic)
  - `zsh-defer` (lazy-loading mechanism)
  - `compile-large-files.zsh` (`.zwc` compilation)
  - `aliases/`, `completions/`, `previews/`, `tools/`, `utils/` (directory roles)

### 2.2. Standardize Plugin Loading
- Define a single, consistent pattern for loading all third-party plugins (git submodules).
- This pattern should integrate with `zsh-defer` for lazy loading wherever possible.
- Create a dedicated file (e.g., `zsh/src/zsh/plugins.zsh`) that manages the sourcing of all external plugins, making it easy to see what's installed.

### 2.3. Review and Optimize Loading
- Analyze the current load order to identify any potential improvements.
- Ensure that `fpath` is configured correctly and early.
- Verify that `compinit` is called only once, after all completion paths have been added.
- Evaluate if any startup-blocking commands can be deferred or loaded lazily based on context (e.g., loading `nvm` tools only when in a JavaScript project directory).

## 3. Action Plan

- [ ] **Step 1: Create `plugins.zsh`**
  - Identify all current third-party plugins.
  - Move their `source` lines from various files into a single `zsh/src/zsh/plugins.zsh` file.
  - Document the purpose of each plugin in the comments.

- [ ] **Step 2: Refine Loading Logic**
  - Review `source-things.zsh` to ensure `plugins.zsh` is sourced at the appropriate time.
  - Confirm that `zsh-defer` is used for plugins that support it.

- [ ] **Step 3: Create System Documentation**
  - Write a `README.md` at the root of the `zsh/` directory explaining the architecture.
  - This document will serve as the guide for future modifications to the Zsh setup.
