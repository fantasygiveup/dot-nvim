local vars = {}

local home = os.getenv("HOME")
local path_sep = vars.is_windows and "\\" or "/"
local os_name = vim.loop.os_uname().sysname
local user_repo = home .. path_sep .. "github.com" .. path_sep .. "fantasygiveup" .. path_sep
local notes_dir_name = "zettelkasten"
local notes_dir_path = user_repo .. notes_dir_name
local cache_dir = home .. path_sep .. ".cache" .. path_sep .. "nvim" .. path_sep
local undo_dir = home .. path_sep .. ".cache" .. path_sep .. "undo" .. path_sep

function vars:load_variables()
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
  vim.g.omni_sql_no_default_maps = 1

  -- Custom.
  self.is_mac = os_name == "Darwin"
  self.is_linux = os_name == "Linux"
  self.is_windows = os_name == "Windows"
  self.vim_path = vim.fn.stdpath("config")
  self.cache_dir = cache_dir
  self.notes_dir_name = notes_dir_name
  self.notes_dir_path = notes_dir_path
  self.scratchpad_file = cache_dir .. "scratchpad.txt"
  self.undo_dir = undo_dir
  self.modules_dir = self.vim_path .. path_sep .. "modules"
  self.path_sep = path_sep
  self.home = home
  self.user_name = "Illia Danko"
  self.diagnostic_severity = vim.diagnostic.severity.ERROR
  self.rg_opts = "--column --line-number --no-heading --color=always --colors='match:none' --smart-case --max-columns=512 --hidden "
    .. (vim.env.RIPGREP_IGNORE_SEARCH_FILTER or "") -- ignore the missing value in restricted environments
  self.fleeting_notes = notes_dir_path .. path_sep .. "sm9z.md"
end

function vars:ensure_dir()
  local data_dir = {
    self.undo_dir,
  }

  if vim.fn.isdirectory(self.cache_dir) == 0 then
    os.execute("mkdir -p " .. self.cache_dir)
    for _, v in pairs(data_dir) do
      if vim.fn.isdirectory(v) == 0 then
        os.execute("mkdir -p " .. v)
      end
    end
  end
end

function vars:load_options()
  vim.o.termguicolors = true
  vim.o.hidden = true -- switch between buffers without having to save first
  vim.o.encoding = "utf-8" -- always use utf-8 whenever possible
  vim.o.clipboard = "unnamed,unnamedplus" -- "unnamed" works well with xsel, "unnamedplus" - with xclip
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
  vim.o.undodir = undo_dir
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
  vim.o.textwidth = 100
  vim.o.cursorline = true
  vim.o.foldenable = true
  vim.o.signcolumn = "yes"
  vim.o.undofile = true
  vim.o.spellfile = cache_dir .. "spell/en.uft-8.add" .. "," .. cache_dir .. "spell/ua.uft-8.add"
  vim.o.updatetime = 500 -- used by vim.lsp.buf.document_highlight()
  vim.o.autoread = true -- informed when changed outside
  vim.o.completeopt = "menu,menuone,noselect"
  vim.o.linebreak = true -- do not split a word into lines
  vim.o.foldtext = "" -- in neovim >= 0.10 to colorize fold
  vim.o.fillchars = "fold:."

  vim.g.clipboard = {
    name = "xsel",
    copy = {
      ["+"] = { "xsel", "--clipboard" },
      ["*"] = { "xsel", "--primary" },
    },
    paste = {
      ["+"] = { "xsel", "-o", "--clipboard" },
      ["*"] = { "xsel", "-o", "--primary" },
    },
    cache_enabled = true,
  }
end

return vars
