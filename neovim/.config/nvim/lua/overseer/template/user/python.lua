-- Python test and run tasks
local files = require("overseer.files")

---@type overseer.TemplateDefinition
return {
  name = "python",
  tags = { "PYTHON", "TEST", "RUN" },
  condition = {
    callback = function(search)
      return files.exists(files.join(search.dir, "pyproject.toml"))
        or files.exists(files.join(search.dir, "setup.py"))
        or files.exists(files.join(search.dir, "requirements.txt"))
    end,
  },
  builder = function(params)
    local cmd = { "python" }
    
    if params.subcommand == "pytest" then
      cmd = { "pytest", "-v" }
      if params.coverage then
        vim.list_extend(cmd, { "--cov", "--cov-report=term" })
      end
      if params.file ~= "" then
        table.insert(cmd, params.file)
      end
    elseif params.subcommand == "run" then
      if params.file ~= "" then
        table.insert(cmd, params.file)
      else
        table.insert(cmd, ".")
      end
    elseif params.subcommand == "unittest" then
      cmd = { "python", "-m", "unittest" }
      if params.file ~= "" then
        table.insert(cmd, params.file)
      else
        table.insert(cmd, "discover")
      end
    end

    return {
      cmd = cmd,
      components = {
        params.subcommand == "pytest" or params.subcommand == "unittest" and "build_test" or "default",
      },
    }
  end,
  params = {
    subcommand = {
      type = "enum",
      default = "pytest",
      choices = { "pytest", "unittest", "run" },
      desc = "Python command",
    },
    file = {
      type = "string",
      optional = true,
      default = "",
      desc = "File to run/test (empty for all)",
    },
    coverage = {
      type = "boolean",
      default = false,
      desc = "Generate coverage report (pytest only)",
    },
  },
  desc = "Run Python command",
}
