local k = require("helpers").k
local k_cmd = require("helpers").k_cmd
local o = "<leader>o"

-- Helper to create overseer command keybinds
local function oc(suffix, command, desc)
  return k_cmd({
    key = o .. suffix,
    action = "Overseer" .. command,
    desc = desc or command,
  })
end

-- Helper to run overseer with tag filter
local function run_with_tags(tags)
  return function()
    require("overseer").run_template({ tags = tags })
  end
end

return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun",
      "OverseerToggle",
      "OverseerOpen",
      "OverseerClose",
      "OverseerLoadBundle",
      "OverseerSaveBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerInfo",
      "OverseerClearCache",
      "OverseerShell",
    },
    keys = {
      -- Keep LazyVim defaults (they define these, we just document them here)
      -- <leader>oo - Run task (all tasks) - from LazyVim
      -- <leader>ow - Task list - from LazyVim
      -- <leader>oi - Overseer Info - from LazyVim
      -- <leader>ot - Task action - from LazyVim
      -- <leader>oq - Action recent task - from LazyVim
      -- <leader>oc - Clear cache - from LazyVim
      -- <leader>ob - Task builder - from LazyVim

      -- Additional task management
      k({
        key = o .. "R",
        action = function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({ recent_first = true })
          if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
          end
        end,
        desc = "Restart last task",
      }),

      -- Shell command (like :! but as overseer task)
      oc("s", "Shell", "Run shell command"),

      -- Output management
      k({
        key = o .. "O",
        action = function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({ recent_first = true })
          if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
          else
            tasks[1]:open_output({ direction = "float" })
          end
        end,
        desc = "Open last task output",
      }),

      -- Task runner filters (unique prefix <leader>or)
      k({ key = o .. "ra", action = run_with_tags({}), desc = "All tasks" }),
      k({ key = o .. "rx", action = run_with_tags({ "NX" }), desc = "Nx tasks" }),
      k({ key = o .. "rn", action = run_with_tags({ "NPM" }), desc = "npm tasks" }),
      k({ key = o .. "rg", action = run_with_tags({ "GO" }), desc = "Go tasks" }),
      k({ key = o .. "rp", action = run_with_tags({ "PYTHON" }), desc = "Python tasks" }),
      k({ key = o .. "rk", action = run_with_tags({ "K8S" }), desc = "kubectl tasks" }),
      k({ key = o .. "rt", action = run_with_tags({ "TILT" }), desc = "Tilt workflow" }),
      k({ key = o .. "rf", action = run_with_tags({ "FULLSTACK" }), desc = "Fullstack workflow" }),

      -- Nx sub-commands (unique prefix <leader>ox)
      k({
        key = o .. "xb",
        action = function()
          require("overseer").run_template({ name = "nx", params = { subcommand = "build" } })
        end,
        desc = "Nx build",
      }),
      k({
        key = o .. "xt",
        action = function()
          require("overseer").run_template({ name = "nx", params = { subcommand = "test" } })
        end,
        desc = "Nx test",
      }),
      k({
        key = o .. "xl",
        action = function()
          require("overseer").run_template({ name = "nx", params = { subcommand = "lint" } })
        end,
        desc = "Nx lint",
      }),
      k({
        key = o .. "xs",
        action = function()
          require("overseer").run_template({ name = "nx", params = { subcommand = "serve" } })
        end,
        desc = "Nx serve",
      }),

      -- npm sub-commands (unique prefix <leader>on)
      k({
        key = o .. "ni",
        action = function()
          require("overseer").run_template({ name = "npm", params = { subcommand = "install" } })
        end,
        desc = "npm install",
      }),
      k({
        key = o .. "nt",
        action = function()
          require("overseer").run_template({ name = "npm", params = { subcommand = "test" } })
        end,
        desc = "npm test",
      }),
      k({
        key = o .. "nb",
        action = function()
          require("overseer").run_template({ name = "npm", params = { subcommand = "build" } })
        end,
        desc = "npm build",
      }),
      k({
        key = o .. "ns",
        action = function()
          require("overseer").run_template({ name = "npm", params = { script = "storybook" } })
        end,
        desc = "npm run storybook",
      }),

      -- Go sub-commands (unique prefix <leader>og)
      k({
        key = o .. "gb",
        action = function()
          require("overseer").run_template({ name = "go", params = { subcommand = "build" } })
        end,
        desc = "Go build",
      }),
      k({
        key = o .. "gt",
        action = function()
          require("overseer").run_template({ name = "go", params = { subcommand = "test" } })
        end,
        desc = "Go test",
      }),
      k({
        key = o .. "gr",
        action = function()
          require("overseer").run_template({ name = "go", params = { subcommand = "run" } })
        end,
        desc = "Go run",
      }),
      k({
        key = o .. "gc",
        action = function()
          require("overseer").run_template({ name = "go", params = { subcommand = "test", coverage = true } })
        end,
        desc = "Go test with coverage",
      }),
    },
    opts = {
      -- Templates to load
      templates = { "builtin", "user" },

      -- Auto-detect task files
      auto_detect_success_color = true,

      -- DAP integration
      dap = true,

      -- Component aliases for different task types
      component_aliases = {
        -- Default components for most tasks
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          { "on_complete_notify", statuses = { "FAILURE" } },
          { "on_complete_dispose", timeout = 600 }, -- 10 minutes
        },

        -- For long-running services (Tilt, port-forwarding, etc)
        long_running = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          -- Don't auto-dispose long-running tasks
        },

        -- For build/test tasks with quickfix integration
        build_test = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          { "on_output_quickfix", open = true, open_height = 8 },
          { "on_complete_notify", statuses = { "FAILURE" } },
          { "on_complete_dispose", timeout = 600 },
        },

        -- For neotest tasks (don't keep these around as long)
        default_neotest = {
          "on_exit_set_status",
          { "on_complete_notify", statuses = { "FAILURE" } },
          { "on_complete_dispose", timeout = 300 }, -- 5 minutes
        },
      },

      -- Task list configuration
      task_list = {
        default_detail = 1,
        max_width = { 100, 0.2 },
        min_width = { 40, 0.1 },
        width = nil,
        max_height = { 20, 0.1 },
        min_height = 8,
        height = nil,
        separator = "────────────────────────────────────────",
        direction = "bottom",
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
          ["q"] = "Close",
        },
      },

      -- Form configuration for OverseerBuild
      form = {
        border = "rounded",
        zindex = 40,
        min_width = 80,
        max_width = 0.9,
        width = nil,
        min_height = 10,
        max_height = 0.9,
        height = nil,
        win_opts = {
          winblend = 0,
        },
      },

      -- Confirmation for dangerous actions
      confirm = {
        border = "rounded",
        zindex = 40,
        min_width = 20,
        max_width = 0.5,
        width = nil,
        min_height = 6,
        max_height = 0.9,
        height = nil,
        win_opts = {
          winblend = 0,
        },
      },

      -- Task window configuration
      task_win = {
        border = "rounded",
        win_opts = {
          winblend = 0,
        },
      },

      -- Help window
      help_win = {
        border = "rounded",
        win_opts = {},
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- Background cache initialization (don't block startup)
      vim.defer_fn(function()
        overseer.preload_task_cache({}, function()
          -- Cache loaded silently
        end)
      end, 2000) -- Wait 2 seconds after startup

      -- Custom user command for quick shell execution
      vim.api.nvim_create_user_command("OS", function(params)
        overseer
          .new_task({
            cmd = vim.fn.expandcmd(params.args),
            components = {
              { "on_output_quickfix", open = not params.bang },
              "default",
            },
          })
          :start()
      end, {
        nargs = "+",
        bang = true,
        complete = "file",
        desc = "Run a shell command as an overseer task",
      })

      -- Restart last task command
      vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end, { desc = "Restart the most recent task" })

      -- Example of running a command with zsh aliases/functions (commented out)
      -- To use zsh aliases, you need an interactive shell:
      -- vim.api.nvim_create_user_command("OSZsh", function(params)
      --   overseer.new_task({
      --     cmd = { "zsh", "-ic", params.args },
      --     components = { "default" },
      --   }):start()
      -- end, {
      --   nargs = "+",
      --   desc = "Run a zsh command (with aliases) as an overseer task",
      -- })
    end,
  },
}
