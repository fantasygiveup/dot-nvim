local nsopts = { noremap = true, silent = true }
local nopts = { noremap = true }
local keybind = vim.api.nvim_set_keymap

-- Pre. Allows us to map C-c key sequence (see Post below).
keybind("n", "<C-c>", "<Nop>", nopts)
keybind("n", "<C-z>", "<Nop>", nopts)
keybind("i", "<C-c>", "<Nop>", nopts)

-- Core.
vim.g.mapleader = " "
vim.g.maplocalleader = ","
keybind("n", vim.g.mapleader, "", nopts)
keybind("x", vim.g.mapleader, "", nopts)
keybind("n", ",", "", nopts)
keybind("x", ",", "", nopts)
keybind("n", vim.g.maplocalleader, "", nopts)
keybind("x", vim.g.maplocalleader, "", nopts)
keybind("n", "[f", "<Cmd>cprev<CR>", nsopts)
keybind("n", "]f", "<Cmd>cnext<CR>", nsopts)
keybind("n", ",ts", "<Cmd>setlocal spell! spelllang=en_us<CR>", nsopts)
keybind("n", ",cw", [[<Cmd>keeppatterns %s/\s\+$//e<CR>]], nsopts)
keybind("n", "X", "<Cmd>lua require'internal'.qf_toggle()<CR>", nsopts)
keybind("n", "ZZ", "<Cmd>xa<CR>", nsopts)
keybind("n", "ZQ", "<Cmd>qa!<CR>", nsopts)

-- Command line (tcsh style).
keybind("c", "<C-a>", "<Home>", nopts)
keybind("c", "<C-f>", "<Right>", nopts)
keybind("c", "<C-b>", "<Left>", nopts)
keybind("c", "<C-e>", "<End>", nopts)
keybind("c", "<C-d>", "<Del>", nopts)
keybind("c", "<Esc>b", "<S-Left>", nopts)
keybind("c", "<Esc>f", "<S-Right>", nopts)
keybind("c", "<C-t>", [[<C-R>=expand("%:p:h") . "/" <CR>]], nopts)

-- Plugins.
keybind("n", "<Leader>pc", "<Cmd>PackerCompile<CR>", nsopts)
keybind("n", "<Leader>ps", "<Cmd>PackerSync<CR>", nsopts)
keybind("n", "-", "<Cmd>nohlsearch | Lf<CR>", nsopts)
keybind("n", ",g?", "<Cmd>lua require'gitsigns'.blame_line({full=true})<CR>", nsopts)
keybind(
  "n",
  ",gu",
  "<Cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.copy_to_clipboard})<CR>",
  nsopts
)
keybind(
  "v",
  ",gu",
  "<Cmd>lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.copy_to_clipboard})<CR>",
  nsopts
)
keybind(
  "n",
  ",gU",
  "<Cmd>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
  nsopts
)
keybind("n", ",gc", "<Cmd>lua require'internal'.git_save_file_remote()<CR>", nsopts)
keybind("n", "<Leader>hp", "<Cmd>lua require'gitsigns'.preview_hunk()<CR>", nsopts)
keybind("n", "<Leader>hu", "<Cmd>lua require'gitsigns'.reset_hunk()<CR>", nsopts)
keybind("n", "<Leader>hs", "<Cmd>lua require'gitsigns'.stage_hunk()<CR>", nsopts)
keybind("n", "<Leader>hr", "<Cmd>lua require'gitsigns'.reset_buffer()<CR>", nsopts)
keybind("n", "]c", "<Cmd>lua require'config'.next_hunk()<CR>", nsopts)
keybind("n", "[c", "<Cmd>lua require'config'.prev_hunk()<CR>", nsopts)
keybind("n", ",tc", "<Cmd>ColorizerToggle<CR>", nopts)
keybind("n", "<C-t>", "<Cmd>lua require'fzf-lua'.files()<CR>", nopts)
keybind("n", "<Leader><", "<Cmd>lua require'fzf-lua'.buffers()<CR>", nopts)
keybind("n", "<Leader>//", ":<C-U>lua require'fzf-lua'.grep_project()<CR>", nsopts)
keybind("v", "<Leader>//", ":<C-U>lua require'fzf-lua'.grep_visual()<CR>", nsopts)
keybind("n", "<Leader>:", "<Cmd>lua require'fzf-lua'.commands()<CR>", nopts)
keybind("n", "<Leader>?", "<Cmd>lua require'fzf-lua'.keymaps()<CR>", nopts)
keybind("n", ",fr", "<Cmd>lua require'fzf-lua'.oldfiles()<CR>", nopts)
keybind("n", ",#", "<Cmd>lua require'fzf-lua'.filetypes()<CR>", nopts)
keybind("n", ",gg", "<Cmd>lua require'fzf-lua'.git_status()<CR>", nopts)
keybind("n", ",gb", "<Cmd>lua require'fzf-lua'.git_bcommits()<CR>", nopts)
keybind("n", ",r", "<Cmd>lua require'fzf-lua'.resume()<CR>", nopts)
keybind(
  "n",
  "<C-s>",
  [[<Cmd>lua require'fzf-lua'.grep_project({cwd = require'global'.notes_dir})<CR>]],
  nsopts
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
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

-- Post.
-- Bind C-c to ESC, also clean up the highlight.
keybind("n", "<C-c>", "<Esc>:noh<CR>", nsopts)
keybind("i", "<C-c>", "<Esc>:noh<CR>", nsopts)
