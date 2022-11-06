-- Navigate and open projects on the system using 'fzf', 'fd', 'awk' and 'tree' commands.
-- It is better integrated with auto path detection tool such as 'ahmedkhalf/project.nvim'.

local ok, fzf_lua = pcall(require, "fzf-lua")
if not ok then
  vim.notify("Could not find fzf-lua module", vim.log.levels.ERROR)
  return
end

local M = {}

local pattern = "'^.git$|^.hg$|^.bzr$|^.svn$|^_darcs$|^Makefile$|^go.mod$|^package.json$'"
local root_path = os.getenv("HOME")
local unique_cmd = "awk '!x[$0]++'"
local preview_cmd = "tree -C -L 1 {}"
local prompt = "Projects> "
local fd_exec = "fd"
if vim.fn.executable("fdfind") == 1 then
  fd_exec = "fdfind"
end
local fd_cmd = fd_exec
  .. " --hidden --case-sensitive --absolute-path --exec echo '{//}' ';' "
  .. pattern
  .. " "
  .. root_path

M.navigate = function()
  fzf_lua.fzf_exec(fd_cmd .. " | " .. unique_cmd, {
    preview = preview_cmd,
    prompt = prompt,
    actions = {
      ["default"] = function(selected, opts)
        if #selected < 1 then
          return
        end
        fzf_lua.files({ cwd = selected[1] })
      end,
    },
  })
end

return M
