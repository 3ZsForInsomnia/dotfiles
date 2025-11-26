# ZSH Completions & Help System TODO

## Status Summary

**Completion Verification Progress**: ~70% Complete

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

## NEXT STEPS - Remaining Alias Files to Verify

**Goal**: Verify remaining alias files against completion files, ensure all functions/aliases have descriptions and appropriate argument completions.

**Process for each file:**
1. Check if completion file exists for the alias file
2. Extract all functions/aliases from `zsh/src/zsh/aliases/FILENAME.zsh`
3. Compare against completion file's `#compdef` line
4. Add missing functions/aliases with descriptions
5. Add argument completions where appropriate (use existing helpers or inline logic)
6. Verify zsh syntax with `zsh -n`
7. Mark as complete in this document

### Remaining Top-Level Alias Files

- [x] `compilation.zsh` - Build/compilation related aliases
- [x] `dash-g.zsh` - Dash documentation shortcuts
- [x] `db.zsh` - Database utilities
- [x] `ghub.zsh` - GitHub CLI shortcuts
- [x] `golang.zsh` - Go language tools
- [x] `jira.zsh` - Jira integration
- [x] `lua.zsh` - Lua language tools
- [x] `sgpt.zsh` - Shell GPT integration
- [x] `slack.zsh` - Slack CLI tools
- [x] `tui-tools.zsh` - TUI application shortcuts
- [x] `vectorcode.zsh` - VectorCode wrappers (completion exists, verified completeness)
- [x] `wezterm.zsh` - Wezterm terminal config shortcuts

### Subdirectory Alias Files

#### `devenv/` - Development Environment
- [x] `devenv/backend.zsh`
- [x] `devenv/configs.zsh` (deprecated - empty file)
- [x] `devenv/database.zsh`
- [x] `devenv/frontend.zsh`
- [x] `devenv/locations.zsh`
- [x] `devenv/misc.zsh`
- [x] `devenv/procfiles.zsh`

**Note**: Check if `_dev_env_completion` covers all devenv aliases or if additional files needed.

#### `work/` - Work-Specific
- [x] `work/config-management.zsh`
- [x] `work/kube.zsh` (covered by `_kube_work_aliases` - verified and enhanced)
- [x] `work/special.zsh`
- [x] `work/variables.zsh`

**Note**: Check `_kube_work_aliases` and see if other completion files needed.

---

## COMPLETION ENHANCEMENTS - Future Work

**Note**: This is OPTIONAL enhancement work for later. The priority is completing verification of all alias files above.

### Context
- Current completions mix inline logic with helper functions
- Many completion patterns are repeated across files
- Could benefit from shared helper functions for common operations

### Potential Shared Completion Helpers

#### Process/System Helpers
- [ ] `_comp_running_processes` - Get running processes with PIDs and names
- [ ] `_comp_process_by_port` - Get process using specific port
- [ ] `_comp_port_numbers` - Common port numbers (3000, 8000, 8080, etc.)
- [ ] `_comp_system_type` - Detect mac/linux/windows

#### File/Directory Helpers
- [ ] `_comp_project_roots` - Find project roots (git repos, package.json, etc.)
- [ ] `_comp_config_files` - Common config file patterns
- [ ] `_comp_archive_files` - Archive file extensions (.zip, .tar.gz, etc.)

#### Development Tool Helpers
- [ ] `_comp_package_json_scripts` - Extract npm/yarn scripts (currently inline in multiple places)
- [ ] `_comp_pyenv_versions` - Get Python versions (currently in _python_tools)
- [ ] `_comp_node_versions` - Get Node versions (if using nvm/n)

#### Container/Orchestration Helpers
- [ ] `_comp_docker_containers` - Consolidate running/stopped container logic
- [ ] `_comp_docker_images` - Get Docker images
- [ ] `_comp_k8s_namespaces` - Get Kubernetes namespaces
- [ ] `_comp_k8s_pods` - Get pods in namespace

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
- [ ] `_misc_aliases` - Add smart completion for directory shortcuts (cd completion)
- [ ] `_search_fzf_individual` - Consider adding preview patterns

### Shared Completion Library Structure

**Proposed location**: `zsh/src/zsh/completions/_completion_helpers`

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
