local v = vim
local f = v.fn
local e = "<leader>e"
local y = "<leader>y"

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    deactivate = function()
      v.cmd([[Neotree close]])
    end,
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      v.api.nvim_create_autocmd("BufEnter", {
        group = v.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = v.uv.fs_stat(f.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "git_status", "document_symbols", "buffers" },
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
      },
    },
    config = function(_, opts)
      f.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      f.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      f.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      f.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

      local function on_move(data)
        LazyVim.lsp.on_rename(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      v.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
    end,
    keys = {
      {
        e .. "o",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        e .. "O",
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
    event = "VeryLazy",
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
