vim.opt_local.concealcursor = "nc" -- reveal on insert
vim.opt_local.conceallevel = 2
vim.opt_local.foldlevel = 0 -- close all folds by default
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"

function _G.custom_markdown_fold(limit)
  local limit = limit or 32
  return vim.fn.getline(vim.v.foldstart):sub(1, limit - 3) .. "..."
end

vim.opt_local.foldtext = "v:lua.custom_markdown_fold()"

-- vim.api.nvim_set_hl(0, "@codeblock", { link = "Visual" }) -- custom markdown tree-sitter highlight
