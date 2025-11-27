# Project 5: Zsh Help System (`zh`)

This document outlines the project to consolidate, enhance, and expand the shell's built-in help system.

## 1. Core Philosophy

The goal is to create a single, powerful, and user-friendly help system that serves as the primary source of truth for discovering and understanding all custom aliases and functions.

The existing `zh` system will be the foundation, as it already supports both aliases and functions. The more complex `zhelp` system will be deprecated and its features migrated into `zh`.

## 2. Project Goals

This project is divided into two main initiatives:
1.  **Enhance `zh`:** Evolve the command-line tool into a more robust and maintainable system.
2.  **Create `zhi`:** Build a new, interactive FZF-based interface for browsing help.

### 2.1. `zh` Enhancement Plan
- **Goal:** Make `zh` the primary, feature-complete help command.
- **Action Items:**
  - [ ] **Modularize the code:** Break the single `zh.zsh` file into a more maintainable structure, similar to the `zhelp` model:
    - `zh-parser.zsh`: Logic for parsing source files to find functions, aliases, and comments.
    - `zh-cache.zsh`: Cache generation and management.
    - `zh-completion.zsh`: Advanced tab-completion logic.
  - [ ] **Improve Tab Completion:** Port the more sophisticated completion logic from `zhelp` to provide richer suggestions.
  - [ ] **Deprecate `zhelp`:** Once all features are migrated, remove the `zhelp` system entirely to eliminate redundancy.

### 2.2. `zhi` (Interactive Help) Plan
- **Goal:** Create a modern, interactive help browser using FZF.
- **Action Items:**
  - [ ] **Build the FZF Interface (`zhi.zsh`):**
    - Create the main function that uses `zh`'s cache as its data source.
    - Implement real-time search and filtering.
    - Design and implement keybindings for navigation and actions.
  - [ ] **Create the Preview Script (`zhi-preview.zsh`):**
    - Develop a preview script that dynamically generates a rich preview pane for the selected item.
    - **Preview Content:**
      - Function/alias name and type.
      - Source file location.
      - Full `-h` help text or comment block.
      - For aliases, the full command it expands to.
      - For functions, the full source code with syntax highlighting (using `bat`).
      - Associated tags for filtering.
  - [ ] **Keybinding Features for `zhi`:**
    - `Enter`: Copy the command name to the clipboard.
    - `Ctrl-E`: Open the source file in `$EDITOR`.
    - `Ctrl-Y`: Copy the entire function definition or alias expansion.
    - `Ctrl-H`: Show the full help text in a pager like `less`.

## 3. File Structure

The final file structure for the new help system will be located in `zsh/src/zsh/tools/help/`:
```
zsh/src/zsh/tools/help/
├── zh.zsh              # Main CLI interface (wrapper)
├── zh-parser.zsh       # (New) Logic to parse source files
├── zh-cache.zsh        # (New) Cache management
├── zh-completion.zsh   # (New) Tab completion logic
├── zhi.zsh             # (New) Interactive FZF interface
└── zhi-preview.zsh     # (New) Preview script for zhi
```
