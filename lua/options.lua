local vars = require("vars")

local M = {}

M.setup = function()
  vim.o.termguicolors = true
  vim.o.hidden = true -- switch between buffers without having to save first
  vim.o.encoding = "utf-8" -- always use utf-8 whenever possible
  vim.o.clipboard = "unnamedplus"
  vim.o.backup = false
  vim.o.writebackup = false
  vim.o.swapfile = false
  -- Show non-printable characters.
  vim.o.list = true
  vim.o.listchars = "tab:  ,nbsp:+,trail:,extends:→,precedes:←"
  vim.o.showmode = false -- don't show current mode in command-line
  vim.o.autoindent = true -- indent according to previous line
  vim.o.expandtab = true -- use spaces instead of tabs
  vim.o.tabstop = 4 -- spaces per tab
  vim.o.softtabstop = 4 -- tab key indents by 4 spaces
  vim.o.shiftwidth = 4 -- indents by 4 spaces
  vim.o.shiftround = true -- >> indents to next multiple of 'shiftwidth'
  -- Preserve undo state.
  vim.o.undodir = vars.undo_dir
  vim.o.ruler = false -- don't show buffer info bottom screen
  vim.o.pumheight = 15
  vim.o.showtabline = 0
  vim.o.virtualedit = "onemore"
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.laststatus = 3
  -- 1. Do not auto break lines.
  -- 2. Turn off autowrap links.
  vim.o.formatoptions = vim.o.formatoptions:gsub("t", ""):gsub("c", "")
  vim.o.grepprg = "rg --hidden --vimgrep --smart-case --"
  vim.o.wrap = false
  vim.o.textwidth = 80
  vim.o.cursorline = true
  vim.o.foldenable = true
  vim.o.signcolumn = "yes"
  vim.o.number = false
  vim.o.undofile = true
  vim.o.spellfile = vars.cache_dir .. "spell/en.uft-8.add"
  vim.o.updatetime = 500 -- used by vim.lsp.buf.document_highlight()
  vim.o.autoread = true -- informed when changed outside
  vim.o.completeopt = "menu,menuone,noselect"
end

return M
