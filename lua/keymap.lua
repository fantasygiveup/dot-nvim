local M = {}

local api = vim.api
local opts = { noremap = true, silent = true }

-- stylua: ignore start
M.core = function()
  -- Pre. Allows us to map C-c key sequence (see Post below).
  vim.keymap.set("n", "<c-c>", "<nop>")
  vim.keymap.set("i", "<c-c>", "<nop>")

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
  vim.keymap.set("n", "[f", "<cmd>cprev<cr>")
  vim.keymap.set("n", "]f", "<cmd>cnext<cr>")
  vim.keymap.set("n", "<localleader>ts", "<cmd>setlocal spell! spelllang=en_us<cr>")
  vim.keymap.set("n", "<localleader>cw", [[<cmd>keeppatterns %s/\s\+$//e<cr>]])
  vim.keymap.set("n", "X", "<cmd>lua require'internal'.qf_toggle()<cr>")
  vim.keymap.set("n", "ZZ", "<cmd>xa<cr>")
  vim.keymap.set("n", "ZQ", "<cmd>qa!<cr>")

  -- Command line (tcsh style).
  vim.keymap.set("c", "<c-a>", "<home>")
  vim.keymap.set("c", "<c-f>", "<right>")
  vim.keymap.set("c", "<c-b>", "<left>")
  vim.keymap.set("c", "<c-e>", "<end>")
  vim.keymap.set("c", "<c-d>", "<del>")
  vim.keymap.set("c", "<esc>b", "<s-left>")
  vim.keymap.set("c", "<esc>f", "<s-right>")
  vim.keymap.set("c", "<c-t>", [[<c-r>=expand("%:p:h") . "/" <cr>]])

  -- Insert mode (tcsh style).
  vim.keymap.set("i", "<a-b>", "<c-o>b")
  vim.keymap.set("i", "<a-f>", "<c-o>w")
  vim.keymap.set("i", "<a-d>", "<c-o>dw")
  vim.keymap.set("i", "<c-y>", "<c-o>gP")
  vim.keymap.set("i", "<c-w>", "<c-o>db")
  vim.keymap.set("i", "<c-k>", "<c-o>D")
  vim.keymap.set("i", "<c-a>", "<c-o>0")
  vim.keymap.set("i", "<c-e>", "<c-o>$")
  vim.keymap.set("i", "<c-_>", "<c-o>u") -- [C-/] to undo
  vim.keymap.set("i", "<c-d>", "<del>")
  vim.keymap.set("i", "<c-u>", "<c-g>u<c-u>")
  vim.keymap.set("i", "<c-b>", "<left>")
  vim.keymap.set("i", "<c-f>", "<right>")
  vim.keymap.set("i", "<c-p>", "<up>")
  vim.keymap.set("i", "<c-n>", "<down>")

  -- Post.
  -- Bind C-c to ESC, also clean up the highlight.
  vim.keymap.set("n", "<c-c>", "<esc>:noh<cr>", opts)
  vim.keymap.set("i", "<c-c>", "<esc>:noh<cr>", opts)
end

M.plugins = function()
  -- Plugins.
  vim.keymap.set("n", "<leader>pc", "<cmd>PackerCompile<cr>")
  vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>")
  vim.keymap.set("n", "-", "<cmd>nohlsearch | Lf<cr>")
  vim.keymap.set("n", "<localleader>g?", "<cmd>lua require'gitsigns'.blame_line({full=true})<cr>")
  vim.keymap.set("n", "<localleader>gc", "<cmd>lua require'internal'.git_save_file_remote()<cr>")
  vim.keymap.set("n", "<leader>hp", "<cmd>lua require'gitsigns'.preview_hunk()<cr>")
  vim.keymap.set("n", "<leader>hu", "<cmd>lua require'gitsigns'.reset_hunk()<cr>")
  vim.keymap.set("n", "<leader>hs", "<cmd>lua require'gitsigns'.stage_hunk()<cr>")
  vim.keymap.set("n", "<leader>hr", "<cmd>lua require'gitsigns'.reset_buffer()<cr>")
  vim.keymap.set("n", "]c", "<cmd>lua require'config'.next_hunk()<cr>")
  vim.keymap.set("n", "[c", "<cmd>lua require'config'.prev_hunk()<cr>")
  vim.keymap.set("n", "<localleader>tc", "<cmd>ColorizerToggle<cr>")
  vim.keymap.set("n", "<C-t>", "<cmd>lua require'fzf-lua'.files()<cr>")
  vim.keymap.set("n", "<localleader>b", "<cmd>lua require'fzf-lua'.buffers()<cr>")
  vim.keymap.set("n", "<leader>:", "<cmd>lua require'fzf-lua'.commands()<cr>")
  vim.keymap.set("n", "<leader>?", "<cmd>lua require'fzf-lua'.keymaps()<cr>")
  vim.keymap.set("n", "<localleader>fr", "<cmd>lua require'fzf-lua'.oldfiles()<cr>")
  vim.keymap.set("n", ",#", "<cmd>lua require'fzf-lua'.filetypes()<cr>")
  vim.keymap.set("n", "<localleader>gg", "<cmd>lua require'fzf-lua'.git_status()<cr>")
  vim.keymap.set("n", "<localleader>gh", "<cmd>lua require'fzf-lua'.git_bcommits()<cr>")
  vim.keymap.set("n", "<localleader>r", "<cmd>lua require'fzf-lua'.resume()<cr>")

  vim.keymap.set("n", "<a-e>", "<cmd>IconPickerNormal<cr>")
  vim.keymap.set("i", "<a-e>", "<cmd>IconPickerInsert<cr>")

  vim.keymap.set( "n", "<localleader>gu", "<cmd>lua require'internal'.git_url_at_point()<cr>")
  vim.keymap.set( "v", "<localleader>gu", "<cmd>lua require'internal'.git_url_range()<cr>")
  vim.keymap.set( "n", "<localleader>gU", "<cmd>lua require'internal'.git_url_in_browser()<cr>")

  vim.keymap.set("n", "<leader>ko", "<cmd>lua require'internal'.del_buf_others()<cr>")
  vim.keymap.set("n", "<leader>ka", "<cmd>lua require'internal'.del_buf_all()<cr>")
  vim.keymap.set("n", "<leader>kp", "<cmd>lua require'internal'.del_buf_current_project()<cr>")

  vim.keymap.set("n", "<leader>//", "<cmd>lua require'fzf-lua'.grep_project()<cr>")
  vim.keymap.set("v", "<leader>//", "<cmd>lua require'fzf-lua'.grep_visual()<cr>")

  vim.keymap.set("n", "<c-s>", "<cmd>lua require'internal'.search_notes()<cr>")

  -- Makefile shortcuts.
  vim.keymap.set("n", "<localleader>cb", "<cmd>lua require'internal'.make_build()<cr>")
  vim.keymap.set("n", "<localleader>cc", "<cmd>!make<cr>")
  vim.keymap.set("n", "<localleader>ct", "<cmd>!make test<cr>")
  vim.keymap.set("n", "<localleader>cr", "<cmd>!make run<cr>")
  vim.keymap.set("n", "<localleader>cl", "<cmd>!make lint<cr>")

  vim.keymap.set("n", "<localleader>z", "<cmd>lua require'internal'.zen_mode_textwidth()<cr>")
  vim.keymap.set("n", "<c-g>", "<cmd>lua require'fzf_projects'.navigate()<cr>")
  vim.keymap.set("n", "<leader>m", "<cmd>Dashboard<cr>")
  vim.keymap.set("n", "<localleader>fn", "<cmd>DashboardNewFile<cr>")
  vim.keymap.set("n", "<leader><Space>", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
  vim.keymap.set("n", "<localleader>dt", "<cmd>lua require'dap'.terminate(); require'dap'.clear_breakpoints()<cr>")
  vim.keymap.set("n", "<localleader>dc", "<cmd>lua require'dap'.continue()<cr>")
  vim.keymap.set("n", "<localleader>dn", "<cmd>lua require'dap'.step_over()<cr>")
  vim.keymap.set("n", "<localleader>di", "<cmd>lua require'dap'.step_into()<cr>")
  vim.keymap.set("n", "<localleader>du", "<cmd>lua require'dapui'.toggle()<cr>")
  vim.keymap.set("v", "<localleader>de", "<cmd>lua require'dapui'.eval(); vim.fn.feedkeys('v')<cr>")
end
-- stylua: ignore end

M.lsp = function(client, bufnr)
  api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  api.nvim_buf_set_keymap(bufnr, "i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  api.nvim_buf_set_keymap(bufnr, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
end

M.core()
M.plugins()

return M
