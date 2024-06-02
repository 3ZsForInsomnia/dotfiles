return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = { "nvim-neotest/neotest-jest" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "npm run test",
            jestConfigFile = "jest.config.ts",
            discovery = {
              enabled = false,
            },
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
        }
      })
    end
  }
}
