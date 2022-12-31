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

-- TODO:
-- Add google docs like outline for ordered lists - 1 a i 2 b ii
-- Add evernote bullet points/symbols

local tabs = function(count)
  return string.rep('\t', count)
end

local rec_ls
rec_ls = function(a1, b1, c1, count)
  return sn(nil, {
    c(1, {
      -- important!! Having the sn(...) as the first choice will cause infinite recursion.
      t({ "" }),
      -- The same dynamicNode as in the snippet (also note: self reference).
      sn(nil,
        { t(tabs(count) .. "<li>"), i(1, 'list item'), t({ '</li>', '' }), d(2, rec_ls, {}, { user_args = { count } }) }),
      sn(nil, {
        t({ tabs(count) .. "<li>", tabs(count + 1) .. "<ul>", tabs(count + 2) .. "<li>" }),
        i(1, 'list item'),
        t({ '</li>', '' }),
        d(2, rec_ls, {}, { user_args = { count + 2 } }),
        t({ tabs(count + 1) .. '</ul>', tabs(count) .. '</li>', '' }),
        d(3, rec_ls, {}, { user_args = { count } })
      }),
    }),
  });
end

return {
  s({
    trig = "ul",
    name = "Unordered List",
    dscr = "Unorderd list that autocreates new li tags automatically on enter within snippet, and a nested list on tab",
    priority = 500,
  }, {
    t({ '<ul>', '\t<li>' }),
    i(1, "list item"),
    t({ '</li>', '' }),
    d(2, rec_ls, {}, { user_args = { 1 } }),
    t({ '</ul>', '' }),
    i(0),
  }),
}
