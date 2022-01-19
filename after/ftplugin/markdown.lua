local nsopts = { noremap = true, silent = true }
vim.api.nvim_buf_set_keymap(0, "n", "<Leader>op", "<Cmd>MarkdownPreview<CR>", nsopts)
vim.o.conceallevel = 1 -- turn on conceal feature
