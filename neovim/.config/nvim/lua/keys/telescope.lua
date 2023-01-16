local wk = require("which-key")
local trouble = require("trouble.providers.telescope")

local f = function(command)
  return "<cmd>Telescope " .. command .. "<cr>"
end

wk.register({
  ['<leader>'] = {},
  f = {
    [''] = { f('live_grep'), "Live search" },
    name = 'Telescope Find',
    f = { f("find_files"), "Files" },
    t = { f(""), "Pickers" },
    fr = { f("frecency"), "Frecency" },
    sl = { f("live_grep"), "Live Search" },
    ss = { f("grep_string"), "String" },
    h = { f("search_history"), "Search History" },
    r = { f("resume"), "Resume previous search" },
    c = {
      name = "Telescope changes/loc/qf lists",
      c = { f("changes"), "Changes" },
      u = { f("undo"), "Undo stack" },
      q = { f("quickfix"), "Quickfix files" },
      qh = { f("quickfixhistory"), "Quickfix history" },
      j = { f("jumplist"), "Jumplist" },
      l = { f("loclist"), "Location list" },
    },
    b = {
      name = "Telescope buffers/tags/marks",
      w = { f("telescope-tabs list-tabs"), "Tabs" },
      m = { f("marks"), "Marks" },
      b = { f("buffers"), "Buffers" },
      r = { f("registers"), "Registers" },
      t = { f("tags"), "Tags" },
      tb = { f("current_buffer_tags"), "Tags in buffer" },
    },
    g = {
      name = "Telescope Git",
      f = { f("git_files"), "Git files" },
      b = { f("git_branches"), "Git branches" },
      st = { f("git_stash"), "Git stashes" },
      s = { f("git_status"), "Git status" },
      c = { f("git_commits"), "Git commits" },
      cb = { f("git_bcommits"), "Commits in buffer" },
    },
    d = {
      name = "Telescope Search Documentation",
      s = { f("luasnip"), "Snippets" },
      ht = { f("http list"), "Http codes" },
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
      name = "Telescope LSP",
      r = { f("lsp_references"), "References" },
      i = { f("lsp_incoming_calls"), "Incoming calls" },
      o = { f("lsp_outgoing_calls"), "Outgoing calls" },
      d = { trouble.open_with_trouble, "Show diagnostics" },
      ds = { f("lsp_document_symbols"), "Document symbols" },
      w = { f("lsp_workspace_symbols"), "Workspace symbols" },
      im = { f("lsp_implementations"), "Implementations" },
      de = { f("lsp_definitions"), "Definitions" },
      t = { f("lsp_type_definitions"), "Type definitions" },
      c = { "<cmd>lua require(\"telescope.builtin\").lsp_workspace_symbols({query=vim.call('expand','<cword>')})<cr>",
        "Search workspace symbol under cursor (even in comments)" },
    },
    m = {
      name = "Telescope Misc",
      sn = { f("scriptnames"), "See all scripts sourced in config" },
      s = { f("xray23 list"), "Vim Sessions" },
      h = { f("heading"), "Document headings" },
      p = { f("packer"), "Packer information/actions" },
      f = { f("file_browser"), "Find files" },
      fo = { f("folder_browser"), "Find folders" },
      c = { "<cmd>TodoTelescope<cr>", "Find todo comments" },
    }
  },
})
