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

-- stylua: ignore start
M.plugins = function()
  -- Plugins.
  vim.keymap.set("n", "<localleader>tc", "<cmd>ColorizerToggle<cr>")

  vim.keymap.set("n", "<localleader>do", "<cmd>lua require'internal'.del_buf_others()<cr>")
  vim.keymap.set("n", "<localleader>d#", "<cmd>lua require'internal'.del_buf_all()<cr>")
  vim.keymap.set("n", "<localleader>dp", "<cmd>lua require'internal'.del_buf_current_project()<cr>")

  vim.keymap.set("n", "<localleader>z", "<cmd>lua require'internal'.zen_mode()<cr>")

  vim.keymap.set("n", "<leader>od", "<cmd>lua require'notes'.diary_new_entry()<cr>")
  vim.keymap.set("n", "<leader>oy", "<cmd>lua require'notes'.diary_open_file()<cr>")
  vim.keymap.set("n", "<leader>ot", "<cmd>lua require'notes'.todos_new_entry()<cr>")
  vim.keymap.set("n", "<leader>os", "<cmd>lua require'notes'.todos_open_file()<cr>")
end
-- stylua: ignore end

M.core()
M.plugins()

return M
