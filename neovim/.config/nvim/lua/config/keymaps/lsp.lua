local l = "<leader>l"
local keybind = require("helpers")
local k_cmd = keybind.k_cmd

local c = function(cmd)
  return "lua vim.lsp.buf." .. cmd .. "()"
end

k_cmd({ key = l .. "a", action = c("code_action"), desc = "Perform code actions" })
k_cmd({ key = l .. "D", action = c("declaration"), desc = "Declaration" })
k_cmd({ key = l .. "d", action = c("definition"), desc = "Definition" })
k_cmd({ key = l .. "i", action = c("implementation"), desc = "Implementation" })
k_cmd({ key = l .. "r", action = c("references"), desc = "References" })
k_cmd({ key = l .. "n", action = c("rename"), desc = "Rename tag under cursor" })
k_cmd({ key = l .. "t", action = c("type_definition"), desc = "Type Def" })
k_cmd({ key = l .. "f", action = ":FormatWrite", desc = "Format" })
k_cmd({ key = "K", action = c("signature_help"), desc = "Show signature" })

local w = l .. "w"
k_cmd({ key = w .. "a", action = c("add_workspace_folder"), desc = "Add folder" })
k_cmd({ key = w .. "r", action = c("remove_workspace_folder"), desc = "Remove folder" })
k_cmd({
  key = w .. "l",
  action = "<cmd>lua print(v.inspect(vim.lsp.buf.list_workspace_folders()))",
  desc = "List folder",
})

local lens = l .. "l"
k_cmd({ key = lens .. "g", action = c("code_lens"), desc = "Get lenses" })
k_cmd({ key = lens .. "f", action = c("refresh_code_lens"), desc = "Refresh" })
k_cmd({ key = lens .. "r", action = c("run_code_lens"), desc = "Run" })
k_cmd({ key = lens .. "c", action = c("clear_references"), desc = "Clear lenses in buffer" })

local wk = require("which-key")

wk.register({
  ["<leader>l"] = {
    name = "LSP",
    a = "Perform code actions",
    D = "Declaration",
    d = "Definition",
    i = "Implementation",
    r = "References",
    n = "Rename tag under cursor",
    t = "Type definition",
    f = "Format",
    l = {
      name = "Code lens",
      g = "Get lenses",
      f = "Refresh",
      r = "Run",
      c = "Clear lenses in buffer",
    },
    w = {
      name = "Workspaces",
      a = "Add folder",
      r = "Remove folder",
      l = "List folder",
    },
  },
  ["<C-k>"] = "Show signature",
})
