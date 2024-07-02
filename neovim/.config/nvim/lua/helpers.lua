local k = vim.api.nvim_set_keymap

local M = {}

M.v = k

M.k = function(args)
  if not args then
    return
  end
  if args.mode == nil then
    args.mode = "n"
  end

  k(args.mode, args.key, args.action, { desc = args.desc, noremap = true, silent = true })
end

M.k_cmd = function(args)
  if not args then
    return
  end
  if args.mode == nil then
    args.mode = "n"
  end

  k(args.mode, args.key, "<cmd>" .. args.action .. "<cr>", { desc = args.desc, noremap = true, silent = true })
end

return M
