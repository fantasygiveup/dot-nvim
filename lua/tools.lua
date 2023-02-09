local M = {}

M.setup = function(use)
  use({ "ziontee113/icon-picker.nvim", config = M.icon_picker })
  use({ "illia-danko/lf.vim", requires = { "rbgrouleff/bclose.vim" }, config = M.lf })
  use({ "norcalli/nvim-colorizer.lua", config = M.colorizer })
end

M.icon_picker = function()
  local ok, icon_picker = pcall(require, "icon-picker")
  if not ok then
    return
  end

  icon_picker.setup({})

  vim.keymap.set("n", "<a-e>", "<cmd>IconPickerNormal<cr>")
  vim.keymap.set("i", "<a-e>", "<cmd>IconPickerInsert<cr>")
end

M.lf = function()
  vim.g.lf_replace_netrw = 1 -- use lf over netrw
  vim.g.lf_map_keys = 0

  vim.keymap.set("n", "-", "<cmd>nohlsearch | Lf<cr>")
end

M.colorizer = function()
  local ok, colorizer = pcall(require, "colorizer")
  if not ok then
    return
  end

  colorizer.setup({
    DEFAULT_OPTIONS = { names = false },
  })

  vim.keymap.set("n", "<localleader>tc", "<cmd>ColorizerToggle<cr>")
end

return M
