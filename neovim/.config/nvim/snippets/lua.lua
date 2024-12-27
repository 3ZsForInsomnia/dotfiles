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

getStringPart = function(args, _, user_args1, user_args2)
  local delimiter = user_args1 or "."
  local text = args[1][1] or ""
  local split = vim.split(text, delimiter, { plain = true })
  local partNumber = user_args2 or #split
  return split[partNumber]
end

return {
  s({
    trig = "wk",
    name = "Create WhichKey Binding",
    dscr = '$1 = { "$2", "$3" },',
  }, {
    c(1, {
      i(1, "binding"),
      sn(nil, {
        t('["<'),
        i(1, "binding"),
        t('>"]'),
      }),
    }),
    t(' = { "'),
    c(2, {
      sn(nil, { t("<cmd>"), i(1), t("<cr>") }),
      sn(nil, { t(":lua "), i(1, "cmd") }),
      i(1, "cmd"),
    }),
    t('", "'),
    i(3, "Desc"),
    t('" },'),
  }),
  s({
    trig = "lr",
    name = 'local x = require("z.y.x")',
    dsrc = "Create local var for last item in require path",
  }, {
    t("local "),
    f(getStringPart, 1),
    t(' = require("'),
    i(1, "module"),
    t('")'),
  }),
  s({
    trig = "lrp",
    name = "local x = require('module').x",
    dscr = "Create a local variable for a property of a module",
  }, {
    t("local "),
    rep(2),
    t(' = require("'),
    i(1, "module"),
    t('").'),
    i(2, "prop"),
  }),
  s({
    trig = "i(%d)",
    name = "i(#, ''),",
    dscr = "Create insertNode with Jump",
    regTrig = true,
  }, {
    t("i("),
    f(function(_, snip)
      return snip.captures[1]
    end, {}),
    t(', "'),
    i(0, "placeholder"),
    t('"),'),
  }),
  s({
    trig = "tit",
    name = "TextNode InsertNode TextNode",
    dscr = "Handles common case of an InsertNode surrounded by TextNodes",
  }, {
    t('t("'),
    i(1, "textNode1"),
    t({ '"),', "i(" }),
    i(2, "insert jump node"),
    t(', "'),
    i(3, "placeholder"),
    t({ '"),', 't("' }),
    i(4, "textNode2"),
    t('"),'),
  }),
  s({
    trig = "snip",
    name = "New snippet",
  }, {
    t({ "s({", '\ttrig = "' }),
    i(1, "trigger"),
    t({ '",', '\tname = "' }),
    i(2, "Name"),
    t({ '",', '\tdscr = "' }),
    i(3, "Description"),
    t({ '",', "}, {", "\t" }),
    i(0, "Snippet goes here"),
    t({ "", "})," }),
  }),
  s({
    trig = "a11",
    name = "args[1][1]",
    dscr = "Description",
  }, {
    t("args[1][1]"),
  }),
}
