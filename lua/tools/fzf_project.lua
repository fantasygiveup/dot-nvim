local ok, fzf_lua = pcall(require, "fzf-lua")
if not ok then
  vim.notify("Could not find fzf-lua module", vim.log.levels.ERROR)
  return
end

local M = {}

local path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
local pattern = "'^.git$|^.hg$|^.bzr$|^.svn$'"
local root_path = os.getenv("HOME")
local unique_cmd = "awk '!x[$0]++'"
local preview_cmd = "tree -C -L 1 " .. root_path .. "/{}"
local prompt = "Projects> "
local fd_exec = "fd"
if vim.fn.executable("fdfind") == 1 then
  fd_exec = "fdfind"
end
local fd_cmd = fd_exec
  .. " --hidden --case-sensitive --base-directory "
  .. root_path
  .. " --relative-path --exec echo '{//}' ';' "
  .. pattern

M.navigate = function()
  fzf_lua.fzf_exec(fd_cmd .. " | cut -c 3- | " .. unique_cmd, {
    preview = preview_cmd,
    prompt = prompt,
    actions = {
      ["default"] = function(selected, opts)
        if #selected < 1 then
          return
        end
        fzf_lua.files({ cwd = root_path .. path_sep .. selected[1] })
      end,
    },
  })
end

M.setup = function()
  vim.keymap.set(
    "n",
    "<C-g>",
    "<Cmd>lua require'tools.fzf_project'.navigate()<CR>",
    { desc = "switch_project" }
  )
end

return M
