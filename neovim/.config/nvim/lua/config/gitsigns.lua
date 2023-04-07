---@diagnostic disable: redundant-parameter
local M = {}

function M.setup()
  require('gitsigns').setup {
    signs = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    yadm = {
      enable = false
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
     map({ 'n', 'v' }, ']h', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map({'n', 'v'}, '[h', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      local wk = require('which-key')
      local stageHunk = { "<cmd>Gitsigns stage_hunk<cr>", "Stage current hunk" }
      local resetHunk = { "<cmd>Gitsigns reset_hunk<cr>", "Reset current hunk" }
      wk.register({
        ['<leader>g'] = {
          name = "Gitsigns",
          s = stageHunk,
          r = resetHunk,
          S = { gs.stage_buffer, "Stage whole buffer" },
          u = { gs.undo_stage_hunk, "Undo staged hunk" },
          R = { gs.reset_buffer, "Reset whole buffer" },
          p = { gs.preview_hunk, "Preview hunk" },
          b = {
            name = "Blame",
            f = { function() gs.blame_line { full = true } end, "Show full blame in floating window" },
            t = { gs.toggle_current_line_blame, "Toggle blame line virtual text for cursorline" },
          },
          dt = { gs.toggle_deleted, "Show deleted (does not re-add it!)" },
          wt = { gs.toggle_word_diff, "Toggle word diff" },
          d = {
            name = "Diff",
            i = { gs.diffthis, "Diff against current index" },
            n = { ":Gitsigns diffthis ~n", "Diff the last [n] commits" },
            m = { function() gs.diffthis('~') end, "Diff against main branch" },
          },
          qf = { "<cmd>Gitsigns setqflist all", "Send all hunks in all files to qf list" },
          lf = { function() gs.setloclist(0, 0) end, "Send all hunks in current buffer to loc list" },
        },
      })

      wk.register({
        ['<leader>g'] = {
          s = stageHunk,
          r = resetHunk,
        },
      }, { mode = 'v' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  }
end

return M
