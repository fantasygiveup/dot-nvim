local M = {}

M.config = function(use)
  use({
    "lmburns/lf.nvim",
    requires = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    config = M.file_manager_setup,
  })
end

M.file_manager_setup = function()
  local ok, lf = pcall(require, "lf")
  if not ok then
    return
  end

  vim.g.loaded_netrw = 1 -- required by nvim-tree file_manager.lua
  vim.g.loaded_netrwPlugin = 1 -- required by nvim-tree file_manager.lua
  vim.g.lf_netrw = 1
  vim.g.lf_replace_netrw = 1 -- use lf over netrw

  lf.setup({
    border = "double",
    winblend = 0, -- disable transparency
    highlights = {
      NormalFloat = { link = "Normal" },
    },
    mappings = false,
  })

  vim.keymap.set("n", "-", "<cmd>nohlsearch | Lf<cr>")
end

return M
