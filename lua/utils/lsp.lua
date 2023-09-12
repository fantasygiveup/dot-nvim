local M = {}

M.lsp_diagnostic_keymap = function(bufnr)
  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "]d",
    "<cmd>lua vim.diagnostic.goto_next({ severity = require'vars'.diagnostic_severity })<cr>",
    opts
  )
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "[d",
    "<cmd>lua vim.diagnostic.goto_prev({ severity = require'vars'.diagnostic_severity })<cr>",
    opts
  )
end

return M
