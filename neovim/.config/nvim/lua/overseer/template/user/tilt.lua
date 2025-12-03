-- Tilt workflow for kubernetes development
return {
  name = "tilt",
  tags = { "TILT", "K8S", "DEV" },
  builder = function(params)
    local cmd = { "tilt", "up" }
    
    if params.args and params.args ~= "" then
      vim.list_extend(cmd, vim.split(params.args, " "))
    end
    
    return {
      cmd = cmd,
      components = { "long_running" },
    }
  end,
  params = {
    args = {
      type = "string",
      optional = true,
      default = "",
      desc = "Additional Tilt arguments",
    },
  },
  desc = "Run Tilt for local kubernetes development",
}
