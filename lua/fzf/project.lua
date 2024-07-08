local M = {}

M.navigate = function()
  local ok, fzf_lua = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("Could not find fzf-lua module", vim.log.levels.ERROR)
    return
  end

  local vars = require("vars")

  local pattern = ".git"
  local root_path = os.getenv("HOME")
  local unique_cmd = "sort -u"
  local preview_cmd = "tree -C -L 1 " .. root_path .. "/{}"
  local prompt = "Projects> "
  local fd_exec = "fdir"
  local fd_cmd = fd_exec
    .. " "
    .. vim.env.FZF_PROJECTS_ROOT_DIRS
    .. " --patterns "
    .. vim.env.FZF_PROJECTS_PATTERNS

  fzf_lua.fzf_exec(fd_cmd .. " | " .. unique_cmd, {
    preview = preview_cmd,
    prompt = prompt,
    actions = {
      ["default"] = function(selected, opts)
        if #selected < 1 then
          return
        end
        fzf_lua.files({
          cwd = vim.env.HOME .. vars.path_sep .. selected[1],
        })
      end,
    },
  })
end

M.init = function()
  require("keymap").fzf_project()
end

return M
