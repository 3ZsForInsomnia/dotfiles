local types = require("luasnip.util.types")

local ls = require("luasnip")
require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load { paths = "~/.config/nvim/lua/snippets/" }
ls.filetype_extend('typescript', { 'javascript' })
ls.filetype_extend('javascriptreact', { 'javascript' })
ls.filetype_extend('typescriptreact', { 'typescript' })
ls.filetype_extend('handlebars', { 'html' })

ls.config.setup({
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "GruvboxOrange" } }
      }
    },
    [types.insertNode] = {
      active = {
        virt_text = { { "●", "GruvboxBlue" } }
      }
    }
  },
})
