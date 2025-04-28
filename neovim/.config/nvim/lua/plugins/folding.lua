local v = vim
local s = v.keymap.set
local getbuf = v.api.nvim_get_current_buf

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = v.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = v.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = v.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      local custom_folds = {}

      local function custom_regions_fold(bufnr)
        return function()
          local regions = custom_folds[bufnr]
          if regions and #regions > 0 then
            return regions
          end

          return {}
        end
      end

      local provider_selector = function(bufnr, filetype, buftype)
        return { "lsp", custom_regions_fold(bufnr) }
      end

      s("v", "<leader>zf", function()
        local bufnr = getbuf()
        local start = v.fn.line("v") - 1
        local finish = v.fn.line(".") - 1
        if start > finish then
          start, finish = finish, start
        end
        custom_folds[bufnr] = custom_folds[bufnr] or {}
        for _, region in ipairs(custom_folds[bufnr]) do
          if region[1] == start and region[2] == finish then
            return
          end
        end
        table.insert(custom_folds[bufnr], { start, finish })
        require("ufo").closeAllFolds()
        require("ufo").openFoldsExceptKinds()
      end, { desc = "Add custom fold (UFO)", silent = true })

      -- Remove all
      s("n", "<leader>zF", function()
        local bufnr = getbuf()
        custom_folds[bufnr] = nil
        require("ufo").closeAllFolds()
        require("ufo").openFoldsExceptKinds()
      end, { desc = "Remove all custom folds (UFO)", silent = true })

      -- Remove under cursor
      s("n", "<leader>zd", function()
        local bufnr = getbuf()
        local linenr = v.fn.line(".") - 1
        local regions = custom_folds[bufnr]
        if regions then
          for i = #regions, 1, -1 do
            local region = regions[i]
            if region[1] <= linenr and linenr <= region[2] then
              table.remove(regions, i)
            end
          end
          if #regions == 0 then
            custom_folds[bufnr] = nil
          end
          require("ufo").closeAllFolds()
          require("ufo").openFoldsExceptKinds()
        end
      end, { desc = "Remove custom fold under cursor (UFO)", silent = true })

      require("ufo").setup({
        fold_virt_text_handler = handler,
        provider_selector = provider_selector,
        open_fold_hl_timeout = 0,
      })

      s("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds with UFO" })
      s("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds with UFO" })
      s("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds with UFO" })
      s("n", "zm", require("ufo").closeFoldsWith, { desc = "Close fold with UFO" })
    end,
  },
}
