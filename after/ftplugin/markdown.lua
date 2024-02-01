vim.wo.concealcursor = "nc" -- reveal on insert
vim.wo.conceallevel = 2
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
