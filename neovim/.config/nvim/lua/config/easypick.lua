local easypick = require('easypick')

local M = {}

function M.setup()
  easypick.setup({
    pickers = {
      {
        name = "clipboard",
        command = [[copyq eval -- "tab('&clipboard'); for(i=size(); i>0; --i) print(str(read(i-1)) + '\n');"]],
        previewer = easypick.previewers.default(),
        action = easypick.actions.nvim_command("!copyq tab '&clipboard' add"),
      },
      {
        name = "conflicts",
        command = "git diff --name-only --diff-filter=U --relative",
        previewer = easypick.previewers.file_diff()
      },
    },
  })
end

return M
