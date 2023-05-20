local M = {}

M.config = function()
  local ok, lf = pcall(require, "lf")
  if not ok then
    return
  end

  vim.g.lf_netrw = 1
  vim.g.lf_replace_netrw = 1 -- use lf over netrw

  lf.setup({
    border = "none",
    width = 1000,
    height = 1000,
    winblend = 0, -- disable transparency
    highlights = {
      NormalFloat = { link = "Normal" },
    },
    mappings = false,
  })

  vim.keymap.set("n", "-", "<cmd>nohlsearch | Lf<cr>")
end

return M
