# Overseer Task Configuration

This directory contains custom task templates for overseer.nvim.

## Directory Structure

```
overseer/
├── README.md           # This file
└── template/
    └── user/           # User-defined task templates
        ├── nx.lua      # Nx monorepo tasks (dynamic discovery)
        ├── npm.lua     # npm script tasks (dynamic discovery)
        ├── go.lua      # Go build/test/run tasks
        ├── python.lua  # Python test/run tasks
        ├── kubectl.lua # Kubernetes operations
        ├── tilt.lua    # Tilt development workflow
        └── fullstack.lua # Parallel fullstack dev environment
```

## Template Types

### Template Providers (Dynamic Discovery)

These templates automatically discover available tasks from your workspace:

- **`nx.lua`**: Runs `npx nx show projects` to find all projects, generates build/test/lint/serve tasks
- **`npm.lua`**: Parses `package.json` to discover all npm scripts, auto-detects long-running tasks

**Benefits:**
- Always up-to-date with your workspace
- Cached based on file modification time
- No manual configuration needed

### Static Templates

These templates provide parameterized task definitions:

- **`go.lua`**: Go operations with coverage/race detection options
- **`python.lua`**: pytest/unittest with coverage options
- **`kubectl.lua`**: Port-forwarding, logs, context switching
- **`tilt.lua`**: Kubernetes development with Tilt
- **`fullstack.lua`**: Runs multiple tasks in parallel (port-forward + backend + frontend)

## Component Aliases

Templates use these component aliases (defined in `plugins/overseer.lua`):

- **`default`**: Standard tasks, auto-dispose after 10 minutes
- **`long_running`**: Services that shouldn't auto-dispose (Tilt, dev servers, port-forwarding)
- **`build_test`**: Build/test tasks with quickfix integration
- **`default_neotest`**: Test tasks that auto-dispose after 5 minutes

## Adding Custom Templates

### Simple Template

Create a new file in `template/user/`:

```lua
-- template/user/my_task.lua
return {
  name = "my_task",
  tags = { "CUSTOM", "BUILD" },
  builder = function(params)
    return {
      cmd = { "my-command", params.arg },
      components = { "default" },
    }
  end,
  params = {
    arg = {
      type = "string",
      desc = "Argument for my command",
    },
  },
  desc = "My custom task",
}
```

### Template Provider (Dynamic)

For tasks that should be discovered from workspace:

```lua
-- template/user/my_dynamic.lua
local files = require("overseer.files")

return {
  cache_key = function(opts)
    return vim.fs.joinpath(opts.dir, "my-config.json")
  end,
  
  condition = {
    callback = function(search)
      return files.exists(files.join(search.dir, "my-config.json"))
    end,
  },
  
  generator = function(opts, cb)
    local tasks = {}
    -- Discover and create tasks dynamically
    -- ... add tasks to the table
    cb(tasks)
  end,
}
```

## Task Filtering

Tasks are filtered by tags via keybinds:

- `<leader>ora` - All tasks
- `<leader>orx` - NX tagged tasks only
- `<leader>orn` - NPM tagged tasks only
- `<leader>org` - GO tagged tasks only
- `<leader>ork` - K8S tagged tasks only
- etc.

When creating custom templates, use appropriate tags for filtering.

## Cache Management

Task cache is automatically:
- Loaded 2 seconds after neovim startup (non-blocking)
- Refreshed when template source files change
- Keyed by workspace directory and config files (nx.json, package.json, etc.)

Manual cache operations:
- `:OverseerClearCache` - Clear all cached tasks (from LazyVim)
- Cache is automatically rebuilt on next `:OverseerRun`

## Integration Notes

### Neotest
Overseer consumer is configured in `plugins/testing.lua`:
- Watch keybinds use overseer for better task management
- All neotest runs can optionally go through overseer

### DAP
Automatically runs `preLaunchTask` from debug configurations.

### Lualine
Task status indicators configured in `plugins/lualine.lua`.

## Troubleshooting

**Tasks not showing up:**
1. Check if condition is met (e.g., `nx.json` exists for nx tasks)
2. Try `:OverseerClearCache` to rebuild
3. Check `:OverseerInfo` for loaded templates

**Dynamic discovery not working:**
1. Verify the discovery command works in terminal (e.g., `npx nx show projects`)
2. Check cache_key function points to correct file
3. Look for errors in `:messages`

**Tasks auto-disposing too quickly/slowly:**
- Adjust timeout in component aliases (`plugins/overseer.lua`)
- Use `long_running` component for services

## Project-Specific Configuration

For project-specific tasks that shouldn't be in public dotfiles:

1. Create `.nvim.lua` in project root (gitignore it)
2. Register templates with `require("overseer").register_template({ ... })`
3. Use `condition = { dir = vim.fn.getcwd() }` to scope to current directory

See [overseer recipes](https://github.com/stevearc/overseer.nvim/blob/master/doc/recipes.md#directory-local-tasks-with-exrc) for more details.
