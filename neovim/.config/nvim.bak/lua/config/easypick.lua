local easypick = require('easypick')
local base_branch = "develop"

local M = {}

function M.setup()
    easypick.setup({
        pickers = {
            {
                name = "clipboard",
                command = [[copyq eval -- "tab('&clipboard'); for(i=size(); i>0; --i) print(str(read(i-1)) + '\n');"]],
                previewer = easypick.previewers.default(),
                action = easypick.actions.nvim_command(
                    "!copyq tab '&clipboard' add")
            }, {
                name = "conflicts",
                command = "git diff --name-only --diff-filter=U --relative",
                previewer = easypick.previewers.file_diff()
            }, {
                name = "changed_files",
                command = "git diff --name-only $(git merge-base HEAD " ..
                    base_branch .. " )",
                previewer = easypick.previewers.branch_diff({
                    base_branch = base_branch
                })
            }
        }
    })
end

return M
