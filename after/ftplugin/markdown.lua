vim.wo.concealcursor = "nc" -- reveal on insert
vim.wo.conceallevel = 2
vim.wo.foldenable = true
vim.wo.foldlevel = 0 -- close all folds by default
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.api.nvim_set_hl(0, "@codeblock", { link = "Visual" }) -- custom markdown tree-sitter highlight
