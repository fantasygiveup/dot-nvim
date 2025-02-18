vim.opt_local.concealcursor = "nc" -- reveal on insert
vim.opt_local.conceallevel = 0 -- disable conceal by default
vim.opt_local.foldlevel = 99 -- open all folds by default
vim.opt_local.foldnestmax = 1
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.textwidth = 80

-- 1. Do not auto break lines.
-- 2. Turn off autowrap links.
vim.opt_local.formatoptions = "jqln"

-- As most of the time I use zen mode to view/edit markdown files, I do not need the number gutter.
vim.opt_local.relativenumber = false
vim.opt_local.number = false

-- vim.api.nvim_set_hl(0, "@codeblock", { link = "Visual" }) -- custom markdown tree-sitter highlight
