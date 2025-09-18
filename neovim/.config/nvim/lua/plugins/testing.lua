local v = vim

local l = "<leader>t"

local js_config = {
  jestCommand = "npm run test --",
  jestConfigFile = "jest.config.ts",
  env = { CI = true },
  cwd = function()
    return v.fn.getcwd()
  end,
  --   discovery = {
  --     enabled = false,
  --   },
}

local go_config = {
  dap_go_enabled = true,
  go_test_args = {
    "-v",
    -- "-race",
    "-count=1",
    "-coverprofile=" .. v.fn.getcwd() .. "/coverage.out",
  },
}

local function jump_to_next_failed_test()
  require("neotest").jump.next({ status = "failed" })
end

local function jump_to_prev_failed_test()
  require("neotest").jump.prev({ status = "failed" })
end

return {
  {
    "andythigpen/nvim-coverage",
    event = "VeryLazy",
    rocks = { "lua-xmlreader" },
    requires = "nvim-lua/plenary.nvim",
    config = true,
    keys = {
      {
        l .. "c",
        function()
          require("coverage").load(true)
        end,
        desc = "Show coverage",
      },
      {
        l .. "Cl",
        function()
          require("coverage").load(false)
        end,
        desc = "Load coverage",
      },
      {
        l .. "Ch",
        function()
          require("coverage").hide()
        end,
        desc = "Hide coverage",
      },
      {
        l .. "Ct",
        function()
          require("coverage").load(false)
          require("coverage").toggle()
        end,
        desc = "Toggle coverage",
      },
      {
        l .. "Cs",
        function()
          require("coverage").load(false)
          require("coverage").summary()
        end,
        desc = "Show coverage summary",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",

      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapters = {
        ["neotest-golang"] = go_config,
        ["neotest-jest"] = js_config,
      },
      diagnostic = {
        enabled = true,
        severity = v.diagnostic.severity.ERROR,
      },
      status = { virtual_text = true, signs = true },
      summary = {
        open = "botright vsplit | vertical resize 75",
      },
      output = {
        enabled = true,
        enter = false,
      },
      quickfix = {
        open = function()
          if LazyVim.has("trouble.nvim") then
            require("trouble").open({ mode = "quickfix", focus = false })
          else
            v.cmd("copen")
          end
        end,
      },
    },
    config = function(_, opts)
      if LazyVim.has("trouble.nvim") then
        opts.consumers = opts.consumers or {}
        -- Refresh and auto close trouble after running tests
        ---@type neotest.Consumer
        opts.consumers.trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end
            local tree = assert(client:get_position(nil, { adapter = adapter_id }))

            local failed = 0
            for pos_id, result in pairs(results) do
              if result.status == "failed" and tree:get_key(pos_id) then
                failed = failed + 1
              end
            end
            v.schedule(function()
              local trouble = require("trouble")
              if trouble.is_open() then
                trouble.refresh()
                if failed == 0 then
                  trouble.close()
                end
              end
            end)
            return {}
          end
        end
      end

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not v.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
    keys = {
      { l, "", desc = "+test" },
      {
        l .. "t",
        function()
          require("neotest").run.run(v.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        l .. "T",
        function()
          require("neotest").run.run(v.uv.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        l .. "r",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        l .. "l",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last",
      },
      {
        l .. "s",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        l .. "o",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        l .. "O",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        l .. "S",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
      {
        l .. "w",
        function()
          require("neotest").watch.toggle(v.fn.expand("%"))
        end,
        desc = "Toggle Watch",
      },
      {
        l .. "j",
        function()
          require("neotest").run.run({ jestCommand = "jest --watch" })
        end,
        desc = "Run Jest Watch",
      },

      {
        "[t",
        function()
          jump_to_prev_failed_test()
        end,
        desc = "Previous Failed Test",
      },
      {
        "]t",
        function()
          jump_to_next_failed_test()
        end,
        desc = "Next Failed Test",
      },
    },
  },
}
