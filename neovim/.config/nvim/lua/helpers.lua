local k_set = vim.keymap.set

local M = {}

M.k = function(args)
  if not args then
    return
  end

  k_set(args.mode or "n", args.key, args.action, { desc = args.desc, noremap = true, silent = true })
end

M.k_cmd = function(args)
  if not args then
    return
  end

  k_set(
    args.mode or "n",
    args.key,
    "<cmd>" .. args.action .. "<cr>",
    { desc = args.desc, noremap = true, silent = true }
  )
end

return M
