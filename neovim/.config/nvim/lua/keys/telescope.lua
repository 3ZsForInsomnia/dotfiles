local wk = require("which-key")

local f = function(command)
  return "<cmd>Telescope " .. command .. "<cr>"
end

local live = function()
  return { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "Live search" }
end

wk.register({
  ['<leader>'] = {
    f = {
      name = 'Telescope Find',
      j = live(),
      f = { f("find_files"), "Files" },
      p = { f("pickers"), "Pickers" },
      y = { f("frecency"), "Frecency" },
      s = { f("grep_string"), "String" },
      h = { f("search_history"), "Search History" },
      r = { f("resume"), "Resume previous search" },
      c = {
        name = "Changes/loc/qf lists",
        c = { f("changes"), "Changes" },
        u = { f("undo"), "Undo stack" },
        f = { f("quickfix"), "Quickfix files" },
        h = { f("quickfixhistory"), "Quickfix history" },
        j = { f("jumplist"), "Jumplist" },
        l = { f("loclist"), "Location list" },
      },
      b = {
        name = "Buffers/tags/marks",
        m = { f("marks"), "Marks" },
        b = { f("buffers"), "Buffers" },
        r = { f("registers"), "Registers" },
        t = { f("tags"), "Tags" },
        c = { f("current_buffer_tags"), "Tags in buffer" },
      },
      g = {
        name = "Git",
        f = { f("git_files"), "Files" },
        h = { "<cmd>Easypick changed_files<cr>", "Changed" },
        b = { f("git_branches"), "Branches" },
        t = { f("git_stash"), "Stashes" },
        s = { f("git_status"), "Status" },
        m = { f("git_commits"), "Commits" },
        c = { f("git_bcommits"), "Commits in buffer" },
      },
      d = {
        name = "Search Documentation",
        s = { f("luasnip"), "Snippets" },
        e = { f("http list"), "Http codes" },
        t = { f("tailiscope"), "Tailwind" },
        m = { f("man_pages"), "Man pages" },
        h = { f("help_tags"), "Vim help tags" },
        d = { "<cmd>Dash<cr>", "Dash Search" },
        c = { "<cmd>DashWord<cr>", "Dash word under cursor" },
        a = { f("dash search"), "Dash Search Without Filter" },
        b = { f("bookmarks"), "Chrome Bookmarks" },
        k = { f("keymaps"), "Keybindings" },
      },
      l = {
        name = "LSP",
        r = { f("lsp_references"), "References" },
        i = { f("lsp_incoming_calls"), "Incoming calls" },
        o = { f("lsp_outgoing_calls"), "Outgoing calls" },
        s = { f("lsp_document_symbols"), "Document symbols" },
        w = { f("lsp_workspace_symbols"), "Workspace symbols" },
        m = { f("lsp_implementations"), "Implementations" },
        d = { f("lsp_definitions"), "Definitions" },
        t = { f("lsp_type_definitions"), "Type definitions" },
        c = { "<cmd>lua require(\"telescope.builtin\").lsp_workspace_symbols({query=vim.call('expand','<cword>')})<cr>",
          "Search workspace symbol under cursor (even in comments)" },
      },
      m = {
        name = "Misc",
        n = { f("scriptnames"), "See all scripts sourced in config" },
        s = { f("xray23 list"), "Vim Sessions" },
        h = { f("heading"), "Document headings" },
        p = { f("packer"), "Packer information/actions" },
        f = { f("file_browser"), "Find files" },
        b = { f("folder_browser"), "Find folders" },
        a = { f("angular"), "Angular modules" },
        c = { "<cmd>TodoTelescope<cr>", "Find todo comments" },
        y = { "<cmd>Easypick clipboard<cr>", "Clipboard" },
      }
    },
  },
})
