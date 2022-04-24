local nsopts = { noremap = true, silent = true }
local nopts = { noremap = true }
local keybind = vim.api.nvim_set_keymap

-- Pre. Allows us to map C-c key sequence (see Post below).
keybind("n", "<C-c>", "<Nop>", nopts)
keybind("i", "<C-c>", "<Nop>", nopts)

-- Core.
vim.g.mapleader = " "
vim.g.maplocalleader = ","
keybind("n", vim.g.mapleader, "", nopts)
keybind("x", vim.g.mapleader, "", nopts)
keybind("n", vim.g.maplocalleader, "", nopts)
keybind("x", vim.g.maplocalleader, "", nopts)
keybind("x", "p", "pgvy", nopts) -- don't override register on visual
keybind("n", "[f", "<Cmd>cprev<CR>", nsopts)
keybind("n", "]f", "<Cmd>cnext<CR>", nsopts)
keybind("n", "<Leader>ts", "<Cmd>setlocal spell! spelllang=en_us<CR>", nsopts)
keybind("n", "<Leader>cw", [[<Cmd>keeppatterns %s/\s\+$//e<CR>]], nsopts)

-- Emacs/tcsh style compatible keybindings.
keybind("i", "<A-b>", "<C-o>b", nopts)
keybind("i", "<A-f>", "<C-o>w", nopts)
keybind("i", "<A-d>", "<C-o>dw", nopts)
keybind("i", "<C-y>", "<C-o>gP", nopts)
keybind("i", "<C-w>", "<C-o>db", nopts)
keybind("i", "<C-k>", "<C-o>D", nopts)
keybind("i", "<C-a>", "<C-o>0", nopts)
keybind("i", "<C-e>", "<C-o>$", nopts)
keybind("i", "<C-_>", "<C-o>u", nopts) -- [C-/] to undo
keybind("i", "<C-d>", "<Del>", nopts)
keybind("i", "<C-u>", "<C-g>u<C-u>", nopts)
keybind("i", "<C-b>", "<Left>", nopts)
keybind("i", "<C-f>", "<Right>", nopts)
keybind("i", "<C-p>", "<Up>", nopts)
keybind("i", "<C-n>", "<Down>", nopts)

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
keybind("n", "-", "<Cmd>Lf<CR>", nsopts)
keybind("n", "<C-t>", "<Cmd>FzfFiles<CR>", nsopts)
keybind("n", "<Leader><", "<Cmd>FzfBuffers<CR>", nsopts)
keybind("n", "<Leader>//", "<Cmd>FzfRg<CR>", nsopts)
keybind("v", "<Leader>//", [[:<C-U>exec 'FzfRg ' . luaeval('require"internal".visual_selection()')<CR>]], nsopts)
keybind("n", "<Leader>?", "<Cmd>FzfMaps<CR>", nsopts)
keybind("n", "<Leader>:", "<Cmd>FzfCommands<CR>", nsopts)
keybind("n", "<Leader>#", "<Cmd>FzfFiletypes<CR>", nsopts)
keybind("n", "<Leader>gg", "<Cmd>Gina status<CR>", nsopts)
keybind("n", "<Leader>gl", ":exec 'Gina log ' . expand('%')<CR>", nsopts)
keybind("n", "<Leader>g?", "<Cmd>lua require'gitsigns'.blame_line({full=true})<CR>", nsopts)
keybind("n", "<leader>gu", "<Cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.copy_to_clipboard})<CR>", nsopts)
keybind("v", "<leader>gu", "<Cmd>lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.copy_to_clipboard})<CR>", nsopts)
keybind("n", "<leader>gU", "<Cmd>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>", nsopts)
keybind("n", "<Leader>hp", "<Cmd>lua require'gitsigns'.preview_hunk()<CR>", nsopts)
keybind("n", "<Leader>hu", "<Cmd>lua require'gitsigns'.reset_hunk()<CR>", nsopts)
keybind("n", "<Leader>hs", "<Cmd>lua require'gitsigns'.stage_hunk()<CR>", nsopts)
keybind("n", "<Leader>hr", "<Cmd>lua require'gitsigns'.reset_buffer()<CR>", nsopts)
keybind("n", "]c", "<Cmd>lua require'config'.next_hunk()<CR>", nsopts)
keybind("n", "[c", "<Cmd>lua require'config'.prev_hunk()<CR>", nsopts)
keybind("n", "]d", "<Cmd>ALENext<CR>", nsopts)
keybind("n", "[d", "<Cmd>ALEPrevious<CR>", nsopts)
keybind("n", "<Leader>tl", "<Cmd>lua require'config'.toggle_diagnostics_sign()<CR>", nsopts)
keybind("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", nsopts)
keybind("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", nsopts)
keybind("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", nsopts)
keybind("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", nsopts)
keybind("n", "<C-s>", "<Cmd>FzfNotes<CR>", nsopts)
keybind("n", "<Leader>tc", "<Cmd>ColorizerToggle<CR>", nopts)
keybind("n", "s(", [[<Cmd>lua require'config'.sandwich_surround('(')<CR>]], nsopts)
keybind("n", "s[", [[<Cmd>lua require'config'.sandwich_surround('[')<CR>]], nsopts)
keybind("n", "s{", [[<Cmd>lua require'config'.sandwich_surround('{')<CR>]], nsopts)
keybind("n", "s'", [[<Cmd>lua require'config'.sandwich_surround("'")<CR>]], nsopts)
keybind("n", 's"', [[<Cmd>lua require'config'.sandwich_surround('"')<CR>]], nsopts)
keybind("n", "s`", [[<Cmd>lua require'config'.sandwich_surround('`')<CR>]], nsopts)

-- Post.
-- Bind C-c to ESC, also clean up the highlight.
keybind("n", "<C-c>", "<Esc>:noh<CR>", nsopts)
keybind("i", "<C-c>", "<Esc>:noh<CR>", nsopts)
