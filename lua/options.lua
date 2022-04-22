local global = require("global")

local global_options = {
  termguicolors  = true,
  background     = "light",
  hidden         = true,                    -- switch between buffers without having to save first
  encoding       = "utf-8",                 -- always use utf-8 whenever possible
  clipboard      = "unnamedplus",

  backup         = false,
  writebackup    = false,
  swapfile       = false,

 -- Show non-printable characters.
  list           = true,
  listchars      = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",

  showmode       = false,                   -- don't show current mode in command-line
  autoindent     = true,                    -- indent according to previous line
  expandtab      = true,                    -- use spaces instead of tabs
  tabstop        = 4,                       -- spaces per tab
  softtabstop    = 4,                       -- tab key indents by 4 spaces
  shiftwidth     = 4,                       -- indents by 4 spaces
  shiftround     = true,                    -- >> indents to next multiple of 'shiftwidth'

  -- Preserve undo state.
  undodir        = global.undo_dir,

  ruler          = false,                   -- don't show buffer info bottom screen
  pumheight      = 15,
  showtabline    = 0,
  virtualedit    = "onemore",
  ignorecase     = true,
  smartcase      = true,
  laststatus     = 3,
  formatoptions  = vim.o.formatoptions:gsub('t', ''),  -- don't auto break lines
}

local buffer_window_local = {
  textwidth      = 80,
  number         = true,
  relativenumber = true,
  cursorline     = true,
  foldenable     = true,
  signcolumn     = "yes",
  undofile       = true,
}

local function bind_global(options)
  for name, value in pairs(options) do
    vim.o[name] = value
  end
end

local function bind_option(options)
  for k, v in pairs(options) do
    if v == true or v == false then
      vim.cmd("set " .. k)
    else
      vim.cmd("set " .. k .. "=" .. v)
    end
  end
end

local function ensure_dir()
  local data_dir = {
    global.undo_dir
  }
  if vim.fn.isdirectory(global.cache_dir) == 0 then
    os.execute("mkdir -p " .. global.cache_dir)
    for _, v in pairs(data_dir) do
      if vim.fn.isdirectory(v) == 0 then
        os.execute("mkdir -p " .. v)
      end
    end
  end
end

bind_global(global_options)
bind_option(buffer_window_local)
ensure_dir()
