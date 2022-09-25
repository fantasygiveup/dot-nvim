local M = {}

local api = vim.api
local opts = { noremap = true, silent = true }
local optsn = { noremap = true }
local bind = api.nvim_set_keymap

M.core = function()
  -- Pre. Allows us to map C-c key sequence (see Post below).
  bind("n", "<C-c>", "<Nop>", optsn)
  bind("n", "<C-z>", "<Nop>", optsn)
  bind("i", "<C-c>", "<Nop>", optsn)

  -- Core.
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","
  bind("n", vim.g.mapleader, "", optsn)
  bind("x", vim.g.mapleader, "", optsn)
  bind("n", ",", "", optsn)
  bind("x", ",", "", optsn)
  bind("n", vim.g.maplocalleader, "", optsn)
  bind("x", vim.g.maplocalleader, "", optsn)
  bind("x", "p", "pgvy", opts)
  bind("n", "[f", "<Cmd>cprev<CR>", opts)
  bind("n", "]f", "<Cmd>cnext<CR>", opts)
  bind("n", ",ts", "<Cmd>setlocal spell! spelllang=en_us<CR>", opts)
  bind("n", ",cw", [[<Cmd>keeppatterns %s/\s\+$//e<CR>]], opts)
  bind("n", "X", "<Cmd>lua require'internal'.qf_toggle()<CR>", opts)
  bind("n", "ZZ", "<Cmd>xa<CR>", opts)
  bind("n", "ZQ", "<Cmd>qa!<CR>", opts)

  -- Command line (tcsh style).
  bind("c", "<C-a>", "<Home>", optsn)
  bind("c", "<C-f>", "<Right>", optsn)
  bind("c", "<C-b>", "<Left>", optsn)
  bind("c", "<C-e>", "<End>", optsn)
  bind("c", "<C-d>", "<Del>", optsn)
  bind("c", "<Esc>b", "<S-Left>", optsn)
  bind("c", "<Esc>f", "<S-Right>", optsn)
  bind("c", "<C-t>", [[<C-R>=expand("%:p:h") . "/" <CR>]], optsn)

  -- Post.
  -- Bind C-c to ESC, also clean up the highlight.
  bind("n", "<C-c>", "<Esc>:noh<CR>", opts)
  bind("i", "<C-c>", "<Esc>:noh<CR>", opts)
end

M.plugins = function()
  -- Plugins.
  bind("n", "<Leader>pc", "<Cmd>PackerCompile<CR>", opts)
  bind("n", "<Leader>ps", "<Cmd>PackerSync<CR>", opts)
  bind("n", "-", "<Cmd>nohlsearch | Lf<CR>", opts)
  bind("n", ",g?", "<Cmd>lua require'gitsigns'.blame_line({full=true})<CR>", opts)
  bind(
    "n",
    ",gu",
    "<Cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.copy_to_clipboard})<CR>",
    opts
  )
  bind(
    "v",
    ",gu",
    "<Cmd>lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.copy_to_clipboard})<CR>",
    opts
  )
  bind(
    "n",
    ",gU",
    "<Cmd>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
    opts
  )
  bind("n", ",gc", "<Cmd>lua require'internal'.git_save_file_remote()<CR>", opts)
  bind("n", "<Leader>hp", "<Cmd>lua require'gitsigns'.preview_hunk()<CR>", opts)
  bind("n", "<Leader>hu", "<Cmd>lua require'gitsigns'.reset_hunk()<CR>", opts)
  bind("n", "<Leader>hs", "<Cmd>lua require'gitsigns'.stage_hunk()<CR>", opts)
  bind("n", "<Leader>hr", "<Cmd>lua require'gitsigns'.reset_buffer()<CR>", opts)
  bind("n", "]c", "<Cmd>lua require'config'.next_hunk()<CR>", opts)
  bind("n", "[c", "<Cmd>lua require'config'.prev_hunk()<CR>", opts)
  bind("n", ",tc", "<Cmd>ColorizerToggle<CR>", optsn)
  bind("n", "<C-t>", "<Cmd>lua require'fzf-lua'.files()<CR>", optsn)
  bind("n", "<Leader><", "<Cmd>lua require'fzf-lua'.buffers()<CR>", optsn)
  bind("n", "<Leader>//", ":<C-U>lua require'fzf-lua'.grep_project()<CR>", opts)
  bind("v", "<Leader>//", ":<C-U>lua require'fzf-lua'.grep_visual()<CR>", opts)
  bind("n", "<Leader>:", "<Cmd>lua require'fzf-lua'.commands()<CR>", optsn)
  bind("n", "<Leader>?", "<Cmd>lua require'fzf-lua'.keymaps()<CR>", optsn)
  bind("n", ",fr", "<Cmd>lua require'fzf-lua'.oldfiles()<CR>", optsn)
  bind("n", ",#", "<Cmd>lua require'fzf-lua'.filetypes()<CR>", optsn)
  bind("n", ",gh", "<Cmd>lua require'fzf-lua'.git_bcommits()<CR>", opts)
  bind("n", ",gg", "<Cmd>LazyGit<CR>", optsn)
  bind("n", ",gl", "<Cmd>LazyGitFilter<CR>", optsn)
  bind("n", ",r", "<Cmd>lua require'fzf-lua'.resume()<CR>", optsn)
  bind(
    "n",
    "<C-s>",
    [[<Cmd>lua require'fzf-lua'.grep_project({cwd = require'global'.notes_dir})<CR>]],
    opts
  )
  vim.keymap.set("n", ",do", function()
    require("close_buffers").wipe({ type = "other", force = true })
  end)
  vim.keymap.set("n", ",da", function()
    require("close_buffers").wipe({ type = "all", force = true })
  end)
  vim.keymap.set("n", ",dp", function()
    local project_root = require("project_nvim.project").get_project_root()
    require("close_buffers").wipe({ regex = project_root, force = true })
  end)
  vim.keymap.set("n", ",e", "<Cmd>IconPickerNormal<CR>")
end

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
