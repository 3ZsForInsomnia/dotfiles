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

local getObservedProps = function(args)
  local observedProps = {}

  for j in ipairs(args[1]) do
    local assignedWithGet = string.match(args[1][j], 'this.get%(%b""')
    local assigned
    if #assignedWithGet == 1 then
      assigned = assignedWithGet
    else
      assigned = string.match(args[1][j], 'this.%w+')
    end
   -- assume never more than one per line - if that happens, more complex than snippet should handle
    if assigned ~= '' then
      local str = string.match(assigned, '%b""')
      local prop = string.sub(str, 2, -2)
      table.insert(observedProps, prop)
    end
  end

  if #observedProps >= 1 then
    observedProps = uniq(sort(observedProps))
    return "'" .. join(observedProps, "', ")
  else
    return ''
  end
end

return {
  s('de', { t('debugger') }),
  s({
    trig = 'clv',
    name = 'console.log("$1", $1);',
    dscr = 'Log a thing'
  }, {
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
  }, {
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
  s({
    trig = "ecp",
    name = "Ember Computed Property",
    dscr = "Create an Ember computed property with automatic addition of Observed properties",
  }, {
    t({ '/**', ' * ' }),
    i(3, 'Summary'),
    t({ '', ' */', '' }),
    i(1, "propName"),
    t(': computed('),
    f(getObservedProps, 2),
    -- grab this.x's here
    t({'function() {', '\t'}),
    i(2, "body"),
    t({ '', '}', '),'}),
  }),
  -- s({
  --   trig = 'etest',
  --   name = 'Ember Test',
  --   dsrc = 'Creates an Ember Test',
  --   -- can choose to have assert.expect(n), ticket (rt or adpr) or not
  -- }, {})
}
