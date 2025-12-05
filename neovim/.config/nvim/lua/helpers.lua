local k_set = vim.keymap.set

local M = {}

M.k = function(args)
  if not args then
    return
  end
  if args.mode == nil then
    args.mode = "n"
  end

  k_set(args.mode, args.key, args.action, { desc = args.desc, noremap = true, silent = true })
end

M.k_cmd = function(args)
  if not args then
    return
  end
  if args.mode == nil then
    args.mode = "n"
  end

  k_set(args.mode, args.key, "<cmd>" .. args.action .. "<cr>", { desc = args.desc, noremap = true, silent = true })
end

return M
