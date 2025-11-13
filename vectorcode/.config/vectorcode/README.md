# VectorCode Projects Configuration

This directory contains configuration for managing VectorCode projects across your development workflow.

## Files

### `projects.txt`

A simple text file listing all project roots to track for vectorization. One project path per line.

**Format:**
- One project root path per line
- Lines starting with `#` are comments (ignored)
- Empty lines are ignored
- Tilde (`~`) is expanded to `$HOME`

**Example:**
```
# My active projects
~/src/dotfiles
~/src/my-app
/Users/username/work/project-x
```

## Usage

Use the `vcp` (VectorCode Projects) command to manage this list:

### Commands

- **`vcp add [path]`** - Add a project (defaults to git root of current directory)
- **`vcp remove <path>`** - Remove a project from tracking
- **`vcp list`** - Show all tracked projects
- **`vcp sync [path]`** - Re-vectorise one or all projects
- **`vcp edit`** - Open projects file in `$EDITOR`

### Examples

```bash
# Add current git repo to tracking
cd ~/src/my-project
vcp add

# Add a specific path
vcp add ~/src/another-project

# List all tracked projects
vcp list

# Re-vectorise all projects
vcp sync

# Re-vectorise a specific project
vcp sync ~/src/my-project

# Remove a project
vcp remove ~/src/old-project

# Edit the projects file directly
vcp edit
```

## How It Works

When you run `vcp sync`, it will:
1. Read all projects from `projects.txt`
2. For each project, run `vectorcode vectorise --project_root <path>`
3. Project-level `.vectorcode` config files determine what to include/exclude
4. Display success/failure summary

This makes it easy to re-populate your embeddings if your ChromaDB data is lost.

## Related Commands

- **`vc`** - Alias for `vectorcode`
- **`vcq <query>`** - Smart query wrapper with argument parsing
- **`vca <filetypes>`** - Smart vectorise wrapper with filetype detection

All VectorCode functions are defined in `zsh/src/zsh/aliases/vectorcode.zsh`.
