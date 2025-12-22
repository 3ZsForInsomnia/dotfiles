# Nx Workspace Completions

Target-aware completions for Nx workspace commands that intelligently suggest only projects with the relevant targets.

## Features

### Smart Project Filtering

Instead of showing all projects for every command, completions now filter based on available targets:

- `nxs <TAB>` - Only shows projects with a "serve" target
- `nxt <TAB>` - Only shows projects with a "test" target  
- `nxb <TAB>` - Only shows projects with a "build" target
- `nxl <TAB>` - Only shows projects with a "lint" target

### Automatic Workspace Detection

The system automatically finds your nx workspace by looking for:
1. `nx.json` (modern nx workspaces)
2. `workspace.json` (legacy nx)
3. `angular.json` (nx with angular)

### Project.json Parsing

Each project's `project.json` file is parsed to determine available targets, ensuring completions only suggest valid project/target combinations.

## Architecture

### Utility Functions (`zsh/src/zsh/utils/nx-utils.zsh`)

Core functions for workspace and project discovery:

- `findNxWorkspaceRoot()` - Locates the workspace root directory
- `getNxProjects()` - Lists all projects in the workspace
- `getNxProjectJsonPath(project)` - Finds a project's project.json file
- `getNxProjectTargets(project)` - Lists available targets for a project
- `projectHasTarget(project, target)` - Checks if a project has a specific target
- `getNxProjectsWithTarget(target)` - Filters projects by target availability
- `getNxProjectInfo(project)` - Gets formatted project information

### Completion Helpers (`zsh/src/zsh/completions/helpers/_comp_nx_tools`)

Wrapper functions that format utility output for zsh completions:

- `_comp_nx_projects()` - Complete with all projects
- `_comp_nx_projects_with_target(target)` - Complete with filtered projects
- `_comp_nx_serveable_projects()` - Projects with "serve" target
- `_comp_nx_testable_projects()` - Projects with "test" target
- `_comp_nx_buildable_projects()` - Projects with "build" target
- `_comp_nx_lintable_projects()` - Projects with "lint" target

### Main Completions (`zsh/src/zsh/completions/_js_tools`)

Integrates the helpers into the completion system for all nx-related commands.

## Usage

After sourcing your zsh configuration, completions work automatically:

```bash
# In an nx workspace
nxs <TAB>        # Shows only serveable projects
nxt my-app <TAB> # Shows completion for "my-app" if it has test target
nxb <TAB>        # Shows only buildable projects
nxl <TAB>        # Shows only lintable projects
```

## Requirements

- `jq` - For parsing JSON workspace and project configuration files
- Nx workspace with `project.json` files for each project

## Fallback Behavior

If `jq` is not available or project.json files aren't found, the system falls back to:
1. Scanning `apps/` and `libs/` directories
2. Showing all found projects (without target filtering)

## Testing

Run the completion test script to verify setup:

```bash
source zsh/src/zsh/completions/test_completions.zsh
```

Look for:
- ✅ nxs completion registered (target-aware)
- ✅ nxt completion registered (target-aware)
- ✅ nxb completion registered (target-aware)
- ✅ nxl completion registered (target-aware)

## Integration

The system integrates with existing zsh infrastructure:

1. **Utils Loading** - `utils/index.zsh` autoloads all nx-utils functions
2. **Completion Helpers** - `completions/helpers/` directory added to fpath
3. **Auto-registration** - `#compdef` directive in `_js_tools` registers completions

## Performance

- Functions use caching where appropriate (directory lookups, JSON parsing)
- Completion results are generated on-demand
- Workspace root is found once and reused within a session
- `jq` parsing is fast enough for real-time completion

## Extending

To add completions for additional nx targets:

1. Add a helper function in `_comp_nx_tools`:
   ```zsh
   _comp_nx_e2e_projects() {
     _comp_nx_projects_with_target "e2e"
   }
   ```

2. Add a case in `_js_tools`:
   ```zsh
   nxe2e)
     if (( CURRENT == 2 )); then
       autoload -Uz _comp_nx_e2e_projects
       _comp_nx_e2e_projects
       return 0
     fi
     ;;
   ```

3. Add to `#compdef` line and command descriptions

## Troubleshooting

**No completions showing:**
- Verify you're in an nx workspace: `ls nx.json`
- Check jq is installed: `which jq`
- Rebuild completions: `rm ~/.zcompdump* && exec zsh`

**Shows all projects instead of filtered:**
- Ensure projects have `project.json` files
- Verify target names match exactly (e.g., "serve" not "start")
- Check project.json structure: `cat apps/my-app/project.json`

**Completions showing but incorrect:**
- Clear cache: `rm -rf ~/.cache/zsh/`
- Reload shell: `exec zsh`
