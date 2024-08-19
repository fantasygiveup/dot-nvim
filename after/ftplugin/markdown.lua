vim.opt_local.concealcursor = "nc" -- reveal on insert
vim.opt_local.conceallevel = 0 -- disable conceal by default
vim.opt_local.foldlevel = 0 -- close all folds by default
vim.opt_local.foldnestmax = 3
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.textwidth = 80
-- 1. Do not auto break lines.
-- 2. Turn off autowrap links.
vim.opt_local.formatoptions = "jqln"
-- vim.api.nvim_set_hl(0, "@codeblock", { link = "Visual" }) -- custom markdown tree-sitter highlight
