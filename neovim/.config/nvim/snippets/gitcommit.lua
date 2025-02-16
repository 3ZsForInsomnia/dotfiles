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

-- Function to retrieve scopes from environment variable
local function read_scopes()
  local scopes = os.getenv("PLATFORM_COMMIT_SCOPES")
  if scopes then
    return vim.split(scopes, ",") -- Assuming scopes are comma-separated
  else
    return {""}
  end
end

return {
  s('conventional', fmt('{}({}): {}\n\n{}\n\nPOD1-{}', {
        -- Choice node for commit type
        c(1, {
            t('feat'),
            t('fix'),
            t('chore'),
            t('docs'),
            t('style'),
            t('refactor'),
            t('perf'),
            t('test'),
            t('build'),
            t('ci'),
            t('revert')
        }),
        -- Choice node for scope using environment variable
        c(2, vim.tbl_map(function(scope)
            return t(scope)
        end, read_scopes())),
        -- Insert node for imperative short description
        i(3, 'short description'),
        -- Insert node for optional long description
        i(4, ''),
        -- Insert node for Jira ticket number
        i(5, '')
    })),
}
