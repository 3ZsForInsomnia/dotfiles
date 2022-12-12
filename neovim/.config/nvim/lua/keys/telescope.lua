local wk = require("which-key")
local trouble = require("trouble.providers.telescope")

local f = function(command)
  return "<cmd>Telescope " .. command .. "<cr>"
end

wk.register({
  f = {
    name = 'Telescope Find',
    f = { f("find_files"), "Files" },
    r = { f("frecency"), "Frecency" },
    gr = { f("live_grep"), "Live Search" },
    s = { f("grep_string"), "String" },
    q = { f("quickfix"), "Quickfix files" },
    qh = { f("quickfixhistory"), "Quickfix history" },
    j = { f("jumplist"), "Jumplist" },
    lo = { f("loclist"), "Location list" },
    t = { f("tags"), "Tags" },
    tb = { f("current_buffer_tags"), "Tags in buffer" },
    b = { f("buffers"), "Buffers" },
    w = { f("telescope-tabs list-tabs"), "Tabs" },
    m = { f("marks"), "Marks" },
    re = { f("registers"), "Registers" },
    k = { f("keymaps"), "Keybindings" },
  },
  fa = {
    name = "Telescope Action",
    h = { f("search_history"), "Search History" },
    r = { f("resume"), "Resume previous search" },
    c = { f("changes"), "Changes" },
    f = { f("builtin"), "Search Telescope Builtins" },
  },
  fg = {
    name = "Telescope Git",
    f = { f("git_files"), "Git files" },
    b = { f("git_branches"), "Git branches" },
    st = { f("git_stash"), "Git stashes" },
    c = { f("git_commits"), "Git commits" },
    cb = { f("git_bcommits"), "Commits in buffer" },
  },
  fd = {
    name = "Telescope Search Documentation",
    u = { f("ultisnips"), "Ultisnips" },
    ht = { f("http list"), "Http codes" },
    t = { f("tailiscope"), "Tailwind" },
    m = { f("man_pages"), "Man pages" },
    h = { f("help_tags"), "Vim help tags" },
    d = { f("dash search"), "Dash Search" },
    -- a = { f("dash search_no_filter"), "Dash Search Without Filter" },
  },
  fl = {
    name = "Telescope LSP",
    r = { f("lsp_references"), "References" },
    i = { f("lsp_incoming_calls"), "Incoming calls" },
    o = { f("lsp_outgoing_calls"), "Outgoing calls" },
    d = { trouble.open_with_trouble, "Show diagnostics" },
    ['do'] = { f("lsp_document_symbols"), "Document symbols" },
    w = { f("lsp_workspace_symbols"), "Workspace symbols" },
    im = { f("lsp_implementations"), "Implementations" },
    de = { f("lsp_definitions"), "Definitions" },
    t = { f("lsp_type_definitions"), "Type definitions" },
  }
}, { prefix = "<leader>" })

