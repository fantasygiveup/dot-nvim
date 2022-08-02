local global = {}
local home = os.getenv("HOME")
local path_sep = global.is_windows and '\\' or '/'
local os_name = vim.loop.os_uname().sysname
local user_repo = home .. path_sep .. "github.com" .. path_sep .. "elijahdanko" .. path_sep

function global:load_variables()
  self.is_mac      = os_name == "Darwin"
  self.is_linux    = os_name == "Linux"
  self.is_windows  = os_name == "Windows"
  self.vim_path    = vim.fn.stdpath("config")
  self.notes_dir   = home .. path_sep .. "github.com" .. path_sep .. "elijahdanko" .. path_sep .."org"
  self.cache_dir   = home .. path_sep .. ".cache" .. path_sep .. "nvim" .. path_sep
  self.undo_dir    = home .. path_sep .. ".cache" .. path_sep .. "undo" .. path_sep
  self.modules_dir = self.vim_path .. path_sep .. "modules"
  self.path_sep    = path_sep
  self.home        = home
  self.user_name   = "Elijah Danko"
  self.email       = "me@elijahdanko.net"
  self.scratchpad  = vim.fn.stdpath("config") .. path_sep .. "scratchpad.txt"
  self.ref         = user_repo .. "restricted" .. path_sep .. "ref.gpg"
end

function global:ensure_dir()
  local data_dir = {
    self.undo_dir
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

global:load_variables()
global:ensure_dir()

return global
