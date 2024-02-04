vim.opt_local.concealcursor = "nc" -- reveal on insert
vim.opt_local.conceallevel = 2
vim.opt_local.foldlevel = 0 -- close all folds by default
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.api.nvim_set_hl(0, "@codeblock", { link = "Visual" }) -- custom markdown tree-sitter highlight
