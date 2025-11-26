# ZSH Completions & Help System TODO

## Status Summary

**Completion Verification Progress**: ✅ **100% Complete**

### All Alias Files Verified & Completed

All functions and aliases from alias files have been verified against completion files, with descriptions added for the help system (`zh`/`zhelp`).

### ✅ Completed Alias Files (Verified & Updated)

All functions and aliases from these files have been verified against their completion files, with descriptions added for the help system (`zh`/`zhelp`):

- **Git** (11 files): All `git/*.zsh` files → corresponding `_git_*` completions
- **Docker/Kubernetes**: `docker.zsh`, `kubernetes.zsh` → `_docker_functions`, `_docker_compose`, `_kubernetes`, `_kube_functions`
- **Cloud**: `azure.zsh` → `_azure_functions`
- **Languages**: `python.zsh` → `_python_tools`, `js-ts.zsh` → `_js_tools`
- **Tools**: `dates.zsh` → `_dates`, `nvim.zsh` → `_file_functions`
- **Utilities**: `misc.zsh` → `_misc_aliases`, `utils.zsh` → `_utils_functions`, `config-utils.zsh` → `_config_utils`
- **Search**: `searching.zsh` → `_search_fzf_individual`, `_ls_aliases`
- **Meta**: `_f`, `_fk`, `_fx` (FZF function prefix completions)

**What was done:**
- Fixed corrupted completion files (`_git_rebase`, `_git_bisect`)
- Added missing functions/aliases to completion files
- Created new completion files where missing
- Added descriptions for ALL functions/aliases
- Added argument completions where appropriate
- Verified every alias file against its completion file

---

## COMPLETION ENHANCEMENTS - Future Work

**Note**: This is OPTIONAL enhancement work for later. The priority is completing verification of all alias files above.

### Refactoring Plan: Completion Helpers

**Goal**: Extract duplicate logic into reusable helpers, making completions DRY and maintainable.

**Architecture**: Two-layer approach
1. **General utility functions** (camelCase, no `_` prefix) - Return raw data, usable anywhere
2. **Completion helpers** (snake_case with `_comp_` prefix) - Wrap utilities with completion formatting

**Naming Conventions**:
- Util functions: `camelCase` (e.g., `getRunningProcesses`, `parsePackageJsonScripts`)
- Util files: `kebab-case.zsh` (e.g., `process-utils.zsh`, `dev-utils.zsh`)
- Completion helpers: `_snake_case` (e.g., `_comp_processes`, `_comp_package_scripts`)
- Completion files: `_snake_case` (existing convention)

**Loading Strategy**: Use `autoload -Uz` for lazy loading
- Utilities autoloaded via `fpath` in `utils/index.zsh`
- Completion helpers autoloaded on-demand when completions trigger
- Zero startup penalty, instant availability when needed

**Directory Structure**:
```
zsh/src/zsh/
├── utils/
│   ├── process-utils.zsh      # getRunningProcesses, getProcessByPort
│   ├── dev-utils.zsh           # parsePackageJsonScripts, etc.
│   └── index.zsh               # Autoload setup: fpath+=(${0:h}) && autoload -Uz ...
├── completions/
│   ├── helpers/
│   │   ├── _comp_processes     # Calls getRunningProcesses, formats for completion
│   │   ├── _comp_dev_tools     # Calls parsePackageJsonScripts, formats for completion
│   │   └── _git_cache_system   # (existing, move here) - reusable completion logic
│   └── _*                      # Main completion files
```

**helpers/ Directory Purpose**:
- Reusable completion logic (like `_git_cache_system`)
- Completion wrappers that call util functions and format output
- Shared completion patterns used across multiple completion files
- NOT required for all completions - inline logic is fine for simple cases

**Pattern Example**:
```zsh
# utils/dev-utils.zsh - General utility (camelCase)
parsePackageJsonScripts() {
  [[ -f package.json ]] || return 1
  jq -r '.scripts | keys[]' package.json 2>/dev/null
}

# completions/helpers/_comp_dev_tools - Completion wrapper (snake_case)
_comp_package_scripts() {
  local -a scripts
  scripts=(${(f)"$(parsePackageJsonScripts)"})
  (( ${#scripts[@]} > 0 )) && _describe 'package.json scripts' scripts
}

# completions/_npm - Uses the helper
_npm() {
  autoload -Uz _comp_package_scripts
  case $state in
    scripts) _comp_package_scripts ;;
  esac
}
```

**Benefits**:
- Single source of truth for data fetching logic
- Utilities reusable in both completions AND regular functions/aliases
- Completion helpers provide consistent formatting
- Lazy loading via autoload (no startup cost)
- Easy to test utilities independently

**Implementation Plan**:
1. **Phase 1**: Create new utils for missing functionality (process, port detection) ✅
   - [x] `utils/index.zsh` - Autoload setup
   - [x] `utils/process-utils.zsh` - `getRunningProcesses`, `getProcessByPort`
   - [x] `utils/dev-utils.zsh` - `parsePackageJsonScripts`
   - [x] `utils/project-utils.zsh` - `findProjectRoot`
   - [x] `utils/python-utils.zsh` - `getPyenvVersions`, `getPyenvCurrentVersion`
   - [x] `utils/docker-utils.zsh` - Docker container/image/network/volume getters
   - [x] `utils/kubernetes-utils.zsh` - Kubernetes namespace/pod/service/deployment getters
   - [x] `completions/helpers/_comp_processes` - Process completion wrappers
   - [x] `completions/helpers/_comp_dev_tools` - Dev tools completion wrappers
   - [x] `completions/helpers/_comp_project_tools` - Project management wrappers
   - [x] `completions/helpers/_comp_python_tools` - Python tools wrappers
   - [x] `completions/helpers/_comp_docker_tools` - Docker tools wrappers
   - [x] `completions/helpers/_comp_kubernetes_tools` - Kubernetes tools wrappers
2. **Phase 2**: Extract duplicated logic (package.json parsing from `_js_tools` and `_completion_integration`) ✅
   - [x] Refactor `_js_tools` to use `_comp_package_scripts`
   - [x] Refactor `_completion_integration` to use `_comp_package_scripts`
3. **Phase 3**: Refactor existing completion helpers where it makes sense ⏸️
   - [ ] Consider moving `_git_cache_system` to `helpers/` (deferred - works fine as-is)
   - [ ] Evaluate other completion files for extractable patterns (future work)
4. **Note**: Not all completions need separate util functions - inline logic is fine for simple, one-off cases

**Summary of Infrastructure Created**:
- ✅ `utils/` directory with 6 utility files (20+ utility functions)
- ✅ `completions/helpers/` directory with 6 helper files (15+ completion helpers)
- ✅ Established pattern for two-layer architecture (utils → completion helpers)
- ✅ All files syntax-validated and ready to use
- ✅ Refactored 2 existing completion files to use new helpers
- 📋 Pattern established for future refactoring of existing completions

### Context
- Current completions mix inline logic with helper functions
- Many completion patterns are repeated across files
- Could benefit from shared helper functions for common operations

### Potential Shared Completion Helpers

#### Process/System Helpers
- [x] `_comp_running_processes` - Get running processes with PIDs and names
- [x] `_comp_process_by_port` - Get process using specific port

#### File/Directory Helpers
- [x] `_comp_project_roots` - Find project roots (git repos, package.json, etc.)

#### Development Tool Helpers
- [x] `_comp_package_json_scripts` - Extract npm/yarn scripts (currently inline in multiple places)
- [x] `_comp_pyenv_versions` - Get Python versions (currently in _python_tools)

#### Container/Orchestration Helpers
- [x] `_comp_docker_containers` - Consolidate running/stopped container logic
- [x] `_comp_docker_images` - Get Docker images
- [x] `_comp_k8s_namespaces` - Get Kubernetes namespaces
- [x] `_comp_k8s_pods` - Get pods in namespace

### File-Specific Completion Improvements

#### High Priority
- [ ] `_docker_functions` - Extract container/image helpers into shared functions
- [ ] `_kubernetes` - Extract k8s resource helpers into shared functions
- [ ] `_python_tools` - Make pyenv/poetry helpers reusable
- [ ] `_js_tools` - Extract package.json parsing into shared function

#### Medium Priority
- [ ] `_utils_functions` - Improve process/port completion logic
- [ ] `_git_core` - Consider adding more intelligent branch/commit completion
- [ ] `_azure_functions` - Add vault/secret caching

#### Low Priority
- [ ] `_search_fzf_individual` - Consider adding preview patterns

### Shared Completion Library Structure

Or break into categories:
- `zsh/src/zsh/completions/_system_helpers` - Process, port, system detection
- `zsh/src/zsh/completions/_dev_helpers` - Package managers, languages, tools
- `zsh/src/zsh/completions/_container_helpers` - Docker, Kubernetes
- `zsh/src/zsh/completions/_file_helpers` - Files, directories, projects

### Benefits
- **Consistency** - Same completion behavior across similar commands
- **Performance** - Shared caching for expensive operations
- **Maintainability** - Fix once, applies everywhere
- **Discoverability** - Easy to see what completion helpers are available

---

## FUTURE ENHANCEMENTS - Help System

### Consolidate and Expand Help Systems
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

### Enhance `zh` to include `zhelp` features
**Goal**: Make `zh` the primary CLI help system with all features from both systems

**Features to add to `zh`**:
- [ ] Modular structure (keep parser, cache, completion separate for maintainability)
- [ ] Better tab completion (use `zhelp`'s completion system)
- [ ] Keep alias tracking (already has this)
- [ ] Keep tag-based filtering (already has this)
- [ ] Improve cache performance if needed
- [ ] Remove `zhelp` once `zh` has all features
- [ ] Update `.zshrc` to only load `zh`

### Create `zhi` - Interactive FZF Help Browser
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
   - **Current approach**: Including all aliases/functions for help system (`zh`)

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

## NOTES

- Keep completion files focused on **non-file arguments** (branches, commits, tags, etc.)
- File/path completion is automatic in zsh
- Descriptions are valuable even for simple commands (aids discovery via `zh`/`zhelp`)
- Test thoroughly after changes to avoid breaking existing workflows
- All functions and aliases should have descriptions for the help system, even if they don't take arguments
