# FZF Preview Scripts

Standalone preview scripts for FZF integrations across the zsh configuration.

## Why Standalone Scripts?

FZF preview commands run in separate subshells that don't inherit shell functions. Previously, we tried to use functions defined in `fzf-helpers.zsh`, but they weren't accessible in the preview subshell context. Standalone executable scripts solve this problem cleanly.

## Architecture

### Preview Scripts

Each preview script is:
- **Standalone** - executable with shebang, can run independently
- **Self-contained** - sources only `_helpers.zsh` for shared utilities
- **Error-handling** - validates inputs and provides helpful error messages
- **Consistent** - uses common formatting helpers for uniform output

### Available Previews

| Script | Purpose | Usage |
|--------|---------|-------|
| `git-commit.zsh` | Git commit details with delta | `$ZSH_PREVIEWS_DIR/git-commit.zsh <hash>` |
| `git-branch.zsh` | Branch info with divergence | `$ZSH_PREVIEWS_DIR/git-branch.zsh <branch>` |
| `git-worktree.zsh` | Worktree status and commits | `$ZSH_PREVIEWS_DIR/git-worktree.zsh <path>` |
| `file.zsh` | File/directory with git status | `$ZSH_PREVIEWS_DIR/file.zsh <path>` |
| `process.zsh` | Process details and resources | `$ZSH_PREVIEWS_DIR/process.zsh <process-line>` |
| `k8s-pod.zsh` | Pod status, events, resources | `$ZSH_PREVIEWS_DIR/k8s-pod.zsh <pod> [ns]` |
| `k8s-service.zsh` | Service endpoints and pods | `$ZSH_PREVIEWS_DIR/k8s-service.zsh <svc> [ns]` |

### Helper Functions

`_helpers.zsh` provides shared utilities:
- `_preview_get_main_branch()` - Detect main/master branch
- `_preview_header()` - Format section headers with emojis
- `_preview_kv()` - Format key-value pairs
- `_preview_has_cmd()` - Check command availability
- `_preview_clean_branch()` - Clean branch name formatting

## Usage in FZF Commands

### Git Example
```zsh
fzf --preview="$ZSH_PREVIEWS_DIR/git-commit.zsh {1}"
```

### File Example
```zsh
fzf --preview="$ZSH_PREVIEWS_DIR/file.zsh {}"
```

### Kubernetes Example
```zsh
fzf --preview="$ZSH_PREVIEWS_DIR/k8s-pod.zsh {} $namespace"
```

## Adding New Previews

1. Create new script in this directory:
   ```zsh
   #!/usr/bin/env zsh
   source "${0:h}/_helpers.zsh"
   
   local item="$1"
   # ... validation and preview logic ...
   ```

2. Make it executable:
   ```bash
   chmod +x previews/new-preview.zsh
   ```

3. Use in FZF command:
   ```zsh
   --preview="$ZSH_PREVIEWS_DIR/new-preview.zsh {}"
   ```

## Performance Considerations

- Scripts spawn new processes (minimal overhead for our use case)
- Delta/bat provide syntax highlighting (fast enough for interactive use)
- For very large diffs, consider adding truncation logic
- Preview window size: 60-65% typical, adjustable per command

## Inline vs Script Decision

**Use inline preview when:**
- Single command (e.g., `bat --color=always {}`)
- Simple pipe (e.g., `git show -p {} | delta`)
- No conditionals or validation needed

**Use script when:**
- Multiple commands or logic
- Conditional behavior
- Error handling needed
- Shared across multiple FZF commands

## Migration Notes

Previously, preview functions lived in `tools/fzf-helpers.zsh` and were called via wrapper scripts. This caused issues with:
- Function availability in subshells
- Lazy loading conflicts
- Sourcing overhead

The new architecture is simpler and more reliable.
