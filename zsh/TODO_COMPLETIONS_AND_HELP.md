# Git Completions & Help System TODO

## Context
- Auditing git alias completions after extracting merge functions into separate file
- Currently at 55%+ context usage, so documenting action items
- User has zsh-syntax-highlighting, zsh-autosuggestions, zsh-autocomplete
- File completions are automatic/default in zsh
- Aliases don't need completions (they expand to underlying commands)

---

## HIGH PRIORITY - Broken/Corrupted Files

### 1. Fix `_git_rebase` completion file
**Status**: ✅ COMPLETE

**Actions**:
- [x] Restructure file with proper function structure
- [x] Remove merge command references from #compdef line
- [x] Remove merge-related case statements from `_git_rebase_complete_args()`
- [x] Verify all braces/blocks are properly closed
- [x] Test that rebase completions work after fix

---

### 2. Fix `_git_bisect` completion file
**Status**: ✅ COMPLETE

**Actions**:
- [x] Implement `_git_bisect_complete_args()` function with:
  - Commit hash completion for `gbs`, `gbsa`
  - Tag completion for `gbstag`
- [x] Add `fbisect-next` to #compdef line
- [x] Test bisect completions

---

## MEDIUM PRIORITY - Missing Completions

### 3. Add descriptions to all completion files
**Rationale**: User wants descriptions for everything (aliases and functions) to aid discoverability

**Current state**: Some completion files have good descriptions, others are minimal

#### Git Completions
- [x] `_git_core` - Audit and add descriptions
- [x] `_git_branch` - Audit and add descriptions
- [x] `_git_stash` - Audit and add descriptions
- [x] `_git_tags` - Audit and add descriptions
- [x] `_git_merge` - Audit and add descriptions
- [x] `_git_cherry_pick` - Audit and add descriptions
- [x] `_git_worktree` - Audit and add descriptions
- [x] `_git_prune` - Audit and add descriptions
- [x] `_git_fzf` - Audit and add descriptions
- [x] `_git_rebase` - Audit and add descriptions (already fixed structure)
- [x] `_git_bisect` - Audit and add descriptions (already fixed structure)

#### Dev Environment Completions
- [ ] `_dev_env_completion` - Audit and add descriptions

#### Docker & Kubernetes Completions
- [x] `_docker` - Audit and add descriptions
- [x] `_docker_compose` - Audit and add descriptions
- [x] `_docker_functions` - Audit and add descriptions
- [x] `_kubernetes` - Audit and add descriptions
- [x] `_kube_functions` - Audit and add descriptions
- [x] `_kube_work_aliases` - Audit and add descriptions

#### Cloud & Services Completions
- [x] `_azure_functions` - Audit and add descriptions

#### Tool-Specific Completions
- [ ] `_dates` - Audit and add descriptions
- [ ] `_file_functions` - Audit and add descriptions
- [ ] `_js_tools` - Audit and add descriptions
- [ ] `_python_tools` - Audit and add descriptions
- [ ] `_nvim-update` - Audit and add descriptions
- [ ] `_vectorcode` - Audit and add descriptions
- [ ] `_ls_aliases` - Audit and add descriptions
- [ ] `_help` - Audit and add descriptions

#### Search & FZF Completions
- [ ] `_search_fzf_individual` - Audit and add descriptions
- [ ] `_git_fzf_individual` - Audit and add descriptions
- [ ] `_kubernetes_fzf_individual` - Audit and add descriptions

#### Utility & Misc Completions
- [ ] `_f` - Audit and add descriptions
- [ ] `_fk` - Audit and add descriptions
- [ ] `_fx` - Audit and add descriptions

**Actions for each file**:
- Audit all commands in #compdef line
- Ensure each has a helpful description in the commands array
- Consider adding alias expansions in descriptions (e.g., `glg:git log (alias)`)
- Verify descriptions match actual function behavior

---

### 4. Document simple aliases - do they need completions?
**Question to resolve**: Should simple aliases (no arguments) be in #compdef lines?

**Examples**:
- `gstuno`, `currBranch`, `gback`, `gpause`, `gundo`, `grhhm`
- `glg`, `lgl`, `lg`, `localGitIgnore`, `gb`

**User's environment**: Has zsh-syntax-highlighting, zsh-autosuggestions, zsh-autocomplete
- May not need explicit completions for command name recognition
- These plugins likely handle alias awareness already

**Actions**:
- [ ] Test if aliases work without being in #compdef
- [ ] Document decision (include or exclude simple aliases)
- [ ] If including, add to appropriate completion files

---

## LOW PRIORITY - Nice to Have

### 5. Add HEAD~N translation helper for `grbi`
**Context**: User suggested making it easier to type `grbi h3` → `HEAD~3`

**Current state**: `grbi` takes number or branch name

**Proposed enhancement**:
- Add logic to `grbi` function itself to translate:
  - `h3` → `HEAD~3`
  - `h5` → `HEAD~5`
  - `h10` → `HEAD~10`
  - etc.

**Actions**:
- [ ] Add translation logic to `grbi` function in `rebase.zsh`
- [ ] Update `-h` help text to document the shorthand
- [ ] Test that it works with both old and new syntax

---

## FUTURE ENHANCEMENTS - Help System

### 6. Consolidate and Expand Help Systems
**Context**: Currently have TWO parallel help systems loaded:

**Current State**:
1. **`zhelp`** (main.zsh) - Loaded in `.zshrc`
   - Modular: separate files for parser, cache, completion
   - Tracks functions only (no aliases)
   - More complex caching system
   - Has tab completion support

2. **`zh`** (zh.zsh) - Loaded in `source-things.zsh`
   - Self-contained single file
   - **Tracks both functions AND aliases** ✅
   - Shows alias expansions ✅
   - Simpler implementation
   - Uses `fd` command
   - Has its own completion file

**Decision: Consolidate into `zh` ecosystem**

### 6a. Enhance `zh` to include `zhelp` features
**Goal**: Make `zh` the primary CLI help system with all features from both systems

**Features to add to `zh`**:
- [ ] Modular structure (keep parser, cache, completion separate for maintainability)
- [ ] Better tab completion (use `zhelp`'s completion system)
- [ ] Keep alias tracking (already has this)
- [ ] Keep tag-based filtering (already has this)
- [ ] Improve cache performance if needed
- [ ] Remove `zhelp` once `zh` has all features
- [ ] Update `.zshrc` to only load `zh`

### 6b. Create `zhi` - Interactive FZF Help Browser
**Goal**: Interactive version of `zh` with rich previews

**Proposed: `zhi` (zh interactive)**

**Features**:
- [ ] Real-time search/filter as you type
- [ ] Preview pane showing:
  - Function definition with syntax highlighting (use `bat` or similar)
  - `which function_name` output
  - Alias expansions (what the alias expands to)
  - Full `-h` help text if available
  - Associated tags
  - Source file location
- [ ] Multi-select tags for filtering
- [ ] Keybindings:
  - `Enter` - Copy function/alias name to clipboard
  - `Ctrl-E` - Open source file in `$EDITOR`
  - `Ctrl-Y` - Copy entire function definition
  - `Ctrl-H` - Show full help text in pager
  - `Ctrl-T` - Toggle tag filtering
- [ ] Show usage examples from help text
- [ ] Color-code by type (function vs alias)
- [ ] Show command history usage count (how often you use it)

**Implementation approach**:
- [ ] Build on top of `zh`'s cache system (already parses aliases + functions)
- [ ] Create preview script: `zsh/src/zsh/tools/help/zhi-preview.zsh`
- [ ] Similar pattern to existing FZF git functions
- [ ] Use FZF with custom bindings and preview

**File structure**:
```
zsh/src/zsh/tools/help/
  zh.zsh              # Main CLI interface (enhanced)
  zh-parser.zsh       # Parse source files
  zh-cache.zsh        # Cache management
  zh-completion.zsh   # Tab completion
  zhi.zsh            # Interactive FZF interface (NEW)
  zhi-preview.zsh    # Preview script for FZF (NEW)
```

---

## QUESTIONS TO RESOLVE

1. **Do simple aliases need to be in #compdef lines?**
   - Test with user's zsh plugins
   - Document decision

2. **Commitizen completions - needed?**
   - `cz` command flags are handled by alias expansion
   - File args auto-complete by default
   - Conclusion: Probably not needed

3. **FZF functions - do they take inputs?**
   - Verified: `fbr`, `fcoc`, `ftco`, `fbremote`, `fco_preview`, `fcoc_preview` all take no args
   - They use FZF for interactive selection
   - Conclusion: Current completions are correct

4. **Helper functions (prefixed with `_`) - need completions?**
   - Examples: `_fgdiff_preview`, `_fgsearch_filter_author`
   - These are internal helpers not meant for direct use
   - Conclusion: No completions needed

---

## TESTING CHECKLIST

After making changes:
- [ ] Source updated completion files: `source ~/.zshrc` or restart shell
- [ ] Test tab completion for affected commands
- [ ] Verify no zsh completion errors in terminal
- [ ] Test that existing completions still work
- [ ] Run `compinit -d` to rebuild completion cache if needed

---

## FILES TO MODIFY

### Completion Files
- `zsh/src/zsh/completions/_git_rebase` - FIX CRITICAL
- `zsh/src/zsh/completions/_git_bisect` - FIX CRITICAL
- `zsh/src/zsh/completions/_git_core` - ADD DESCRIPTIONS
- `zsh/src/zsh/completions/_git_branch` - ADD DESCRIPTIONS
- `zsh/src/zsh/completions/_git_stash` - ADD DESCRIPTIONS
- `zsh/src/zsh/completions/_git_tags` - ADD DESCRIPTIONS
- `zsh/src/zsh/completions/_git_merge` - ADD DESCRIPTIONS
- `zsh/src/zsh/completions/_git_cherry_pick` - ADD DESCRIPTIONS
- `zsh/src/zsh/completions/_git_worktree` - ADD DESCRIPTIONS
- `zsh/src/zsh/completions/_git_prune` - ADD DESCRIPTIONS
- `zsh/src/zsh/completions/_git_fzf` - ADD DESCRIPTIONS (if needed)

### Alias Files
- `zsh/src/zsh/aliases/git/rebase.zsh` - ADD `h3` → `HEAD~3` translation to `grbi`

### Help System (Future)
- Create new `zsh/src/zsh/tools/help/fhelp.zsh` or similar

---

## NOTES

- Keep completion files focused on **non-file arguments** (branches, commits, tags, etc.)
- File/path completion is automatic in zsh
- Descriptions are valuable even for simple commands (aids discovery)
- Test thoroughly after changes to avoid breaking existing workflows
