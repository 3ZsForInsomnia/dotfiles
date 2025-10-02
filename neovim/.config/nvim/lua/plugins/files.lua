local v = vim
local f = v.fn
local e = "<leader>e"
local y = "<leader>y"

local function add_file_to_quickfix(state)
  local node = state.tree:get_node() -- Get node under cursor
  if node and node.type == "file" then
    vim.fn.setqflist({ { filename = node.path } }, "a") -- 'a' appends to quickfix
    vim.notify("Added to quickfix: " .. node.path)
  else
    vim.notify("Node is not a file.", vim.log.levels.WARN)
  end
end

local function open_in_diffview(state)
  local node = state.tree:get_node()
  if node and node.path then
    vim.cmd("DiffviewOpen " .. vim.fn.fnameescape(node.path))
  else
    vim.notify("No file under cursor", vim.log.levels.WARN)
  end
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    init = function()
      return false
    end,
    deactivate = function()
      v.cmd([[Neotree close]])
    end,
    opts = {
      sources = { "filesystem", "git_status", "document_symbols", "buffers" },
      buffers = {
        show_unloaded = true,
      },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      popup_border_style = "NC",
      use_popups_for_input = false,
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            v.wo.number = true
            v.wo.relativenumber = true
          end,
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          always_show = { ".gitignore" },
          never_show = { ".DS_Store", "thumbs.db" },
        },
        renderers = {
          file = {
            {
              "container",
              width = "100%",
              right_padding = 1,
              content = {
                {
                  "name",
                  use_git_status_colors = true,
                  zindex = 10,
                },
                { "git_status", zindex = 20, align = "right" },
                { "diagnostics", zindex = 20, align = "right" },
                { "token_count", zindex = 10, align = "right" },
              },
            },
          },
        },
      },
      git_status = {
        window = {
          mappings = {
            ["p"] = open_in_diffview,
          },
        },
      },
      window = {
        width = 50,
        mappings = {
          ["space"] = "none",
          ["l"] = "toggle_node",
          ["h"] = "close_node",
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["Q"] = add_file_to_quickfix,
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              f.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["Z"] = "expand_all_nodes",
        },
      },
      default_component_configs = {
        name = {
          highlight_opened_files = true,
          trailing_slash = true,
        },
        created = {
          enabled = true,
        },
        symlink_target = {
          enabled = true,
        },
        diagnostics = {
          symbols = {
            hint = "󰌵 ",
            info = " ",
            warn = " ",
            error = " ",
          },
          highlights = {
            hint = "DiagnosticSignHint",
            info = "DiagnosticSignInfo",
            warn = "DiagnosticSignWarn",
            error = "DiagnosticSignError",
          },
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      v.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })

      opts.filesystem.components = opts.filesystem.components or {}
      opts.filesystem.components.token_count = require("token-count.integrations.neo-tree").get_component()

      require("neo-tree").setup(opts)
    end,
    keys = {
      {
        e .. "f",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        e .. "F",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = v.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { e .. "e", "fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { e .. "E", "fE", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        e .. "g",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Status",
      },
      {
        e .. "b",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
      {
        e .. "d",
        function()
          require("neo-tree.command").execute({ source = "document_symbols", toggle = true })
        end,
        desc = "Document Symbols Explorer",
      },
      { e .. "ge", false },
      { e .. "be", false },
      { e .. "fe", false },
      { e .. "fE", false },
      { e .. "E", false },
      { e .. "e", false },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    cmd = "Yazi",
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    keys = {
      {
        y .. "o",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        y .. "w",
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
  },
}
