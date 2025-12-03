-- npm task template provider with dynamic script discovery
local files = require("overseer.files")

---@type overseer.TemplateFileProvider
return {
  cache_key = function(opts)
    return vim.fs.joinpath(opts.dir, "package.json")
  end,
  
  condition = {
    callback = function(search)
      return files.exists(files.join(search.dir, "package.json"))
    end,
  },
  
  generator = function(opts, cb)
    local tasks = {}
    local package_json_path = vim.fs.joinpath(opts.dir, "package.json")
    
    -- Read and parse package.json
    local ok, package_data = pcall(function()
      local content = vim.fn.readfile(package_json_path)
      return vim.json.decode(table.concat(content, "\n"))
    end)
    
    if not ok or not package_data or not package_data.scripts then
      -- Fallback: provide basic npm commands
      table.insert(tasks, {
        name = "npm install",
        tags = { "NPM", "INSTALL" },
        builder = function()
          return {
            cmd = { "npm", "install" },
            components = { "default" },
          }
        end,
      })
      cb(tasks)
      return
    end
    
    -- Create tasks for each script in package.json
    for script_name, _ in pairs(package_data.scripts) do
      table.insert(tasks, {
        name = string.format("npm run %s", script_name),
        tags = { "NPM", "SCRIPT" },
        params = {
          extra_args = {
            type = "string",
            optional = true,
            desc = "Extra arguments",
          },
        },
        builder = function(params)
          local cmd = { "npm", "run", script_name }
          if params.extra_args and params.extra_args ~= "" then
            table.insert(cmd, "--")
            vim.list_extend(cmd, vim.split(params.extra_args, " "))
          end
          return {
            cmd = cmd,
            components = {
              -- Use long_running for dev/start/watch scripts
              (script_name:match("^dev") or script_name:match("^start") or script_name:match("watch"))
                  and "long_running"
                or "build_test",
            },
          }
        end,
      })
    end
    
    -- Add common npm commands
    table.insert(tasks, {
      name = "npm install",
      tags = { "NPM", "INSTALL" },
      params = {
        save_dev = {
          type = "boolean",
          default = false,
          desc = "Install as dev dependency (--save-dev)",
        },
        package = {
          type = "string",
          optional = true,
          desc = "Package name (leave empty to install all)",
        },
      },
      builder = function(params)
        local cmd = { "npm", "install" }
        if params.save_dev then
          table.insert(cmd, "--save-dev")
        end
        if params.package and params.package ~= "" then
          table.insert(cmd, params.package)
        end
        return {
          cmd = cmd,
          components = { "default" },
        }
      end,
    })
    
    table.insert(tasks, {
      name = "npm test",
      tags = { "NPM", "TEST" },
      params = {
        extra_args = {
          type = "string",
          optional = true,
          desc = "Extra arguments",
        },
      },
      builder = function(params)
        local cmd = { "npm", "test" }
        if params.extra_args and params.extra_args ~= "" then
          table.insert(cmd, "--")
          vim.list_extend(cmd, vim.split(params.extra_args, " "))
        end
        return {
          cmd = cmd,
          components = { "build_test" },
        }
      end,
    })
    
    cb(tasks)
  end,
}
