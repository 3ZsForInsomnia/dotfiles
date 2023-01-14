local M = {}

function M.setup()
  require('code_runner').setup({
    -- put here the commands by filetype
    filetype = {
      java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
      python = "python3 -u",
      typescript = "ts-node",
      javascript = "node",
      rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt"
    },
  })
end

return M
