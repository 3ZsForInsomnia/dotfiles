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

local comments = require('snippets.utils.comments')

return {
  s('de', { t('debugger') }),
  s(
    {
      trig = 'clv',
      name = 'console.log("$1", $1);',
      dscr = 'Log a thing'
    },
    {
      t('console.log("'),
      i(1),
      t('", '),
      rep(1),
      t(');')
    }
  ),
  s({
    trig = 'efu',
    name = 'Ember property function',
    dscr = 'Ember property function with docstring'
  },
    {
      t({ '/**', ' * ' }),
      i(3, 'Summary'),
      t({ '', '' }),
      d(4, comments.docstringParams, { 2 }),
      t({ ' **/', '' }),
      i(1, 'name'),
      t('('), i(2, 'params'), t({ ') {', '\t' }),
      i(0),
      t({ '', '},' })
    }),
  -- s({
  --   trig = 'ecp',
  --   name = 'Ember Computed Property',
  --   dsrc = 'Creates an Ember Computed Property with docstring and adds any `this.*` to list of observed properties',
  -- }, {

  -- }),
  -- s({
  --   trig = 'etest',
  --   name = 'Ember Test',
  --   dsrc = 'Creates an Ember Test',
  --   -- can choose to have assert.expect(n), ticket (rt or adpr) or not
  -- }, {})
}
