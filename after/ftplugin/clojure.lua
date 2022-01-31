local nsopts = { noremap = true, silent = true }
vim.api.nvim_buf_set_keymap(0, "n", "gd", "<Cmd>ConjureDefWord<CR>", nsopts)
