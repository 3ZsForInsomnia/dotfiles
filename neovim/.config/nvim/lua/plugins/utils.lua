return {
  { "zdcthomas/yop.nvim" },
  { "winston0410/cmd-parser.nvim" },
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "luasnip",
    },
  },
  -- {
  --   "vhyrro/luarocks.nvim",
  --   priority = 1000,
  --   config = true,
  --   opts = {
  --     rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
  --   },
  -- },
  -- {
  --   "rest-nvim/rest.nvim",
  --   ft = "http",
  --   dependencies = { "luarocks.nvim" },
  --   config = function()
  --     require("rest-nvim").setup()
  --   end,
  -- },
  {
    "niuiic/code-shot.nvim",
    event = "VeryLazy",
    dependencies = "niuiic/core.nvim",
    opts = {
      output = function()
        local v = vim
        local sep = package.config:sub(1, 1)
        local basepath = "~" .. sep .. "Documents" .. sep .. "screenshots" .. sep .. "code" .. sep
        local folder = string.match(v.fn.getcwd(), "[^" .. sep .. "]+$") .. sep
        local path = basepath .. folder

        local isok, errstr, errcode = os.rename(path, path)
        if isok == nil then
          os.execute("mkdir " .. path)
        end

        local extension = ".png"

        local now = os.date("%Y-%m-%d_%X")
        local core = require("core")
        local buf_name = core.file.name(v.api.nvim_buf_get_name(0))
        local filename = now .. "_" .. buf_name .. extension

        return path .. filename
      end,
      -- select_area: {s_start: {row: number, col: number}, s_end: {row: number, col: number}} | nil
      options = function(select_area)
        if not select_area then
          return {}
        end
        return {
          "--line-offset",
          select_area.s_start.row,
        }
      end,
    },
  },
}
