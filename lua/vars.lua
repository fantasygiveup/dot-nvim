local vars = {}

local home = os.getenv("HOME")
local path_sep = vars.is_windows and "\\" or "/"
local os_name = vim.loop.os_uname().sysname
local user_repo = home .. path_sep .. "github.com" .. path_sep .. "illia-danko" .. path_sep
local notes_dir = user_repo .. "docs"
local cache_dir = home .. path_sep .. ".cache" .. path_sep .. "nvim" .. path_sep
local rg_opts = {
  "rg",
  "--color=never",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--column",
  "--smart-case",
}
-- TODO(idanko): move to utils (split string, merge table)
for word in vim.env.RG_OPTS_FILTER:gmatch("%S+") do
  table.insert(rg_opts, word)
end
local fzf_default_command = {}
for word in vim.env.FZF_DEFAULT_COMMAND:gmatch("%S+") do
  table.insert(fzf_default_command, word)
end

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
  self.notes_dir = notes_dir
  self.diary = notes_dir .. path_sep .. "diary.md"
  self.todos = notes_dir .. path_sep .. "todos.md"
  self.cache_dir = cache_dir
  self.undo_dir = home .. path_sep .. ".cache" .. path_sep .. "undo" .. path_sep
  self.modules_dir = self.vim_path .. path_sep .. "modules"
  self.path_sep = path_sep
  self.home = home
  self.user_name = "Illia Danko"
  self.diagnostic_severity = vim.diagnostic.severity.ERROR
  self.rg_opts = rg_opts
  self.scratchpad_path = cache_dir .. "scratchpad.txt"
  self.system_theme_file = home
    .. path_sep
    .. ".config"
    .. path_sep
    .. "appearance"
    .. path_sep
    .. "background"
  self.fzf_default_command = fzf_default_command
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

return vars
