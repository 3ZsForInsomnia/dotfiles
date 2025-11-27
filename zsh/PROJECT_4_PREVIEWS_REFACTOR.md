# Project 4: FZF Previews & Keybindings Refactor

This document outlines the project to refactor all FZF-based functions and their preview scripts to improve consistency, maintainability, and user experience.

## 1. Core Philosophy

The FZF ecosystem is a powerful part of the command line. This project aims to treat it as a first-class citizen by:
1.  **Standardizing User Experience:** Ensuring that all FZF-based tools share a common set of keybindings for a predictable and ergonomic feel.
2.  **Applying DRY Principles:** Refactoring preview scripts to eliminate duplicated code and share logic where possible.
3.  **Establishing Clear Structure:** Defining a home for preview-specific logic versus more general utility functions.

## 2. Architectural Guidelines

- **`zsh/src/zsh/previews/`**: This directory is the home for scripts that are **exclusively for generating FZF preview windows**.
- **`zsh/src/zsh/previews/helpers/`**: This new directory will contain **reusable Zsh functions specific to building previews**. For example, a function to create a standardized header for all previews.
- **`zsh/src/zsh/utils/`**: This directory will house **general-purpose helper functions** that might be used by previews, but also by completions, aliases, or other parts of the system. Logic that fetches data (e.g., `git log`, `gh pr view`) belongs here if it can be used elsewhere.

## 3. Keybinding Standardization

A major goal is to create a consistent set of keybindings across all FZF widgets. The following standard should be applied to all FZF-based functions.

### Standard Keybinding Map:
- **`Enter`**: Primary action (e.g., checkout branch, delete item, copy to clipboard).
- **`Ctrl-S`**: Inspect / Show details (e.g., show full git diff, view full PR).
- **`Ctrl-E`**: Edit (e.g., open the source file in `$EDITOR`).
- **`Ctrl-Y`**: Yank / Copy to clipboard (e.g., copy commit hash, copy branch name).
- **`Ctrl-A`**: Select All.
- **`Ctrl-D`**: Deselect All.
- **`Tab`**: Toggle selection of the current item.
- **`Alt-P` or `Ctrl-P`**: Toggle the preview window visibility.
- **`Esc` / `Ctrl-C` / `Ctrl-Q`**: Cancel / Quit.

## 4. Refactoring Checklist

The core of this project is a systematic review and refactor of all FZF-related functions and their preview scripts.

### 4.1. Immediate Task: `gprune` Preview
- [ ] **Goal:** Update the FZF preview for the `gprune` command.
- [ ] **Requirement:** The preview currently shows the PR details but doesn't explicitly display the associated local branch name. The preview script should be modified to clearly show which local branch will be deleted.

### 4.2. General Refactoring Checklist
The following files and any other FZF-based functions should be reviewed and updated.

**Goal for each item:**
- Refactor the FZF command to use the standard keybinding map.
- Move the preview logic into a dedicated script in `zsh/src/zsh/previews/`.
- Extract any reusable preview-generation logic into `zsh/src/zsh/previews/helpers/`.
- Extract any general data-fetching logic into `zsh/src/zsh/utils/`.

#### Preview Files for Refactoring:
- [ ] `_helpers.zsh`
- [ ] `file.zsh`
- [ ] `git-branch.zsh`
- [ ] `git-commit.zsh`
- [ ] `git-worktree.zsh`
- [ ] `k8s-pod.zsh`
- [ ] `k8s-service.zsh`
- [ ] `process.zsh`
- [ ] `README.md`

#### FZF Functions in `aliases` for Refactoring:
- [ ] `gprune` (in `git/prune.zsh`)
- [ ] `fcom` (in `git/core.zsh`)
- [ ] `fgdiff` (in `git/core.zsh`)
- [ ] `fgsearch` (in `git/core.zsh`)
- [ ] ... and any others found during the project.
