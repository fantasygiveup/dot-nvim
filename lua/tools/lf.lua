local M = {}

M.setup = function(use)
  use({ "illia-danko/lf.vim", requires = { "rbgrouleff/bclose.vim" }, config = M.lf_setup })
end

M.lf_setup = function()
  vim.g.lf_replace_netrw = 1 -- use lf over netrw
  vim.g.lf_map_keys = 0

  vim.keymap.set("n", "-", "<cmd>nohlsearch | Lf<cr>")
end

return M
