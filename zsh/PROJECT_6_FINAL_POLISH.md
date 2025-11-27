# Project 6: Final Polish & Architectural Review

This document outlines the final, open-ended project to be undertaken after the first five projects are complete. Its purpose is to address remaining technical debt, perform a holistic architectural review, and optimize overall shell performance.

## 1. Core Philosophy

Continuous improvement is key to a healthy codebase, and a Zsh configuration is no different. This project provides a dedicated space to step back, review the entire system, and make cross-cutting changes that don't fit neatly into the other projects.

## 2. Key Areas of Focus

This project will be guided by the following areas of investigation:

### 2.1. Architectural Review
- **Goal:** Ensure the overall structure of the Zsh configuration is logical, consistent, and maintainable.
- **Action Items:**
  - [ ] **Review Folder Structure:**
    - Re-evaluate the purpose of the `aliases/` directory. Since it contains functions as well as aliases, should it be renamed to something more generic like `functions/` or `core/`?
    - Are there other directories that could be better organized?
  - [ ] **Sourced Files vs. Executables:**
    - Review scripts in the `tools/` directory and elsewhere.
    - Should some sourced Zsh functions that act like standalone tools be converted into executable scripts (with a shebang and placed on the `$PATH`)?
    - Conversely, should some simple executable scripts be converted to sourced functions to improve performance?
  - [ ] **Review `gprune` as a Plugin Candidate:**
    - The `gprune` function is a complex, multi-dependency tool (git, gh, jq, fzf) with its own helpers and preview scripts.
    - Evaluate if it (and other similar complex functions) should be converted into a self-contained, formal Zsh plugin for better isolation and portability.
  - [ ] **Review Naming Conventions:**
    - Ensure consistency in function, alias, and file naming across the entire configuration.

### 2.2. Performance Optimization
- **Goal:** Identify and eliminate performance bottlenecks in both shell startup and interactive use.
- **Action Items:**
  - [ ] **Startup Profiling:**
    - Use `zprof` or `time (zsh -i -c exit)` to formally profile the shell startup time.
    - Analyze the output to identify the slowest parts of the loading process.
  - [ ] **Runtime Performance:**
    - Investigate the performance of frequently used functions and aliases.
    - Identify any commands that cause noticeable lag during interactive sessions.
  - [ ] **Review Lazy-Loading Strategy:**
    - Evaluate the existing `zsh-defer` and custom lazy-loading implementations.
    - Are there more opportunities to defer loading of non-essential components?
    - Can any tools be loaded conditionally based on the current directory or the presence of certain files (e.g., `package.json`, `go.mod`)?

### 2.3. Code Cleanup and Debt Reduction
- **Goal:** Address any remaining "code smells," inconsistencies, or outdated patterns.
- **Action Items:**
  - [ ] **Consolidate Helper Functions:** Search for any duplicated helper functions that were missed during the initial refactoring projects.
  - [ ] **Review Deprecated Patterns:** Look for any outdated Zsh practices or functions that could be updated.
  - [ ] **Improve Commenting and Documentation:** Ensure that complex or non-obvious code is adequately explained.

## 3. Getting Started

This project is intended to be a living document. As new ideas for improvement arise during the other projects, they should be added here for future consideration.

## Other ideas

Zsh completions for npm scripts
Auto-load .env files at current directory
- Need to walk "up the directory tree", at least until a .git folder is found
- Limit which folders can activate this
