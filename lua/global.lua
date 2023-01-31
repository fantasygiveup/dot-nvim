local global = {}

local home = os.getenv("HOME")
local path_sep = global.is_windows and "\\" or "/"
local os_name = vim.loop.os_uname().sysname
local user_repo = home .. path_sep .. "github.com" .. path_sep .. "illia-danko" .. path_sep
local notes_dir = user_repo .. "org"

function global:load_variables()
  self.is_mac = os_name == "Darwin"
  self.is_linux = os_name == "Linux"
  self.is_windows = os_name == "Windows"
  self.vim_path = vim.fn.stdpath("config")
  self.notes_dir = notes_dir
  self.diary = notes_dir .. path_sep .. "diary.md"
  self.todos = notes_dir .. path_sep .. "todos.md"
  self.cache_dir = home .. path_sep .. ".cache" .. path_sep .. "nvim" .. path_sep
  self.undo_dir = home .. path_sep .. ".cache" .. path_sep .. "undo" .. path_sep
  self.modules_dir = self.vim_path .. path_sep .. "modules"
  self.path_sep = path_sep
  self.home = home
  self.user_name = "Illia Danko"
  self.diagnostic_severity = vim.diagnostic.severity.ERROR
end

function global:ensure_dir()
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

return global
