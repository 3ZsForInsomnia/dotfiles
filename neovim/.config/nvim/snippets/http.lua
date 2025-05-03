local v = vim.api

local ls = require("luasnip")
local s, t, i, c, d, sn, fmt =
  ls.s,
  ls.text_node,
  ls.insert_node,
  ls.choice_node,
  ls.dynamic_node,
  ls.snippet_node,
  require("luasnip.extras.fmt").fmt

-- Helper: query param dynamic node (for GET/DELETE/HEAD)
local function query_params_node(args, _, _)
  local method = args[1][1]
  if method == "GET" or method == "DELETE" or method == "HEAD" then
    return sn(nil, {
      t("?"),
      i(1, "param=value"),
      c(2, {
        t(""),
        sn(nil, { t("&"), i(1, "param2=value2") }),
      }),
    })
  else
    return sn(nil, { t("") })
  end
end

-- Helper: read kulala-style variables from buffer
local function get_kulala_vars()
  local vars = {}
  local lines = v.nvim_buf_get_lines(0, 0, math.min(50, v.nvim_buf_line_count(0)), false)
  for _, line in ipairs(lines) do
    -- matches lines like "@pokemon=PIKACHU"
    local name = line:match("@([%w_]+)=")
    if name then
      table.insert(vars, name)
    end
    if #vars >= 24 then
      break
    end -- don't get crazy
  end
  return vars
end

-- Helper: variable interpolation choice node
local function variable_choice_node()
  return d(1, function()
    local vars = get_kulala_vars()
    local opts = {}
    for _, var in ipairs(vars) do
      table.insert(opts, t(var))
    end
    table.insert(opts, i(#opts + 1, "custom_variable"))
    return sn(nil, {
      t("{{"),
      c(1, opts),
      t("}}"),
    })
  end)
end

-- Helper: headers dynamic node (inline 'header' snippet call)
local function headers_node()
  return sn(nil, {
    c(1, {
      t(""), -- No headers
      ls.function_node(function()
        v.nvim_feedkeys(":lua require('luasnip').expand_snippet('header')\n", "n", true)
        return ""
      end, {}),
    }),
  })
end

-- Helper: request body dynamic node (inline 'body' call)
local function req_body_node(args, _, _)
  local method = args[1][1]
  if method == "POST" or method == "PUT" or method == "PATCH" then
    return sn(nil, {
      c(1, {
        t(""), -- No body
        t("\n"), -- Empty body line
        ls.function_node(function()
          v.nvim_feedkeys(":lua require('luasnip').expand_snippet('body')\n", "n", true)
          return ""
        end, {}),
      }),
    })
  else
    return sn(nil, { t("") })
  end
end

----------------------------------------------------------
-- SNIPPETS --

return {
  -- MAIN KULALA REQUEST BLOCK
  s(
    "req",
    fmt(
      [[
###
{} http://{}{}
{}
{}
###
]],
      {
        c(1, { t("GET"), t("POST"), t("PUT"), t("PATCH"), t("DELETE"), t("HEAD") }), -- HTTP verb
        i(2, "api.example.com"), -- Endpoint
        d(3, query_params_node, { 1 }), -- Query params if method is right
        d(4, headers_node, {}), -- Headers
        d(5, req_body_node, { 1 }), -- Body
      }
    )
  ),

  -- HEADER BUILDER -- same as before, just without XML options
  s(
    "header",
    c(1, {
      sn(
        nil,
        fmt("Authorization: {} {}", {
          c(1, { t("Bearer"), t("Basic") }),
          i(2, "your_token_or_base64"),
        })
      ),
      sn(
        nil,
        fmt("Content-Type: {}", {
          c(1, {
            t("application/json"),
            t("application/x-www-form-urlencoded"),
            t("multipart/form-data"),
            t("text/plain"),
            t("text/html"),
            i(2, "other/type"),
          }),
        })
      ),
      sn(
        nil,
        fmt("Accept: {}", {
          c(1, {
            t("application/json"),
            t("application/xml"),
            t("text/plain"),
            t("*/*"),
            i(2, "other/type"),
          }),
        })
      ),
      sn(
        nil,
        fmt("User-Agent: {}", {
          c(1, {
            t("curl/8.6.0"),
            t("Mozilla/5.0"),
            i(2, "custom-agent"),
          }),
        })
      ),
      sn(
        nil,
        fmt("{}: {}", {
          i(1, "X-Custom-Header"),
          i(2, "value"),
        })
      ),
    })
  ),

  -- REQUEST BODY
  s(
    "body",
    c(1, {
      -- JSON
      sn(
        nil,
        fmt(
          [[
{{
  "{}": "{}"
}}
    ]],
          {
            i(1, "key"),
            i(2, "value"),
          }
        )
      ),
      -- Form-urlencoded
      sn(nil, fmt("{}={}", { i(1, "field"), i(2, "value") })),
      -- Raw/plain
      i(1, "plain request body"),
    })
  ),

  -- VARIABLE INTERPOLATION (uses dynamic node for choices)
  s("var", variable_choice_node()),
}
