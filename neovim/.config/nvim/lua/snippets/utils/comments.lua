local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local strings = require('snippets.utils.strings')

local M = {}

M.docstringParams = function(str)
  local params = vim.split(str[1][1], ', ', {})
  if #params == 0 then
    return sn(nil, { t('') })
  end
  local ret = {}
  table.insert(ret, t({ ' *', '' }))
  for j, param in ipairs(params) do
    print('param is ', param)
    table.insert(ret, t({ ' * @param ' .. param, '' }))
  end
  table.insert(ret, t({ ' *', '' }))

  return sn(nil, ret)
end

return M
