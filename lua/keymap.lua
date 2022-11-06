local M = {}

local api = vim.api
local opts = { noremap = true, silent = true }

-- stylua: ignore start
M.core = function()
  -- Pre. Allows us to map C-c key sequence (see Post below).
  vim.keymap.set("n", "<C-c>", "<Nop>")
  vim.keymap.set("i", "<C-c>", "<Nop>")

  -- Core.
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","
  vim.keymap.set("n", vim.g.mapleader, "")
  vim.keymap.set("x", vim.g.mapleader, "")
  vim.keymap.set("n", ",", "")
  vim.keymap.set("x", ",", "")
  vim.keymap.set("n", vim.g.maplocalleader, "")
  vim.keymap.set("x", vim.g.maplocalleader, "")
  vim.keymap.set("x", "p", "pgvy")
  vim.keymap.set("n", "[f", "<Cmd>cprev<CR>")
  vim.keymap.set("n", "]f", "<Cmd>cnext<CR>")
  vim.keymap.set("n", ",ts", "<Cmd>setlocal spell! spelllang=en_us<CR>")
  vim.keymap.set("n", ",cw", [[<Cmd>keeppatterns %s/\s\+$//e<CR>]])
  vim.keymap.set("n", "X", "<Cmd>lua require'internal'.qf_toggle()<CR>")
  vim.keymap.set("n", "ZZ", "<Cmd>xa<CR>")
  vim.keymap.set("n", "ZQ", "<Cmd>qa!<CR>")

  -- Command line (tcsh style).
  vim.keymap.set("c", "<C-a>", "<Home>")
  vim.keymap.set("c", "<C-f>", "<Right>")
  vim.keymap.set("c", "<C-b>", "<Left>")
  vim.keymap.set("c", "<C-e>", "<End>")
  vim.keymap.set("c", "<C-d>", "<Del>")
  vim.keymap.set("c", "<Esc>b", "<S-Left>")
  vim.keymap.set("c", "<Esc>f", "<S-Right>")
  vim.keymap.set("c", "<C-t>", [[<C-R>=expand("%:p:h") . "/" <CR>]])

  -- Post.
  -- Bind C-c to ESC, also clean up the highlight.
  vim.keymap.set("n", "<C-c>", "<Esc>:noh<CR>", opts)
  vim.keymap.set("i", "<C-c>", "<Esc>:noh<CR>", opts)
end

M.plugins = function()
  -- Plugins.
  vim.keymap.set("n", "<Leader>pc", "<Cmd>PackerCompile<CR>")
  vim.keymap.set("n", "<Leader>ps", "<Cmd>PackerSync<CR>")
  vim.keymap.set("n", "-", "<Cmd>nohlsearch | Lf<CR>")
  vim.keymap.set("n", ",g?", "<Cmd>lua require'gitsigns'.blame_line({full=true})<CR>")
  vim.keymap.set("n", ",gc", "<Cmd>lua require'internal'.git_save_file_remote()<CR>")
  vim.keymap.set("n", "<Leader>hp", "<Cmd>lua require'gitsigns'.preview_hunk()<CR>")
  vim.keymap.set("n", "<Leader>hu", "<Cmd>lua require'gitsigns'.reset_hunk()<CR>")
  vim.keymap.set("n", "<Leader>hs", "<Cmd>lua require'gitsigns'.stage_hunk()<CR>")
  vim.keymap.set("n", "<Leader>hr", "<Cmd>lua require'gitsigns'.reset_buffer()<CR>")
  vim.keymap.set("n", "]c", "<Cmd>lua require'config'.next_hunk()<CR>")
  vim.keymap.set("n", "[c", "<Cmd>lua require'config'.prev_hunk()<CR>")
  vim.keymap.set("n", ",tc", "<Cmd>ColorizerToggle<CR>")
  vim.keymap.set("n", "<C-t>", "<Cmd>lua require'fzf-lua'.files()<CR>")
  vim.keymap.set("n", "<Leader><", "<Cmd>lua require'fzf-lua'.buffers()<CR>")
  vim.keymap.set("n", "<Leader>:", "<Cmd>lua require'fzf-lua'.commands()<CR>")
  vim.keymap.set("n", "<Leader>?", "<Cmd>lua require'fzf-lua'.keymaps()<CR>")
  vim.keymap.set("n", ",fr", "<Cmd>lua require'fzf-lua'.oldfiles()<CR>")
  vim.keymap.set("n", ",#", "<Cmd>lua require'fzf-lua'.filetypes()<CR>")
  vim.keymap.set("n", ",gg", "<Cmd>lua require'fzf-lua'.git_status()<CR>")
  vim.keymap.set("n", ",gh", "<Cmd>lua require'fzf-lua'.git_bcommits()<CR>")
  vim.keymap.set("n", ",r", "<Cmd>lua require'fzf-lua'.resume()<CR>")

  vim.keymap.set("n", "<A-e>", "<Cmd>IconPickerNormal<CR>")
  vim.keymap.set("i", "<A-e>", "<Cmd>IconPickerInsert<CR>")

  vim.keymap.set( "n", ",gu", "<Cmd>lua require'internal'.git_url_at_point()<CR>")
  vim.keymap.set( "v", ",gu", "<Cmd>lua require'internal'.git_url_range()<CR>")
  vim.keymap.set( "n", ",gU", "<Cmd>lua require'internal'.git_url_in_browser()<CR>")

  vim.keymap.set("n", ",do", "<Cmd> lua require'internal'.del_buf_others()<CR>")
  vim.keymap.set("n", ",da", "<Cmd> lua require'internal'.del_buf_all()<CR>")
  vim.keymap.set("n", ",dp", "<Cmd> lua require'internal'.del_buf_current_project()<CR>")

  vim.keymap.set("n", "<Leader>//", "<Cmd>lua require'fzf-lua'.grep_project()<CR>")
  vim.keymap.set("v", "<Leader>//", "<Cmd>lua require'fzf-lua'.grep_visual()<CR>")

  vim.keymap.set("n", "<C-s>", "<Cmd>lua require'internal'.search_notes()<CR>")

  -- Makefile shortcuts.
  vim.keymap.set("n", ",cb", "<Cmd>lua require'internal'.make_build()<CR>")
  vim.keymap.set("n", ",cc", "<Cmd>!make<CR>")
  vim.keymap.set("n", ",ct", "<Cmd>!make test<CR>")
  vim.keymap.set("n", ",cr", "<Cmd>!make run<CR>")
  vim.keymap.set("n", ",cl", "<Cmd>!make lint<CR>")

  vim.keymap.set("n", ",z", "<Cmd>ZenMode<CR>")

  vim.keymap.set("n", "<C-g>", "<Cmd>lua require'fzf_projects'.navigate()<CR>")
  vim.keymap.set("n", "<localleader>b", "<Cmd>Dashboard<CR>")
end
-- stylua: ignore end

M.lsp = function(client, bufnr)
  api.nvim_buf_set_keymap(bufnr, "n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gh", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  api.nvim_buf_set_keymap(bufnr, "i", "<C-h>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gR", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
end

M.core()
M.plugins()

return M
